Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37775 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3D3G3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 02:29:11 -0400
Received: by mail-pd0-f176.google.com with SMTP id r10so127412pdi.7
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 23:29:11 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/4] [media] s3c-camif: Remove redundant NULL check
Date: Tue, 30 Apr 2013 11:46:18 +0530
Message-Id: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
to IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s3c-camif/camif-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 0d0fab1..2449f13 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -341,7 +341,7 @@ static void camif_clk_put(struct camif_dev *camif)
 	int i;
 
 	for (i = 0; i < CLK_MAX_NUM; i++) {
-		if (IS_ERR_OR_NULL(camif->clock[i]))
+		if (IS_ERR(camif->clock[i]))
 			continue;
 		clk_unprepare(camif->clock[i]);
 		clk_put(camif->clock[i]);
-- 
1.7.9.5

