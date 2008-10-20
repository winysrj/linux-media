Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KMasJo017821
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 18:36:54 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KMahSj031775
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 18:36:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id C32BA11A2BF8
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 23:36:42 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id palRd0t49slt for <video4linux-list@redhat.com>;
	Mon, 20 Oct 2008 23:36:42 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 83A6C118C140
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 23:36:42 +0100 (BST)
Message-ID: <48FD07FA.9090402@pickworth.me.uk>
Date: Mon, 20 Oct 2008 23:36:42 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: gspca V2 vs V1: webcam picture very dark
Reply-To: ian@pickworth.me.uk
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

Running my Logitec cheapo webcam on gspca V2, the result is not as good
as when I previously used gspca V1 freestanding (20071224).

Specifically, under V2:
	The picture is very, very dark - can hardly make it out.
	The webcam light switches off after first use, and stays off.

The second may or may not be a problem, but I'm assuming that the light
is signaling something useful, thus its state seems important.

To test the webcam, I'm using spcaview.

Using the freestanding (V1) gspca module on kernel 2.6.26, I see output
below (gspca V1 run). The webcam light switches on when the gspca module
loads, stays on throughout, and after the application finishes as well.
The brightness is normal, ie I can see myself clearly.

Using the new gspca_main/gspca_spca561 modules on kernel 2.6.27 I see
output below (gspca_main/gspca_spca561 run). The webcam light switches
on when the modules are loaded, stays on until spcaview exits, at which
point it switches off. It then stays off until the modules are reloaded.
The brightness is very low indeed - I can hardly make myself out.

The main difference between the two outputs (old then new) seems to be:

---------------------------------------------------
Camera found: Logitech QuickCam EC
Bridge found: SPCA561
Bridge find SPCA561 number 9
StreamId: GBRG Camera
quality 0 autoexpo 1 Timeframe 0 lightfreq 50
Bridge find SPCA561 number 9

vs

Camera found: Camera
Bridge found: spca561
Unable to find a StreamId !!
StreamId: -1 Unknow Camera
----

and

----
VIDIOCGPICT
brightnes=16384 hue=0 color=0 contrast=8192 whiteness=0
depth=12 palette=15

vs

VIDIOCGPICT
brightnes=0 hue=0 color=0 contrast=0 whiteness=0
depth=8 palette=15
--------------------------------

brightness and contrast seem to be way off for the new modules.

So, I'm guessing that some attributes that previously were detected by
gspca are being missed by gspca_spca561.

I am very keen to help make this work properly for gspca V2, but... I am
not much of a C coder. If someone can tell me how to produce useful
diagnostics, and/or point me at some code to fiddle I'm willing to have
a go. However - I'd be best at testing someone else's patches!

dmesg for the gspca_main/gspca_spca561 modules is:
[   28.308979] gspca: main v2.3.0 registered
[   28.333195] gspca: probing 046d:092e
[   28.531364] gspca: probe ok
[   28.531603] spca561: registered

dmesg for the gspca module is:
[   40.140033] gspca: USB GSPCA camera found.(SPCA561A)
[   40.140033] gspca: [spca5xx_probe:4275] Camera type S561
[   40.153846] gspca: [spca5xx_getcapability:1249] maxw 352 maxh 288
minw 160 minh 120
[   40.153907] usbcore: registered new interface driver gspca
[   40.153910] gspca: gspca driver 01.00.20 registered
[   65.614301] gspca: [spca561_init:467] Find spca561 USB Product ID 92e
[   65.828003] gspca: [spca5xx_set_light_freq:1932] Sensor currently not
support light frequency banding filters.


Regards
Ian


---------------------
gspca V1 run
---------------------

ipic@ian2 ~/bin $ spcaview -d /dev/video_webcam
 Spcaview version: 1.1.7 date: 06:11:2006 (C) mxhaard@magic.fr
Initializing SDL.
SDL initialized.
bpp 3 format 15
Using video device /dev/video_webcam.
Initializing v4l.
**************** PROBING CAMERA *********************
Camera found: Logitech QuickCam EC
Bridge found: SPCA561
Bridge find SPCA561 number 9
StreamId: GBRG Camera
quality 0 autoexpo 1 Timeframe 0 lightfreq 50
Bridge find SPCA561 number 9
Available Resolutions width 352  heigth 288 native
Available Resolutions width 320  heigth 240 native *
Available Resolutions width 176  heigth 144 native
Available Resolutions width 160  heigth 120 native
unable to probe size !!
*****************************************************
 grabbing method default MMAP asked
VIDIOCGMBUF size 2457616  frames 2  offets[0]=0 offsets[1]=1228808
VIDIOCGPICT
brightnes=16384 hue=0 color=0 contrast=8192 whiteness=0
depth=12 palette=15
VIDIOCSPICT
brightness=16384 hue=0 color=0 contrast=8192 whiteness=0
depth=24 palette=15


Stop asked

Used 19966ms for 244 images => 81ms/image 12fps.
Quiting SDL.
Decoded frames:244 Average decode time: 1.000000
unmapping
closing
closed
Destroy Picture thread ...
Quiting....


----------------------------
gspca_main/gspca_spca561 run
----------------------------
ipic@ian2 ~/bin $ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so spcaview -d
/dev/video_webcam

 Spcaview version: 1.1.7 date: 06:11:2006 (C) mxhaard@magic.fr
Initializing SDL.
SDL initialized.
bpp 3 format 15
Using video device /dev/video_webcam.
Initializing v4l.
**************** PROBING CAMERA *********************
Camera found: Camera
Bridge found: spca561
Unable to find a StreamId !!
StreamId: -1 Unknow Camera
Available Resolutions width 640  heigth 480 native
Available Resolutions width 352  heigth 288 native
Available Resolutions width 320  heigth 240 native *
Available Resolutions width 176  heigth 144 native
Available Resolutions width 160  heigth 120 native
unable to probe size !!
*****************************************************
 grabbing method default MMAP asked
VIDIOCGMBUF size 67108864  frames 4  offets[0]=0 offsets[1]=16777216
VIDIOCGPICT
brightnes=0 hue=0 color=0 contrast=0 whiteness=0
depth=8 palette=15
VIDIOCSPICT
brightness=0 hue=0 color=0 contrast=0 whiteness=0
depth=24 palette=15


Stop asked

Used 2131ms for 63 images => 33ms/image 29fps.
Quiting SDL.
Decoded frames:63 Average decode time: 0.000000
unmapping
closing
closed
Destroy Picture thread ...
Quiting....

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
