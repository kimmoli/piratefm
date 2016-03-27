import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QtQuick.LocalStorage 2.0
import org.nemomobile.dbus 2.0

ApplicationWindow
{
    initialPage: Qt.resolvedUrl("pages/Tuner.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Radio 
    {
        id: radio
        band: Radio.FM
    }

    Component.onCompleted:
    {
        radio.stop()
        rmeftimer.start()
    }

    Timer
    {
        id: rmeftimer
        interval: 500
        onTriggered:
        {
            radio.start()
            routeManager.enableFmRadio()
        }
    }

    DBusInterface
    {
        //  dbus-send --system --type=method_call --print-reply
        // --dest=org.nemomobile.Route.Manager /org/nemomobile/Route/Manager
        // org.nemomobile.Route.Manager.Enable string:fmradioloopback

        id: routeManager

        bus: DBus.SystemBus
        service: 'org.nemomobile.Route.Manager'
        path: '/org/nemomobile/Route/Manager'
        iface: 'org.nemomobile.Route.Manager'

        signalsEnabled: true

        function enableFmRadio()
        {
            call('Enable', "fmradioloopback")
        }

        function audioRouteChanged(a, b)
        {
            if (a == "headphone")
            {
                radio.stop()
                rmeftimer.start()
            }
        }
    }


    ListModel
    {
        id: stations
        function add( data )
        {
            for (var i=0; i<count; i++)
                if (data.frequency === get(i).frequency)
                    return;

            var db = opendb()
            db.transaction(function(x)
            {
                x.executeSql("INSERT INTO favourites (station, frequency) VALUES(?, ?)",[ data.station, data.frequency ])
            })
            stations.reload()
        }

        function reload()
        {
            var db = opendb()
            clear()
            db.transaction(function(x)
            {
                var res = x.executeSql("SELECT * FROM favourites")
                for(var i = 0; i < res.rows.length; i++)
                {
                    append(res.rows.item(i))
                }
            })
        }

        Component.onCompleted: reload()
    }

    function opendb()
    {
        return LocalStorage.openDatabaseSync('harbour-piratefm', '', 'Stations', 2000, function(db)
        {
            db.transaction(function(x)
            {
                x.executeSql("CREATE TABLE IF NOT EXISTS favourites (id INTEGER PRIMARY KEY AUTOINCREMENT, station TEXT, frequency INTEGER)")
            })
        })

    }

}


