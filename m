Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3383 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1FJJTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 05:19:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] Add autofoo/foo and control event support
Date: Fri, 10 Jun 2011 11:19:33 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101119.33512.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This patch series adds support for handling autofoo/foo type controls (e.g.
autogain/gain, autoexposure/exposure, etc) and adds a new event for control
changes, either a value or a status change.

The changes against the RFCv3 patch series are minor: one small bug was fixed
in the autofoo/foo support (a cluster_walk started one element too far) and
I removed the v4l2_ctrl_handler_cnt that I added earlier. I'm working on a
much better solution for this. See this thread:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg32552.html

So I decided not to add something that I'm going to remove soon anyway.

Test code is available in qv4l2 from here:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

It's been tested with vivi and ivtv. We (Cisco) have also been using an older
version of this patch series at work for the past 2-3 months.

I have added some additional notes to the various patches below.

Regards,

	Hans

The following changes since commit 75125b9d44456e0cf2d1fbb72ae33c13415299d1:

  [media] DocBook: Don't be noisy at make cleanmediadocs (2011-06-09 16:40:58 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core8

Hans Verkuil (18):
      v4l2-ctrls: introduce call_op define
      v4l2-ctrls: simplify error_idx handling.
      v4l2-ctrls: drivers should be able to ignore the READ_ONLY flag
      v4l2-ioctl: add ctrl_handler to v4l2_fh
      v4l2-subdev: implement per-filehandle control handlers.
      v4l2-ctrls: fix and improve volatile control handling.
      v4l2-controls.txt: update to latest v4l2-ctrl.c changes.
      v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
      DocBook: Improve cluster documentation and document the new autoclusters.
      vivi: add autogain/gain support to test the autocluster functionality.

These patches above all deal with autocluster support. I'm hoping that this
set of patches can at least be merged since once this is in I can work on
converting soc-camera to the control framework. That work depends on the
autocluster support.

      v4l2-ctrls: add v4l2_fh pointer to the set control functions.
      vb2_poll: don't start DMA, leave that to the first read().
      v4l2-ctrls: add control events.
      v4l2-ctrls: simplify event subscription.
      V4L2 spec: document control events.
      vivi: support control events.
      ivtv: add control event support.

This set adds support for the new control events.

      v4l2-compat-ioctl32: add VIDIOC_DQEVENT support.

This adds a missing compat32 conversion. It didn't matter much in the past
that this was missing, but control events are something that are much more
likely to be used in a 32-bit app running in a 64-bit OS, so it is now more
important to do this right.

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   17 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  142 +++++++++-
 Documentation/video4linux/v4l2-controls.txt        |   69 ++++-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   34 +--
 drivers/media/video/ivtv/ivtv-ioctl.c              |    2 +
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |   37 +++
 drivers/media/video/v4l2-ctrls.c                   |  332 ++++++++++++++++----
 drivers/media/video/v4l2-device.c                  |    1 +
 drivers/media/video/v4l2-event.c                   |  130 ++++++--
 drivers/media/video/v4l2-fh.c                      |    6 +-
 drivers/media/video/v4l2-ioctl.c                   |   40 ++-
 drivers/media/video/v4l2-subdev.c                  |   14 +-
 drivers/media/video/videobuf2-core.c               |   17 +-
 drivers/media/video/vivi.c                         |   53 +++-
 include/linux/videodev2.h                          |   29 ++-
 include/media/v4l2-ctrls.h                         |   92 +++++-
 include/media/v4l2-event.h                         |    2 +
 include/media/v4l2-fh.h                            |    2 +
 kernel/compat.c                                    |    1 +
 22 files changed, 851 insertions(+), 177 deletions(-)
