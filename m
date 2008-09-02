Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m82N7eSA029391
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 19:07:41 -0400
Received: from n6.bullet.ukl.yahoo.com (n6.bullet.ukl.yahoo.com
	[217.146.182.183])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m82N7A3s018591
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 19:07:10 -0400
From: Lars Oliver Hansen <lolh@ymail.com>
To: video4linux-list@redhat.com
Date: Wed, 03 Sep 2008 01:06:52 +0200
Message-Id: <1220396812.3752.46.camel@lars-laptop>
Mime-Version: 1.0
Subject: em28xx-based KWorld 310U delivers no signal, 2 drivers tried
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0980010013=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============0980010013==
Content-Type: multipart/related; type="multipart/alternative";
	boundary="=-/trEqekWwOEUAfPTdizS"


--=-/trEqekWwOEUAfPTdizS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

I had troubles with my saa7134 card (driver got in a phase where it
never powered on the device again) so I fetched an em2880-based KWorld
DVB-T 310U. I feel awkward bothering you again but this device doesn't
want to work properly, 2 different drivers tried, although I researched
before my purchase which device would most probably work.

I tried the v4l-dvb-kernel em28xx driver from mcentral linked to at
http://mcentral.de/wiki/index.php5/Em2880 which is where one gets
directed to when following the links about supported hardware using
video via usb em28xx from the v4l wiki main page.

When using tvtime-scanner it reports I/O error, driver doesn't want to
stop streaming, driver doesn't want to start streaming and can't drop
frame after a while. When using tvtimes gui scanner it hangs at a random
channel after a while. While it has gathered some channels then, it
hasn't got all. Sometimes tvtime only output black and white and
sometimes in color and it freezes at a frame after some while. dmesg
says incorrect setup device. For the rare moments the tv image was fine,
dmesg gave analog tv request.

DVB-T scanning went fine with scan from dvb-utils and w_scan only
mplayer doesn't have an option for TV in its gui (I reconfigured mplayer
and got v4l support reported and recompiled) and I won't bash tune
manually everytime, so I never saw a DVB-T image and mplayer is the only
option with Gnome as far as I gathered (kaffeine is for KDE, someone
wrote xine is for grandfathers and Totem, well I didn't find the
directory where to place channels.conf).

Then I switched to the v4l-dvb driver which is the first link in the
users section on v4l wikis main page. This driver put out to dmesg: 

[    0.000000] Linux video capture interface: v2.00
[    0.000000] em28xx v4l2 driver version 0.1.0 loaded
[    0.000000] em28xx new video device (eb1a:e310): interface 0, class
255
[    0.000000] em28xx Has usb audio class
[    0.000000] em28xx #0: Alternate settings: 8
[    0.000000] em28xx #0: Alternate setting 0, max size= 0
[    0.000000] em28xx #0: Alternate setting 1, max size= 0
[    0.000000] em28xx #0: Alternate setting 2, max size= 1448
[    0.000000] em28xx #0: Alternate setting 3, max size= 2048
[    0.000000] em28xx #0: Alternate setting 4, max size= 2304
[    0.000000] em28xx #0: Alternate setting 5, max size= 2580
[    0.000000] em28xx #0: Alternate setting 6, max size= 2892
[    0.000000] em28xx #0: Alternate setting 7, max size= 3072
[    0.000000] em28xx #0: chip ID is em2882/em2883
[    0.000000] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 50 12
5c 03 6a 22 00 00
[    0.000000] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
00 00 5b 1e 00 00
[    0.000000] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[    0.000000] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 44 00
[    0.000000] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[    0.000000] EEPROM ID= 0x9567eb1a, hash = 0x966a0441
[    0.000000] Vendor/Product ID= eb1a:e310
[    0.000000] AC97 audio (5 sample rates)
[    0.000000] 500mA max power
[    0.000000] Table at 0x04, strings=0x226a, 0x0000, 0x0000
[    0.000000] em28xx #0: 
[    0.000000] 
[    0.000000] em28xx #0: The support for this board weren't valid yet.
[    0.000000] em28xx #0: Please send a report of having this working
[    0.000000] em28xx #0: not to V4L mailing list (and/or to other
addresses)
[    0.000000] 
[    0.000000] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
[    0.000000] xc2028 1-0061: creating new instance
[    0.000000] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
[    0.000000] tvp5150 1-005c: tvp5150am1 detected.
[    0.000000] em28xx #0: V4L2 device registered as /dev/video0
and /dev/vbi0
[    0.000000] em28xx #0: Found MSI DigiVox A/D
[    0.000000] usbcore: registered new interface driver em28xx
[    0.000000] tvp5150 1-005c: tvp5150am1 detected.
[    0.000000] tvp5150 1-005c: tvp5150am1 detected.
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
[    0.000000] tvp5150 1-005c: tvp5150am1 detected.
[    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.

After I got the firmware following the instructions on the wiki, tvtimes
takes approximately 10 seconds to load (it seems to load 80 different
firmwares) in contrast to instant load before but tvtime says no signal
and while it can scan the screen remains blue.

I tried the zapping application but it delivers 3 error messages before
it segfaults: /dev/vbi0 is no vbi device, -- that's it at another try,
it was sth like driver doesn't support video_overlay and sth long string
before.

What are the best working options to get my KWorld DVB-T 310U usable in
analog TV mode at least? Which driver to I have to take, what would I
have to do? (I removed my previous saa7134 driver installation
completely, so probably no old modules lying around). I'm on Ubuntu 8.04
but I have a vanilla kernel 2.6.27-rc5 source at hand  (yes which I
configured, compiled and have working with Ubuntu in another grub
entry :-)), which v4l drivers would I have to enable there to use that
kernels drivers?

Thanks fro any help!

Kind and Best Regards

Lars

--=-/trEqekWwOEUAfPTdizS
Content-ID: <1220396404.3752.38.camel@lars-laptop>
Content-Disposition: attachment; filename=stock_smiley-1.png
Content-Type: image/png; name=stock_smiley-1.png
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAAB3RJ
TUUH1wgOER8RqU5d7gAAAwtJREFUOI1lk01oXGUYhZ/73Ts/sWPiT8YE2ti6SF00jDWBaBWLuhFB
QgUNQsFdCair2pVSBV3YGkNWDVjcqKlIaG2sLf5EUBqTBkqjTFMi2Px2ojOTpJnMZHLnfvd+3+si
VKR5V2dxOBx4z+Nw1419QZty3R5EdYmJmgEcpfIgF6zYT59+nan/+5074sYQ8XIQG/ASjYdbDxyP
px58Rql4M0hIFMxQKf5sb149pY1eOdOQ4I193ej/AoaGcFt07PKufUc6dmY+ShBOI+FfQAB4ID5C
CieeYWHy3SA/c/FaLsHB7m4MABNfxfpvTfb4YkpiNi+K1X+K2EDEhiKmIhIVxNauil55R6LNUZkZ
e96fGKQfwBn7jN3xhqZsx8tT9aInUYlOTvSeYrlYoK/3fcRWOdk7wHJxiY8/eBZdPo/X8BZ/XHql
HG5UM0olvaOtT7yXIprF8fYALmfPfcPwt5dANNgyZ8+PMPzdOJh/wOQx/ii7M6+mSHJU4ahDqfRz
SqJ5cGIgNR5t3Uv7/gxifbDr7H0kxeNtOxB9A3Aw/jip9EHlCIc8G0VNKpZGdBGiHOI+xODnJ0FC
xK6AKfDl6ZcgmkOiRcBg9QLJB1qwliYPAIkQKUM4DbYETt1WfSmDWQa7BraKNTXEBohoQADwHNct
mGD+YSUKMXkc8cFJbhlsFbFrYFYRW8KaDazxQaUJ/XmUoqAEM1wufG/xdkK0xOTICW4v/YKuTmP0
AjbMEdYWWc3Pcv1KFmMquHWdVJYvW3EY3nrjvfdl27t+qpfKaW5X2slN9VEtLWEiDYDredxT38iu
treJywB16Q/J/nikHG5UM1tDGlT9c1de9CN/XMK1T8TUrok1ayJWi9hAbLQqYXVUqn+/KUHpa5n5
7anNO0PyABbj9pi9+UOniNPR8tjxRLgxgvF/xeg5xAY4bhq37gDejhe4db2vVpwb/z2X4Ng2mNZr
DLjx+w/v2f9aPNX4pIolW0AsoT9LZWXCLmTPaaPXzzQk74JpG84OPQJdWJoBUOQduGCFbTj/C8H3
uN+XWOgHAAAAAElFTkSuQmCC


--=-/trEqekWwOEUAfPTdizS--


		
___________________________________________________________ 
Try the all-new Yahoo! Mail. "The New Version is radically easier to use"  The Wall Street Journal 
http://uk.docs.yahoo.com/nowyoucan.html


--===============0980010013==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0980010013==--


		
___________________________________________________________ 
Try the all-new Yahoo! Mail. "The New Version is radically easier to use"  The Wall Street Journal 
http://uk.docs.yahoo.com/nowyoucan.html
