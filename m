Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51927 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbeF2MrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:47:23 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH] media: coda: mark CODA960 firmware version 2.1.9 as supported
Date: Fri, 29 Jun 2018 14:47:20 +0200
Message-Id: <20180629124720.15653-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the i.MX6 CODA960 firmware versions 2.1.9
(revision 32515) to the list of supported firmware versions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 5d575da3efad..d9432e07aa48 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -722,6 +722,7 @@ static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_HX4, 1, 4, 50),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
 	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
+	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 9),
 	CODA_FIRMWARE_VERNUM(CODA_960, 2, 3, 10),
 	CODA_FIRMWARE_VERNUM(CODA_960, 3, 1, 1),
 };
-- 
2.17.1
