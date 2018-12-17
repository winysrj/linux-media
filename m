Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B62C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 12:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BE02133F
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 12:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbeLQMHJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 07:07:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59264 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbeLQMHJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 07:07:09 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A332691D192D6;
        Mon, 17 Dec 2018 20:07:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Mon, 17 Dec 2018 20:06:55 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Eddie James <eajames@linux.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-media@vger.kernel.org>, <openbmc@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] media: platform: Fix missing spin_lock_init()
Date:   Mon, 17 Dec 2018 12:14:35 +0000
Message-ID: <1545048875-157403-1-git-send-email-weiyongjun1@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver allocates the spinlock but not initialize it.
Use spin_lock_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/aspeed-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index dfec813..692e08e 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1661,6 +1661,7 @@ static int aspeed_video_probe(struct platform_device *pdev)
 
 	video->frame_rate = 30;
 	video->dev = &pdev->dev;
+	spin_lock_init(&video->lock);
 	mutex_init(&video->video_lock);
 	init_waitqueue_head(&video->wait);
 	INIT_DELAYED_WORK(&video->res_work, aspeed_video_resolution_work);



