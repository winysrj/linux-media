Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36320 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdHOLYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:24:05 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] omap3isp: constify platform_device_id
Date: Tue, 15 Aug 2017 16:53:42 +0530
Message-Id: <1502796222-9681-4-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

platform_device_id are not supposed to change at runtime. All functions
working with platform_device_id provided by <linux/platform_device.h>
work with const platform_device_id. So mark the non-const structs as
const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c1..ddb2cf5 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2373,7 +2373,7 @@ static const struct dev_pm_ops omap3isp_pm_ops = {
 	.complete = isp_pm_complete,
 };
 
-static struct platform_device_id omap3isp_id_table[] = {
+static const struct platform_device_id omap3isp_id_table[] = {
 	{ "omap3isp", 0 },
 	{ },
 };
-- 
2.7.4
