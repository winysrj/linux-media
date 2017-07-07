Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59131 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdGGJ6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:58:55 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/5] [media] coda: mark CODA960 firmware versions 2.3.10 and 3.1.1 as supported
Date: Fri,  7 Jul 2017 11:58:31 +0200
Message-Id: <20170707095831.9852-5-p.zabel@pengutronix.de>
In-Reply-To: <20170707095831.9852-1-p.zabel@pengutronix.de>
References: <20170707095831.9852-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware versions 2.3.10 revision 40778 and 3.1.1 revision 46072 are
contained in the i.MX firmware download archives provided by NXP at
http://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.5.7-1.0.0.bin
and http://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-5.4.bin,
respectively.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2a8e13c53f2e1..95e4b74d5dd01 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -703,6 +703,8 @@ static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
 	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
+	CODA_FIRMWARE_VERNUM(CODA_960, 2, 3, 10),
+	CODA_FIRMWARE_VERNUM(CODA_960, 3, 1, 1),
 };
 
 static bool coda_firmware_supported(u32 vernum)
-- 
2.11.0
