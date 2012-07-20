Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40542 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2GTOBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 10:01:10 -0400
Received: by gglu4 with SMTP id u4so3985484ggl.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 07:01:09 -0700 (PDT)
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] davinci: vpbe: fix check for s_dv_preset function pointer
Date: Fri, 20 Jul 2012 19:30:57 +0530
Message-Id: <1342792857-16421-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

fix check for s_dv_preset function pointer to be NULL.
return -EINVAL if function pointer is NULL.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpbe_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index e106b72..f78ccc0 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1083,7 +1083,7 @@ vpbe_display_s_dv_preset(struct file *file, void *priv,
 	}
 
 	/* Set the given standard in the encoder */
-	if (NULL != vpbe_dev->ops.s_dv_preset)
+	if (!vpbe_dev->ops.s_dv_preset)
 		return -EINVAL;
 
 	ret = vpbe_dev->ops.s_dv_preset(vpbe_dev, preset);
-- 
1.7.4.1

