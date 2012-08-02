Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:32772 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2HBIAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 04:00:38 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id q7280aJe032732
	for <linux-media@vger.kernel.org>; Thu, 2 Aug 2012 03:00:37 -0500
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v8 0/2] add dm365 specific media formats
Date: Thu, 2 Aug 2012 13:30:08 +0530
Message-ID: <1343894410-16829-1-git-send-email-prabhakar.lad@ti.com>
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
3: YDYU

Changes for v8:
1: Fixed a comment from Sakari, removed extra space.

Changes for v7:
1: Fixed a comment from Laurent, removed subscript for
   dummy tags.
2: Fixed a comment from Sakari, used the same order for
   ALAW pix fmt according to Documentation/video4linux/4CCs.txt.

Changes for v6:
1: Fixed a comment from Hans, replaced "YUYDYDYV and YVYDYDYU"
   to "YUYDYVYD and YVYDYUYD".

Changes for v5:
1: Fixed comment from Laurent, moved ALAW format above DPCM
   format to keep the alphabetically sorted, grouped textual
   description for ALAW and DPCM compression, as they're mutally
   exclusive, Changed V4L2_MBUS_FMT_YDYC8_1X16 to
   V4L2_MBUS_FMT_YDYUYDYV8_1X16.

Changes for v4:
1: Rebased the patch set on Sakari's branch
(http://git.linuxtv.org/sailus/media_tree.git/shortlog/refs/heads/media-for-3.4)
   mainly because of this patch
   <URL:http://www.spinics.net/lists/linux-media/msg44871.html>
2: Fixed comments from Sakari, changed description for
   UV8, and re-arranged &sub-uv8; in
   Documentation/DocBook/media/v4l/pixfmt.xml file.

Changes for v3:
1: Added 4cc code for A-law compressed format as per
  specified in documentation,
  http://www.spinics.net/lists/linux-media/msg43890.html

Changes for v2:
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

 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  250 +++++++++++++++++++-
 include/linux/v4l2-mediabus.h                      |   10 +-
 include/linux/videodev2.h                          |    8 +
 6 files changed, 358 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml

