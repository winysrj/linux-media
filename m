Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34011 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2EJGly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 02:41:54 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so1304993dad.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 23:41:53 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 2/2] [media] s5p-mfc: Add missing static storage class to silence warnings
Date: Thu, 10 May 2012 12:02:01 +0530
Message-Id: <1336631521-24820-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1336631521-24820-1-git-send-email-sachin.kamat@linaro.org>
References: <1336631521-24820-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:

drivers/media/video/s5p-mfc/s5p_mfc.c:73:6
	warning: symbol 's5p_mfc_watchdog' was not declared. Should it be static?
drivers/media/video/s5p-mfc/s5p_mfc_opr.c:299:6:
	warning: symbol 's5p_mfc_set_shared_buffer' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c     |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index ac2dac9..2de6c72 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -70,7 +70,7 @@ static void wake_up_dev(struct s5p_mfc_dev *dev, unsigned int reason,
 	wake_up(&dev->queue);
 }
 
-void s5p_mfc_watchdog(unsigned long arg)
+static void s5p_mfc_watchdog(unsigned long arg)
 {
 	struct s5p_mfc_dev *dev = (struct s5p_mfc_dev *)arg;
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index a802829..e6217cb 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -296,7 +296,7 @@ void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for shared buffer */
-void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
-- 
1.7.4.1

