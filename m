Return-path: <mchehab@localhost>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55416 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1GFMiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 08:38:14 -0400
Date: Wed, 6 Jul 2011 15:38:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [GIT PULL FOR 3.1] Bitmask controls, flash API and adp1653 driver
Message-ID: <20110706123808.GS12671@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Mauro,

This pull request adds the bitmask controls, flash API and the adp1653
driver.

Laurent noticed an issue with the previous pull request and I've fixed that.

Changes since the second pull request:

- Properly call validate_new_int() from validate_new() for bitmask controls.

Changes since the first pull request to the second one:

- Added a patch to document the V4L2 control endianness. It's on the top.
- Rebased the patches. I haven't tested vivi, though.
- The adp1653 uses dev_pm_ops instead of i2c ops for suspend/resume.

Changes since the last patchset since the first pull request:

- Adp1653 flash faults control is volatile. Fix this.
- Flash interface marked as experimental.
- Moved the DocBook documentation to a new location.
- The target version is 3.1, not 2.6.41.

The following changes since commit df6aabbeb2b8799d97f3886fc994c318bc6a6843:

  [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK (2011-07-01 20:54:51 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.1-flash-4

Hans Verkuil (3):
      v4l2-ctrls: add new bitmask control type.
      vivi: add bitmask test control.
      DocBook: document V4L2_CTRL_TYPE_BITMASK.

Sakari Ailus (4):
      v4l: Add a class and a set of controls for flash devices.
      v4l: Add flash control documentation
      adp1653: Add driver for LED flash controller
      v4l: Document V4L2 control endianness as machine endianness.

 Documentation/DocBook/media/v4l/compat.xml         |   11 +
 Documentation/DocBook/media/v4l/controls.xml       |  291 ++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    6 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |   12 +-
 drivers/media/video/Kconfig                        |    9 +
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/adp1653.c                      |  491 ++++++++++++++++++++
 drivers/media/video/v4l2-common.c                  |    3 +
 drivers/media/video/v4l2-ctrls.c                   |   63 +++-
 drivers/media/video/vivi.c                         |   18 +-
 include/linux/videodev2.h                          |   37 ++
 include/media/adp1653.h                            |  126 +++++
 13 files changed, 1068 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/video/adp1653.c
 create mode 100644 include/media/adp1653.h

-- 
Sakari Ailus
sakari.ailus@iki.fi
