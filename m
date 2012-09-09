Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2394 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2IIIsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 04:48:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Fergal Butler" <fbutler@blueyonder.co.uk>
Subject: Re: v42l-ctl not working correctly with a em28xx device
Date: Sun, 9 Sep 2012 10:48:18 +0200
Cc: "'V4L Mailing List'" <linux-media@vger.kernel.org>
References: <007201cd8dee$bef98990$3cec9cb0$@blueyonder.co.uk> <008c01cd8def$22613af0$6723b0d0$@blueyonder.co.uk>
In-Reply-To: <008c01cd8def$22613af0$6723b0d0$@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209091048.18416.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat September 8 2012 20:24:05 Fergal Butler wrote:
> Hi,
> 
> I was wondering if you could help me.
> 
> I have an EzCAP 116 USB 2.0 Video Capture  device purchased directly from
> http://www.ezcap.tv/ 
> 
> I can play audio from the device, however all my attempts to view video from
> it result in either a green or black screen
> 
> v4l2-ctl appears to not be working correctly with it. This is illustrated by
> trying to set the standard on the device as shown below.
> 
> Any advice on how to get both video and audio from the device would be much
> appreciated
> 
> The device is connected to a raspberry pi running raspian: “Linux raspi1
> 3.2.27+ #114 PREEMPT Tue Sep 4 00:15:33 BST 2012 armv6l GNU/Linux”
> 
> Listing the available standards shows:
> pi@raspi1 ~/capture $ v4l2-ctl --list-standards supported by the device
> shows 
> ioctl: VIDIOC_ENUMSTD
>         Index       : 0
>         ID          : 0x000000000000B000
>         Name        : NTSC
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 1
>         ID          : 0x0000000000001000
>         Name        : NTSC-M
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 2
>         ID          : 0x0000000000002000
>         Name        : NTSC-M-JP
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 3
>         ID          : 0x0000000000008000
>         Name        : NTSC-M-KR
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 4
>         ID          : 0x0000000000004000
>         Name        : NTSC-443
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 5
>         ID          : 0x00000000000000FF
>         Name        : PAL
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 6
>         ID          : 0x0000000000000007
>         Name        : PAL-BG
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 7
>         ID          : 0x0000000000000008
>         Name        : PAL-H
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 8
>         ID          : 0x0000000000000010
>         Name        : PAL-I
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 9
>         ID          : 0x00000000000000E0
>         Name        : PAL-DK
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 10
>         ID          : 0x0000000000000100
>         Name        : PAL-M
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 11
>         ID          : 0x0000000000000200
>         Name        : PAL-N
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 12
>         ID          : 0x0000000000000400
>         Name        : PAL-Nc
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 13
>         ID          : 0x0000000000000800
>         Name        : PAL-60
>         Frame period: 1001/30000
>         Frame lines : 525
>         Index       : 14
>         ID          : 0x0000000000FF0000
>         Name        : SECAM
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 15
>         ID          : 0x0000000000010000
>         Name        : SECAM-B
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 16
>         ID          : 0x0000000000040000
>         Name        : SECAM-G
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 17
>         ID          : 0x0000000000080000
>         Name        : SECAM-H
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 18
>         ID          : 0x0000000000320000
>         Name        : SECAM-DK
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 19
>         ID          : 0x0000000000400000
>         Name        : SECAM-L
>         Frame period: 1/25
>         Frame lines : 625
>         Index       : 20
>         ID          : 0x0000000000800000
>         Name        : SECAM-Lc
>         Frame period: 1/25
>         Frame lines : 625        
> If I try and set the standard to PAL-60:
> 
> pi@raspi1 ~/capture $  v4l2-ctl --set-standard PAL-60
> Standard set to 0000b000

Oops! That's a v4l2-ctl bug. The standard parsing routine wasn't case
insensitive. So pal-60 will work while PAL-60 will not.

I've fixed the v4l2-ctl code.

> 
> It sets the standard ID to 0000b000 which is NTSC rather than the 0000800 ID
> associated with PAL-60
> 
> This confirmed by then reading the standard back from the device: 
> 
> pi@raspi1 ~/capture $  v4l2-ctl --get-standard
> Video Standard = 0x0000b000
>         NTSC-M/M-JP/M-KR
> 
> If however I set the standard using the index for PAL-60 it correctly sets
> the standard:
> 
> pi@raspi1 ~/capture $ v4l2-ctl --set-standard 13
> Standard set to 00000800
> 
> Which is confirmed by:
> 
> pi@raspi1 ~/capture $  v4l2-ctl --get-standard
> Video Standard = 0x00000800
>         PAL-60
> 
> The device is identified as follows by lsusb
> 
> pi@raspi1 ~/capture $ lsusb -s 1:39
> Bus 001 Device 039: ID eb1a:2861 eMPIA Technology, Inc. 
> Dmesg shows the following when  the device is plugged in:
> [37368.868492] usb 1-1.3.1.3: new high-speed USB device number 39 using
> dwc_otg
> [37368.968977] usb 1-1.3.1.3: New USB device found, idVendor=eb1a,
> idProduct=2861
> [37368.969001] usb 1-1.3.1.3: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [37369.056218] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class
> 0)
> [37369.056440] em28xx #0: chip ID is em2860
> [37369.171780] em28xx #0: board has no eeprom
> [37369.283182] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [37369.317938] em28xx #0: Your board has no unique USB ID.
> [37369.317961] em28xx #0: A hint were successfully done, based on i2c
> devicelist hash.
> [37369.317973] em28xx #0: This method is not 100% failproof.
> [37369.317982] em28xx #0: If the board were missdetected, please email this
> log to:
> [37369.317993] em28xx #0:       V4L Mailing List 
> <linux-media@vger.kernel.org>
> [37369.318004] em28xx #0: Board detected as EM2860/SAA711X Reference Design
> [37369.408323] em28xx #0: Identified as EM2860/SAA711X Reference Design
> (card=19)
> [37369.408346] em28xx #0: Registering snapshot button...
> [37369.415731] input: em28xx snapshot button as
> /devices/platform/bcm2708_usb/usb1/1-1/1-1.3/1-1.3.1/1-1.3.1.3/input/input12
> 4
> [37370.049046] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a
> (em28xx #0)
> [37371.328710] em28xx #0: Config register raw data: 0x10
> [37371.368476] em28xx #0: AC97 vendor ID = 0x83847652
> [37371.388482] em28xx #0: AC97 features = 0x6a90
> [37371.388500] em28xx #0: Sigmatel audio processor detected(stac 9752)
> [37372.148451] em28xx #0: v4l2 driver version 0.1.3
> [37373.856981] em28xx #0: V4L2 video device registered as video0
> [37373.857009] em28xx #0: V4L2 VBI device registered as vbi0
> [37373.859948] usbcore: registered new interface driver em28xx
> [37373.859973] em28xx driver loaded 
> 
> usb-devices for the device shows:
> T:  Bus=01 Lev=04 Prnt=05 Port=02 Cnt=02 Dev#= 39 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=eb1a ProdID=2861 Rev=01.00
> C:  #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> I:  If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
> I:  If#= 2 Alt= 0 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
> 
> I’ve also tried using a few different card ID’s for the device using:
> 
> pi@raspi1 ~/capture $ sudo rmmod ex28xx
> 
> Followed by 
> 
> pi@raspi1 ~/capture $  sudo modprobe em28xx card=<n> 
> 
> With different values of <n> but given that there are 77 cards listed I
> haven’t managed to find one that works yet!
> 
> Is it possible that the device is being incorrectly identified or is the
> device not currently supported?
> 
> Let me know if you want me to do anything to further diagnose the issue.

Hopefully someone else can help with this.

Regards,

	Hans
