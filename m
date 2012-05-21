Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:33614 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab2EUDDU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 23:03:20 -0400
Message-ID: <4FB9B070.9060200@iki.fi>
Date: Mon, 21 May 2012 06:03:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: snjw23@gmail.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com
Subject: [GIT PULL FOR 3.5 v2] V4L2 and V4L2 subdev selection target rename
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Compared to the last pull req, I've rebased the request on top of more
recent media_tree.git and replaced Sylwester's patch with a newer
version of it.

---

This pull request contains just two patches; one for the V4L2 and one
for the V4L2 subdev interfaces. The patches rename the effective
selection targets by removing the _ACTUAL (V4L2 subdev) or _ACTIVE
(V4L2) part of the target name, thus making the target names the same on
both interfaces except for the _SUBDEV string in the names. We later
will to remove that as well but to do that properly requires non-trivial
changes to the documentation. The users are already encouraged to use
the V4L2 selection targets on subdevs; the documentation will be changed
for 3.6.

These patches should be applied already now since that decreases the
number of required changes for selection API users in the future, and
3.5 is also the first kernel version where the subdev selection API is
present.




The following changes since commit abed623ca59a7d1abed6c4e7459be03e25a90a1e:

  [media] radio-sf16fmi: add support for SF16-FMD (2012-05-20 16:10:05
-0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-selections

Sakari Ailus (1):
      v4l: Remove "_ACTUAL" from subdev selection API target definition
names

Sylwester Nawrocki (1):
      V4L: Remove "_ACTIVE" from the selection target name definitions

 Documentation/DocBook/media/v4l/dev-subdev.xml     |   25
+++++++++----------
 Documentation/DocBook/media/v4l/selection-api.xml  |   24
+++++++++---------
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   15 ++++++-----
 .../media/v4l/vidioc-subdev-g-selection.xml        |   12 ++++----
 drivers/media/video/omap3isp/ispccdc.c             |    4 +-
 drivers/media/video/omap3isp/isppreview.c          |    4 +-
 drivers/media/video/omap3isp/ispresizer.c          |    4 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   14 +++++-----
 drivers/media/video/s5p-fimc/fimc-lite.c           |    4 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    4 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +++---
 drivers/media/video/smiapp/smiapp-core.c           |   22 ++++++++--------
 drivers/media/video/v4l2-ioctl.c                   |    8 +++---
 drivers/media/video/v4l2-subdev.c                  |    4 +-
 include/linux/v4l2-subdev.h                        |    4 +-
 include/linux/videodev2.h                          |    8 ++++-
 16 files changed, 84 insertions(+), 80 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
