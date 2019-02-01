Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A211FC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 18:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BA6721872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 18:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfBASGt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:06:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54539 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfBASGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 13:06:48 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gpdD9-0004hI-1D; Fri, 01 Feb 2019 18:06:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: vb2: remove unused variable i
Date:   Fri,  1 Feb 2019 18:06:42 +0000
Message-Id: <20190201180642.14328-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable i is declared and never used. Fix this by removing it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index e07b6bdb6982..34cc87ca8d59 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 static void __vb2_dqbuf(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int i;
 
 	/* nothing to do if the buffer is already dequeued */
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
-- 
2.20.1

