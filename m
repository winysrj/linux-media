Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52197 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbdG1N0x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:26:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Jan Luebbe <jlu@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: reduce iram size to leave space for suspend to ram
Date: Fri, 28 Jul 2017 15:26:47 +0200
Message-Id: <20170728132647.27173-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Luebbe <jlu@pengutronix.de>

The on-chip SRAM of i.MX6S is only 128 KiB. 4 KiB of that are allocated
for suspend to RAM since commit df595746fa69 ("ARM: imx: add suspend in
ocram support for i.mx6q"). Reduce the requested IRAM size to 124 KiB to
avoid an allocation failure that causes the coda driver to not use the
SRAM at all.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 40f31038249d9..27c613752fbf7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2443,7 +2443,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.num_vdevs    = ARRAY_SIZE(coda9_video_devices),
 		.workbuf_size = 80 * 1024,
 		.tempbuf_size = 204 * 1024,
-		.iram_size    = 0x20000,
+		.iram_size    = 0x1f000, /* leave 4k for suspend code */
 	},
 };
 
-- 
2.11.0
