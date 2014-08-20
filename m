Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1475 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaHTW7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/29] solo6x10: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:01 +0200
Message-Id: <1408575568-20562-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/solo6x10/solo6x10-disp.c:184:24: warning: incorrect type in assignment (different base types)
drivers/media/pci/solo6x10/solo6x10-disp.c:223:32: warning: incorrect type in assignment (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/solo6x10/solo6x10-disp.c   | 4 ++--
 drivers/media/pci/solo6x10/solo6x10-eeprom.c | 8 ++++----
 drivers/media/pci/solo6x10/solo6x10.h        | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
index 5ea9cac..11c98f0 100644
--- a/drivers/media/pci/solo6x10/solo6x10-disp.c
+++ b/drivers/media/pci/solo6x10/solo6x10-disp.c
@@ -172,7 +172,7 @@ static void solo_vout_config(struct solo_dev *solo_dev)
 static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 			       u16 val, int reg_size)
 {
-	u16 *buf;
+	__le16 *buf;
 	const int n = 64, size = n * sizeof(*buf);
 	int i, ret = 0;
 
@@ -211,7 +211,7 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 {
 	const unsigned size = sizeof(u16) * 64;
 	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
-	u16 *buf;
+	__le16 *buf;
 	int x, y;
 	int ret = 0;
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-eeprom.c b/drivers/media/pci/solo6x10/solo6x10-eeprom.c
index af40b3a..da25ce4 100644
--- a/drivers/media/pci/solo6x10/solo6x10-eeprom.c
+++ b/drivers/media/pci/solo6x10/solo6x10-eeprom.c
@@ -100,7 +100,7 @@ unsigned int solo_eeprom_ewen(struct solo_dev *solo_dev, int w_en)
 	return retval;
 }
 
-unsigned short solo_eeprom_read(struct solo_dev *solo_dev, int loc)
+__be16 solo_eeprom_read(struct solo_dev *solo_dev, int loc)
 {
 	int read_cmd = loc | (EE_READ_CMD << ADDR_LEN);
 	unsigned short retval = 0;
@@ -117,11 +117,11 @@ unsigned short solo_eeprom_read(struct solo_dev *solo_dev, int loc)
 
 	solo_eeprom_reg_write(solo_dev, ~EE_CS);
 
-	return retval;
+	return (__force __be16)retval;
 }
 
 int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
-		      unsigned short data)
+		      __be16 data)
 {
 	int write_cmd = loc | (EE_WRITE_CMD << ADDR_LEN);
 	unsigned int retval;
@@ -130,7 +130,7 @@ int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
 	solo_eeprom_cmd(solo_dev, write_cmd);
 
 	for (i = 15; i >= 0; i--) {
-		unsigned int dataval = (data >> i) & 1;
+		unsigned int dataval = ((__force unsigned)data >> i) & 1;
 
 		solo_eeprom_reg_write(solo_dev, EE_ENB);
 		solo_eeprom_reg_write(solo_dev,
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index c6154b0..72017b7 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -394,9 +394,9 @@ int solo_osd_print(struct solo_enc_dev *solo_enc);
 
 /* EEPROM commands */
 unsigned int solo_eeprom_ewen(struct solo_dev *solo_dev, int w_en);
-unsigned short solo_eeprom_read(struct solo_dev *solo_dev, int loc);
+__be16 solo_eeprom_read(struct solo_dev *solo_dev, int loc);
 int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
-		      unsigned short data);
+		      __be16 data);
 
 /* JPEG Qp functions */
 void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
-- 
2.1.0.rc1

