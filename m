Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdIWMvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 08:51:24 -0400
MIME-Version: 1.0
Message-ID: <trinity-2aee2302-1512-4f3a-90fb-cd6fe9d02481-1506171083299@3c-app-mailcom-bs16>
From: daggs <daggs@gmx.com>
To: linux-media@vger.kernel.org
Subject: usb dvb device doesn't works
Content-Type: text/plain; charset=UTF-8
Date: Sat, 23 Sep 2017 14:51:23 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I have the following device: Mygica T230 DVB-T/T2/C, although everywhere I see, it is advertised as a good device, I'm unable to render it working.
I've tested on 4 different computers, in all the linux systems (gentoo with kernel 4.13.3, rpi2 with kernel 4.9 and odroid with kerne 3.14 + media-build drivers), I'm unable to get it to work properly. useally, it doesn't receives anything and in the few times it does, the connection drops fast.
the fourth computer I've tried is a netbook running windows 10 and the device works great.
e.g. I plug it into the rpi2, no reception, I move it to the gentoo machine, the same, I then move it to the win10, it works.
I'm using the fw from the linuxtv.org website, scan dobe by w_scan shows this:
538000: (time: 00:37.793)         signal ok:    QAM_AUTO f = 538000 kHz I999B8C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 538000 kHz I999B8C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:2)
        QAM_AUTO f = 538000 kHz I999B8C999D999T999G999Y999 (0:0:2) : updating network_id -> (0:4369:2)
        new transponder: (QPSK     f =      0 kHz I0B999C0D0T2G32Y0 (65314:4369:1)) 0x4000
        QAM_AUTO f = 538000 kHz I999B8C999D999T999G999Y999 (0:4369:2) : updating original_network_id -> (65314:4369:2)
        updating transponder:
           (QAM_AUTO f = 538000 kHz I999B8C999D999T999G999Y999 (65314:4369:2)) 0x0000
        to (QAM_16   f = 538000 kHz I999B8C23D0T8G4Y0 (65314:4369:2)) 0x405A
        new transponder: (QAM_16   f =      0 kHz I999B8C23D0T8G4Y0 (8959:4369:3)) 0x405A 
but ends up with this:
tune to: QAM_16   f = 538000 kHz I999B8C23D0T8G4Y0 (65314:4369:2) (time: 03:56.559)
        Info: no data from PAT after 2 seconds
        Info: no data from SDT(actual) after 3 seconds
        Info: no data from NIT(actual )after 13 seconds
retrying with center_frequency = 514000000
tune to: QAM_16   f = 514000 kHz I999B8C23D0T8G4Y0 (8959:4369:3) (time: 04:11.176)
----------no signal----------
tune to: QAM_AUTO f = 514000 kHz I999B8C999D0T999G999Y0 (8959:4369:3) (time: 04:17.276)  (no signal)
----------no signal----------
(time: 04:23.333) dumping lists (0 services) 

dmesg shows this:
[    4.229580] usb 1-1.5.2: new high-speed USB device number 6 using dwc_otg
[    4.370544] usb 1-1.5.2: language id specifier not provided by device, defaulting to English
[    4.387050] usb 1-1.5.2: New USB device found, idVendor=0572, idProduct=c688
[    4.397366] usb 1-1.5.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.451361] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[    4.740541] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    4.756011] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[    4.798511] i2c i2c-3: Added multiplexed i2c bus 4
[    4.806867] si2168 3-0064: Silicon Labs Si2168-B40 successfully identified
[    4.817327] si2168 3-0064: firmware version: B 4.0.2
[    4.844102] media: Linux media interface: v0.10
[    4.863036] si2157 4-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[    4.874499] usb 1-1.5.2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[    4.887326] input: IR-receiver inside an USB DVB receiver as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5.2/input/input0
[    4.906630] dvb-usb: schedule remote query interval to 100 msecs.
[    4.916686] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized and connected.
[    4.928449] usbcore: registered new interface driver dvb_usb_cxusb
[    9.489093] si2168 3-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[   11.266434] si2168 3-0064: firmware version: B 4.0.25
[   11.280454] usb 1-1.5.2: DVB: adapter 0 frontend 0 frequency 0 out of range (42000000..870000000)
[   11.573770] si2168 3-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[   13.350881] si2168 3-0064: firmware version: B 4.0.25

dvb-fe-tool shows this:
Device Silicon Labs Si2168 (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_2G_MODULATION
     CAN_FEC_1_2
     CAN_FEC_2_3
     CAN_FEC_3_4
     CAN_FEC_5_6
     CAN_FEC_7_8
     CAN_FEC_AUTO
     CAN_GUARD_INTERVAL_AUTO
     CAN_HIERARCHY_AUTO
     CAN_INVERSION_AUTO
     CAN_MULTISTREAM
     CAN_MUTE_TS
     CAN_QAM_16
     CAN_QAM_32
     CAN_QAM_64
     CAN_QAM_128
     CAN_QAM_256
     CAN_QAM_AUTO
     CAN_QPSK
     CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.10, Current v5 delivery system: DVBT
Supported delivery systems:
    [DVBT]
     DVBT2
     DVBC/ANNEX_A

why does my dongle doesn't work?

Thanks, Dagg.
