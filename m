Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33544 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755306AbdCGPS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 10:18:27 -0500
Received: by mail-pg0-f41.google.com with SMTP id 25so1517357pgy.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 07:16:49 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, hans.verkuil@cisco.com,
        wuchengli@google.com
Cc: djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] mtk-vcodec: check the vp9 decoder buffer index from VPU
Date: Tue,  7 Mar 2017 22:42:06 +0800
Message-Id: <20170307144207.133234-1-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

This patch guards against the invalid buffer index from
VPU firmware.

v2: also check the result of vdec_if_decode in mtk_vdec_worker.

Wu-Cheng Li (1):
  mtk-vcodec: check the vp9 decoder buffer index from VPU.

 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 23 ++++++++++++++-----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |  2 ++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
 4 files changed, 48 insertions(+), 5 deletions(-)

-- 
2.12.0.rc1.440.g5b76565f74-goog
