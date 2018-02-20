/*
 * Copyright (C) 2018 - Helge Lente <h.lente@gmx.net>
 *
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
//import QtGraphicalEffects 1.0

Item {
	property bool animationEnabled : true

// Block for local Testing
//	width : 400
//	height : 400
//	property var wallClock : {time : new Date()}
//	Timer {
//		interval: 100; running: true; repeat: true;
//		onTriggered: {
//			wallClock.time = new Date()
//		}
//	}

	Timer {
		id : animationDelayTimer
		interval: 10; running: false; repeat: false;
		onTriggered: {
			animationEnabled = true
		}
	}

	Item{
		id : face
		anchors.fill : parent
		Rectangle{
			anchors.fill : parent
			color:'#00ffffff'
			radius: width / 2
		}
	}

	Item{
		id : date
		anchors.fill : parent

		Text{
			id : dateText
			horizontalAlignment: Text.AlignHCenter

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height/4

			color: '#ffffffff'
			opacity: 0.8
			font.pixelSize: parent.height/17

			text: Qt.formatDate(wallClock.time, "<b>ddd</b> d MMM")
		}
	}

	Item{
		id : hands
		anchors.fill : parent

		Rectangle{
			id: hourHand

			width: parent.width * .02
			height: parent.height * .3

			color:"#ffffffff"
			border.color:'#cccccccc'
			border.width: 1
			radius:width / 2
			antialiasing : true
			x: ( parent.width - width ) / 2
			y: ( parent.height - height ) / 2
			transform: [
				Translate {
					y : -( hourHand.height - hourHand.width ) / 2
				} ,
				Rotation {
					id: hourHandRotation
					origin.x: hourHand.width/2
					origin.y: hourHand.height/2
					angle: ( ( wallClock.time.getHours() * 30 ) + ( wallClock.time.getMinutes() * .5 ) )
				}
			]
		}

		Rectangle{
			id: minuteHand

			width: parent.width * .02
			height: parent.height * .4

			color:"#ffffffff"
			border.color:'#cccccccc'
			border.width: 1
			radius:width / 2
			antialiasing : true
			x: ( parent.width - width ) / 2
			y: ( parent.height - height ) / 2
			transform: [
				Translate {
					y : -( minuteHand.height - minuteHand.width ) / 2
				} ,
				Rotation {
					id: minuteHandRotation
					origin.x: minuteHand.width/2
					origin.y: minuteHand.height/2
					angle: ( ( wallClock.time.getMinutes() * 6 ) + ( wallClock.time.getSeconds() * .1 ) )
					Behavior on angle {
						enabled : animationEnabled
						SpringAnimation { spring: 1; damping: 0.1; modulus: 360 }
					}
				}
			]
		}

		Rectangle{
			id: secondHand

			width: parent.width * .01
			height: parent.height * .4

			color:"#ffcc4400"
			border.color:'#cccc4400'
			border.width: 1
			radius:width / 2
			antialiasing : true
			x: ( parent.width - width ) / 2
			y: ( parent.height - height ) / 2
			transform: [
				Translate {
					y : -( secondHand.height - secondHand.width ) / 2
				} ,
				Rotation {
					id: secondHandRotation
					origin.x: secondHand.width/2
					origin.y: secondHand.height/2
					angle: (wallClock.time.getSeconds() * 6)
					Behavior on angle {
						enabled : animationEnabled
						SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
					}
				}
			]
		}
//		layer.enabled: true
//		layer.effect: DropShadow {
//			transparentBorder: true
//			color:'#aa000000'
//			horizontalOffset: 5
//			verticalOffset: 5
//		}
	}
	Connections {
		target: wallClock
		onEnabledChanged:{
			if (wallClock.enabled){
				animationDelayTimer.start()
			}else{
				animationEnabled = false;
			}
		}
	}
}
