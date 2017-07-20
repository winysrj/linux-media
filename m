Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50467 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964876AbdGTPSj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:18:39 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] venus/davinci fixes for 4.13
Message-ID: <4dbb9259-6574-746b-515b-1454b6561a83@xs4all.nl>
Date: Thu, 20 Jul 2017 17:18:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0e6fd95802e25b2428749703f76ea9d54ea743a3:

  media: pulse8-cec/rainshadow-cec: make adapter name unique (2017-07-18 13:00:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13b

for you to fetch changes up to 250c04a2dda0cb7e378773443a000f5c32b42c8d:

  media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS (2017-07-20 17:08:06 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      venus: mark PM functions as __maybe_unused
      venus: fix compile-test build on non-qcom ARM platform

Prabhakar Lad (2):
      media: platform: davinci: return -EINVAL for VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
      media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS

Rob Clark (1):
      media: venus: hfi: fix error handling in hfi_sys_init_done()

Stanimir Varbanov (1):
      media: venus: don't abuse dma_alloc for non-DMA allocations

 drivers/media/platform/Kconfig                  |   4 +--
 drivers/media/platform/davinci/ccdc_hw_device.h |  10 ------
 drivers/media/platform/davinci/dm355_ccdc.c     |  92 +-----------------------------------------------
 drivers/media/platform/davinci/dm644x_ccdc.c    | 151 ++-----------------------------------------------------------------------------
 drivers/media/platform/davinci/vpfe_capture.c   |  93 -------------------------------------------------
 drivers/media/platform/qcom/venus/core.c        |  16 ++++-----
 drivers/media/platform/qcom/venus/core.h        |   1 -
 drivers/media/platform/qcom/venus/firmware.c    |  76 ++++++++++++++++++----------------------
 drivers/media/platform/qcom/venus/firmware.h    |   5 ++-
 drivers/media/platform/qcom/venus/hfi_msgs.c    |  11 +++---
 include/media/davinci/dm644x_ccdc.h             |  12 -------
 include/media/davinci/vpfe_capture.h            |  10 ------
 12 files changed, 54 insertions(+), 427 deletions(-)
