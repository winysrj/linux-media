Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2267 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaGQSm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 14:42:56 -0400
Message-ID: <53C81922.90607@xs4all.nl>
Date: Thu, 17 Jul 2014 20:42:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [GIT PULL FOR v3.17] A few more fixes for 3.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit bdc2df62ae38bbab044078f4d25a7a3d9e2379c9:

  [media] v4l: vsp1: uds: Fix scaling of alpha layer (2014-07-17 12:45:00 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17c

for you to fetch changes up to 12ae380f97c884b21c1eefb1c7dfd0f411639f70:

  v4l: ctrls: Unlocked variants of v4l2_ctrl_s_ctrl{,_int64}() (2014-07-17 20:41:16 +0200)

----------------------------------------------------------------
Andrey Utkin (1):
      drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: fix negativity check

Hans Verkuil (1):
      saa7146: fix compile warning

Ian Molton (1):
      adv7180: Remove duplicate unregister call

Sakari Ailus (3):
      v4l: ctrls: Move control lock/unlock above the control access functions
      v4l: ctrls: Provide an unlocked variant of v4l2_ctrl_modify_range()
      v4l: ctrls: Unlocked variants of v4l2_ctrl_s_ctrl{,_int64}()

 drivers/media/common/saa7146/saa7146_fops.c        | 13 ++++++-------
 drivers/media/i2c/adv7180.c                        |  1 -
 drivers/media/v4l2-core/v4l2-ctrls.c               | 34 ++++++++++++++++++++++++----------
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  5 +++--
 include/media/v4l2-ctrls.h                         | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 5 files changed, 89 insertions(+), 39 deletions(-)
