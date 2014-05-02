Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.176.135]:52922 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaEBHSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 03:18:22 -0400
Received: from smtp10.mail.ru (smtp10.mail.ru [94.100.176.152])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 835D2100D8C34
	for <linux-media@vger.kernel.org>; Fri,  2 May 2014 11:18:20 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] media: mx2-emmaprp: Add missing mutex_destroy()
Date: Fri,  2 May 2014 11:18:01 +0400
Message-Id: <1399015081-23953-2-git-send-email-shc_work@mail.ru>
In-Reply-To: <1399015081-23953-1-git-send-email-shc_work@mail.ru>
References: <1399015081-23953-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the missing mutex_destroy(), when the driver is removed.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/mx2_emmaprp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 85ce099..fa8f7ca 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -985,6 +985,8 @@ rel_vdev:
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 
+	mutex_destroy(&pcdev->dev_mutex);
+
 	return ret;
 }
 
@@ -998,6 +1000,7 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
+	mutex_destroy(&pcdev->dev_mutex);
 
 	return 0;
 }
-- 
1.8.3.2

