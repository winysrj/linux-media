Return-path: <mchehab@pedra>
Received: from 47-67.174.81.serverdedicati.seflow.net ([81.174.67.47]:58059
	"EHLO vps.virtual-bit.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752212Ab1CTTRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 15:17:39 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by vps.virtual-bit.com (Postfix) with ESMTP id 59E7A13B0120
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 20:10:35 +0100 (CET)
Received: from vps.virtual-bit.com ([127.0.0.1])
	by localhost (vps.virtual-bit.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4UlklaOSQ9OK for <linux-media@vger.kernel.org>;
	Sun, 20 Mar 2011 20:10:34 +0100 (CET)
Received: from precision.localnet (dynamic-adsl-84-223-100-58.clienti.tiscali.it [84.223.100.58])
	by vps.virtual-bit.com (Postfix) with ESMTPA id BAECC13B00DA
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 20:10:34 +0100 (CET)
From: Lucio Crusca <lucio@sulweb.org>
To: linux-media@vger.kernel.org
Subject: AF9015 problems
Date: Sun, 20 Mar 2011 20:10:33 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103202010.33892.lucio@sulweb.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello *,

I'm new here, hope to be on the right list (crossposting from  
linux-dvb@linuxtv.org which mailman told me is deprecated). 
I'm trying to tune a AF9015, but w_scan finds only 4 tv services, while the 
same dongle attached to the same antenna cable, on the same computer, with 
Windows Media Center finds as much as 135 tv services.

The 4 services it finds are all from the same 205500 KHz transponder. Any clue?

Some details:

# lsusb
...
Bus 002 Device 002: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T 
USB2.0 stick
...

# dmesg 
[ 6484.732102] usb 2-2: new high speed USB device using ehci_hcd and address 2
[ 6484.913877] IR NEC protocol handler initialized
[ 6484.915782] IR RC5(x) protocol handler initialized
[ 6484.918307] IR RC6 protocol handler initialized
[ 6484.920723] IR JVC protocol handler initialized
[ 6484.922643] IR Sony protocol handler initialized
[ 6484.925543] lirc_dev: IR Remote Control driver registered, major 250 
[ 6484.926765] IR LIRC bridge handler initialized
[ 6485.285760] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold 
state, will try to load a firmware
[ 6485.318245] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[ 6485.385897] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm 
state.
[ 6485.386035] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 6485.386449] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 
stick)
[ 6485.404493] af9013: firmware version:4.95.0.0
[ 6485.408621] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
[ 6485.413124] tda18218: NXP TDA18218HN successfully identified.
[ 6485.415018] Registered IR keymap rc-empty
[ 6485.415127] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/rc/rc0/input13
[ 6485.415208] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/rc/rc0
[ 6485.415212] dvb-usb: schedule remote query interval to 500 msecs.
[ 6485.415216] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
initialized and connected.
[ 6485.423782] usbcore: registered new interface driver dvb_usb_af9015
[ 6485.440130] usbcore: registered new interface driver usbhid
[ 6485.440134] usbhid: USB HID core driver

# uname -r
2.6.38-rc6

# lsmod | grep dvb
dvb_usb_af9015         19468  0 
dvb_usb                15052  1 dvb_usb_af9015
dvb_core               86023  1 dvb_usb
rc_core                16999  9 
ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,dvb_usb_af9015,ir_rc5_decoder,ir_nec_decoder,dvb_usb

# w_scan -c IT -ft -X
w_scan version 20100316 (compiled for DVB API 5.1)
using settings for ITALY
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format czap/tzap/szap/xine
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> DVB-T "Afatech AF9013 DVB-T": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
Using DVB API 5.2
frontend Afatech AF9013 DVB-T supports
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
191500: (time: 00:05) 
198500: (time: 00:08) 
205500: (time: 00:10) (time: 00:13) signal ok:
        QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999
        new transponder:
           (QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0)
212500: (time: 00:26) 
219500: (time: 00:29) 
226500: (time: 00:31) 
Scanning 8MHz frequencies...
474000: (time: 00:34) 
482000: (time: 00:36) 
490000: (time: 00:39) 
498000: (time: 00:41) 
506000: (time: 00:44) 
514000: (time: 00:46) 
522000: (time: 00:49) 
530000: (time: 00:51) 
538000: (time: 00:54) 
546000: (time: 00:56) 
554000: (time: 00:59) 
562000: (time: 01:01) 
570000: (time: 01:04) 
578000: (time: 01:07) 
586000: (time: 01:09) 
594000: (time: 01:12) 
602000: (time: 01:14) 
610000: (time: 01:17) 
618000: (time: 01:19) 
626000: (time: 01:22) 
634000: (time: 01:24) 
642000: (time: 01:27) (time: 01:29) 
650000: (time: 01:30) 
658000: (time: 01:33) 
666000: (time: 01:36) 
674000: (time: 01:38) 
682000: (time: 01:41) 
690000: (time: 01:43) 
698000: (time: 01:46) 
706000: (time: 01:48) 
714000: (time: 01:51) 
722000: (time: 01:53) 
730000: (time: 01:56) 
738000: (time: 01:59) 
746000: (time: 02:01) 
754000: (time: 02:04) 
762000: (time: 02:06) 
770000: (time: 02:09) 
778000: (time: 02:11) 
786000: (time: 02:14) 
794000: (time: 02:16) 
802000: (time: 02:19) 
810000: (time: 02:22) 
818000: (time: 02:24) 
826000: (time: 02:27) 
834000: (time: 02:29) 
842000: (time: 02:32) 
850000: (time: 02:34) 
858000: (time: 02:37) 
tune to: QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 
(time: 02:39)   service = Rai 1 (RAI)
        service = Rai 2 (RAI)
        service = Rai 3 TGR Piemonte (Rai)
        service = Rai Radio1 (RAI)
        service = Rai Radio2 (RAI)
        service = Rai Radio3 (RAI)
        service = Rai News (Rai)
tune to: QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0 
(time: 02:53) set_frontend:1703: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
tune to: QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0 
(time: 02:53) set_frontend:1703: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
dumping lists (7 services)
Done.
