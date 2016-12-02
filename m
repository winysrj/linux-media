Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:34976 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbcLBCip (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 21:38:45 -0500
Received: by mail-pg0-f41.google.com with SMTP id p66so101795550pga.2
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2016 18:38:44 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: tiffany.lin@mediatek.com, andrew-ct.chen@mediatek.com,
        mchehab@kernel.org, matthias.bgg@gmail.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, pawel@osciak.com,
        Wu-Cheng Li <wuchengli@google.com>
Subject: [PATCH v1] mtk-vcodec: use V4L2_DEC_CMD_STOP to implement flush
Date: Fri,  2 Dec 2016 10:38:33 +0800
Message-Id: <1480646314-75478-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

This patch uses V4L2_DEC_CMD_STOP to implement flush -- requesting
the remaining images to be returned to userspace. The old unofficial
way was to use a size-0 input buffer and the code is removed.

Tiffany Lin (1):
  mtk-vcodec: use V4L2_DEC_CMD_STOP to implement flush

 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 151 ++++++++++++++-------
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  14 ++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   2 +
 3 files changed, 117 insertions(+), 50 deletions(-)

-- 
2.8.0.rc3.226.g39d4020

