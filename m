Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:55039 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3ANKSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 05:18:09 -0500
Received: by mail-da0-f54.google.com with SMTP id n2so1759541dad.27
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 02:18:09 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-mfc: Use NULL instead of 0 for pointer
Date: Mon, 14 Jan 2013 15:39:41 +0530
Message-Id: <1358158181-5356-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warning:
drivers/media/platform/s5p-mfc/s5p_mfc_opr.c:56:27: warning:
Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index b4c1943..10f8ac3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -53,7 +53,7 @@ void s5p_mfc_release_priv_buf(struct device *dev,
 {
 	if (b->virt) {
 		dma_free_coherent(dev, b->size, b->virt, b->dma);
-		b->virt = 0;
+		b->virt = NULL;
 		b->dma = 0;
 		b->size = 0;
 	}
-- 
1.7.4.1

