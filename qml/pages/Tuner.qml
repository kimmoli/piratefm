import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page
{
    id: page

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: "About..."
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"),
                                          { "version": "0.0.0",
                                              "year": "2016",
                                              "name": "Pirate FM",
                                              "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-piratefm.png"} )
            }
        }

        contentHeight: column.height

        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingSmall
            PageHeader
            {
                title: "Tuner"
            }

            Row
            {
                width: parent.width - Theme.paddingLarge
                Label
                {
                    id: freqLabel
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - seekButtons.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "" + (radio.frequency / 1000000).toFixed(1) + " MHz"
                    color: radio.seeking ? Theme.primaryColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeHuge * 1.5
                    font.bold: true
                }
                Column
                {
                    id: seekButtons
                    IconButton
                    {
                        icon.source: "image://theme/icon-m-up"
                        onClicked: radio.tuneUp()
                        onPressAndHold:
                        {
                            tick.play()
                            radio.scanUp()
                        }
                    }
                    IconButton
                    {
                        icon.source: "image://theme/icon-m-down"
                        onClicked: radio.tuneDown()
                        onPressAndHold:
                        {
                            tick.play()
                            radio.scanDown()
                        }
                    }
                }
            }
            
            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton
                {
                    icon.source: "image://theme/icon-m-speaker" + (radio.muted ? "" : "-mute")
                    onClicked: radio.setMuted(!radio.muted)
                }
                IconButton
                {
                    icon.source: "image://theme/icon-m-favorite"
                    onClicked:
                    {
                        stations.add({"frequency": radio.frequency, "station": radio.radioData.stationName})
                    }
                }
            }

            Label
            {
                id: stationName
                anchors.horizontalCenter: parent.horizontalCenter
                text: radio.radioData.stationName ? radio.radioData.stationName : " "
                font.pixelSize: Theme.fontSizeLarge
            }
            Label
            {
                id: radioText
                anchors.horizontalCenter: parent.horizontalCenter
                text: radio.radioData.radioText ? radio.radioData.radioText.replace(/\s+/g,' ').trim() : " "
            }
            SectionHeader
            {
                text: "Favourites"
                visible: stations.count > 0
            }
            Repeater
            {
                model: stations
                delegate: ListItem
                {
                    contentHeight: Theme.itemSizeSmall
                    width: parent.width
                    menu: contextmenu

                    Label
                    {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.verticalCenter: parent.verticalCenter
                        text: station
                    }
                    Label
                    {
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingMedium
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + (frequency / 1000000).toFixed(1) + " MHz"
                        font.bold: true
                    }
                    onClicked: radio.frequency = frequency

                    Component
                    {
                        id: contextmenu
                        ContextMenu
                        {
                            MenuItem
                            {
                                text: "Delete"
                                onClicked: remove()
                            }
                        }
                    }

                    function remove()
                    {
                        remorseAction("Deleting", function()
                        {
                            var db = opendb()
                            db.transaction(function(x)
                            {
                                x.executeSql("DELETE FROM favourites WHERE id=?",[ stations.get(index).id ])
                            })
                            stations.reload()
                        })
                    }
                }
            }
        }
    }

    SoundEffect
    {
        id: tick
        source: "/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav"
    }

}


