Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81EFC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 18:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9973B21908
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 18:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392053AbeLVSbU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:31:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42517 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392020AbeLVSbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 13:31:17 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gafmx-0004zr-Mu; Sat, 22 Dec 2018 11:49:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] media: staging: intel-ipu3: fix unsigned comparison with < 0
Date:   Sat, 22 Dec 2018 11:49:51 +0000
Message-Id: <20181222114951.31503-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison css->pipes[pipe].bindex < 0 is always false because
bindex is an unsigned int.  Fix this by using a signed integer for
the comparison.

Detected by CoverityScan, CID#1476023 ("Unsigned compared against 0")

Fixes: f5f2e4273518 ("media: staging/intel-ipu3: Add css pipeline programming")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/ipu3/ipu3-css.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 44c55639389a..b9354d2bb692 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -1751,7 +1751,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 					&q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
 	struct v4l2_pix_format_mplane *const vf =
 					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
-	int i, s;
+	int i, s, ret;
 
 	/* Adjust all formats, get statistics buffer sizes and formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
@@ -1826,12 +1826,12 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
 	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
 
-	css->pipes[pipe].bindex =
-		ipu3_css_find_binary(css, pipe, q, r);
-	if (css->pipes[pipe].bindex < 0) {
+	ret = ipu3_css_find_binary(css, pipe, q, r);
+	if (ret < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
 		return -EINVAL;
 	}
+	css->pipes[pipe].bindex = ret;
 
 	dev_dbg(css->dev, "Binary index %d for pipe %d found.",
 		css->pipes[pipe].bindex, pipe);
-- 
2.19.1

