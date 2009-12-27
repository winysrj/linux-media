Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52006 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZL0Ux2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 15:53:28 -0500
Received: by ewy19 with SMTP id 19so1337470ewy.21
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2009 12:53:27 -0800 (PST)
Message-ID: <4B37C944.3030700@googlemail.com>
Date: Sun, 27 Dec 2009 20:53:24 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Error using PWC on a PS3
References: <hh5u7f$km0$1@ger.gmane.org> <hh5unq$m02$1@ger.gmane.org>
In-Reply-To: <hh5unq$m02$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/12/09 21:20, Andrea wrote:
> On 26/12/09 21:12, Andrea wrote:
>> Hi,
>>
>> I've tried to attach my Logitech, Inc. QuickCam Pro 4000 to a PS3 running Fedora 12.
>>
>> I get this error in dmesg
>>
>> pwc: Failed to set video mode QSIF@10 fps; return code = -110
>>
>> Everything works well on a standard x86 laptop running Fedora 11.
>>
>> Anybody has an idea why a different architecture could affect pwc?
>> I don't know, problems with little/big endian?

I've recompiled pwc adding some extra logging and this is the output

The first error is

kernel: pwc: Failed to set LED on/off time; error -110 .    <<<<<<<<<<<<<< this is the first error

Does anybody know what -110 means?

Moreover, these 2 lines DON'T happen on a x86

kernel: pwc: probe() called [046D 08B2], if 1
kernel: pwc: probe() called [046D 08B2], if 2

any idea?

Thanks

kernel: usb 1-2.1: new full speed USB device using ps3-ehci-driver and address 4
kernel: usb 1-2.1: New USB device found, idVendor=046d, idProduct=08b2
kernel: usb 1-2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
kernel: usb 1-2.1: configuration #1 chosen from 1 choice
kernel: Linux video capture interface: v2.00
kernel: pwc: Philips webcam module version 10.0.13 loaded.
kernel: pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
kernel: pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
kernel: pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
kernel: pwc: Trace options: 0x01ff
kernel: pwc: Registering driver at address 0xd000000000ed9cf0.
kernel: pwc: probe() called [046D 08B2], if 0
kernel: pwc: Logitech QuickCam 4000 Pro USB webcam detected.
kernel: pwc: Device serial number is
kernel: pwc: Release: 0000
kernel: pwc: Registered as video0.
kernel: pwc: probe() function returning struct at 0xc000000006808400.
kernel: pwc: >> video_open called(vdev = 0xc000000004f2d400).
kernel: pwc: Doing first time initialization.
kernel: pwc: This Logitech QuickCam Pro 4000 camera is equipped with a Sony CCD sensor + TDA8787 (32).
kernel: pwc: probe() called [046D 08B2], if 1
kernel: pwc: probe() called [046D 08B2], if 2
kernel: usbcore: registered new interface driver Philips webcam
kernel: pwc: >> pwc_allocate_buffers(pdev = 0xc000000006808400)
kernel: pwc: Allocated iso buffer at c00000000ede4000.
kernel: pwc: Allocated iso buffer at c00000000ed34000.
kernel: pwc: Allocated frame buffer structure at c000000006516420.
kernel: pwc: Allocated frame buffer 0 at d000000000f57000.
kernel: pwc: Allocated frame buffer 1 at d000000000fca000.
kernel: pwc: Allocated frame buffer 2 at d00000000103d000.
kernel: pwc: Allocated image buffer at d0000000010b0000.
kernel: pwc: << pwc_allocate_buffers()
kernel: pwc: >> pwc_reset_buffers __enter__
kernel: pwc: << pwc_reset_buffers __leaving__
kernel: pwc: set_video_mode(176x144 @ 10, palette 15).
kernel: pwc: decode_size = 1.
kernel: pwc: Using alternate setting 1.
kernel: pwc: frame_size=18900, vframes=10, vsize=1, vsnapshot=0, vbandlength=630
kernel: pwc: Set viewport to 176x144, image size is 160x120.
kernel: pwc: Setting alternate interface 1
kernel: pwc: Allocated URB at 0xc00000000652de00
kernel: pwc: Allocated URB at 0xc00000000652dc00
kernel: pwc: URB 0xc00000000652de00 submitted.
kernel: pwc: URB 0xc00000000652dc00 submitted.
kernel: pwc: << pwc_isoc_init()
kernel: pwc: << video_open() returns 0.
kernel: VIDIOC_QUERYCAP
kernel: pwc: ioctl(VIDIOC_QUERYCAP) This application try to use the v4l2 layer
kernel: pwc: >> video_close called(vdev = 0xc000000004f2d400).
kernel: pwc: >> pwc_isoc_cleanup()
kernel: pwc: Unlinking URB c00000000652de00
kernel: pwc: URB (c00000000652de00) unlinked synchronuously.
kernel: pwc: Unlinking URB c00000000652dc00
kernel: pwc: URB (c00000000652dc00) unlinked synchronuously.
kernel: pwc: Freeing URB
kernel: pwc: Freeing URB
kernel: pwc: << pwc_isoc_cleanup()
kernel: pwc: Entering free_buffers(c000000006808400).
kernel: pwc: Freeing ISO buffer at c00000000ede4000.
kernel: pwc: Freeing ISO buffer at c00000000ed34000.
kernel: pwc: Freeing frame buffer 0 at d000000000f57000.
kernel: pwc: Freeing frame buffer 1 at d000000000fca000.
kernel: pwc: Freeing frame buffer 2 at d00000000103d000.
kernel: pwc: Freeing decompression buffer at c000000006a40000.
kernel: pwc: Freeing image buffer at d0000000010b0000.
kernel: pwc: Leaving free_buffers().
kernel: pwc: Failed to set LED on/off time; error -110 .    <<<<<<<<<<<<<< this is the first error
kernel: pwc: << video_close() vopen=0
kernel: pwc: >> video_open called(vdev = 0xc000000004f2d400).
kernel: pwc: Failed to set LED on/off time.
kernel: pwc: >> pwc_allocate_buffers(pdev = 0xc000000006808400)
kernel: pwc: Allocated iso buffer at c00000000eecc000.
kernel: pwc: Allocated iso buffer at c000000002af8000.
kernel: pwc: Allocated frame buffer structure at c000000004f48d80.
kernel: pwc: Allocated frame buffer 0 at d0000000011fc000.
kernel: pwc: Allocated frame buffer 1 at d00000000126f000.
kernel: pwc: Allocated frame buffer 2 at d0000000012e2000.
kernel: pwc: Allocated image buffer at d000000001355000.
kernel: pwc: << pwc_allocate_buffers()
kernel: pwc: >> pwc_reset_buffers __enter__
kernel: pwc: << pwc_reset_buffers __leaving__
kernel: pwc: set_video_mode(160x120 @ 10, palette 15).
kernel: pwc: decode_size = 1.
kernel: pwc: Using alternate setting 1.
kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110
kernel: pwc: First attempt at set_video_mode failed.
kernel: pwc: set_video_mode(160x120 @ 10, palette 15).
kernel: pwc: decode_size = 1.
kernel: pwc: Using alternate setting 1.
kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110
kernel: pwc: Second attempt at set_video_mode failed.
kernel: pwc: Entering free_buffers(c000000006808400).
kernel: pwc: Freeing ISO buffer at c00000000eecc000.
kernel: pwc: Freeing ISO buffer at c000000002af8000.
kernel: pwc: Freeing frame buffer 0 at d0000000011fc000.
kernel: pwc: Freeing frame buffer 1 at d00000000126f000.
kernel: pwc: Freeing frame buffer 2 at d0000000012e2000.
kernel: pwc: Freeing decompression buffer at c000000006a40000.
kernel: pwc: Freeing image buffer at d000000001355000.
kernel: pwc: Leaving free_buffers().
kernel: usb 1-2: clear tt 1 (0040) error -110
kernel: ALSA sound/usb/usbmixer.c:730: 2:1: cannot get min/max values for control 2 (id 2)
kernel: usbcore: registered new interface driver snd-usb-audio
kernel: usb 1-2: clear tt 1 (8040) error -110
