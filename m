Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o23DCWA3026218
	for <video4linux-list@redhat.com>; Wed, 3 Mar 2010 08:12:32 -0500
Received: from smtp.positive-internet.com (mx0.positive-internet.com
	[80.87.128.64])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o23DCIIc024304
	for <video4linux-list@redhat.com>; Wed, 3 Mar 2010 08:12:19 -0500
Subject: em28xx v4l-info returns gibberish on igepv2
From: John Banks <john.banks@noonanmedia.com>
To: video4linux-list@redhat.com
Date: Wed, 03 Mar 2010 13:12:18 +0000
Message-ID: <1267621938.3066.46.camel@chimpin>
Mime-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have an usb capture card that accepts composite and svideo and outputs
raw video through v4l2.

When running the card on my laptop (ubuntu karmic) I am able to use
gstreamer to dump the raw video to a file. It comes out as yuv and can
be easily played back.

However when I plug it into our embedded arm board (it's an igepv2 which
runs on an omap3530 soc) the same gstreamer command results in a near
empty file. Here is part of a hexdump:
chimp@ll-1:~$ hexdump output.yuv | head
0000000 4747 4746 0000 0000 0000 0000 0000 0000
0000010 0000 0000 0000 0000 0000 0000 0000 0000
*
00005a0 4847 4747 0000 0000 0000 0000 0000 0000
00005b0 0000 0000 0000 0000 0000 0000 0000 0000
*
00ca800 4847 4748 0000 0000 0000 0000 0000 0000
00ca810 0000 0000 0000 0000 0000 0000 0000 0000

Running v4l-info reveals some sort of problem with it parsing the
capabilities of the card:

standards
    VIDIOC_ENUMSTD(0)
        index                   : 0
        id                      : 0xb00000000000 [(null),(null),(null)]
        name                    : ""
        frameperiod.numerator   : 0
        frameperiod.denominator : 1001
        framelines              : 30000


Full output here http://pastebin.com/0Ah6SYTX

While running it on my laptop I get the seemingly correct response:

standards
    VIDIOC_ENUMSTD(0)
        index                   : 0
        id                      : 0xb000 [NTSC_M,NTSC_M_JP,?]
        name                    : "NTSC"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525


Full output from laptop here http://pastebin.com/JNmMHVt2

The igepv2 board is currently running 2.6.33-rc8 however I also tested
it on the 2.6.28.10 kernel and same problem occurred.

Finally here is the output from dmesg when its plugged in:
[ 2085.872894] em28xx: New device @ 480 Mbps (eb1a:2860, interface 0,
class 0)
[ 2085.873138] em28xx #0: chip ID is em2860
[ 2085.987823] em28xx #0: board has no eeprom
[ 2086.012329] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[ 2086.031188] em28xx #0: found i2c device @ 0x4a [saa7113h]
[ 2086.072143] em28xx #0: Your board has no unique USB ID.
[ 2086.081451] em28xx #0: A hint were successfully done, based on i2c
devicelist hash.
[ 2086.093231] em28xx #0: This method is not 100% failproof.
[ 2086.102722] em28xx #0: If the board were missdetected, please email
this log to:
[ 2086.114257] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[ 2086.125030] em28xx #0: Board detected as EM2860/SAA711X Reference
Design
[ 2086.135925] em28xx #0: Registering snapshot button...
[ 2086.155548] input: em28xx snapshot button
as /devices/platform/ehci-omap.0/usb1/1-1/input/input1
[ 2086.645385] saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[ 2087.566986] em28xx #0: Config register raw data: 0x00
[ 2087.629058] em28xx #0: v4l2 driver version 0.1.2
[ 2088.277679] em28xx #0: V4L2 video device registered as video1
[ 2088.277709] em28xx #0: V4L2 VBI device registered as vbi0

-- 
John Banks - Head of Engineering
Noonan Media Ltd 

www.noonanmedia.com 

MB: +44 779 62 64 707 
E: john.banks@noonanmedia.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
