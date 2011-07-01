Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4408 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1GAJES (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 05:04:18 -0400
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id p6194GGH098224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 1 Jul 2011 11:04:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] Control event and control framework
Date: Fri, 1 Jul 2011 11:04:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011104.15980.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This is the pull request containing all control event and control framework
patches. The first set (until the compat-ioctl32 patch) you have already reviewed.

The second set contains the RFCv2 patch series posted Tuesday together with
the two changes you wanted for the first set ('make manual_mode_value 8 bits'
and 'V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK').

There were no comments regarding the RFCv2 patch series, so that is unchanged.

The first 18 patches are also part of the pull request I posted on Tuesday, you
can either pull from that request first and than this one, or just pull it all
from this repository, whatever is easiest for you.

Of course, the poll() changes are not included, that is still under discussion.

Regards,

	Hans

The following changes since commit 7023c7dbc3944f42aa1d6910a6098c5f9e23d3f1:

  [media] DVB: dvb-net, make the kconfig text helpful (2011-06-21 15:55:15 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core8c

Hans Verkuil (32):
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
      v4l2-events/fh: merge v4l2_events into v4l2_fh
      v4l2-ctrls/event: remove struct v4l2_ctrl_fh, instead use v4l2_subscribed_event
      v4l2-event/ctrls/fh: allocate events per fh and per type instead of just per-fh
      v4l2-event: add optional merge and replace callbacks
      v4l2-ctrls: don't initially set CH_VALUE for write-only controls
      v4l2-ctrls: improve discovery of controls of the same cluster
      v4l2-ctrls: split try_or_set_ext_ctrls()
      v4l2-ctrls: v4l2_ctrl_handler_setup code simplification
      v4l2-framework.txt: updated v4l2_fh_init documentation.
      v4l2-framework.txt: update v4l2_event section.
      DocBook: update V4L Event Interface section.
      v4l2-ctrls/v4l2-events: small coding style cleanups
      v4l2-event.h: add overview documentation to the header.
      v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK

 Documentation/DocBook/media/v4l/dev-event.xml      |   30 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   17 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  173 ++++++-
 Documentation/video4linux/v4l2-controls.txt        |   69 ++-
 Documentation/video4linux/v4l2-framework.txt       |   59 ++-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   19 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    4 +-
 drivers/media/video/omap3isp/ispccdc.c             |    3 +-
 drivers/media/video/omap3isp/ispstat.c             |    3 +-
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |   37 ++
 drivers/media/video/v4l2-ctrls.c                   |  564 +++++++++++++-------
 drivers/media/video/v4l2-device.c                  |    1 +
 drivers/media/video/v4l2-event.c                   |  282 +++++-----
 drivers/media/video/v4l2-fh.c                      |   23 +-
 drivers/media/video/v4l2-ioctl.c                   |   40 +-
 drivers/media/video/v4l2-subdev.c                  |   31 +-
 drivers/media/video/vivi.c                         |   53 ++-
 drivers/usb/gadget/uvc_v4l2.c                      |   22 +-
 include/linux/videodev2.h                          |   30 +-
 include/media/v4l2-ctrls.h                         |   72 +++-
 include/media/v4l2-event.h                         |   84 +++-
 include/media/v4l2-fh.h                            |   13 +-
 include/media/v4l2-subdev.h                        |    2 -
 kernel/compat.c                                    |    1 +
 27 files changed, 1156 insertions(+), 484 deletions(-)
