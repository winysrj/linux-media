Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:36530 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab3ILMZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 08:25:39 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	ismael.luceno@corp.bluecherry.net
Date: Thu, 12 Sep 2013 14:25:36 +0200
MIME-Version: 1.0
Message-ID: <m37gemb51b.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] SOLO6x10: don't do DMA from stack in solo_dma_vin_region().
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
index 32d9953..884512e 100644
--- a/drivers/staging/media/solo6x10/solo6x10-disp.c
+++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
@@ -176,18 +176,26 @@ static void solo_vout_config(struct solo_dev *solo_dev)
 static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 			       u16 val, int reg_size)
 {
-	u16 buf[64];
-	int i;
-	int ret = 0;
+	u16 *buf;
+	const int n = 64, size = n * sizeof(*buf);
+	int i, ret = 0;
+
+	if (!(buf = kmalloc(size, GFP_KERNEL)))
+		return -ENOMEM;
 
-	for (i = 0; i < sizeof(buf) >> 1; i++)
+	for (i = 0; i < n; i++)
 		buf[i] = cpu_to_le16(val);
 
-	for (i = 0; i < reg_size; i += sizeof(buf))
-		ret |= solo_p2m_dma(solo_dev, 1, buf,
-				    SOLO_MOTION_EXT_ADDR(solo_dev) + off + i,
-				    sizeof(buf), 0, 0);
+	for (i = 0; i < reg_size; i += size) {
+		ret = solo_p2m_dma(solo_dev, 1, buf,
+				   SOLO_MOTION_EXT_ADDR(solo_dev) + off + i,
+				   size, 0, 0);
+
+		if (ret)
+			break;
+	}
 
+	kfree(buf);
 	return ret;
 }
 
