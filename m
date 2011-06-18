Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3319 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1FRKkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 06:40:04 -0400
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5IAe1Yh061307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 12:40:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] Improve event and control handling
Date: Sat, 18 Jun 2011 12:39:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106181239.56449.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This pull requests sits on top of my previous pull request:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg32762.html

This core9 branch contains the same patches as the earlier core8, so if you
want you can also pull everything from the core9 branch.

The patches in this pull request are almost the same as these:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg33054.html

The two changes are the addition of documentation (both DocBook and
v4l2-framework.txt) and patch 4 in the link above: instead of one single
merge() callback it is now split into a replace() callback and a merge()
callback. When I was documenting the original merge() callback I realized
that it really had to be split into two callbacks or it would be too
confusing.

It's been tested extensively with ivtv and vivi.

I've added support for waiting/polling on the control event to v4l2-ctl:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

The first four and the last three patches deal with a change in the event
handling, adding guarantees to the framework what should be done when the
internal event queues become full and events need to be dropped. It's much
more useful now.

The four v4l2-ctrls patches improve the internal datastructures and reduce
the time spent with a lock held. In particular it gets rid of a potential
quadratic algorithm, replacing it with a linear one (and making the code
shorter as well). It is the first important step towards allowing certain
types of controls to be set from interrupt context.

Regards,

	Hans

The following changes since commit a07d17c00db2cff623aea8113d6cfd181baf86a1:

  v4l2-compat-ioctl32: add VIDIOC_DQEVENT support. (2011-06-10 10:57:27 +0200)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core9

Hans Verkuil (11):
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

 Documentation/DocBook/media/v4l/dev-event.xml      |   30 ++-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   15 +-
 Documentation/video4linux/v4l2-framework.txt       |   59 ++-
 drivers/media/video/ivtv/ivtv-fileops.c            |   10 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    4 +-
 drivers/media/video/omap3isp/ispccdc.c             |    3 +-
 drivers/media/video/omap3isp/ispstat.c             |    3 +-
 drivers/media/video/v4l2-ctrls.c                   |  416 +++++++++-----------
 drivers/media/video/v4l2-event.c                   |  218 ++++------
 drivers/media/video/v4l2-fh.c                      |   19 +-
 drivers/media/video/v4l2-subdev.c                  |   17 +-
 drivers/media/video/vivi.c                         |    4 +-
 drivers/usb/gadget/uvc_v4l2.c                      |   22 +-
 include/media/v4l2-ctrls.h                         |   39 +--
 include/media/v4l2-event.h                         |   44 ++-
 include/media/v4l2-fh.h                            |   11 +-
 include/media/v4l2-subdev.h                        |    2 -
 17 files changed, 417 insertions(+), 499 deletions(-)
