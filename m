Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A57EC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 02:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D70D1218FD
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 02:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbeL2Cqg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 21:46:36 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:58745 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727815AbeL2Cqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 21:46:36 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DC9C1968DD1DA;
        Sat, 29 Dec 2018 10:46:32 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Sat, 29 Dec 2018
 10:46:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <sakari.ailus@linux.intel.com>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-media@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] media: staging/intel-ipu3: Fix err handle of ipu3_css_find_binary
Date:   Sat, 29 Dec 2018 10:45:28 +0800
Message-ID: <20181229024528.6016-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

'bindex' is unsigned, it never less than zero.
This patch bring int 'binary' back to handle the err condition.

Fixes: 51abe041c5ed ("media: staging/intel-ipu3: Add dual pipe support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/media/ipu3/ipu3-css.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 44c5563..28f0c02 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -1751,7 +1751,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 					&q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
 	struct v4l2_pix_format_mplane *const vf =
 					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
-	int i, s;
+	int i, s, binary;
 
 	/* Adjust all formats, get statistics buffer sizes and formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
@@ -1826,13 +1826,13 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
 	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
 
-	css->pipes[pipe].bindex =
-		ipu3_css_find_binary(css, pipe, q, r);
-	if (css->pipes[pipe].bindex < 0) {
+	binary = ipu3_css_find_binary(css, pipe, q, r);
+	if (binary < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
 		return -EINVAL;
 	}
 
+	css->pipes[pipe].bindex = binary;
 	dev_dbg(css->dev, "Binary index %d for pipe %d found.",
 		css->pipes[pipe].bindex, pipe);
 
-- 
2.7.0


