Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n380WdWo009140
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 20:32:39 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n380WHSb018060
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 20:32:18 -0400
Received: by wa-out-1112.google.com with SMTP id v33so1965828wah.19
	for <video4linux-list@redhat.com>; Tue, 07 Apr 2009 17:32:17 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Apr 2009 20:32:17 -0400
Message-ID: <c9d40de90904071732h47699f11p535ea725f49899aa@mail.gmail.com>
From: Alan McCosh <amccosh@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: AVerMedia MiniPCI DVB-T Hybrid
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

Hello All,

I'm working with the AVerMedia MiniPCI DVB-T Hybrid, [1461:f636].
Running 2.6.29.1, I'm stuck getting 'No Signal' in tvtime, black
screen in mplayer.

Debug infos:
=================================================
user@localhost ~ $ dmesg | grep saa
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
saa7133[0]: found at 0000:01:00.0, rev: 209, irq: 16, latency: 32,
mmio: 0xe8000000
saa7133[0]: subsystem: 1461:f636, board: AVerMedia MiniPCI DVB-T
Hybrid M103 [card=145,autodetected]
saa7133[0]: board init: gpio is 220000
IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: 61 14 36 f6 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 0e ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 1-0061: chip found @ 0xc2 (saa7133[0])
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
DVB: registering new adapter (saa7133[0])
=================================================
user@localhost ~ $ dmesg | grep tuner
tuner' 1-0061: chip found @ 0xc2 (saa7133[0])
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
=================================================
user@localhost ~/.tvtime $ tvtime -vvv
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/user/.tvtime/tvtime.xml
cpuinfo: CPU Intel(R) Pentium(R) M processor 1.40GHz, family 6, model
13, stepping 8.
cpuinfo: CPU measured at 1395.434MHz.
xcommon: Display :0.0, vendor The X.Org Foundation, vendor release 10300000
xfullscreen: Using XINERAMA for dual-head information.
xfullscreen: Pixels are square.
xfullscreen: Number of displays is 1.
xfullscreen: Head 0 at 0,0 with size 1024x768.
xcommon: Have XTest, will use it to ping the screensaver.
xcommon: Pixel aspect ratio 1:1.
xcommon: Pixel aspect ratio 1:1.
xcommon: Window manager is Openbox and is EWMH compliant.
xcommon: Using EWMH state fullscreen property.
xcommon: Using EWMH state above property.
xcommon: Using EWMH state below property.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xvoutput: Using XVIDEO adaptor 73: Intel(R) Video Overlay.
speedycode: Using MMXEXT optimized functions.
station: Reading stationlist from /home/user/.tvtime/stationlist.xml
videoinput: Using video4linux2 driver 'saa7134', card 'AVerMedia
MiniPCI DVB-T Hybrid ' (bus PCI:0000:01:00.0).
videoinput: Version is 526, capabilities 5010015.
videoinput: Width 768 too high, using 704 instead as suggested by the driver.
videoinput: Maximum input width: 704 pixels.
tvtime: Sampling input at 704 pixels per scanline.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xcommon: Received a map, marking window as visible (75).
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 1024x768 window inside 1024x768 space.
=================================================
user@localhost ~ $ lsmod
Module                  Size  Used by
i915                  108812  2
genrtc                  4620  0
saa7134_dvb             9092  0
lnbp21                   680  1 saa7134_dvb
tda826x                 1520  1 saa7134_dvb
mt352                   3504  1 saa7134_dvb
tda10086                5648  1 saa7134_dvb
dvb_pll                 5652  1 saa7134_dvb
videobuf_dvb            2768  1 saa7134_dvb
dvb_core               54440  1 videobuf_dvb
nxt200x                 9232  1 saa7134_dvb
isl6421                  744  1 saa7134_dvb
zl10353                 4280  1 saa7134_dvb
tda1004x                9968  1 saa7134_dvb
tuner                  16520  0
tea5767                 4112  1 tuner
tda8290                12436  1 tuner
tda18271               25760  1 tda8290
tda827x                 6864  2 saa7134_dvb,tda8290
tuner_xc2028           14572  2 saa7134_dvb,tuner
xc5000                  7440  1 tuner
tda9887                 6624  1 tuner
tuner_simple            9344  2 saa7134_dvb,tuner
tuner_types             7240  1 tuner_simple
mt20xx                  8896  1 tuner
tea5761                 2576  1 tuner
snd_intel8x0           17388  1
snd_ac97_codec         67324  1 snd_intel8x0
ac97_bus                 456  1 snd_ac97_codec
i2c_i801                5496  0
saa7134               105188  2 saa7134_dvb
ir_common              30296  1 saa7134
v4l2_common             7880  2 tuner,saa7134
videodev               28592  4 tuner,saa7134,v4l2_common
v4l1_compat             9296  1 videodev
videobuf_dma_sg         5168  2 saa7134_dvb,saa7134
8139too                13084  0
videobuf_core           8560  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom                9104  1 saa7134
8139cp                 11472  0
mii                     2472  2 8139too,8139cp
usbtouchscreen          4952  0
=================================================

Any advice is greatly appreciated :)

Cheers,
Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
