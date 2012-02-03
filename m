Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1355 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2BCNJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 08:09:22 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id q13D9JYi008863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 3 Feb 2012 14:09:21 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 72E4635C0004
	for <linux-media@vger.kernel.org>; Fri,  3 Feb 2012 14:09:19 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.4] Updating ISA Radio drivers :-)
Date: Fri, 3 Feb 2012 14:09:18 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202031409.18394.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One of the things I've wanted to do for some time is to start upgrading
all drivers to the latest V4L2 frameworks and ensuring that they pass
the v4l2-compliance tests.

So I started out with some of the oldest drivers around: the ISA radio
drivers :-)

Partially because they are easy to convert, partially because it is fun to
work with old hardware like that every so often.

I have tested this with actual hardware for the aimslab, aztech and gemtek
drivers.

Since you can load ISA drivers even if there is no actual hardware, I was
able to run the other drivers through v4l2-compliance as well. I couldn't
test whether it actually works, of course, but at least it doesn't crash...

The original RFC patch series is here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg42091.html

Not surprisingly there were no comments.

This series is identical, except for being updated to use the new helper
functions that are part of the radio-keene patch set:

http://www.spinics.net/lists/linux-media/msg43852.html

If you want, you can pull from my radio-isa2 branch to get both the isa
driver changes and the radio-keene + helper functions changes.

Regards,

	Hans

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:

  Merge branch 'v4l_for_linus' into staging/for_v3.4 (2012-01-23 18:11:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git radio-isa2

Hans Verkuil (16):
      v4l2: standardize log start/end message.
      v4l2-subdev: add start/end messages for log_status.
      v4l2-ctrls: add helper functions for control events.
      vivi: use v4l2_ctrl_subscribe_event.
      radio-keene: add a driver for the Keene FM Transmitter.
      hid-core: ignore the Keene FM transmitter.
      radio-isa: add framework for ISA radio drivers.
      radio-aimslab: Convert to radio-isa.
      radio-aztech: Convert to radio-isa.
      radio-gemtek: Convert to radio-isa.
      radio-rtrack2: Convert to radio-isa.
      radio-terratec: Convert to radio-isa.
      radio-trust: Convert to radio-isa.
      radio-typhoon: Convert to radio-isa.
      radio-zoltrix: Convert to radio-isa.
      radio/Kconfig: cleanup.

 drivers/hid/hid-core.c                        |   10 +
 drivers/hid/hid-ids.h                         |    1 +
 drivers/media/radio/Kconfig                   |  123 +++----
 drivers/media/radio/Makefile                  |    2 +
 drivers/media/radio/radio-aimslab.c           |  439 ++++++-----------------
 drivers/media/radio/radio-aztech.c            |  371 ++++---------------
 drivers/media/radio/radio-gemtek.c            |  493 +++++--------------------
 drivers/media/radio/radio-isa.c               |  339 +++++++++++++++++
 drivers/media/radio/radio-isa.h               |  105 ++++++
 drivers/media/radio/radio-keene.c             |  427 +++++++++++++++++++++
 drivers/media/radio/radio-rtrack2.c           |  332 ++++-------------
 drivers/media/radio/radio-terratec.c          |  364 +++---------------
 drivers/media/radio/radio-trust.c             |  387 +++++---------------
 drivers/media/radio/radio-typhoon.c           |  365 ++++---------------
 drivers/media/radio/radio-zoltrix.c           |  441 ++++++-----------------
 drivers/media/video/bt8xx/bttv-driver.c       |    4 -
 drivers/media/video/cx18/cx18-ioctl.c         |    4 -
 drivers/media/video/ivtv/ivtv-ioctl.c         |    5 -
 drivers/media/video/pwc/pwc-v4l.c             |   10 +-
 drivers/media/video/saa7164/saa7164-encoder.c |    6 -
 drivers/media/video/saa7164/saa7164-vbi.c     |    6 -
 drivers/media/video/v4l2-ctrls.c              |   32 ++
 drivers/media/video/v4l2-ioctl.c              |    6 +
 drivers/media/video/v4l2-subdev.c             |   12 +-
 drivers/media/video/vivi.c                    |   23 +-
 include/media/v4l2-ctrls.h                    |   13 +
 26 files changed, 1683 insertions(+), 2637 deletions(-)
 create mode 100644 drivers/media/radio/radio-isa.c
 create mode 100644 drivers/media/radio/radio-isa.h
 create mode 100644 drivers/media/radio/radio-keene.c
