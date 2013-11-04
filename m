Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3KDAG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 16/18] v4l: omap4iss: Make loop counters unsigned where appropriate
Date: Mon,  4 Nov 2013 01:06:41 +0100
Message-Id: <1383523603-3907-17-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Loop counters that can only take positive values should be unsigned.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 043a3f3..c7dffa6 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1290,7 +1290,8 @@ static int iss_probe(struct platform_device *pdev)
 {
 	struct iss_platform_data *pdata = pdev->dev.platform_data;
 	struct iss_device *iss;
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	if (pdata == NULL)
 		return -EINVAL;
@@ -1414,7 +1415,7 @@ error:
 static int iss_remove(struct platform_device *pdev)
 {
 	struct iss_device *iss = platform_get_drvdata(pdev);
-	int i;
+	unsigned int i;
 
 	iss_unregister_entities(iss);
 	iss_cleanup_modules(iss);
-- 
1.8.1.5

