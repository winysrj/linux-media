Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42341 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1KVJzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 04:55:52 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV200GPK3L271@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 09:55:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV200IDW3L18F@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 09:55:50 +0000 (GMT)
Date: Tue, 22 Nov 2011 10:55:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC] v4l: Compressed data formats on the video bus
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1321955740-24452-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series tries to solve the issue presented in my other posting [1] by
extending the media bus format data structure with a new parameter, rather than
adding a new subdev video ops callback.

Although there are opinions [2] the 'framesamples' parameter should not be a part
of v4l2_mbus_framefmt data structure, it might be a better approach than creating 
a new subdev callback for a few reasons: 

 - the frame size parameter is usually needed altogether with other parameters
   already included in struct v4l2_mbus_framefmt;
 - it allows to clearly associate the frame length with the media entity pads;
 - the semantics is more straightforward and would yield simpler implementations,
   it's similar to current 'sizeimage' handling at struct v4l2_pix_format;
 - the applications could simply propagate the 'framesamples' value along the 
   pipeline, starting from the data source (sensor) subdev, only for compressed 
   data formats;


The new struct v4l2_mbus_framefmt would look as follows:

struct v4l2_mbus_framefmt {
	__u32			width;
	__u32			height;
	__u32			code;
	__u32			field;
	__u32			colorspace;
	__u32			framesamples;
	__u32			reserved[6];
};

The proposed semantics for the 'framesamples' parameter is roughly as follows:

 - the value is propagated at video pipeline entities where 'code' indicates
   compressed format;
 - the subdevs adjust the value if needed;
 - although currently there is only one compressed data format at the media 
   bus - V4L2_MBUS_FMT_JPEG_1X8 which corresponds to V4L2_PIX_FMT_JPEG and
   one sample at the media bus equals to one byte in memory, it is assumed
   that the host knows exactly what is framesamples/sizeimage ratio and it will 
   validate framesamples/sizeimage values before starting streaming;
 - the host will query internally a relevant subdev to properly handle 'sizeimage' 
   at the VIDIOC_TRY/S_FMT ioctl 
      

Comments ?

--- 
Regards, 
Sylwester Nawrocki 
Samsung Poland R&D Center

[1] http://www.spinics.net/lists/linux-media/msg39703.html 
[2] http://www.spinics.net/lists/linux-media/msg37703.html
