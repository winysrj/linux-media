Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42932 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbCGPa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 10:30:57 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: am437x-vpfe: return error in case memory allocation failure
Date: Sat,  7 Mar 2015 15:30:50 +0000
Message-Id: <1425742250-24404-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425742250-24404-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425742250-24404-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

return error in case devm_kzalloc() fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 3d59ae0..8e056eb 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2501,6 +2501,12 @@ vpfe_get_pdata(struct platform_device *pdev)
 		pdata->asd[i] = devm_kzalloc(&pdev->dev,
 					     sizeof(struct v4l2_async_subdev),
 					     GFP_KERNEL);
+		if (!pdata->asd[i]) {
+			of_node_put(rem);
+			pdata = NULL;
+			goto done;
+		}
+
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
 		pdata->asd[i]->match.of.node = rem;
 		of_node_put(rem);
-- 
2.1.0

