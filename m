Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2HQGY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 02:24:56 -0400
Received: by pbbrr13 with SMTP id rr13so2828980pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 23:24:55 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH-Trivial] [media] s5p-mfc: Add missing braces around sizeof
Date: Fri, 17 Aug 2012 11:52:55 +0530
Message-Id: <1345184575-14035-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warnings:
WARNING: sizeof *ctx should be sizeof(*ctx)
WARNING: sizeof *dev should be sizeof(*dev)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e3e616d..815affe 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -649,7 +649,7 @@ static int s5p_mfc_open(struct file *file)
 		return -ERESTARTSYS;
 	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
 	/* Allocate memory for context */
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		mfc_err("Not enough memory\n");
 		ret = -ENOMEM;
@@ -961,7 +961,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	int ret;

 	pr_debug("%s++\n", __func__);
-	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&pdev->dev, "Not enough memory for MFC device\n");
 		return -ENOMEM;
--
1.7.4.1

