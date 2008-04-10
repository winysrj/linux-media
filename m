Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3AID67T014862
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 14:13:07 -0400
Received: from pasmtpA.tele.dk (pasmtpa.tele.dk [80.160.77.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3AICsiS024562
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 14:12:55 -0400
Received: from rhea.solnet (0x57352a0d.vgnxx8.adsl-dhcp.tele.dk [87.53.42.13])
	by pasmtpA.tele.dk (Postfix) with ESMTP id 63328801B3B
	for <video4linux-list@redhat.com>;
	Thu, 10 Apr 2008 20:11:53 +0200 (CEST)
Date: Thu, 10 Apr 2008 20:11:51 +0200
From: "Jesper K. Pedersen" <linux@famped.dk>
To: video4linux-list@redhat.com
Message-ID: <20080410201151.5647224c@io.solnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: BlueTinum BT-TTU305 V2.0 - USB DVD converter box with TV Tuner (not
 working but now "almost" recognized)
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

Here is the result using the latest V4L downloaded from the mercurial
latest release using my BlueTinum USB dvd converter/tv tuner

-- 
 usb 3-4.3: new high speed USB device using ehci_hcd and address 5
 usb 3-4.3: configuration #1 chosen from 1 choice
 Linux video capture interface: v2.00
 em28xx v4l2 driver version 0.1.0 loaded
 em28xx new video device (eb1a:2821): interface 0, class 255
 em28xx Has usb audio class
 em28xx #0: Alternate settings: 8
 em28xx #0: Alternate setting 0, max size= 0
 em28xx #0: Alternate setting 1, max size= 1024
 em28xx #0: Alternate setting 2, max size= 1448
 em28xx #0: Alternate setting 3, max size= 2048
 em28xx #0: Alternate setting 4, max size= 2304
 em28xx #0: Alternate setting 5, max size= 2580
 em28xx #0: Alternate setting 6, max size= 2892
 em28xx #0: Alternate setting 7, max size= 3072
 em28xx #0: em28xx chip ID = 18
 em28xx #0: found i2c device @ 0x4a [saa7113h]
 em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
 em28xx #0: Your board has no unique USB ID and thus need a hint to be
detected. em28xx #0: You may try to use card=<n> insmod option to
workaround that. em28xx #0: Please send an email with this log to:
 em28xx #0: 	V4L Mailing List <video4linux-list@redhat.com>
 em28xx #0: Board eeprom hash is 0x00000000
 em28xx #0: Board i2c devicelist hash is 0xc51200e3
 em28xx #0: Here is a list of valid choices for the card=<n> insmod
option: em28xx #0:     card=0 -> Unknown EM2800 video grabber
 em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
 em28xx #0:     card=2 -> Terratec Cinergy 250 USB
 em28xx #0:     card=3 -> Pinnacle PCTV USB 2
 em28xx #0:     card=4 -> Hauppauge WinTV USB 2
 em28xx #0:     card=5 -> MSI VOX USB 2.0
 em28xx #0:     card=6 -> Terratec Cinergy 200 USB
 em28xx #0:     card=7 -> Leadtek Winfast USB II
 em28xx #0:     card=8 -> Kworld USB2800
 em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
 em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
 em28xx #0:     card=11 -> Terratec Hybrid XS
 em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
 em28xx #0:     card=13 -> Terratec Prodigy XS
 em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
 em28xx #0:     card=15 -> V-Gear PocketTV
 em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
 em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
 em28xx #0: Found Unknown EM2750/28xx video grabber
 usbcore: registered new interface driver em28xx

--
Result is unfortunately not a usable unit. 
Xawtv fails with this error :

ioctl: VIDIOC_REQBUFS(count=4;type=VIDEO_CAPTURE;memory=MMAP): Success
ioctl: VIDIOC_S_INPUT(int=0): Invalid argument
v4l2: oops: select timeout
v4l2: read: Interrupted system call
ioctl: VIDIOC_S_CTRL(id=9963785;value=1): Bad file descriptor

--
Performing a "v4l-info" gives the following information.

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "em28xx"
        card                    : "Unknown EM2750/28xx video grabb"
        bus_info                : "3-4.3"
        version                 : 0.1.0
        capabilities            : 0x5020041
[VIDEO_CAPTURE,?,AUDIO,READWRITE,STREAMING]

standards
    VIDIOC_ENUMSTD(0)
        index                   : 0
        id                      : 0xff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
name                    : "PAL" frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(1)
        index                   : 1
        id                      : 0x100 [PAL_M]
        name                    : "PAL-M"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(2)
        index                   : 2
        id                      : 0x200 [PAL_N]
        name                    : "PAL-N"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(3)
        index                   : 3
        id                      : 0x400 [PAL_Nc]
        name                    : "PAL-Nc"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(4)
        index                   : 4
        id                      : 0x800 [PAL_60]
        name                    : "PAL-60"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(5)
        index                   : 5
        id                      : 0xb000 [NTSC_M,NTSC_M_JP,?]
        name                    : "NTSC"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(6)
        index                   : 6
        id                      : 0x4000 [?]
        name                    : "NTSC-443"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(7)
        index                   : 7
        id                      : 0xff0000
[SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
name                    : "SECAM" frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625

inputs

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "Packed YUY2"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 720
        fmt.pix.height          : 576
        fmt.pix.pixelformat     : 0x56595559 [YUYV]
        fmt.pix.field           : INTERLACED
        fmt.pix.bytesperline    : 1440
        fmt.pix.sizeimage       : 829440
        fmt.pix.colorspace      : SMPTE170M
        fmt.pix.priv            : 0

controls

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "Unknown EM2750/28xx video grabb"
        type                    : 0x1 [CAPTURE]
        channels                : 0
        audios                  : 0
        maxwidth                : 720
        maxheight               : 576
        minwidth                : 48
        minheight               : 32

channels

tuner
    VIDIOCGTUNER
        tuner                   : 0
        name                    : "Tuner"
        rangelow                : 0
        rangehigh               : 0
        flags                   : 0x7 [PAL,NTSC,SECAM]
        mode                    : PAL
        signal                  : 0

audio
    VIDIOCGAUDIO
        audio                   : 0
        volume                  : 65535
        bass                    : 0
        treble                  : 0

picture
    VIDIOCGPICT
        brightness              : 0
        hue                     : 0
        colour                  : 0
        contrast                : 0
        whiteness               : 0
        depth                   : 16
        palette                 : YUYV

buffer
ioctl VIDIOCGFBUF: Invalid argument

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 720
        height                  : 576
        chromakey               : 0
        flags                   : 0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
