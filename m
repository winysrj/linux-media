Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48727 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933752AbcI1VW2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:28 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 20/35] media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
Date: Wed, 28 Sep 2016 16:22:20 -0500
Message-ID: <20160928212220.27220-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ti_vpe module currently does not get loaded automatically.
Added MODULE_DEVICE_TABLE hint to the driver to assist.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index a43dcac0b15e..57d19ad6d4a5 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2448,6 +2448,7 @@ static const struct of_device_id vpe_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, vpe_of_match);
 #endif
 
 static struct platform_driver vpe_pdrv = {
-- 
2.9.0

