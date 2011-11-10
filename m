Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20165 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1KJLxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 06:53:45 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUG004EM11JPR@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUG00BHY11IHW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Date: Thu, 10 Nov 2011 12:53:30 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 0/5] v4l: introduce selection API
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	mchehab@redhat.com
Message-id: <1320926015-5841-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone,

This is the sixth version of extended crop/compose RFC.  The patch-set
introduces new ioctls to V4L2 API for the configuration of the selection
rectangles like crop and compose areas. Please refer to the link below for more
details about the API development.

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32152

Changelog:

v5:
- changed naming of constraints flags to form V4L2_SEL_FLAG_*
- changed naming of selection target to form V4L2_SEL_TGT_*
- size of PNG files in the documentation is greatly reduced
- fixes to handling of output queues for old cropping emulation
- VIDIOC_{S/G}_SELECTION for s5p-mixer accepts single- and multiplane buffers
  as VIDIOC_{S/G}_CROP did

v4:
- typos, style fixes
- added piorority support to VIDIOC_S_SELECTION
- removed deprecation of current crop API
- marked selection as experimental API
- removed references to pipeline configuration rules
- added subsection about deficiencies of current cropping API
- moved patches to binaries to separate patch
- updated V4L2 changelog

v3:
- added target for padded buffer
- reduced number of constraint flags to SIZE_LE and SIZE_GE
- removed try flag
- added documentation for selection ioctls
- added documentation for new model of cropping, composing and scaling
- support of selection api for s5p-tv
- fixed returning ioctl's structures on failure

v2:
- reduced number of hints and its semantics to be more practical and less
  restrictive
- combined EXTCROP and COMPOSE ioctls into VIDIOC_{S/G}_SELECTION
- introduced crop and compose targets
- introduced try flag that prevents passing configuration to a hardware
- added usage examples

Tomasz Stanislawski (5):
  v4l: add support for selection api
  doc: v4l: add binary images for selection API
  doc: v4l: add documentation for selection API
  v4l: emulate old crop API using extended crop/compose API
  v4l: s5p-tv: mixer: add support for selection API

 Documentation/DocBook/media/constraints.png.b64    |   59 ++++
 Documentation/DocBook/media/selection.png.b64      |  206 ++++++++++++
 Documentation/DocBook/media/v4l/common.xml         |    2 +
 Documentation/DocBook/media/v4l/compat.xml         |    9 +
 Documentation/DocBook/media/v4l/selection-api.xml  |  327 +++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  304 +++++++++++++++++
 drivers/media/video/s5p-tv/mixer.h                 |   14 +-
 drivers/media/video/s5p-tv/mixer_grp_layer.c       |  157 +++++++--
 drivers/media/video/s5p-tv/mixer_video.c           |  342 +++++++++++++-------
 drivers/media/video/s5p-tv/mixer_vp_layer.c        |  108 ++++---
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ioctl.c                   |  116 +++++++-
 include/linux/videodev2.h                          |   46 +++
 include/media/v4l2-ioctl.h                         |    4 +
 15 files changed, 1495 insertions(+), 202 deletions(-)
 create mode 100644 Documentation/DocBook/media/constraints.png.b64
 create mode 100644 Documentation/DocBook/media/selection.png.b64
 create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml

-- 
1.7.5.4

