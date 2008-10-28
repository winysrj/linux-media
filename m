Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SIdGI0024983
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:39:16 -0400
Received: from MAIL.ELESIA.IT (net134-030.mclink.it [195.110.134.30])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m9SId44l018810
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:39:05 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Tue, 28 Oct 2008 19:38:59 +0100
Message-ID: <7406AFA195507943B258D3AD834FD2209574EB@ELEMAIL.ELE.IT>
From: "Francesco Conte" <fconte@elesia.it>
To: <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Cc: Stefano Pettazzoni <spettazzoni@elesia.it>
Subject: xawtv, overlay and Xinerama
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

Hi all,

I'm having 'funny' un wanted behaviour grabbing images on a multi head
xinerama system.
My system is based on a dual quad xeon MB, NVIDIA Quadro NVS-440 and
Adlink RTV24 (4 channel frame grabber).
OS is RHEL 5 Update 0.
Xorg is configured with xinerama and following modules are loaded:

    Load           "dbe"
    Load           "extmod"
    Load           "type1"
    Load           "freetype"
    Load           "glx"
    Load           "v4l"

xawtv -hwscan returns:

This is xawtv-3.95, running on Linux/i686 (2.6.18-8.el5)
looking for available devices
port 275-275                            [ -xvport 275 ]
    type : Xvideo, video overlay
    name : video4linux

port 276-276                            [ -xvport 276 ]
    type : Xvideo, video overlay
    name : video4linux

port 277-277                            [ -xvport 277 ]
    type : Xvideo, video overlay
    name : video4linux

port 278-278                            [ -xvport 278 ]
    type : Xvideo, video overlay
    name : video4linux

port 279-310
    type : Xvideo, image scaler
    name : NV17 Video Texture

port 311-342
    type : Xvideo, image scaler
    name : NV05 Video Blitter

/dev/video0: OK                         [ -device /dev/video0 ]
    type : v4l2
    name : BT878 video (Adlink RTV24)
    flags: overlay capture tuner

/dev/video1: OK                         [ -device /dev/video1 ]
    type : v4l2
    name : BT878 video (Adlink RTV24)
    flags: overlay capture tuner

/dev/video2: OK                         [ -device /dev/video2 ]
    type : v4l2
    name : BT878 video (Adlink RTV24)
    flags: overlay capture tuner

/dev/video3: OK                         [ -device /dev/video3 ]
    type : v4l2
    name : BT878 video (Adlink RTV24)
    flags: overlay capture tuner


Executing 'xawtv -xvport 276', I can see 2nd input correctly shown on my
1st screen as expected.
>From the shell I can see:
This is xawtv-3.95, running on Linux/i686 (2.6.18-8.el5)
xinerama 0: 1600x1200+0+0
xinerama 1: 1600x1200+1600+0
xinerama 2: 1600x1200+3200+0

Then moving xawtv window on my 2nd screen (it is configured horizontally
one after the other) video input shown becomes the one of 1st channel
(the one expected for -xvport 275).
Moreover if I start 2 xawtv sessions, one for xvport 275(1st) and the
other for xvport 267(2nd), and again I move xawtv 2nd channel window on
second xinerama screen, 1st video input is shown on 2nd xawtv and 1st
xawtv window freezes.

v4l-conf is configured with "v4l-conf -a 0xd87d0000 -b 24", returning:

v4l-conf: using X11 display :0.0
dga: version 2.0
WARNING: No DGA support available for this display.
using user provided base address 0xd87d0000
mode: 4800x1200, depth=24, bpp=24, bpl=14400, base=0xd87d0000
/dev/video0 [v4l2]: configuration done

Each xawtv windows, at the beginning, tells:"4800x1200, 32 bit TrueColor
(LE: bgr-)"; after a while it tells "???"

Any suggestions to solve this or just to investigate?


Further infos:

Xawtv: 3.95

Bttv: 0.9.15 (RHEL5.0)

Adlink bttv.card = 134,134,134,134

Kernel: 2.6.18-8.el5 #1 SMP

Nvidia driver:
NVRM version: NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct  1 14:38:10
PDT 2008
GCC version:  gcc version 4.1.1 20070105 (Red Hat 4.1.1-52)

NOTEs: 
[1]same behaviour with several previous version nvidia driver. 
[2]same behaviour with XFree86 4.7.0 instead of xorg.
[3]same behaviour with Ubuntu Hardy Heron and Suse 11
[4]using xawtv 4 pre, xvport devices does not display video but random
stripes/flashes.

Thanks for your attention,

Francesco

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
