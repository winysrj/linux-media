Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59412 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2ATNW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 08:22:26 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0KDMOp2010417
	for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 07:22:25 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 0/2] add dm365 specific media formats
Date: Fri, 20 Jan 2012 18:52:17 +0530
Message-ID: <1327065739-3362-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add mediabus formats and pixel formats supported
as part of dm365 vpfe device.
The device supports media formats(transfer and storage)
which include-
1: ALAW compressed bayer.
2: UV interleaved without Y (for resizer).
3: YDYC.

Changes from previous version:
1: Added entries in subdev-formats.xml for
   V4L2_MBUS_FMT_YDYC8_1X16, V4L2_MBUS_FMT_UV8_1X8,
   V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8,
   V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8,
   V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
   V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8.
2: Added documentation of ALAW and UV8 pix format.

Manjunath Hadli (2):
  media: add new mediabus format enums for dm365
  v4l2: add new pixel formats supported on dm365

 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 ++++
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  171 ++++++++++++++++++++
 include/linux/v4l2-mediabus.h                      |   10 +-
 include/linux/videodev2.h                          |    9 +
 6 files changed, 286 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml

