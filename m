Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:4559 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZKEMkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 07:40:04 -0500
Message-ID: <4AF2C79C.800@gmail.com>
Date: Thu, 05 Nov 2009 13:39:56 +0100
From: Aurelio Grego <80classics@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy T-Express
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,
I'm writing you about a problem with Terratec Cinergy T-Express DVB-T
USB card.
The card is recognized by kernel, after compiling v4l-dvb sources
(v4l-dvb-fd679bbd8bb3.tar.gz).
Despite all, kaffeine and w_scan utility are not able to receive any
channels.
I've downloaded the required firmware from here:
http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw
What can I do? I used recent Linux distributions with kernel 2.6.31, but
with no luck.
Thanks for your help and support.

dylan@linux-t9fm:~> dmesg | grep dvb
dvb-usb: found a 'Terratec Cinergy T Express' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dvb-usb: found a 'Terratec Cinergy T Express' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Terratec Cinergy T Express successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700

dylan@linux-t9fm:~> lsusb
Bus 007 Device 005: ID 0ccd:0062 TerraTec Electronic GmbH

dylan@linux-t9fm:~/Desktop/w_scan-20090504> ./w_scan -ft -c IT -X >> /home/dylan
/channels.conf
w_scan version 20090502 (compiled for DVB API 5.0)
using settings for ITALY
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format czap/tzap/szap/xine
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> DVB-T "DiBcom 7000PC": good  :-) 
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.0
frontend DiBcom 7000PC supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 7MHz frequencies...
177500: (time: 00:00)
184500: (time: 00:03)
191500: (time: 00:06)
198500: (time: 00:09)
205500: (time: 00:12)
212500: (time: 00:16)
219500: (time: 00:19)
226500: (time: 00:22)
Scanning 8MHz frequencies...
474000: (time: 00:25) (time: 00:27) signal ok:
        QAM_AUTO f = 474000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
482000: (time: 00:42) (time: 00:44) signal ok:
        QAM_AUTO f = 482000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
490000: (time: 00:59)
498000: (time: 01:02)
506000: (time: 01:05) (time: 01:08) signal ok:
        QAM_AUTO f = 506000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
514000: (time: 01:22) (time: 01:25) signal ok:
        QAM_AUTO f = 514000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
522000: (time: 01:39)
530000: (time: 01:42)
538000: (time: 01:45)
546000: (time: 01:47) (time: 01:50) signal ok:
        QAM_AUTO f = 546000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
554000: (time: 02:05)
562000: (time: 02:08)
570000: (time: 02:11)
578000: (time: 02:14) (time: 02:16) signal ok:
        QAM_AUTO f = 578000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
586000: (time: 02:31)
594000: (time: 02:34)
602000: (time: 02:37)
610000: (time: 02:40)
618000: (time: 02:44)
626000: (time: 02:47)
634000: (time: 02:50)
642000: (time: 02:53)
650000: (time: 02:56) (time: 02:59) signal ok:
        QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
658000: (time: 03:13) (time: 03:15) signal ok:
        QAM_AUTO f = 658000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
666000: (time: 03:30) (time: 03:32) signal ok:
        QAM_AUTO f = 666000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
674000: (time: 03:47)
682000: (time: 03:50)
690000: (time: 03:53)
698000: (time: 03:56)
706000: (time: 03:59)
714000: (time: 04:02)
722000: (time: 04:05)
730000: (time: 04:08)
738000: (time: 04:11)
746000: (time: 04:14)
754000: (time: 04:17)
762000: (time: 04:20)
770000: (time: 04:23)
778000: (time: 04:26)
786000: (time: 04:29)
794000: (time: 04:33)
802000: (time: 04:36)
810000: (time: 04:39)
818000: (time: 04:42)
826000: (time: 04:45)
834000: (time: 04:48)
842000: (time: 04:51)
850000: (time: 04:54)
858000: (time: 04:57)
tune to: QAM_AUTO f = 474000 kHz I999B8C999D999T999G999Y999
(time: 05:00) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 482000 kHz I999B8C999D999T999G999Y999
(time: 05:15) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 506000 kHz I999B8C999D999T999G999Y999
(time: 05:29) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 514000 kHz I999B8C999D999T999G999Y999
(time: 05:44) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 546000 kHz I999B8C999D999T999G999Y999
(time: 05:59) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 578000 kHz I999B8C999D999T999G999Y999
(time: 06:13) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999
(time: 06:28) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 658000 kHz I999B8C999D999T999G999Y999
(time: 06:43) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
tune to: QAM_AUTO f = 666000 kHz I999B8C999D999T999G999Y999
(time: 06:58) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
dumping lists (0 services)
Done.





