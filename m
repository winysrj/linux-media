Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346Ab2COQyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:43 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009K6QZ5MD@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X0016HQZ3YS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:39 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 00/23] New camera controls
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this change set introduces a couple of new relatively high level camera controls.
This is an early initial version, I'd like to ask for review and comments, 
especially on the "V4L:..." patches.

This change set depends on some patches from Sakari, which are included in this
pull request: http://patchwork.linuxtv.org/patch/10299/

The whole branch can be looked at at:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/camera-controls

--
Regards,
Sylwester

Sylwester Nawrocki (23):
  V4L: Add camera auto focus controls
  V4L: Add White Balance Preset camera class control
  V4L: Add Wide Dynamic Range camera class control
  V4L: Add Image Stabilization camera class control
  V4L: Add camera exposure bias control
  V4L: Add camera ISO sensitivity controls
  V4L: Add camera exposure metering mode control
  V4L: camera control class documentation
  V4L: Add helper function for standard integer menu controls
  m5mols: Comments and data structures cleanup
  m5mols: Convert macros to inline functions
  m5mols: Refactored controls handling
  m5mols: Use proper sensor mode for the controls
  m5mols: Add ISO controls
  m5mols: Add white balance preset control
  m5mols: Add exposure bias control
  m5mols: Add wide dynamic range control
  m5mols: Add image stabilization control
  m5mols: Add auto focus controls
  m5mols: Add exposure metering control
  m5mols: Add JPEG compression quality control
  V4L: Add auto focus targets to the selections API
  V4L: Add auto focus targets to the subdev selections API

 Documentation/DocBook/media/v4l/biblio.xml         |   11 +
 Documentation/DocBook/media/v4l/controls.xml       |  312 ++++++++++-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   35 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |   14 +-
 drivers/media/video/m5mols/m5mols.h                |   85 ++-
 drivers/media/video/m5mols/m5mols_controls.c       |  551 +++++++++++++++++---
 drivers/media/video/m5mols/m5mols_core.c           |  144 +++--
 drivers/media/video/m5mols/m5mols_reg.h            |    6 +
 drivers/media/video/v4l2-ctrls.c                   |   89 +++-
 include/linux/v4l2-subdev.h                        |    4 +
 include/linux/videodev2.h                          |   52 ++
 include/media/v4l2-ctrls.h                         |   17 +
 14 files changed, 1195 insertions(+), 163 deletions(-)

-- 
1.7.9.2

