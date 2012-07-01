Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45681 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932358Ab2GANej (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 09:34:39 -0400
Date: Sun, 1 Jul 2012 16:34:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Subject: [GIT PULL for v3.6] V4L2 and V4L2 subdev selection target and flag
 changes
Message-ID: <20120701133435.GA20344@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset unifies the selection interface definitions and fixes a
conflict in selections documentation.

Changes since patchset v5:

- Addressed Sylwester's concerns:
  - Correct underlying target definitions for compat definitions
  - Minor documentation fixes
  - Improved description of "v4l: Unify selection targets across V4L2 and V4L2 subdev interfaces"


The following changes since commit 704a28e88ab6c9cfe393ae626b612cab8b46028e:

  [media] drxk: prevent doing something wrong when init is not ok (2012-06-29 19:04:32 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6-unify-targets

Sakari Ailus (6):
      v4l: Remove "_ACTUAL" from subdev selection API target definition names
      v4l: Unify selection targets across V4L2 and V4L2 subdev interfaces
      v4l: Common documentation for selection targets
      v4l: Unify selection flags
      v4l: Unify selection flags documentation
      v4l: Correct conflicting V4L2 subdev selection API documentation

Sylwester Nawrocki (2):
      V4L: Remove "_ACTIVE" from the selection target name definitions
      Feature removal: V4L2 selections API target and flag definitions

 Documentation/DocBook/media/v4l/compat.xml         |    9 +-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   36 ++--
 Documentation/DocBook/media/v4l/selection-api.xml  |   34 ++--
 .../DocBook/media/v4l/selections-common.xml        |  164 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    5 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   86 ++---------
 .../media/v4l/vidioc-subdev-g-selection.xml        |   79 +---------
 Documentation/feature-removal-schedule.txt         |   18 ++
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
 include/linux/v4l2-common.h                        |   71 +++++++++
 include/linux/v4l2-subdev.h                        |   20 +--
 include/linux/videodev2.h                          |   27 +---
 21 files changed, 390 insertions(+), 292 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/selections-common.xml
 create mode 100644 include/linux/v4l2-common.h


Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
