Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3489 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2BAQkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 11:40:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.4] Add decoder API to V4L2
Date: Wed, 1 Feb 2012 17:40:27 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202011740.27842.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is my pull request for the decoder API.

The code is the same as the RFCv3 patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg40516.html

and my previous pull request:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/43354

except for being rebased to the latest for_v3.4 branch.

BTW, my previous pull request is in patchwork:

http://patchwork.linuxtv.org/patch/9483/

but it is marked 'rejected'. I assume that is rejected for v3.3, and not
rejected because of other issues since I am not aware of any objections
to this patch series.

Regards,

        Hans


The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:

  Merge branch 'v4l_for_linus' into staging/for_v3.4 (2012-01-23 18:11:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git decoder6

Hans Verkuil (8):
      v4l2: add VIDIOC_(TRY_)DECODER_CMD.
      v4l spec: document VIDIOC_(TRY_)DECODER_CMD.
      ivtv: implement new decoder command ioctls.
      v4l2-ctrls: add new controls for MPEG decoder devices.
      Document decoder controls.
      ivtv: implement new decoder controls.
      cx18/ddbridge: remove unused headers.
      ivtv: add IVTV_IOC_PASSTHROUGH_MODE.

 Documentation/DocBook/media/v4l/controls.xml       |   59 +++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  256 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    9 +-
 drivers/media/dvb/ddbridge/ddbridge.h              |    2 -
 drivers/media/video/cx18/cx18-driver.h             |    2 -
 drivers/media/video/ivtv/ivtv-controls.c           |   62 +++++
 drivers/media/video/ivtv/ivtv-controls.h           |    2 +
 drivers/media/video/ivtv/ivtv-driver.c             |   37 +++-
 drivers/media/video/ivtv/ivtv-driver.h             |   12 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |  181 +++++++-------
 drivers/media/video/ivtv/ivtv-streams.c            |    9 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ctrls.c                   |   23 ++
 drivers/media/video/v4l2-ioctl.c                   |   28 +++
 include/linux/ivtv.h                               |    6 +-
 include/linux/videodev2.h                          |   66 +++++
 include/media/v4l2-ioctl.h                         |    4 +
 19 files changed, 652 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
