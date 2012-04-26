Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53684 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2DZAPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 20:15:13 -0400
Received: by lbbgf7 with SMTP id gf7so554656lbb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 17:15:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3onKoP7GxWqf8siVJ1yywQR3wukN_or0QJ2Wr90eqJzOy3BQ@mail.gmail.com>
References: <CAH3onKon2-6QJjA6n5ANoT86HpheHX7_oL_OFrhMwk4nHkAShA@mail.gmail.com>
	<CAH3onKoP7GxWqf8siVJ1yywQR3wukN_or0QJ2Wr90eqJzOy3BQ@mail.gmail.com>
Date: Thu, 26 Apr 2012 02:15:11 +0200
Message-ID: <CAH3onKrxhrFfvug1BLT+1-pM6F5=MMXUx+9Bb8R2oE2Pbj7H7w@mail.gmail.com>
Subject: Unable to open frontend of divb0700 / w_scan fails / Channel scan
 works on Windows
From: Jose Tejada <jose.tejada@ieee.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to understand what is going wrong on a Pinnacle 73e running on
Linux Mint 12. The system seems to recognize the device properly:

dmesg

[   25.571464] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[   25.795650] DiB0070: successfully identified
[   25.820158] Registered IR keymap rc-dib0700-rc5
[   25.820357] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input8
[   25.820494] rc0: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
[   25.820716] dvb-usb: schedule remote query interval to 50 msecs.
[   25.820719] dvb-usb: Pinnacle PCTV 73e successfully initialized and
connected.
[   25.820807] dib0700: rc submit urb failed
[   25.820810]
[   25.820853] usbcore: registered new interface driver dvb_usb_dib0700

Sometimes dmesg shows a message about installing the firmware
/lib/firmware/dvb-usb-dib0700-1.20.fw
but this time it didn't issue that message.

uname -r gives 3.0.0-12-generic

If I try to scan the channels using VLC, w_scan or scan, it fails to find
anything. I have tried forcing the LNA:

~ $ cat /etc/modprobe.d/options.conf
options dvb-usb-dib0700 force_lna_activation=1

but that didn't make a difference.

The output from dvbscan is:
~ $ dvbscan /usr/share/dvb/dvb-t/es-Valencia
Unable to query frontend status

The output from w_scan is:

w_scan /usr/share/dvb/dvb-t/es-Valencia
w_scan version 20110616 (compiled for DVB API 5.3)
guessing country 'ES', use -c <country> to override
using settings for SPAIN
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format vdr-1.6
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
    /dev/dvb/adapter0/frontend0 -> DVB-T "DiBcom 7000PC": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.3
frontend 'DiBcom 7000PC' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (45.00MHz ... 860.00MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 7MHz frequencies...
177500: (time: 00:00)
184500: (time: 00:03)
191500: (time: 00:06)
198500: (time: 00:09)
205500: (time: 00:12)
212500: (time: 00:15)
219500: (time: 00:18)
226500: (time: 00:21)
Scanning 8MHz frequencies...
474000: (time: 00:24)
482000: (time: 00:27)
490000: (time: 00:32)
498000: (time: 00:35)
506000: (time: 00:38)
514000: (time: 00:41)
522000: (time: 00:44)
530000: (time: 00:47)
538000: (time: 00:52)
546000: (time: 00:55)
554000: (time: 00:58)
562000: (time: 01:01)
570000: (time: 01:04) (time: 01:05) signal ok:
    QAM_AUTO f = 570000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
578000: (time: 01:20)
586000: (time: 01:23)
594000: (time: 01:26)
602000: (time: 01:29)
610000: (time: 01:32)
618000: (time: 01:35)
626000: (time: 01:39) (time: 01:40) signal ok:
    QAM_AUTO f = 626000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
634000: (time: 01:54)
642000: (time: 01:57)
650000: (time: 02:01) (time: 02:02) signal ok:
    QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
658000: (time: 02:16)
666000: (time: 02:20)
674000: (time: 02:23) (time: 02:24) signal ok:
    QAM_AUTO f = 674000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
682000: (time: 02:39)
690000: (time: 02:42)
698000: (time: 02:45)
706000: (time: 02:48)
714000: (time: 02:51)
722000: (time: 02:54)
730000: (time: 02:57)
738000: (time: 03:00)
746000: (time: 03:03)
754000: (time: 03:06)
762000: (time: 03:09) (time: 03:10) signal ok:
    QAM_AUTO f = 762000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
770000: (time: 03:25) (time: 03:26) signal ok:
    QAM_AUTO f = 770000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
778000: (time: 03:41)
786000: (time: 03:44)
794000: (time: 03:47)
802000: (time: 03:50)
810000: (time: 03:53)
818000: (time: 03:56)
826000: (time: 04:00)
834000: (time: 04:03) (time: 04:04) signal ok:
    QAM_AUTO f = 834000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
842000: (time: 04:18) (time: 04:19) signal ok:
    QAM_AUTO f = 842000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
850000: (time: 04:34) (time: 04:35) signal ok:
    QAM_AUTO f = 850000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
858000: (time: 04:50) (time: 04:51) signal ok:
    QAM_AUTO f = 858000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 570000 kHz I999B8C999D999T999G999Y999
(time: 05:06) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 626000 kHz I999B8C999D999T999G999Y999
(time: 05:21) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999
(time: 05:36) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 674000 kHz I999B8C999D999T999G999Y999
(time: 05:51) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 762000 kHz I999B8C999D999T999G999Y999
(time: 06:06) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 770000 kHz I999B8C999D999T999G999Y999
(time: 06:21) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 834000 kHz I999B8C999D999T999G999Y999
(time: 06:36) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 842000 kHz I999B8C999D999T999G999Y999
(time: 06:51) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 850000 kHz I999B8C999D999T999G999Y999
(time: 07:06) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 858000 kHz I999B8C999D999T999G999Y999
(time: 07:20) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
dumping lists (0 services)
Done.

The output from scan is:
scan -v -v -v -v -v /usr/share/dvb/dvb-t/es-Valencia
scanning /usr/share/dvb/dvb-t/es-Valencia
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 490000000 0 2 9 3 1 3 0
initial transponder 746000000 0 2 9 3 1 3 0
initial transponder 762000000 0 2 9 3 1 3 0
initial transponder 770000000 0 2 9 3 1 3 0
initial transponder 834000000 0 2 9 3 1 3 0
initial transponder 842000000 0 2 9 3 1 3 0
initial transponder 850000000 0 2 9 3 1 3 0
initial transponder 858000000 0 2 9 3 1 3 0
>>> tune to:
>>> 490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x02
>>> tuning status == 0x02
>>> tuning status == 0x00
>>> tuning status == 0x02
>>> tuning status == 0x02
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1a
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
>>> tune to:
>>> 770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
>>> tune to:
>>> 834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
>>> tune to:
>>> 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
>>> tune to:
>>> 850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
>>> tune to:
>>> 858000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
add_filter:1791: add filter pid 0x0000
start_filter:1731: start filter pid 0x0000 table_id 0x00
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0011
start_filter:1731: start filter pid 0x0011 table_id 0x42
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
add_filter:1791: add filter pid 0x0010
start_filter:1731: start filter pid 0x0010 table_id 0x40
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 5
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1799: remove filter pid 0x0011
stop_filter:1777: stop filter pid 0x0011
update_poll_fds:1711: poll fd 6
update_poll_fds:1711: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1799: remove filter pid 0x0000
stop_filter:1777: stop filter pid 0x0000
update_poll_fds:1711: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1799: remove filter pid 0x0010
stop_filter:1777: stop filter pid 0x0010
dumping lists (0 services)
Done.

I cannot find any channel during the scan. However, I know that the card and
the antenna are sound because I do find all channels in Windows 7. divb0700
chipset seems to be well supported in v4l so I do not want to give it up and
make it work. However, I am stuck now as I do not know what might be going
wrong. I even tried different inputs to the scan program to see if it made a
difference:

#!/bin/bash
for x in /usr/share/dvb/dvb-t/es-Val*; do
    for i in 0 1 2; do
        scan -i $i -5 -n -t 1 $x > /tmp/$(basename $x)-$i.tv
    done
done

But it didn't. Scan cannot find channels anyway.

Please any hint about what to check next will be very much appreciated.

Thank you,
Pepe
