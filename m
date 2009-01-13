Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:1266 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZAMTWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 14:22:35 -0500
From: Roland Graf <roland.graf@alice.it>
To: linux-media@vger.kernel.org
Subject: Problem with driver for  0ac8:301b Z-Star Microelectronics Corp. ZC0301 WebCam
Date: Tue, 13 Jan 2009 20:58:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901132058.22336.roland.graf@alice.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Gentlemen,

I'm using the v4l-dvb driver with Kernel Version 22.6.26. 

Connecting the camera 0ac8:301b Z-Star Microelectronics Corp. ZC0301 WebCam 
the driver for the camera is loaded correctly, but the sensorchip is not 
recognized.

dmesg- Output:

usb 3-4: new full speed USB device using ohci_hcd and address 6
usb 3-4: configuration #1 chosen from 1 choice
usb 3-4: ZC0301[P] Image Processor and Control Chip detected (vid/pid 
0x0AC8:0x3                       01B)
usb 3-4: No supported image sensor detectedmsg

For example with the gspacv1-Driver  the WebCam works without Problems.

I need the v4l-dvb driver for my Twinhan 1030 TV-Card.

Installing v4l-dvb and gspcav1 doesn't work because these packages don't work 
together.

Is there some workaround for this Problem?


Best Thanks

Roland Graf
