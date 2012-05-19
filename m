Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60809 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932Ab2ESSKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 14:10:05 -0400
Date: Sat, 19 May 2012 21:10:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: snjw23@gmail.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com
Subject: [GIT PULL FOR 3.5] V4L2 and V4L2 subdev selection target rename
Message-ID: <20120519181000.GQ3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains just two patches; one for the V4L2 and one for
the V4L2 subdev interfaces. The patches rename the effective selection
targets by removing the _ACTUAL (V4L2 subdev) or _ACTIVE (V4L2) part of the
target name, thus making the target names the same on both interfaces except
for the _SUBDEV string in the names. We later will to remove that as well
but to do that properly requires non-trivial changes to the documentation.
The users are already encouraged to use the V4L2 selection targets on
subdevs; the documentation will be changed for 3.6.

These patches should be applied already now since that decreases the number
of required changes for selection API users in the future, and 3.5 is also
the first kernel version where the subdev selection API is present.


The following changes since commit 61282daf505f3c8def09332ca337ac257b792029:

  [media] V4L2: mt9t112: fixup JPEG initialization workaround (2012-05-15 16:15:35 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-selections

Sakari Ailus (1):
      v4l: Remove "_ACTUAL" from subdev selection API target definition names

Sylwester Nawrocki (1):
      V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to V4L2_SEL_TGT_[CROP/COMPOSE]

 Documentation/DocBook/media/v4l/dev-subdev.xml     |   25 +++++++++----------
 Documentation/DocBook/media/v4l/selection-api.xml  |   24 +++++++++---------
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   15 ++++++-----
 .../media/v4l/vidioc-subdev-g-selection.xml        |   12 ++++----
 drivers/media/video/omap3isp/ispccdc.c             |    4 +-
 drivers/media/video/omap3isp/isppreview.c          |    4 +-
 drivers/media/video/omap3isp/ispresizer.c          |    4 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    8 +++---
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    4 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +++---
 drivers/media/video/smiapp/smiapp-core.c           |   22 ++++++++--------
 drivers/media/video/v4l2-ioctl.c                   |    8 +++---
 drivers/media/video/v4l2-subdev.c                  |    4 +-
 include/linux/v4l2-subdev.h                        |    4 +-
 include/linux/videodev2.h                          |    4 +-
 15 files changed, 75 insertions(+), 75 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
