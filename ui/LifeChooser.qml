import QtQuick 2.4
import Ubuntu.Components 1.2

Page {
    id: lifeTypeChooser

    title: i18n.tr("Choose life type")

    head.actions: [
        Action {
            iconName: "ok"
            text: i18n.tr("Ok")
            onTriggered: {
                mainView.currentCellularAutomaton = lifeChoose.selectedIndex
                mainStack.pop()
            }
        }
    ]
    
    Column {
        spacing: units.gu(1)
        anchors {
            margins: units.gu(2)
            fill: parent
        }
        OptionSelector {
            id: lifeChoose
            text: i18n.tr("Cellular automaton list")
            expanded: true
            selectedIndex: mainView.currentCellularAutomaton
            model: [
                    i18n.tr("Conway's Life 23/3"),
                    i18n.tr("2x2 125/36"),
                    i18n.tr("Assimilation 4567/345"),
                    i18n.tr("Amazing 12345/3"),
                    i18n.tr("Bacteria 456/34"),
                    i18n.tr("Coagulation 125678/367"),
                    i18n.tr("Coral 45678/3"),
                    i18n.tr("Day & Night 34678/3678"),
                    i18n.tr("Flakes 012345678/3"),
                    i18n.tr("Gnarl 1/1"),
                    i18n.tr("Seeds /2"),
                    i18n.tr("Maze 12345/3"),
                    i18n.tr("Mazectric 1234/3"),
                    i18n.tr("Walled Cities 2345/45678"),
                   ]

            onSelectedIndexChanged: {

            }
        }
    }
}
