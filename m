Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:61583 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaERToy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 May 2014 15:44:54 -0400
Received: by mail-yh0-f46.google.com with SMTP id 29so6127123yhl.33
        for <linux-media@vger.kernel.org>; Sun, 18 May 2014 12:44:53 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: Reduce OSD writes to the minimum necessary
Date: Sun, 18 May 2014 16:44:11 -0300
Message-Id: <1400442251-7548-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/solo6x10-enc.c     | 31 ++++++++++-------------
 drivers/staging/media/solo6x10/solo6x10-offsets.h |  2 ++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-enc.c b/drivers/staging/media/solo6x10/solo6x10-enc.c
index 94d5735..2db53b6 100644
--- a/drivers/staging/media/solo6x10/solo6x10-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-enc.c
@@ -134,51 +134,48 @@ static void solo_capture_config(struct solo_dev *solo_dev)
 	kfree(buf);
 }
 
+#define SOLO_OSD_WRITE_SIZE (16 * OSD_TEXT_MAX)
+
 /* Should be called with enable_lock held */
 int solo_osd_print(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	unsigned char *str = solo_enc->osd_text;
 	u8 *buf = solo_enc->osd_buf;
-	u32 reg = solo_reg_read(solo_dev, SOLO_VE_OSD_CH);
+	u32 reg;
 	const struct font_desc *vga = find_font("VGA8x16");
 	const unsigned char *vga_data;
-	int len;
 	int i, j;
 
 	if (WARN_ON_ONCE(!vga))
 		return -ENODEV;
 
-	len = strlen(str);
-
-	if (len == 0) {
+	reg = solo_reg_read(solo_dev, SOLO_VE_OSD_CH);
+	if (!*str) {
 		/* Disable OSD on this channel */
 		reg &= ~(1 << solo_enc->ch);
-		solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
-		return 0;
+		goto out;
 	}
 
-	memset(buf, 0, SOLO_EOSD_EXT_SIZE_MAX);
+	memset(buf, 0, SOLO_OSD_WRITE_SIZE);
 	vga_data = (const unsigned char *)vga->data;
 
-	for (i = 0; i < len; i++) {
-		unsigned char c = str[i];
-
+	for (i = 0; *str; i++, str++) {
 		for (j = 0; j < 16; j++) {
-			buf[(j * 2) + (i % 2) + (i / 2 * 32)] =
-				bitrev8(vga_data[(c * 16) + j]);
+			buf[(j << 1) | (i & 1) | ((i & ~1) << 4)] =
+			    bitrev8(vga_data[(*str << 4) | j]);
 		}
 	}
 
 	solo_p2m_dma(solo_dev, 1, buf,
-		     SOLO_EOSD_EXT_ADDR +
-		     (solo_enc->ch * SOLO_EOSD_EXT_SIZE(solo_dev)),
-		     SOLO_EOSD_EXT_SIZE(solo_dev), 0, 0);
+		     SOLO_EOSD_EXT_ADDR_CHAN(solo_dev, solo_enc->ch),
+		     SOLO_OSD_WRITE_SIZE, 0, 0);
 
 	/* Enable OSD on this channel */
 	reg |= (1 << solo_enc->ch);
-	solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
 
+out:
+	solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
 	return 0;
 }
 
diff --git a/drivers/staging/media/solo6x10/solo6x10-offsets.h b/drivers/staging/media/solo6x10/solo6x10-offsets.h
index f005dca..13eeb44 100644
--- a/drivers/staging/media/solo6x10/solo6x10-offsets.h
+++ b/drivers/staging/media/solo6x10/solo6x10-offsets.h
@@ -35,6 +35,8 @@
 #define SOLO_EOSD_EXT_SIZE_MAX			0x20000
 #define SOLO_EOSD_EXT_AREA(__solo) \
 	(SOLO_EOSD_EXT_SIZE(__solo) * 32)
+#define SOLO_EOSD_EXT_ADDR_CHAN(__solo, ch) \
+	(SOLO_EOSD_EXT_ADDR + SOLO_EOSD_EXT_SIZE(__solo) * (ch))
 
 #define SOLO_MOTION_EXT_ADDR(__solo) \
 	(SOLO_EOSD_EXT_ADDR + SOLO_EOSD_EXT_AREA(__solo))
-- 
1.9.1

