Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m295jnxJ010896
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 00:45:49 -0500
Received: from bay0-omc1-s23.bay0.hotmail.com (bay0-omc1-s23.bay0.hotmail.com
	[65.54.246.95])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m295jARu010936
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 00:45:10 -0500
Message-ID: <BAY106-W33F4407BA8EADCCFBA81F8DA0D0@phx.gbl>
From: GLo arb <gloarb__@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Sun, 9 Mar 2008 06:45:05 +0100
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Cant scan channels
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi everybody.
I have a HVR-950 usb dvb card from Hauppauge.
I installed from http://lunapark6.com/usb-hdtv-tuner-stick-for-windows-linux-hauppauge-wintv-hvr-950.html the driver, here my dmesg:

[ 2378.470898] usb 5-8: new high speed USB device using ehci_hcd and address 6
[ 2378.608354] usb 5-8: configuration #1 chosen from 1 choice
[ 2378.608595] em28xx new video device (2040:6513): interface 0, class 255
[ 2378.608607] em28xx: device is attached to a USB 2.0 bus
[ 2378.608615] em28xx: you're using the experimental/unstable tree from mcentral.de
[ 2378.608624] em28xx: there's also a stable tree available but which is limited to
[ 2378.608632] em28xx: linux <=2.6.19.2
[ 2378.608638] em28xx: it's fine to use this driver but keep in mind that it will move
[ 2378.608646] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
[ 2378.608654] em28xx: proved to be stable
[ 2378.608665] em28xx #0: Alternate settings: 8
[ 2378.608672] em28xx #0: Alternate setting 0, max size= 0
[ 2378.608680] em28xx #0: Alternate setting 1, max size= 0
[ 2378.608688] em28xx #0: Alternate setting 2, max size= 1448
[ 2378.608696] em28xx #0: Alternate setting 3, max size= 2048
[ 2378.608704] em28xx #0: Alternate setting 4, max size= 2304
[ 2378.608712] em28xx #0: Alternate setting 5, max size= 2580
[ 2378.608719] em28xx #0: Alternate setting 6, max size= 2892
[ 2378.608728] em28xx #0: Alternate setting 7, max size= 3072
[ 2379.031492] attach_inform: eeprom detected.
[ 2379.058309] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[ 2379.058340] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[ 2379.058362] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[ 2379.058384] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[ 2379.058406] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2379.058426] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2379.058446] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[ 2379.058467] em28xx #0: i2c eeprom 70: 33 00 30 00 36 00 30 00 37 00 39 00 37 00 30 00
[ 2379.058489] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[ 2379.058510] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[ 2379.058532] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 2379.058554] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 62 32
[ 2379.058606] em28xx #0: i2c eeprom c0: 3e f0 74 02 01 00 01 79 d4 00 00 00 00 00 00 00
[ 2379.058627] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 2379.058649] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 62 32
[ 2379.058678] em28xx #0: i2c eeprom f0: 3e f0 74 02 01 00 01 79 d4 00 00 00 00 00 00 00
[ 2379.058700] EEPROM ID= 0x9567eb1a
[ 2379.058707] Vendor/Product ID= 2040:6513
[ 2379.058713] AC97 audio (5 sample rates)
[ 2379.058718] 500mA max power
[ 2379.058725] Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[ 2379.058742] tveeprom 1-0050: Hauppauge model 65201, rev A1C0, serial# 4076130
[ 2379.058753] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[ 2379.058764] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[ 2379.058775] tveeprom 1-0050: audio processor is None (idx 0)
[ 2379.058783] tveeprom 1-0050: has radio
[ 2379.061053] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 2379.061121] attach inform (default): detected I2C address c2
[ 2379.061134] /lib/firmware/v4l-dvb-kernel/v4l/tuner-core.c: setting tuner callback
[ 2379.061142] tuner 0x61: Configuration acknowledged
[ 2379.061150] /lib/firmware/v4l-dvb-kernel/v4l/tuner-core.c: setting tuner callback
[ 2379.061373] /lib/firmware/v4l-dvb-kernel/v4l/xc3028-tuner.c: attach request!
[ 2379.061384] /lib/firmware/v4l-dvb-kernel/v4l/tuner-core.c: xc3028 tuner successfully loaded
[ 2379.067377] attach_inform: tvp5150 detected.
[ 2379.131028] tvp5150 1-005c: tvp5150am1 detected.
[ 2379.221237] Loading base firmware: xc3028_init0.i2c.fw
[ 2380.117016] Loading default analogue TV settings: xc3028_BG_PAL_A2_A.i2c.fw
[ 2380.140225] xc3028-tuner.c: firmware 2.7
[ 2380.140240] ANALOG TV REQUEST
[ 2380.146350] em28xx #0: V4L2 device registered as /dev/video0
[ 2380.146365] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2380.146373] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2380.146935] em2880-dvb.c: DVB Init
[ 2380.146960] Loading base firmware: xc3028_8MHz_init0.i2c.fw
[ 2381.632258] Loading specific dtv settings: xc3028_DTV8_2633.i2c.fw
[ 2381.656090] xc3028-tuner.c: firmware 2.7
[ 2381.656106] Sending extra call for Digital TV!
[ 2381.758256] /lib/firmware/v4l-dvb-kernel/v4l/xc3028-tuner.c: attach request!
[ 2381.758276] DVB: registering new adapter (em2880 DVB-T)
[ 2381.758286] DVB: registering frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[ 2381.758808] em28xx #0: Found Hauppauge WinTV HVR 950
[ 3131.216174] Loading base firmware: xc3028_8MHz_init0.i2c.fw
[ 3132.242387] Loading specific dtv settings: xc3028_DTV6_ATSC_2620.i2c.fw
[ 3132.272457] xc3028-tuner.c: firmware 2.7
[ 3132.272473] Sending extra call for Digital TV!
[ 3132.275949] DIGITAL TV REQUEST
[ 3132.275966] Loading Bandwidth settings: xc3028_DTV6_ATSC_2620.i2c.fw
[ 3132.797360] DIGITAL TV REQUEST
[ 3133.297150] DIGITAL TV REQUEST

I think everything is ok.
I try to scan channels, but no success:

sudo /usr/bin/scan /usr/share/doc/dvb-utils/examples/scan/atsc/us-NTSC-center-frequencies-8VSB> ~/channels.conf

WARNING:>>> tuning failed!!!
...
>>> tune to: 177000000:8VSB (tuning failed)
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb
...

I live at Montreal (CANADA).

I run scan on a windo$ and i have channels, bad quality (local antenna). 

Any ideas?
_________________________________________________________________
Microsoft vous recommande de mettre à jour Internet Explorer.
http://specials.fr.msn.com/IE7P25

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
