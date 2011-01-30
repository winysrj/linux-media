Return-path: <mchehab@pedra>
Received: from grimli.r00tworld.net ([83.169.44.195]:44680 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1A3KQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jan 2011 05:16:07 -0500
From: Mathias Krause <minipli@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] [media] OMAP1: fix use after free
Date: Sun, 30 Jan 2011 11:05:58 +0100
Message-Id: <1296381958-15760-1-git-send-email-minipli@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Even though clk_put() is a no-op on most architectures it is not for
some ARM implementations. To not fail on those, release the clock timer
before freeing the surrounding structure.

This bug was spotted by the semantic patch tool coccinelle using the
script found at scripts/coccinelle/free/kfree.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/media/video/omap1_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index 0a2fb2b..9ed1513 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1664,10 +1664,10 @@ static int __exit omap1_cam_remove(struct platform_device *pdev)
 	res = pcdev->res;
 	release_mem_region(res->start, resource_size(res));
 
-	kfree(pcdev);
-
 	clk_put(pcdev->clk);
 
+	kfree(pcdev);
+
 	dev_info(&pdev->dev, "OMAP1 Camera Interface driver unloaded\n");
 
 	return 0;
-- 
1.5.6.5

