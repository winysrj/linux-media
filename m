Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36204 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756710AbdCHDlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 22:41:35 -0500
Received: by mail-pg0-f54.google.com with SMTP id 187so8021127pgb.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 19:41:04 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, hans.verkuil@cisco.com,
        wuchengli@google.com
Cc: djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/1] mtk-vcodec: check the vp9 decoder buffer index from VPU
Date: Wed,  8 Mar 2017 11:40:57 +0800
Message-Id: <20170308034058.99886-1-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

v2: also check the result of vdec_if_decode in mtk_vdec_worker.
v3: set buffer status to VB2_BUF_STATE_ERROR. Move printk out of lock.

Wu-Cheng Li (1):
  mtk-vcodec: check the vp9 decoder buffer index from VPU.

 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 33 +++++++++++++++++-----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |  2 ++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 +++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
 4 files changed, 56 insertions(+), 7 deletions(-)

-- 
2.12.0.246.ga2ecc84866-goog
