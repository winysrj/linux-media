Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58110 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3EMJbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:31:15 -0400
Received: by mail-pd0-f174.google.com with SMTP id u10so4256236pdi.5
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:31:14 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: sachin.kamat@linaro.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] [media] omap3isp: Remove redundant platform_set_drvdata()
Date: Mon, 13 May 2013 14:47:54 +0530
Message-Id: <1368436674-11876-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1d7dbd5..4afa421 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2291,8 +2291,6 @@ error_isp:
 	isp_xclk_cleanup(isp);
 	omap3isp_put(isp);
 error:
-	platform_set_drvdata(pdev, NULL);
-
 	mutex_destroy(&isp->isp_mutex);
 
 	return ret;
-- 
1.7.9.5

