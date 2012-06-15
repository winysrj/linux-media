Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:48097 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2FOShS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 14:37:18 -0400
Message-ID: <4FDB80C8.4060505@iki.fi>
Date: Fri, 15 Jun 2012 21:36:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [GIT PULL FOR 3.5] V4L2 and V4L2 subdev selection target and flag
 changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset contains changes to unify the selection targets and flags
across the V4L2 and V4L2 subdev interfaces, as well as a fix to
conflicting information in the documentation.

Since the patchset (v4) I've addressed Laurent's comments:

- Fixed badly formatted xref references
- Spelling corrections and references to wrong defines
- Always tell KEEP_CONFIG will not change any other processing steps
than the one it applies to


The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
09:27:24 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-unify-targets

Sakari Ailus (6):
      v4l: Remove "_ACTUAL" from subdev selection API target definition
names
      v4l: Unify selection targets across V4L2 and V4L2 subdev interfaces
      v4l: Common documentation for selection targets
      v4l: Unify selection flags
      v4l: Unify selection flags documentation
      v4l: Correct conflicting V4L2 subdev selection API documentation

Sylwester Nawrocki (1):
      V4L: Remove "_ACTIVE" from the selection target name definitions

 Documentation/DocBook/media/v4l/compat.xml         |    9 +-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   36 ++--
 Documentation/DocBook/media/v4l/selection-api.xml  |   34 ++--
 .../DocBook/media/v4l/selections-common.xml        |  164
++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    5 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   86 ++---------
 .../media/v4l/vidioc-subdev-g-selection.xml        |   79 +---------
 drivers/media/video/omap3isp/ispccdc.c             |    8 +-
 drivers/media/video/omap3isp/isppreview.c          |    8 +-
 drivers/media/video/omap3isp/ispresizer.c          |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   32 ++--
 drivers/media/video/s5p-fimc/fimc-lite.c           |   15 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    4 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +-
 drivers/media/video/smiapp/smiapp-core.c           |   40 +++---
 drivers/media/video/v4l2-ioctl.c                   |    8 +-
 drivers/media/video/v4l2-subdev.c                  |    4 +-
 include/linux/v4l2-common.h                        |   58 +++++++
 include/linux/v4l2-subdev.h                        |   20 +--
 include/linux/videodev2.h                          |   27 +---
 20 files changed, 359 insertions(+), 292 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/selections-common.xml
 create mode 100644 include/linux/v4l2-common.h


Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

