/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Start Tracking")
                onClicked: {
                    console.log("Starting tracking");
                    tracker.active = true;
                }
            }
            MenuItem {
                text: qsTr("Stop Tracking")
                onClicked: {
                    console.log("Stopping tracking");
                    tracker.active = false;
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("RTrack") }
            Label {
                x: Theme.paddingLarge
                text: tracker.active ? "Running" : "Not Running"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField {
                id: userField
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: "User"
                inputMethodHints: Qt.ImhNoPredictiveText
                text: getUser();

            }
            TextField {
                id: passField
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Pass"
                inputMethodHints: Qt.ImhNoPredictiveText
                text: getPass();
                echoMode: TextInput.Password
            }
            Row {
                width: parent.width
                spacing: Theme.paddingLarge

                Button {
                    text: "Save"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        setUserPass(userField.text, passField.text);
                    }
                }
                Button {
                    text: "Load"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        loadUserPass();
                        userField.text = getUser();
                        passField.text = getPass();
                    }
                }
            }
            Button {
                text: "Create User"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {

                    var request = new XMLHttpRequest();
                    var urlToUse = "http://gallium.r2zer0.net:4999/newuser";
                    request.open("POST", urlToUse, true);

                    var postParams = "user=" + getUser() + "&passkey=" + getPass();

                    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    request.setRequestHeader("Content-length", postParams.length);
                    request.setRequestHeader("Connection", "close");

                    request.onreadystatechange = function() {
                        if(request.readyState == 4) {
                            if(request.status == 200) {
                                console.log("Successfully sent newuser request");
                            }else{
                                console.log("Couldn't send newuser request");
                                console.log("   readyState = " + request.readyState)
                                console.log("   status = " + request.status)
                                console.log(request.responseText);
                            }
                        }
                    }

                    request.send(postParams);
                    // TODO: determine success or not

                }
            }
        }
    }
}


