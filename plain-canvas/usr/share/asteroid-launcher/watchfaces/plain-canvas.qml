/*
* Copyright (C) 2018 - Helge Lente <h.lente@gmx.net>
*               2017 - Mario Kicherer <dev@kicherer.org>
*               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
*               2015 - Florent Revest <revestflo@gmail.com>
*               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
*                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
*                      Arto Jalkanen <ajalkane@gmail.com>
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

/*
 * This watchface is based on the official analog watchface but comes
 * with a seconds hand, strokes for hours and minutes, correct
 * dropshadows for the hands and other small improvements.
 */

import QtQuick 2.1

Item {
	property real secondRad : 0
	property real minuteRad : 0
	property real hourRad : 0

    // Block for local Testing
    id : wallClock
    width : 400
    height : 400
    property var time : new Date()
    Timer {
    	interval: 100; running: true; repeat: true;
    	onTriggered: {
    		wallClock.time = new Date()
    	}
    }
	property int seconds: wallClock.time.getSeconds()

	states: [State { when: seconds % 2 == 0; PropertyChanges { secondAngle: seconds * 6; target: secondHandCanvas }},
			State { when: seconds % 2 == 1; PropertyChanges { secondAngle: seconds * 6; target: secondHandCanvas }}  ]

	transitions: Transition {
		RotationAnimation {
			property: "secondAngle"
			direction: RotationAnimation.Clockwise
			easing.type: Easing.OutBack
			duration: 200
		}
	}
	property int minutes: wallClock.time.getMinutes()

	states: [State { when: seconds % 2 == 0; PropertyChanges { minutesAngle: minutes * 6 + seconds * .1; target: secondHandCanvas }},
			State { when: seconds % 2 == 1; PropertyChanges { minutesAngle: minutes * 6 + seconds * .1; target: secondHandCanvas }}  ]

	transitions: Transition {
		RotationAnimation {
			property: "minuteAngle"
			direction: RotationAnimation.Clockwise
			easing.type: Easing.OutBack
			duration: 200
		}
	}
	property int hours: wallClock.time.getHours()

	states: [State { when: minutes % 2 == 0; PropertyChanges { hoursAngle: hours * 30 + minutes * .5; target: secondHandCanvas }},
			State { when: minutes % 2 == 1; PropertyChanges { hoursAngle: hours * 30 + minutes * .5; target: secondHandCanvas }}  ]

	transitions: Transition {
		RotationAnimation {
			property: "hourAngle"
			direction: RotationAnimation.Clockwise
			easing.type: Easing.OutBack
			duration: 200
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

	Canvas {
		id:hourHandCanvas
		anchors.fill: parent
		smooth: true
		renderTarget: Canvas.FramebufferObject
		onPaint: {
			var ctx = getContext('2d')
			ctx.save()
			ctx.clearRect(0, 0, parent.width, parent.height)
			ctx.translate(parent.width/2, parent.height/2)
			ctx.strokeStyle = '#ffffffff'
			ctx.lineWidth = parent.width * .02
			ctx.lineCap = 'round'
			ctx.shadowColor = '#80000000'
			ctx.shadowOffsetX = Math.cos(hourRad) * parent.width * .0125
			ctx.shadowOffsetY = Math.cos(hourRad) * parent.width * .0125
			ctx.shadowBlur = parent.width * .005
			ctx.rotate(hourRad)
			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(0, -parent.width * .3)
			ctx.stroke()
			ctx.restore()
		}
	}
	Canvas {
		id:minuteHandCanvas
		anchors.fill: parent
		property real minuteAngle: seconds * 6;
		onMinuteAngleChanged: requestPaint()

		renderTarget: Canvas.FramebufferObject
		renderStrategy: Canvas.Cooperative
		smooth: true
		onPaint: {
			var ctx = getContext('2d')
			ctx.save()
			ctx.clearRect(0, 0, parent.width, parent.height)
			ctx.translate(parent.width/2, parent.height/2)
			ctx.strokeStyle = '#ffffffff'
			ctx.lineWidth = parent.width * .02
			ctx.lineCap = 'round'
			ctx.shadowColor = '#80000000'
            ctx.shadowOffsetX = Math.cos( minuteAngle * Math.PI / 180 ) * parent.width * .0125
			ctx.shadowOffsetY = Math.cos( minuteAngle * Math.PI / 180 ) * parent.width * .0125
			ctx.shadowBlur = parent.width * .005
			ctx.rotate( minuteAngle * Math.PI / 180 )
			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(0, -parent.width * .4)
			ctx.stroke()
			ctx.restore()
		}
	}
	Canvas {
		id:secondHandCanvas
		anchors.fill:parent;

		property real secondAngle: seconds * 6;
		onSecondAngleChanged: requestPaint()

		renderTarget: Canvas.FramebufferObject
		renderStrategy: Canvas.Cooperative
		smooth: true

		onPaint: {
			var ctx = getContext('2d')
			//ctx.resetTransform()
			ctx.save()
			ctx.clearRect(0, 0, parent.width, parent.height)
			ctx.translate(parent.width/2, parent.height/2)
			ctx.strokeStyle = '#ffff0000'
			ctx.lineWidth = parent.width*.01
			ctx.lineCap = 'round'
			ctx.shadowColor = '#80000000'
            ctx.shadowOffsetX = Math.cos(secondAngle * Math.PI/180 ) * parent.width * .0125
			ctx.shadowOffsetY = Math.cos(secondAngle * Math.PI/180) * parent.width * .0125
			ctx.shadowBlur = parent.width * .005
			ctx.rotate(secondAngle * Math.PI/180)
			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(0, -parent.width*.4)
			ctx.stroke()
			ctx.restore()
		}
		//Timer { repeat: true; running: true; onTriggered: secondHandCanvas.seconds = new Date().getSeconds()  }

	}

//	Connections {
//		target: wallClock
//		onTimeChanged: {
//			//secondHandCanvas.seconds = wallClock.time.getSeconds()
//			minuteRad = wallClock.time.getMinutes() / 30 * Math.PI + secondRad / 60
//			hourRad = wallClock.time.getHours() / 6 * Math.PI + minuteRad / 60
//			hourHandCanvas.requestPaint()
//			minuteHandCanvas.requestPaint()
//			//secondHandCanvas.requestPaint()
//		}
//	}
}
