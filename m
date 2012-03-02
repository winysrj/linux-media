Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3934 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2CBQJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 11:09:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.4] Fix ivtv/control issues.
Date: Fri, 2 Mar 2012 17:09:19 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021709.19383.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I discovered that after the decoder controls were added to ivtv a lot of the
controls went missing.

The core reason was a bug in v4l2_ctrl_add_handler that was triggered for the
first time due to the ivtv changes. So the first patch fixes that bug.

The second reason was unnecessarily complex coding in ivtv. The second patch
simplifies ivtv. Either patch is actually sufficient to solve the bug since
after the simplification the condition that triggered the v4l2_ctrl_add_handler
bug no longer occurs.

Regards,

	Hans

The following changes since commit e8ca6d20a65d9d94693a0ed99b12d95b882dc859:

  [media] tveeprom: update hauppauge tuner list thru 181 (2012-02-28 18:46:53 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ivtv-fix

for you to fetch changes up to bb5b2c83cb86c34bb345c40685c135e9a3e31195:

  ivtv: simplify how the decoder controls are set up. (2012-03-02 17:02:11 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-ctrls: v4l2_ctrl_add_handler should add all refs
      ivtv: simplify how the decoder controls are set up.

 drivers/media/video/ivtv/ivtv-controls.c |    4 ++--
 drivers/media/video/ivtv/ivtv-driver.c   |   20 ++++++++------------
 drivers/media/video/ivtv/ivtv-driver.h   |    1 -
 drivers/media/video/ivtv/ivtv-ioctl.c    |    5 +----
 drivers/media/video/ivtv/ivtv-streams.c  |    5 +----
 drivers/media/video/v4l2-ctrls.c         |    6 ++++--
 6 files changed, 16 insertions(+), 25 deletions(-)
