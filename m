Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35982 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbcARMW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:22:56 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so11681636pfn.3
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:22:56 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>
Subject: [PATCH 05/13] atmel-isi: add a function: isi_hw_wait_status() to check ISI_SR status
Date: Mon, 18 Jan 2016 20:21:41 +0800
Message-Id: <1453119709-20940-6-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

Extract the code that check ISI_SR flag into a function:
isi_hw_wait_status().

In this patch, we use isi_hw_wait_status() to check CDC pending status.

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 28 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 4bd8258..f0508ea 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -190,6 +190,21 @@ static void configure_geometry(struct atmel_isi *isi, u32 width,
 	return;
 }
 
+static int isi_hw_wait_status(struct atmel_isi *isi, int status_flag,
+			       int wait_ms)
+{
+	unsigned long timeout = jiffies + wait_ms * HZ;
+
+	while ((isi_readl(isi, ISI_STATUS) & status_flag) &&
+			time_before(jiffies, timeout))
+		msleep(1);
+
+	if (time_after(jiffies, timeout))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static void isi_hw_initialize(struct atmel_isi *isi)
 {
 	u32 common_flags = isi->bus_param;
@@ -511,7 +526,6 @@ static void stop_streaming(struct vb2_queue *vq)
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf, *node;
 	int ret = 0;
-	unsigned long timeout;
 
 	spin_lock_irq(&isi->lock);
 	isi->active = NULL;
@@ -523,15 +537,11 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irq(&isi->lock);
 
 	if (!isi->enable_preview_path) {
-		timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
 		/* Wait until the end of the current frame. */
-		while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
-				time_before(jiffies, timeout))
-			msleep(1);
-
-		if (time_after(jiffies, timeout))
-			dev_err(icd->parent,
-				"Timeout waiting for finishing codec request\n");
+		ret = isi_hw_wait_status(isi, ISI_CTRL_CDC,
+					 FRAME_INTERVAL_MILLI_SEC);
+		if (ret)
+			dev_err(icd->parent, "Timeout waiting for finishing codec request\n");
 	}
 
 	/* Disable interrupts */
-- 
1.9.1

