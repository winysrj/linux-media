Return-path: <linux-media-owner@vger.kernel.org>
Received: from eth1683.vic.adsl.internode.on.net ([150.101.217.146]:59273 "EHLO
	greyinnovation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753596Ab1JCFut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 01:50:49 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Help with omap3isp resizing
Date: Mon, 3 Oct 2011 16:51:34 +1100
Message-ID: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
From: "Paul Chiha" <paul.chiha@greyinnovation.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been having trouble getting the resizer to work, and mainly because
I don't know how to correctly configure it.
I'm using kernel 2.6.37 on arm DM37x board.

I've been able to configure the media links sensor=>ccdc=>ccdc_output
(all with 640x480 V4L2_MBUS_FMT_UYVY8_2X8) and VIDIOC_STREAMON works on
/dev/video2.
But if I configure media links sensor=>ccdc=>resizer=>resizer_output,
then VIDIOC_STREAMON fails on /dev/video6 (with pixelformat mismatch).
I noticed that the resizer driver only supports V4L2_MBUS_FMT_UYVY8_1X16
& V4L2_MBUS_FMT_YUYV8_1X16, so I tried again with all the links set to
V4L2_MBUS_FMT_UYVY8_1X16 instead, but then ioctl VIDIOC_SUBDEV_S_FMT
fails on /dev/v4l-subdev8, because the sensor driver doesn't support
1X16.
Then I tried using V4L2_MBUS_FMT_UYVY8_2X8 for the sensor and
V4L2_MBUS_FMT_UYVY8_1X16 for the resizer, but it either failed with
pixelformat mismatch or link pipeline mismatch, depending on which pads
were different.

Can someone please tell me what I need to do to make this work?

Thanks,
Paul


