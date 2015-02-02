Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46212 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbbBBPQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 10:16:40 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6B1F02A0080
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 16:16:01 +0100 (CET)
Message-ID: <54CF94B1.20109@xs4all.nl>
Date: Mon, 02 Feb 2015 16:16:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found a few more patches that I missed.

Regards,

	Hans

The following changes since commit 05439b1a36935992785c4f28f6693e73820321cb:

  [media] media: au0828 - convert to use videobuf2 (2015-02-02 11:58:27 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20e

for you to fetch changes up to d1abf49aab3b43ac0eb2551592ab9cba65abad9b:

  media: platform: fix platform_no_drv_owner.cocci warnings (2015-02-02 16:14:31 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      marvell-ccic: MMP_CAMERA no longer builds

Fengguang Wu (1):
      media: platform: fix platform_no_drv_owner.cocci warnings

Markus Elfring (1):
      staging: bcm2048: Delete an unnecessary check before the function call "video_unregister_device"

Prabhakar Lad (1):
      media: ti-vpe: Use mem-to-mem ioctl helpers

 drivers/media/platform/am437x/am437x-vpfe.c   |   1 -
 drivers/media/platform/marvell-ccic/Kconfig   |   2 +-
 drivers/media/platform/ti-vpe/vpe.c           | 157 +++++++++++++++++++++++++-----------------------------------------------------
 drivers/staging/media/bcm2048/radio-bcm2048.c |   4 +-
 4 files changed, 52 insertions(+), 112 deletions(-)
