Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4274 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1FZJhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 05:37:38 -0400
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5Q9baNu021449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 11:37:36 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.0 and 3.1] tuner-core fixes
Date: Sun, 26 Jun 2011 11:37:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261137.36704.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Here is the final set of patches fixing various tuner-core bugs.

The first 6 patches should go to 3.0 as well as they fix serious regression
bugs.

The remainder can go into 3.1.

There is definitely more work to be done, but it's at least in better shape.

Tested with em28xx + xc2028, ivtv (including PVR-500 with separate TV and radio
tuners), cx18, bttv and pvrusb2.

Regards,

	Hans

The following changes since commit 7023c7dbc3944f42aa1d6910a6098c5f9e23d3f1:

  [media] DVB: dvb-net, make the kconfig text helpful (2011-06-21 15:55:15 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git tuner

Hans Verkuil (14):
      tuner-core: fix s_std and s_tuner.
      tuner-core: fix tuner_resume: use t->mode instead of t->type.
      v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner.
      pvrusb2: fix g/s_tuner support.
      bttv: fix s_tuner for radio.
      feature-removal-schedule: change in how radio device nodes are handled.
      v4l2-subdev.h: remove unused s_mode tuner op.
      tuner-core/v4l2-subdev: document that the type field has to be filled in.
      tuner-core: simplify the standard fixup.
      v4l2-ioctl.c: check for valid tuner type in S_HW_FREQ_SEEK.
      tuner-core: power up tuner when called with s_power(1).
      cx18/ivtv: fix g_tuner support.
      tuner-core.c: don't change type field in g_tuner or g_frequency
      msp3400: fill in v4l2_tuner based on vt->type field.

 Documentation/feature-removal-schedule.txt |   22 +++
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c      |    8 +-
 drivers/media/video/ivtv/ivtv-ioctl.c      |    8 +-
 drivers/media/video/msp3400-driver.c       |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 +
 drivers/media/video/tuner-core.c           |  229 ++++++++++++++--------------
 drivers/media/video/v4l2-ioctl.c           |   18 ++-
 include/media/v4l2-subdev.h                |   10 +-
 9 files changed, 174 insertions(+), 139 deletions(-)
