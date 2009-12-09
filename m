Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:44422 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbZLITxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 14:53:35 -0500
Received: by ewy1 with SMTP id 1so4734468ewy.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 11:53:41 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 20:53:38 +0100
Message-ID: <51be034e0912091153n663111c5pe920f405c5befa13@mail.gmail.com>
Subject: MSI StarCam working in vlc only (with poor colors)
From: Jozef Riha <jose1711@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello dear ML members,

I wonder whether you can help me with the following issue. My webcam
MSI StarCam (http://www.aaronpc.cz/produkty/msi-starcam-370i)
identified as

(lsusb)
Bus 003 Device 002: ID 1b3b:2951 iPassion Technology Inc. PC
Camera/Webcam controller

(dmesg)
input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:1d/LNXVIDEO:00/input/input8
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device <unnamed> (1b3b:2951)
uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling
workaround.
input: UVC Camera (1b3b:2951) as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input9
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)

It is apparently detected while appropriate modules are loaded
(v4l1_compat, uvcvideo, videodev), but of 3 tested applications: vlc,
xawtv and skype, only vlc shows some output. Moreover there's plenty
of

uvcvideo: Failed to query (130) UVC probe control : -32 (exp. 26).

in dmesg.log.

The console outputs of all three programs follow.

xawtv:

libv4l2: error setting pixformat: Input/output error
ioctl: VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=320;fmt.pix.height=240;fmt.pix.pixelformat=0x47504a4d
[MJPG];fmt.pix.field=NONE;fmt.pix.bytesperline=0;fmt.pix.sizeimage=77312;fmt.pix.colorspace=SRGB;fmt.pix.priv=0):
Input/output error
ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument

skype:

libv4l2: error setting pixformat: Input/output error

vlc v4l2://

[0xa18a530] main input error: demux doesn't like DEMUX_GET_TIME
(probably irrelevant)

As I wrote above vlc is able to capture the image but the quality is
really low - please see screenshot at
http://yfrog.com/86vlcsnap2009120920h48m50p

I'd be glad to see the colors improved but main concern is that the
camera does not seem to be Skype-friendly.

Is there anything that can be done to improve this situation?

Thank you,

joe
