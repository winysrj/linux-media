Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43820 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1HaMfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:35:11 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQS00HJ3LLUSJ@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:34:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQS00AAALBYJO@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:28:47 +0100 (BST)
Date: Wed, 31 Aug 2011 14:28:19 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv5 0/4] v4l: extended crop/compose api
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Message-id: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone,

This is the fifth version of extended crop/compose RFC. It was updated after
Laurent's review. The patch-set introduces new ioctls to V4L2 API for
configuration of selection rectangles like crop and compose areas. The last
patch adds selection support for s5p-tv driver. Please refer to discussion
below for more details about api development.

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32152

Changelog:

v4:
- removed returning best-hit rectangle on failure of VIDIOC_S_SELECTION
- fixed typos and naming
- removed enums from structures
- code style cleanup

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

Tomasz Stanislawski (4):
  v4l: add support for selection api
  v4l: add documentation for selection API
  v4l: emulate old crop API using extended crop/compose API
  v4l: s5p-tv: mixer: add support for selection API

 Documentation/DocBook/media/constraints.png.b64    |  134 +
 Documentation/DocBook/media/selection.png.b64      | 2937 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/common.xml         |    4 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |  278 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  281 ++
 drivers/media/video/s5p-tv/mixer.h                 |   14 +-
 drivers/media/video/s5p-tv/mixer_grp_layer.c       |  157 +-
 drivers/media/video/s5p-tv/mixer_video.c           |  339 ++-
 drivers/media/video/s5p-tv/mixer_vp_layer.c        |  108 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ioctl.c                   |  114 +-
 include/linux/videodev2.h                          |   46 +
 include/media/v4l2-ioctl.h                         |    4 +
 14 files changed, 4210 insertions(+), 209 deletions(-)
 create mode 100644 Documentation/DocBook/media/constraints.png.b64
 create mode 100644 Documentation/DocBook/media/selection.png.b64
 create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml

-- 
1.7.6

