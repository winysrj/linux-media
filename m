Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63775 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LAKU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 05:20:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVI00HI8SQXU240@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVI0023KSQWB3@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:56 +0000 (GMT)
Date: Thu, 01 Dec 2011 11:20:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC v2] v4l2: Compressed data formats on the video bus
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is an updated version of the changeset extending struct v4l2_mbus_framefmt
with new framesamples field.

Changes since v1:
 - Docbook documentation improvements
 - drivers that are exposing a sub-device node are modified to initialize
   the new struct v4l2_mbus_framefmt member to 0 if they support only
   uncompressed formats
 
The proposed semantics for the framesamples parameter is as follows:

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
      
And here is a link to my initial RFC:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39321.html


-- 
Regards, 

Sylwester Nawrocki 
Samsung Poland R&D Center
