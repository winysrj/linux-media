Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:38196 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbZKDWDT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 17:03:19 -0500
Message-ID: <4AF1FA24.4090608@email.cz>
Date: Wed, 04 Nov 2009 23:03:16 +0100
From: Martin Rod <martin.rod@email.cz>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: MSI StarCam Racer - No valid video chain found
References: <4AED4C3B.3020706@email.cz> <200911021437.05207.laurent.pinchart@ideasonboard.com> <4AEF41B6.6080102@email.cz> <200911041609.29721.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200911041609.29721.laurent.pinchart@ideasonboard.com>
Content-Type: multipart/mixed;
 boundary="------------010904080907030504030908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010904080907030504030908
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Laurent,

I send you  log file with trace (kernel 2.6.30.9)

I have tried this kernel (on UBNT RouterStation and OpenWrt) with results:

2.6.28.10. -  camera works, I tried only snapshots (I have to use 
external power for USB, without  external  power  sometimes works, 
sometimes  no ...)
2.6.31.5 - kernel copmpiles ok, but uvcvideo module was missing, I don't 
know why ...

Thanks,

Martin


Laurent Pinchart napsal(a):
> Hi Martin,
>
> On Monday 02 November 2009 21:31:50 Martin Rod wrote:
>   
>> Hi Laurent,
>>
>> I send you output of lsusb. I think, that the uvcdriver is the latest. I
>> try older kernel tomorrow.
>>     
>
> Could you please load the driver with trace=255 (modprobe uvcvideo trace=255) 
> or, if the driver is already loaded, change the trace parameter to 255 (echo 
> 255 > /sys/module/uvcvideo/parameters/trace), plug your camera and send me the 
> messages printed by the uvcvideo driver to the kernel log?
>
> Thanks.
>
>   

--------------010904080907030504030908
Content-Type: text/plain;
 name="log_trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log_trace.txt"

usb 1-1: USB disconnect, address 3
usb 1-1: new high speed USB device using ar71xx-ehci and address 4
usb 1-1: configuration #1 chosen from 1 choice
uvcvideo: Probing generic UVC device 1
uvcvideo: Found format YUV 4:2:2 (YUYV).
uvcvideo: - 640x480 (30.0 fps)
uvcvideo: - 352x288 (30.0 fps)
uvcvideo: - 320x240 (30.0 fps)
uvcvideo: - 176x144 (30.0 fps)
uvcvideo: - 160x120 (30.0 fps)
uvcvideo: device 4 videostreaminginterface 1 frame index 9 out of range
uvcvideo: Found a Status endpoint (addr 83).
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62e0)
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/9 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/1 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/4 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/5 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11 to device 1 entity 3
uvcvideo: Added control 00000000-0000-0000-0000-000000000001/2 to device 1 entity 1
uvcvideo: Added control 00000000-0000-0000-0000-000000000001/3 to device 1 entity 1
uvcvideo: Added control 00000000-0000-0000-0000-000000000001/4 to device 1 entity 1
uvcvideo: Added control 00000000-0000-0000-0000-000000000001/11 to device 1 entity 1
uvcvideo: Added control 00000000-0000-0000-0000-000000000001/13 to device 1 entity 1
uvcvideo: Scanning UVC chain: OT 2 <- XU 5 <- XU 4 <- PU 3 <- IT 1
uvcvideo: No valid video chain found.

--------------010904080907030504030908--
