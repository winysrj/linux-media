Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2788 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1CLKBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 05:01:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.39] Core prio support and global release callback
Date: Sat, 12 Mar 2011 11:01:23 +0100
Cc: Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103121101.23464.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro!

This changeset adds core support for VIDIOC_S/G_PRIORITY and adds a release
callback to struct v4l2_device.

vivi and cx18 are modified to use the core prio support and dsbr100 was
changed to use the release callback and unlocked_ioctl.

I fixed a few related ivtv problems as well.

Tested with cx18, ivtv, vivi and bttv.

We don't have hardware for the DSB-R100, so those changed are untested.

There is one on its way to me, so I should be able to verify it in 2-3
weeks.

The core prio support makes vivi fully pass v4l2-compliance (and it's the
first driver to do so :-) ). It is also required to have the control
framework honor the priority ioctls. Without this file descriptors with a
lower prio could still change controls.

Note that the prio core support only kicks in for drivers that use struct
v4l2_fh and do not set vidioc_s_priority in the ioctl_ops.

Regards,

	Hans

The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:

  [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core

Hans Verkuil (17):
      v4l2_prio: move from v4l2-common to v4l2-dev.
      v4l2: add v4l2_prio_state to v4l2_device and video_device
      v4l2-fh: implement v4l2_priority support.
      v4l2-fh: add v4l2_fh_open and v4l2_fh_release helper functions
      v4l2-fh: add v4l2_fh_is_singular
      v4l2-ioctl: add priority handling support.
      ivtv: convert to core priority handling.
      v4l2-framework.txt: improve v4l2_fh/priority documentation
      cx18: use v4l2_fh as preparation for adding core priority support.
      cx18: use core priority handling
      v4l2-device: add kref and a release function
      v4l2-framework.txt: document new v4l2_device release() callback
      dsbr100: convert to unlocked_ioctl
      dsbr100: ensure correct disconnect sequence.
      vivi: convert to core priority handling.
      ivtv: add missing v4l2_fh_exit.
      ivtv: replace ugly casts with a proper container_of.

 Documentation/video4linux/v4l2-framework.txt |  135 ++++++++++++++++------
 drivers/media/radio/dsbr100.c                |  128 ++++++---------------
 drivers/media/radio/radio-si4713.c           |    3 +-
 drivers/media/video/cpia2/cpia2_v4l.c        |    3 +-
 drivers/media/video/cx18/cx18-driver.h       |   14 ++-
 drivers/media/video/cx18/cx18-fileops.c      |   20 ++-
 drivers/media/video/cx18/cx18-ioctl.c        |  128 ++++++---------------
 drivers/media/video/davinci/vpfe_capture.c   |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h       |    2 -
 drivers/media/video/ivtv/ivtv-fileops.c      |    3 +-
 drivers/media/video/ivtv/ivtv-ioctl.c        |  159 +++++++++++---------------
 drivers/media/video/meye.c                   |    3 +-
 drivers/media/video/mxb.c                    |    3 +-
 drivers/media/video/pwc/pwc-v4l.c            |    3 +-
 drivers/media/video/v4l2-common.c            |   63 ----------
 drivers/media/video/v4l2-dev.c               |   80 +++++++++++++
 drivers/media/video/v4l2-device.c            |   17 +++
 drivers/media/video/v4l2-fh.c                |   46 ++++++++
 drivers/media/video/v4l2-ioctl.c             |   64 +++++++++-
 drivers/media/video/vivi.c                   |   17 +--
 include/media/v4l2-common.h                  |   15 ---
 include/media/v4l2-dev.h                     |   18 +++
 include/media/v4l2-device.h                  |   14 +++
 include/media/v4l2-fh.h                      |   29 +++++
 include/media/v4l2-ioctl.h                   |    2 +-
 25 files changed, 546 insertions(+), 425 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
