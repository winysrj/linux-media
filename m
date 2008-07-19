Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6JKHnRX018814
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 16:17:49 -0400
Received: from interpont.hu (qmailr@gandalf.interpont.hu [87.229.73.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6JKHYJO028929
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 16:17:34 -0400
Message-ID: <40552.89.135.34.134.1216498656.squirrel@webmail.interpont.hu>
Date: Sat, 19 Jul 2008 22:17:36 +0200 (CEST)
From: interpont@interpont.hu
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Subject: New em2821 based tv tuner ... how will it work?
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



Hi,



I have installed V4L CVS according to this page:

http://linuxtv.org/v4lwiki/index.php/How_to_build_from_Mercurial



I have an "ADS Tech Instant TV USB" device. See website:

http://www.adstech.com/support/productsupport.asp?productId=USBAV-704&productName=Instant%20TV%20USB



# lsusb

Bus 007 Device 001: ID 0000:0000  

Bus 006 Device 001: ID 0000:0000  

Bus 005 Device 001: ID 0000:0000  

Bus 002 Device 001: ID 0000:0000  

Bus 001 Device 001: ID 0000:0000  

Bus 004 Device 002: ID eb1a:2821 eMPIA Technology, Inc. 

Bus 004 Device 001: ID 0000:0000  

Bus 003 Device 001: ID 0000:0000  



# dmesg | grep em28

[   69.073149] em28xx v4l2 driver version 0.1.0 loaded

[   69.073222] em28xx new video device (eb1a:2821): interface 0, class
255

[   69.073290] em28xx Has usb audio class

[   69.073293] em28xx #0: Alternate settings: 8

[   69.073297] em28xx #0: Alternate setting 0, max size= 0

[   69.073301] em28xx #0: Alternate setting 1, max size= 1024

[   69.073306] em28xx #0: Alternate setting 2, max size= 1448

[   69.073309] em28xx #0: Alternate setting 3, max size= 2048

[   69.073313] em28xx #0: Alternate setting 4, max size= 2304

[   69.073317] em28xx #0: Alternate setting 5, max size= 2580

[   69.073321] em28xx #0: Alternate setting 6, max size= 2892

[   69.073325] em28xx #0: Alternate setting 7, max size= 3072

[   69.076079] em28xx #0: em28xx chip ID = 18

[   69.317350] em28xx #0: found i2c device @ 0x4a [saa7113h]

[   69.321464] em28xx #0: found i2c device @ 0x60 [remote IR sensor]

[   69.328594] em28xx #0: found i2c device @ 0x86 [tda9887]

[   69.340589] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]

[   69.351086] em28xx #0: Your board has no unique USB ID and thus need a
hint to be detected.

[   69.351148] em28xx #0: You may try to use card=<n> insmod option
to workaround that.

[   69.351217] em28xx #0: Please send an email with this log to:

[   69.351281] em28xx #0: 	V4L Mailing List
<video4linux-list@redhat.com>

[   69.351345] em28xx #0: Board eeprom hash is 0x00000000

[   69.351410] em28xx #0: Board i2c devicelist hash is 0x8cad00a0

[   69.351474] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:

[   69.351555] em28xx #0:     card=0 -> Unknown EM2800 video grabber

[   69.351620] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber

[   69.351686] em28xx #0:     card=2 -> Terratec Cinergy 250 USB

[   69.351750] em28xx #0:     card=3 -> Pinnacle PCTV USB 2

[   69.351812] em28xx #0:     card=4 -> Hauppauge WinTV USB 2

[   69.351875] em28xx #0:     card=5 -> MSI VOX USB 2.0

[   69.351937] em28xx #0:     card=6 -> Terratec Cinergy 200 USB

[   69.352000] em28xx #0:     card=7 -> Leadtek Winfast USB II

[   69.352063] em28xx #0:     card=8 -> Kworld USB2800

[   69.352126] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC
100

[   69.352190] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900

[   69.352254] em28xx #0:     card=11 -> Terratec Hybrid XS

[   69.352316] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF

[   69.352379] em28xx #0:     card=13 -> Terratec Prodigy XS

[   69.352441] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB
2.0

[   69.352507] em28xx #0:     card=15 -> V-Gear PocketTV

[   69.352568] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950

[   69.352633] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick

[   69.352697] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)

[   69.352762] em28xx #0:     card=19 -> PointNix Intra-Oral Camera

[   69.886366] em28xx #0: V4L2 device registered as /dev/video0 and
/dev/vbi0

[   69.886379] em28xx #0: Found Unknown EM2750/28xx video grabber

[   69.886418] em28xx audio device (eb1a:2821): interface 1, class 1

[   69.886504] em28xx audio device (eb1a:2821): interface 2, class 1

[   69.886597] usbcore: registered new interface driver em28xx



Television standard for my country (Hungary): PAL (same as in Austria and
Germany)



The problem:

In the dmesg it tells that "V4L2 device registered as /dev/video0 and
/dev/vbi0" but actually there is no /dev/video0 or similar. I tried
to open /dev/video0 with vlc and tvtime.



For example tvtime-scanner reports:

Reading configuration: /etc/tvtime/tvtime.xml

Reading configuration: /root/.tvtime/tvtime.xml

Scanning with PAL norms.

/root/.tvtime/stationlist.xml: No existing PAL station list
"Custom".

videoinput: No inputs available on video4linux2 device '/dev/video0'.





Please help... what to do next?



Thanks a lot,



David
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
