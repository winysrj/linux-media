Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36507 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1G1REO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 13:04:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LP100IVUZF0O160@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jul 2011 18:04:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LP1002XWZF0OI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jul 2011 18:04:12 +0100 (BST)
Received: from [106.116.37.156] (unknown [106.116.37.156])
	by linux.samsung.com (Postfix) with ESMTP id DF41427005E	for
 <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 19:05:03 +0200 (CEST)
Date: Thu, 28 Jul 2011 19:04:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RFC: Negotiating frame buffer size between sensor subdevs and bridge
 devices
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4E31968B.9080603@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Trying to capture images in JPEG format with regular "image sensor -> 
mipi-csi receiver -> host interface" H/W configuration I've found there
is no standard way to communicate between the sensor subdev and the host
driver what is exactly a required maximum buffer size to capture a frame.

For the raw formats there is no issue as the buffer size can be easily
determined from the pixel format and resolution (or sizeimage set on
a video node). 
However compressed data formats are a bit more complicated, the required
memory buffer size depends on multiple factors, like compression ratio,
exact file header structure etc.

Often it is at the sensor driver where all information required to 
determine size of the allocated memory is present. Bridge/host devices
just do plain DMA without caring much what is transferred. I know of
hardware which, for some pixel formats, once data capture is started,
writes to memory whatever amount of data the sensor is transmitting,
without any means to interrupt on the host side. So it is critical
to assure the buffer allocation is done right, according to the sensor
requirements, to avoid buffer overrun.


Here is a link to somehow related discussion I could find:
[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg27138.html


In order to let the host drivers query or configure subdevs with required
frame buffer size one of the following changes could be done at V4L2 API:

1. Add a 'sizeimage' field in struct v4l2_mbus_framefmt and make subdev
 drivers optionally set/adjust it when setting or getting the format with
 set_fmt/get_fmt pad level ops (and s/g_mbus_fmt ?)
 There could be two situations:
 - effective required frame buffer size is specified by the sensor and the
   host driver relies on that value when allocating a buffer;
 - the host driver forces some arbitrary buffer size and the sensor performs
   any required action to limit transmitted amount of data to that amount
   of data;

Both cases could be covered similarly as it's done with VIDIOC_S_FMT. 

Introducing 'sizeimage' field is making the media bus format struct looking
more similar to struct v4l2_pix_format and not quite in line with media bus
format meaning, i.e. describing data on a physical bus, not in the memory.
The other option I can think of is to create separate subdev video ops.


2. Add new s/g_sizeimage subdev video operations 

The best would be to make this an optional callback, not sure if it makes sense
though. It has an advantage of not polluting the user space API. Although 
'sizeimage' in user space might be useful for some purposes I rather tried to
focus on "in-kernel" calls.
 

Comments? Better ideas?


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
