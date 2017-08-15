Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33599 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdHOLYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:24:00 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] coda: constify platform_device_id
Date: Tue, 15 Aug 2017 16:53:40 +0530
Message-Id: <1502796222-9681-2-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f92cc7d..530c937 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2390,7 +2390,7 @@ static const struct coda_devtype coda_devdata[] = {
 	},
 };
 
-static struct platform_device_id coda_platform_ids[] = {
+static const struct platform_device_id coda_platform_ids[] = {
 	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
 	{ /* sentinel */ }
 };
-- 
2.7.4
