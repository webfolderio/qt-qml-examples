import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.3

Window {
    id: wnd
    width: Screen.width - (Screen.width / 2)
    height: Screen.height - (Screen.height / 2)
    visible: true
    title: qsTr("Address Book")

    Component.onCompleted: {
        // center the window
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    ListModel {
        id: addressBookModel

        ListElement {
            name: "Bill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "John Brown"
            number: "555 8426"
        }
        ListElement {
            name: "Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "John Doe"
            number: "555 3264"
        }
    }

    DelegateModel {
        id: adressBookDelegateModel

        model: addressBookModel

        groups: [
            DelegateModelGroup {
                // set initial visibility
                // all items visible by default
                includeByDefault: true
                name: "visible"
            }
        ]

        filterOnGroup: "visible"

        delegate: Component {
            id: contactDelegate
            Item {
                id: contactItem
                width: wnd.width
                height:  {
                    txtName.height +
                    txtPhoneNumber.height +
                    txtName.topPadding +
                    txtPhoneNumber.topPadding
                }
                Column {
                    id: col
                    leftPadding: 10

                    Text {  id: txtName;
                            text: qsTr("<b>Name:</b>: %1").arg(name);
                            topPadding: 5
                    }
                    Text {  id: txtPhoneNumber;
                            text: qsTr("<b>Phone Number:</b>: %1").arg(number);
                            topPadding: 5
                    }
                }
                MouseArea {
                    width: contactItem.width
                    height: contactItem.height
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height

        ColumnLayout {
            spacing: 0

            TextField {
                id: txtSearch
                Layout.fillWidth: true
                placeholderText: "Search name"
                Layout.preferredHeight: 28
                inputMethodHints: "ImhNoPredictiveText"
                width: wnd.width
                text: ""
                focus: false
                onTextChanged: {
                    // hide the item if it's name doesn't match with the search criteria
                    for (var i = 0; i < addressBookModel.count; i++) {
                        adressBookDelegateModel.items.get(i).inVisible =
                                addressBookModel.get(i).name.toLowerCase().match(txtSearch.text.toLowerCase())
                    }
                }
            }

            ListView {
                id: lstAddressBook
                height: wnd.height
                width: wnd.width
                model: adressBookDelegateModel
                highlight: Rectangle { color: "lightsteelblue"; }
                activeFocusOnTab: true
                orientation: Qt.Vertical
            }
        }
    }
}
