Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2328 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab1F1OBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 10:01:39 -0400
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5SE1cHa042726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 16:01:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.1] Add Control Event and autofoo/foo support
Date: Tue, 28 Jun 2011 16:01:37 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281601.37915.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This is the same as the first pull request, except for:

- the poll patch has been removed (to be discussed further)
- the corresponding poll changes in ivtv were removed (pending same
  discussion).
- a new patch has been added that fixes your manual_mode_value comments.

Note that I have left out the 'event feedback' fix in this patch series.
I'm going to make a patch for the second patch series instead: it's much
easier to implement there (that may have been a reason why I didn't
implement such a flag in the first place). I'll post that fix later for
review.

Regards,

        Hans

The following changes since commit 7023c7dbc3944f42aa1d6910a6098c5f9e23d3f1:

  [media] DVB: dvb-net, make the kconfig text helpful (2011-06-21 15:55:15 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core8b

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
      v4l2-ctrls: add v4l2_fh pointer to the set control functions.
      v4l2-ctrls: add control events.
      v4l2-ctrls: simplify event subscription.
      V4L2 spec: document control events.
      vivi: support control events.
      ivtv: add control event support.
      v4l2-compat-ioctl32: add VIDIOC_DQEVENT support.
      v4l2-ctrls: make manual_mode_value 8 bits and check against control range.

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   17 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  142 +++++++++-
 Documentation/video4linux/v4l2-controls.txt        |   69 ++++-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   11 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    2 +
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |   37 +++
 drivers/media/video/v4l2-ctrls.c                   |  333 ++++++++++++++++----
 drivers/media/video/v4l2-device.c                  |    1 +
 drivers/media/video/v4l2-event.c                   |  130 ++++++--
 drivers/media/video/v4l2-fh.c                      |    6 +-
 drivers/media/video/v4l2-ioctl.c                   |   40 ++-
 drivers/media/video/v4l2-subdev.c                  |   14 +-
 drivers/media/video/vivi.c                         |   53 +++-
 include/linux/videodev2.h                          |   29 ++-
 include/media/v4l2-ctrls.h                         |   92 +++++-
 include/media/v4l2-event.h                         |    2 +
 include/media/v4l2-fh.h                            |    2 +
 kernel/compat.c                                    |    1 +
 21 files changed, 842 insertions(+), 147 deletions(-)
