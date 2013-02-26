Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38277 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3BZTZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 14:25:17 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so2564672pbc.36
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2013 11:25:16 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, mchehab@redhat.com
Subject: [PATCH] siano: Remove redundant NULL check before kfree
Date: Wed, 27 Feb 2013 00:54:56 +0530
Message-Id: <1361906696-2624-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/common/siano/smscoreapi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 1842e64..9565dcc 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -719,8 +719,7 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 		dma_free_coherent(NULL, coredev->common_buffer_size,
 			coredev->common_buffer, coredev->common_buffer_phys);
 
-	if (coredev->fw_buf != NULL)
-		kfree(coredev->fw_buf);
+	kfree(coredev->fw_buf);
 
 	list_del(&coredev->entry);
 	kfree(coredev);
-- 
1.7.9.5

