Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35377 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdKTWrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 17:47:01 -0500
From: Vasyl Gomonovych <gomonovych@gmail.com>
To: patrice.chotard@st.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        gomonovych@gmail.com
Subject: [PATCH] [media] c8sectpfe: Use resource_size function on memory resource
Date: Mon, 20 Nov 2017 23:46:47 +0100
Message-Id: <1511218007-3577-1-git-send-email-gomonovych@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To adapt fei->sram_size calculation via resource_size for memory size
calculation before, in fei->sram = devm_ioremap_resource(dev, res).
And make memory initialization range in
memset_io for fei->sram appropriate

Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 59280ac31937..283f7289aaa1 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -691,7 +691,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 	if (IS_ERR(fei->sram))
 		return PTR_ERR(fei->sram);
 
-	fei->sram_size = res->end - res->start;
+	fei->sram_size = resource_size(res);
 
 	fei->idle_irq = platform_get_irq_byname(pdev, "c8sectpfe-idle-irq");
 	if (fei->idle_irq < 0) {
-- 
1.9.1
