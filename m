Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78040C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 02:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504D9218A3
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 02:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfCOCBl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 22:01:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726451AbfCOCBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 22:01:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8159C8707C2565BADABB;
        Fri, 15 Mar 2019 10:01:38 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Fri, 15 Mar 2019
 10:01:30 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <maintainers@bluecherrydvr.com>, <anton@corp.bluecherry.net>,
        <andrey.utkin@corp.bluecherry.net>, <mchehab@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] media: tw5864: Fix possible NULL pointer dereference in tw5864_handle_frame
Date:   Fri, 15 Mar 2019 10:01:24 +0800
Message-ID: <20190315020124.18292-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

'vb' null check should before dereference it in
tw5864_handle_frame, otherwise NULL pointer dereference
may occurs.

Fixes: 34d1324edd31 ("[media] pci: Add tw5864 driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/pci/tw5864/tw5864-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 5a1f3aa..434d313 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -1395,13 +1395,13 @@ static void tw5864_handle_frame(struct tw5864_h264_frame *frame)
 	input->vb = NULL;
 	spin_unlock_irqrestore(&input->slock, flags);
 
-	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
-
 	if (!vb) { /* Gone because of disabling */
 		dev_dbg(&dev->pci->dev, "vb is empty, dropping frame\n");
 		return;
 	}
 
+	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
+
 	/*
 	 * Check for space.
 	 * Mind the overhead of startcode emulation prevention.
-- 
2.7.0


