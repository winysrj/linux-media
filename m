Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5J2SRsO015310
	for <video4linux-list@redhat.com>; Thu, 18 Jun 2009 22:28:27 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n5J2SDQL009274
	for <video4linux-list@redhat.com>; Thu, 18 Jun 2009 22:28:14 -0400
Received: by wf-out-1314.google.com with SMTP id 28so616124wfa.6
	for <video4linux-list@redhat.com>; Thu, 18 Jun 2009 19:28:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 10:28:13 +0800
Message-ID: <f927bc850906181928r240d71d7y587b116ef8559124@mail.gmail.com>
From: =?ISO-2022-JP?B?GyRCPlVFX0VfGyhC?= <do2jiang@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: servfox error
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

hello,everyon!
my arm9-linux is kernel 2.6.8.1.there is this error as follow ,when i
patched usb-2.6.8.1-2.patch and cross-compiled spcaview-20061208 and
servfox-R1_1_3.
use command xxx -d /dev/video0 -g -f yuv -s 320x240 -w 10240
the board is edb9302. arm-linux-gcc-3.3
spcaview and  servfox run well on my pc.

error form runing spcaser:
Damned second try fail
try palette 3 depth 16
Couldnt set palette first try 3
Damned second try fail
try palette 5 depth 32
Couldnt set palette first try 5
Damned second try fail
probe size in
Available Resolutions width 640  heigth 480
Available Resolutions width 384  heigth 288
Available Resolutions width 352  heigth 288
Available Resolutions width 320  heigth 240
Available Resolutions width 192  heigth 144
Available Resoludrivers/usb/media/spca5xx/spca_core.c: VIDIOCMCAPTURE:
invalid f
ormat (15)
tions width 176  heigth 144
cmcapture: Invalid argument
 Format asked 15 check -1
VIDIOCSPICT brightnes=32768 hue=49155 color=0 contrast=32768
whiteness=0depth=12
 palette=15
VIDIOCGPICT brightnes=32768 hue=49155 color=0 contrast=32768
whiteness=0depth=8
palette=21
could't set video palette Abort


error from runing servfox:
wrong spca5xx device
StreamId: 0  Camera
VIDIOCSPICT brightnes=32768 hue=49155 color=0 contrast=32768
whiteness=0depth=8
palette=21
VIDIOCGPICT brightnes=32768 hue=49155 color=0 contrast=32768
whiteness=0depth=8
palette=21
 grabbing method READ asked
VIDIOCSWIN height 240  width 320
videoIn.signalquit:1
Waiting .... for connection. CTrl_c to stop !!!!
videoIn.signalquit:1
Killed

I allo have searched some information to solve the problem,but failed.
who can help me?  Thank you very much!

-- 
Jone
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
