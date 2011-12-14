Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30791 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab1LNMXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 07:23:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW700EAO12OI250@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW7007RS12NJD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Date: Wed, 14 Dec 2011 13:23:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 0/2] v4l2: Extend media bus format with framesamples
 field
In-reply-to: <201112120131.24192.laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
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
Changes since v3:
 - dropped patches for m5mols and s5p-fimc drivers which are unchanged;
 - in teh subdev drivers use local copy of the format data structure to clear
   all structure members which are unused by a driver, in way that it don't break
   after new fields are added to struct v4l2_mbus_framefmt;      

The omap3isp changes are only compile tested. I'd like to ask someone who 
has access to the hardware to test the patch.


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
      
The initial RFC can be found here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39321.html

Sylwester Nawrocki (2):
  v4l: Add new framesamples field to struct v4l2_mbus_framefmt
  v4l: Update subdev drivers to handle framesamples parameter

 Documentation/DocBook/media/v4l/dev-subdev.xml     |   10 +++++-
 Documentation/DocBook/media/v4l/subdev-formats.xml |    9 +++++-
 drivers/media/video/noon010pc30.c                  |    3 ++
 drivers/media/video/omap3isp/ispccdc.c             |   12 +++++--
 drivers/media/video/omap3isp/ispccp2.c             |   31 +++++++++++--------
 drivers/media/video/omap3isp/ispcsi2.c             |   12 +++++--
 drivers/media/video/omap3isp/isppreview.c          |   23 +++++++++-----
 drivers/media/video/omap3isp/ispresizer.c          |   19 +++++++++---
 drivers/media/video/s5k6aa.c                       |    2 +
 include/linux/v4l2-mediabus.h                      |    4 ++-
 10 files changed, 87 insertions(+), 38 deletions(-)

-- 
1.7.8


-- 
Best regards, 

Sylwester Nawrocki 
