Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34112 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaIJNsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 09:48:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Krzysztof Borowczyk <k.borowczyk@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Webcam problem
Date: Wed, 10 Sep 2014 16:48:39 +0300
Message-ID: <1634489.4ADxKSlpeA@avalon>
In-Reply-To: <009701cfc83b$0dd0b100$29721300$%borowczyk@samsung.com>
References: <009701cfc83b$0dd0b100$29721300$%borowczyk@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

On Thursday 04 September 2014 14:23:36 Krzysztof Borowczyk wrote:
> Hello,
> 
> I’ve recently noticed a problem with Modecom Venus and A4Tech PK-333E
> webcams. Both can be put into a “bad state” in which they refuse to do
> anything until they’re reconnected to the usb port. The test case is
> simple:
> 
> gst-launch-1.0 v4l2src ! videoconvert ! autovideosink
> Setting pipeline to PAUSED ...
> Pipeline is live and does not need PREROLL ...
> Setting pipeline to PLAYING ...
> New clock: GstSystemClock
> eKilled
> 
> gst-launch-1.0 v4l2src ! videoconvert ! autovideosink
> Setting pipeline to PAUSED ...
> Pipeline is live and does not need PREROLL ...
> Setting pipeline to PLAYING ...
> New clock: GstSystemClock
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not
> read from resource. Additional debug info:
> gstv4l2bufferpool.c(994): gst_v4l2_buffer_pool_poll ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: poll error 1: Invalid argument
> (22)
> Execution ended after 0:00:00.046823946
> Setting pipeline to PAUSED ...
> Setting pipeline to READY ...
> Setting pipeline to NULL ...
> Freeing pipeline ...
> 
> The GStreamer process has to be killed with the -9:
> kill -9 `pidof gst-launch-1.0`
> 
> The dmesg log shows this:
> [88000.804362] usb 3-3: new high-speed USB device number 4 using xhci_hcd
> [88000.864107] usb 3-3: New USB device found, idVendor=0ac8, idProduct=3460
> [88000.864113] usb 3-3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [88000.864116] usb 3-3: Product: Venus USB2.0 Camera
> [88000.864118] usb 3-3: Manufacturer: Vimicro Corp.
> [88000.865088] uvcvideo: Found UVC 1.00 device Venus USB2.0 Camera
> (0ac8:3460)
> [88000.866783] input: Venus USB2.0 Camera as
> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0/input/input16
> [88024.007404] uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2:
> -110 (exp. 2).
> [88024.307041] uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2:
> -110 (exp. 2).
> [88025.837884] uvcvideo: Failed to set UVC probe control : -32 (exp. 26).
> [88030.830854] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
> [88035.824615] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
> [88040.818399] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
> [88045.812171] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
> [88050.805941] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
> [88088.249967] xhci_hcd 0000:00:14.0: Signal while waiting for configure
> endpoint command
> [88088.250000] usb 3-3: Not enough bandwidth for altsetting 0
> [88090.907927] xhci_hcd 0000:00:14.0: ERROR Transfer event for disabled
> endpoint or incorrect stream ring
> [88090.907940] xhci_hcd 0000:00:14.0: @0000000115c5f460 00000000 00000000
> 0c000000 03058000
> [88091.021791] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff88006b0fa540
> [88091.021797] xhci_hcd 0000:00:14.0: Trying to add endpoint 0x82 without
> dropping it.
> [88091.021802] usb 3-3: Not enough bandwidth for altsetting 7
> [88091.021805] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff88006b0fa540

This looks like a low-level problem. Either the webcam firmware crashed, or 
the XCHI USB controller get in a bad state. What kernel version are you 
running ?

-- 
Regards,

Laurent Pinchart

