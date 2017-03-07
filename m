Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:32807 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdCGGF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 01:05:27 -0500
Received: by mail-pg0-f41.google.com with SMTP id 25so75088136pgy.0
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 22:03:35 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, hans.verkuil@cisco.com,
        wuchengli@google.com
Cc: djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/1] mtk-vcodec: check the vp9 decoder buffer index from VPU
Date: Tue,  7 Mar 2017 14:03:27 +0800
Message-Id: <20170307060328.114348-1-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

This patch guards against the invalid buffer index from
VPU firmware.

Wu-Cheng Li (1):
  mtk-vcodec: check the vp9 decoder buffer index from VPU.

 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  6 +++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
 3 files changed, 34 insertions(+)

-- 
2.12.0.rc1.440.g5b76565f74-goog
