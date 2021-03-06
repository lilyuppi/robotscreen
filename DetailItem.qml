import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.0

Rectangle{
    property size sizeDisplay: Qt.size(1920, 1040)
    id: detailItem
    y: header.height
    width: sizeDisplay.width
    height: sizeDisplay.height
    color: "#e9ebee"
    //    opacity: (sizeDisplay.width - x )/ sizeDisplay.width
    function updateData(){
        listImgPath.clear()
        timerAutoNextImage.restart()
        header.showBtnBack()
        for(var i = 0; i < DataJson.numImgDetail; i++){
            listImgPath.append({
                                   srcImgDetailFromJson: DataJson.listImgDetail[i]
                               });
        }

    }

    function backHome(){
        detailItemHide.start()
        detailItem.enabled = false
        listImgPath.clear()
        header.hideBtnBack()
    }

    MouseArea{
        anchors.fill: parent
    }
    Rectangle{
        property var mouseXPrevious

        id: dragArea
        width: sizeDisplay.width
        height: sizeDisplay.height
        anchors.top: parent.top
        color: "transparent"
        MouseArea{
            anchors.fill: parent
            drag.target: detailItem
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: sizeDisplay.width
            onPressed: {
                timerGetMousePrevious.start()
                timerGetMousePrevious.repeat = true
                timerGetMousePrevious.running = true
            }
            onReleased: {
                timerGetMousePrevious.stop()
                if(dragArea.mouseXPrevious < detailItem.x){
                    backHome()
                }else{
                    detailItemShow.start()
                }
            }
        }
        Timer{
            id: timerGetMousePrevious
            interval: 10
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: {
                dragArea.mouseXPrevious = detailItem.x
            }
        }

        ParallelAnimation{
            id: detailItemHide
            NumberAnimation{
                target: detailItem
                properties: "x"
                from: detailItem.x
                to: sizeDisplay.width
                easing.type: Easing.InCubic
            }
        }
        ParallelAnimation{
            id: detailItemShow
            NumberAnimation{
                target: detailItem
                properties: "x"
                from: detailItem.x
                to: 0
                easing.type: Easing.InCubic
            }
        }
    }
    layer.enabled: true
    layer.effect: OpacityMask{
        maskSource: Item{
            width: sizeDisplay.width
            height: sizeDisplay.height
            Rectangle{
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
        }
    }
    Rectangle{
        id: rectTextTitle
        anchors.left: parent.left
        anchors.top: parent.top
        width: sizeDisplay.width
        height: detailItem.height -  rectContainImg.height - header.height
        color: "#f5f6f7"

        //        LinearGradient{
        //            anchors.fill: parent
        //            start: Qt.point(0, 0)
        //            end: Qt.point(parent.width, parent.height)
        //            gradient: Gradient{
        //                GradientStop{position: 0.0; color: "#fdfbfb"}
        //                GradientStop{position: 1.0; color: "#ECEFF1"}
        //            }
        //        }

        Text{
            id: textTitle
            anchors.left: parent.left
            anchors.leftMargin: detailItem.width / 48
            anchors.top: parent.top
            anchors.topMargin: detailItem.height / 20.8
            //            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: detailItem.height / 21
            font.weight: Font.Black
            //            font.family: "San Francisco"
            FontLoader { id: myCustomFont; source: "qrc:/fonts/Lora-Bold.ttf" }
            font.family: myCustomFont.name
            //            color: "white"
            text: {
                if(DataJson.indexItem != -1)
                    DataJson.listTitle[DataJson.indexItem]
                else
                    ""
            }
        }


        RosButton{
            id: rectPresentation
            anchors.left: rectTextTitle.left
            anchors.leftMargin: detailItem.width / 45
            anchors.bottom: rectTextTitle.bottom
            anchors.bottomMargin: detailItem.height / 54
            height: detailItem.height / 15
            img_src: "present"
            textIn: "Thuyết trình"

        }
        RosButton{
            id: rectGuide
            anchors.left: rectPresentation.right
            anchors.leftMargin: 50
            anchors.verticalCenter: rectPresentation.verticalCenter
            width: rectPresentation.width
            height: rectPresentation.height
            img_src: "guide"
            color: "#009688"
            textIn: "Chỉ đường"
        }

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 0.3
            samples: 25
            radius: 5
            color: "#7f8c8d"
        }
    }



    Rectangle{
        id: rectContainImg
        anchors.left: detailItem.left
        anchors.top: rectTextTitle.bottom
        //        anchors.topMargin: 10
        width: detailItem.width / 1.371428571
        height: sizeDisplay.height / (detailItem.width / width)
        color: rectTextDetail.color

        Rectangle {
            id: rectContainPath

            width: parent.width
            height: parent.height

            PathView {
                id: view
                anchors.fill: parent
                model: ItemPathImageDetail{
                    id: listImgPath
                }

                pathItemCount: DataJson.numImgDetail
                //                pathItemCount: 2
                path: Path {
                    startX: -rectContainPath.width / 2
                    startY: view.height / 2

                    PathLine {
                        x: rectContainPath.width * DataJson.numImgDetail - rectContainPath.width / 2
                        y: view.height / 2
                    }

                }
                delegate: Rectangle {
                    width: rectContainPath.width
                    height: rectContainPath.height
                    color: rectContainImg.color
                    Image {
                        id: imgDetailPath
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: srcImgDetailFromJson
                    }
                }
                onCurrentIndexChanged: {
                    //                    console.log("DetailItem: current index image in detail change")
                    timerAutoNextImage.restart()
                }
            }
            Timer{
                id: timerAutoNextImage
                interval: 5000
                repeat: true
                running: false
                onTriggered: {
                    view.incrementCurrentIndex()
                }
            }
        }
    }


    Rectangle{
        id: rectTextDetail
        anchors.left: rectContainImg.right
        anchors.top: rectTextTitle.bottom
        //        anchors.topMargin: 5
        width: sizeDisplay.width - rectContainImg.width
        height: sizeDisplay.height
        color: "#ffffff"
        radius: 0

        Text {
            id: textDetail
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            width: parent.width - 20
            wrapMode: Text.WordWrap
            font.weight: Font.Normal
            font.pixelSize: 14
            FontLoader { id: myCustomFontDetail; source: "qrc:/fonts/Merriweather-Regular.ttf" }
            font.family: myCustomFontDetail.name
            text: "<b></b> " + DataJson.textDetail
        }


//        layer.enabled: true
//        layer.effect: InnerShadow {
//            horizontalOffset: -0.3
//            samples: 25
//            radius: 5
//            color: "#7f8c8d"
//        }
    }

}
