Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31338 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaIDMXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 08:23:40 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBD00KK2MK4Q110@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Sep 2014 13:26:28 +0100 (BST)
Received: from AVDC551 ([106.120.205.44])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NBD0015ZMFDGOB0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Sep 2014 13:23:37 +0100 (BST)
From: Krzysztof Borowczyk <k.borowczyk@samsung.com>
To: linux-media@vger.kernel.org
Subject: Webcam problem
Date: Thu, 04 Sep 2014 14:23:36 +0200
Message-id: <009701cfc83b$0dd0b100$29721300$%borowczyk@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I’ve recently noticed a problem with Modecom Venus and A4Tech PK-333E webcams. Both can be put into a “bad state” in which they refuse to do anything until they’re reconnected to the usb port. The test case is simple:

gst-launch-1.0 v4l2src ! videoconvert ! autovideosink
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
Setting pipeline to PLAYING ...
New clock: GstSystemClock
eKilled

gst-launch-1.0 v4l2src ! videoconvert ! autovideosink
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
Setting pipeline to PLAYING ...
New clock: GstSystemClock
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not read from resource.
Additional debug info:
gstv4l2bufferpool.c(994): gst_v4l2_buffer_pool_poll (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
poll error 1: Invalid argument (22)
Execution ended after 0:00:00.046823946
Setting pipeline to PAUSED ...
Setting pipeline to READY ...
Setting pipeline to NULL ...
Freeing pipeline ...

The GStreamer process has to be killed with the -9:
kill -9 `pidof gst-launch-1.0`

The dmesg log shows this:
[88000.804362] usb 3-3: new high-speed USB device number 4 using xhci_hcd
[88000.864107] usb 3-3: New USB device found, idVendor=0ac8, idProduct=3460
[88000.864113] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[88000.864116] usb 3-3: Product: Venus USB2.0 Camera
[88000.864118] usb 3-3: Manufacturer: Vimicro Corp.
[88000.865088] uvcvideo: Found UVC 1.00 device Venus USB2.0 Camera (0ac8:3460)
[88000.866783] input: Venus USB2.0 Camera as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0/input/input16
[88024.007404] uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -110 (exp. 2).
[88024.307041] uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -110 (exp. 2).
[88025.837884] uvcvideo: Failed to set UVC probe control : -32 (exp. 26).
[88030.830854] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
[88035.824615] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
[88040.818399] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
[88045.812171] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
[88050.805941] uvcvideo: Failed to set UVC probe control : -110 (exp. 26).
[88088.249967] xhci_hcd 0000:00:14.0: Signal while waiting for configure endpoint command
[88088.250000] usb 3-3: Not enough bandwidth for altsetting 0
[88090.907927] xhci_hcd 0000:00:14.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
[88090.907940] xhci_hcd 0000:00:14.0: @0000000115c5f460 00000000 00000000 0c000000 03058000
[88091.021791] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88006b0fa540
[88091.021797] xhci_hcd 0000:00:14.0: Trying to add endpoint 0x82 without dropping it.
[88091.021802] usb 3-3: Not enough bandwidth for altsetting 7
[88091.021805] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88006b0fa540


-- 
Best regards,
Krzysztof Borowczyk


