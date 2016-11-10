Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35825 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcKJFYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 00:24:19 -0500
Received: by mail-pf0-f169.google.com with SMTP id i88so139055548pfk.2
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2016 21:24:19 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, djkurtz@chromium.org,
        dan.carpenter@oracle.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wu-Cheng Li <wuchengli@google.com>
Subject: [PATCH v1] mtk-vcodec: add index check in decoder vidioc_qbuf
Date: Thu, 10 Nov 2016 13:24:04 +0800
Message-Id: <1478755445-23494-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

This patch adds a buffer index check in decoder vidioc_qbuf.

Wu-Cheng Li (1):
  mtk-vcodec: add index check in decoder vidioc_qbuf.

 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.8.0.rc3.226.g39d4020

