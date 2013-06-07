Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44325 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3FGLZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 07:25:45 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO000JGPT2W81A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Jun 2013 12:25:44 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	HyungJun Choi <hj210.choi@samsung.com>
Subject: [PATCH 0/2] V4L: Add auto focus area control and selection
Date: Fri, 07 Jun 2013 13:25:20 +0200
Message-id: <1370604322-15476-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set of patches is created by Sylwester Nawrocki, with my adjustments.

This set of patches extends the camera class with control
V4L2_CID_AUTO_FOCUS_AREA for determining the area of the frame that
camera uses for auto-focus.
The control takes care of three cases:
- V4L2_AUTO_FOCUS_AREA_AUTO:		the camera automatically selects the
    focus area.
- V4L2_AUTO_FOCUS_AREA_RECTANGLE:	user provides rectangle or spot
    as an area of interest,
- V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION: object/face detection engine
    of the camera should be used for auto-focus.

In case of the rectangle or the spot its coordinates shall be passed
to the driver using selection API (VIDIOC_SUBDEV_S_SELECTION) with
V4L2_SEL_TGT_AUTO_FOCUS as a target name. In case of spot width and
height of the rectangle shall be set to 0.

This is the second version of AF area patches.
It was modified according to comments by Sakari and Sylwester, thanks.
Change details are described in patch comments.

The most significant change I propose is to extend
V4L2_CID_AUTO_FOCUS_START to apply AF changes in case continuous
auto-focus is active. As a consequence V4L2_AUTO_FOCUS_(AREA|RANGE) controls
do not trigger HW changes immediately.

I have also replaced V4L2_AUTO_FOCUS_AREA_ALL with V4L2_AUTO_FOCUS_AREA_AUTO
with better description.

Regards
Andrzej

Andrzej Hajda (1):
  V4L: Add V4L2_CID_AUTO_FOCUS_AREA control

Sylwester Nawrocki (1):
  V4L: Add auto focus selection targets

 Documentation/DocBook/media/v4l/compat.xml         |  9 +++-
 Documentation/DocBook/media/v4l/controls.xml       | 62 +++++++++++++++++++---
 Documentation/DocBook/media/v4l/selection-api.xml  | 31 ++++++++++-
 .../DocBook/media/v4l/selections-common.xml        | 37 +++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |  7 +++
 .../media/v4l/vidioc-subdev-g-selection.xml        |  9 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c               | 10 ++++
 include/uapi/linux/v4l2-common.h                   |  5 ++
 include/uapi/linux/v4l2-controls.h                 |  4 ++
 9 files changed, 160 insertions(+), 14 deletions(-)

-- 
1.8.1.2

