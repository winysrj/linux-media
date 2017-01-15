Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55847 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbdAOH7g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Jan 2017 02:59:36 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2] [media] coda: add Freescale firmware compatibility location
Date: Sun, 15 Jan 2017 09:59:14 +0200
Message-Id: <5723860e4668aebd07ea61d17b7879bea8b2f230.1484467154.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
by default. Make coda look there for firmware files to ease the update path.

Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: add compatibility path; don't change existing path (Fabio)
---
 drivers/media/platform/coda/coda-common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 9e6bdafa16f5..ce0d00f3f3ba 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2079,6 +2079,7 @@ static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
 		.firmware     = {
 			"vpu_fw_imx27_TO2.bin",
+			"vpu/vpu_fw_imx27_TO2.bin",
 			"v4l-codadx6-imx27.bin"
 		},
 		.product      = CODA_DX6,
@@ -2092,6 +2093,7 @@ static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX53] = {
 		.firmware     = {
 			"vpu_fw_imx53.bin",
+			"vpu/vpu_fw_imx53.bin",
 			"v4l-coda7541-imx53.bin"
 		},
 		.product      = CODA_7541,
@@ -2106,6 +2108,7 @@ static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX6Q] = {
 		.firmware     = {
 			"vpu_fw_imx6q.bin",
+			"vpu/vpu_fw_imx6q.bin",
 			"v4l-coda960-imx6q.bin"
 		},
 		.product      = CODA_960,
@@ -2120,6 +2123,7 @@ static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX6DL] = {
 		.firmware     = {
 			"vpu_fw_imx6d.bin",
+			"vpu/vpu_fw_imx6d.bin",
 			"v4l-coda960-imx6dl.bin"
 		},
 		.product      = CODA_960,
-- 
2.11.0

