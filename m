Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54798 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752842AbcL0KGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 05:06:55 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] [media] coda: fix Freescale firmware location
Date: Tue, 27 Dec 2016 12:06:16 +0200
Message-Id: <628638bcda35ffe92f931f67560ed01cba970067.1482833176.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
by default. Make coda conform with that to ease the update path.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/platform/coda/coda-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 9e6bdafa16f5..140c02715855 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2078,7 +2078,7 @@ enum coda_platform {
 static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
 		.firmware     = {
-			"vpu_fw_imx27_TO2.bin",
+			"vpu/vpu_fw_imx27_TO2.bin",
 			"v4l-codadx6-imx27.bin"
 		},
 		.product      = CODA_DX6,
@@ -2091,7 +2091,7 @@ static const struct coda_devtype coda_devdata[] = {
 	},
 	[CODA_IMX53] = {
 		.firmware     = {
-			"vpu_fw_imx53.bin",
+			"vpu/vpu_fw_imx53.bin",
 			"v4l-coda7541-imx53.bin"
 		},
 		.product      = CODA_7541,
@@ -2105,7 +2105,7 @@ static const struct coda_devtype coda_devdata[] = {
 	},
 	[CODA_IMX6Q] = {
 		.firmware     = {
-			"vpu_fw_imx6q.bin",
+			"vpu/vpu_fw_imx6q.bin",
 			"v4l-coda960-imx6q.bin"
 		},
 		.product      = CODA_960,
@@ -2119,7 +2119,7 @@ static const struct coda_devtype coda_devdata[] = {
 	},
 	[CODA_IMX6DL] = {
 		.firmware     = {
-			"vpu_fw_imx6d.bin",
+			"vpu/vpu_fw_imx6d.bin",
 			"v4l-coda960-imx6dl.bin"
 		},
 		.product      = CODA_960,
-- 
2.11.0

