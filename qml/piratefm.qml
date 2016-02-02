import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

ApplicationWindow
{
    initialPage: Qt.resolvedUrl("pages/Tuner.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    
    Radio 
    {
        id: radio
        band: Radio.FM
   }

    ListModel
    {
        id: stations
        function add( data )
        {
            for (var i=0; i<count; i++)
                if (data.frequency === get(i).frequency)
                    return;
            append(data)
        }
    }
}


