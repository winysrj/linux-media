Return-path: <linux-media-owner@vger.kernel.org>
Received: from auth.a.painless.aa.net.uk ([90.155.4.51]:50608 "EHLO
	auth.a.painless.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 14:20:05 -0400
Received: from 6.15.169.217.in-addr.arpa ([217.169.15.6] helo=[192.168.2.244])
	by a.painless.aa.net.uk with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <linux-media@destevenson.freeserve.co.uk>)
	id 1bQIZn-0003sP-A7
	for linux-media@vger.kernel.org; Thu, 21 Jul 2016 19:20:03 +0100
To: linux-media@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Subject: Sony imx219 driver?
Message-ID: <57911245.1010500@destevenson.freeserve.co.uk>
Date: Thu, 21 Jul 2016 19:19:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

Just a quick query to avoid duplicating effort. Has anyone worked on a 
Sony IMX219 (or other Sony sensor) subdevice driver as yet?

With the new Raspberry Pi camera being IMX219, and as Broadcom have 
released an soc_camera based driver for the sensor already 
(https://android.googlesource.com/kernel/bcm/+/android-bcm-tetra-3.10-lollipop-wear-release/drivers/media/video/imx219.c) 
I was going to investigate converting that to a subdevice. I just wanted 
to check this wasn't already in someone else's work queue.

A further Google shows that there's also an soc_camera IMX219 driver in 
ChromiumOS, copyright Andrew Chew @ Nvidia, but author Guennadi 
Liakhovetski who I know posts on here. 
https://chromium.googlesource.com/chromiumos/third_party/kernel/+/factory-ryu-6486.14.B-chromeos-3.14/drivers/media/i2c/soc_camera/imx219.c. 
The Broadcom one supports 8MPix and 1080P, the Chromium one only 8MP. 
Perhaps a hybrid of the feature set?
Throw in 
https://github.com/ZenfoneArea/android_kernel_asus_zenfone5/blob/master/linux/modules/camera/drivers/media/i2c/imx219/imx219.h 
as well, and we have register sets for numerous readout modes, plus 
there are the ones in the Pi firmware which can be extracted if necessary.


On a related note, if putting together a system with IMX219 or similar 
producing Bayer raw 10, the data on the CSI2 bus is one of the 
V4L2_PIX_FMT_SRGGB10P formats. What's the correct way to reflect that 
from the sensor subdevice in an MEDIA_BUS_FMT_ enum?
The closest is MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE (or LE), but the data 
isn't padded (the Pi CSI2 receiver can do the unpacking and padding, but 
that just takes up more memory).|||| Or is it MEDIA_BUS_FMT_SBGGR10_1X10 
to describe the data on the bus correctly as 10bpp Bayer, and the odd 
packing is ignored. Or do we need new enums?

Thanks.
   Dave
