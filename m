Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34056 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbcBGUOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 15:14:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id p63so12474209wmp.1
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 12:14:24 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/3] media: rc: nuvoton: expose most recent raw packet via
 sysfs
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56B7A596.3050503@gmail.com>
Date: Sun, 7 Feb 2016 21:14:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the recently introduced functionality to expose raw packet data
via sysfs.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c96da3a..4b97a6f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -692,6 +692,7 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 	for (i = 0; i < nvt->pkts; i++) {
 		sample = nvt->buf[i];
+		ir_raw_store_sysfs_lrp(nvt->rdev, sample);
 
 		rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
 		rawir.duration = US_TO_NS((sample & BUF_LEN_MASK)
@@ -1102,6 +1103,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->timeout = MS_TO_NS(100);
 	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
 	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
+	rdev->enable_sysfs_lrp = true;
 #if 0
 	rdev->min_timeout = XYZ;
 	rdev->max_timeout = XYZ;
-- 
2.7.0

