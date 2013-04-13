Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34515 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3DMJrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 05:47:43 -0400
Received: by mail-ee0-f50.google.com with SMTP id e53so1623665eek.9
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 02:47:42 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/3] em28xx: add helper function for handling the GPIO registers of newer devices
Date: Sat, 13 Apr 2013 11:48:41 +0200
Message-Id: <1365846521-3127-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code provides a helper function em28xx_write_reg_bits() that reads
the current state/value of a GPIO register, modifies only the bits specified
with the value and bitmask parmaters and writes the new value back to the
register.

Newer devices (em25xx, em276x/7x/8x) are using separate registers for reading
and changing the states of the GPIO ports/lines, for which this helper function
cannot be used.

Introduce a new function em28xx_write_regs_bits() that uses two register
parameters reg_r (register for reading the current value) and
reg_w (register for writing the new value).
Make em28xx_write_reg_bits() a wrapper function calling this new function with
the same value for both registers.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   26 +++++++++++++++++++-------
 drivers/media/usb/em28xx/em28xx.h      |    5 +++--
 2 Dateien geändert, 22 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..293dc31 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -205,23 +205,35 @@ int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val)
 EXPORT_SYMBOL_GPL(em28xx_write_reg);
 
 /*
- * em28xx_write_reg_bits()
- * sets only some bits (specified by bitmask) of a register, by first reading
- * the actual value
+ * em28xx_write_regs_bits()
+ * reads value from a register, modifies only the bits specified with the value
+ * and bitmask parameters and writes the new value two a second register.
  */
-int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
-				 u8 bitmask)
+int em28xx_write_regs_bits(struct em28xx *dev, u16 reg_r, u16 reg_w, u8 val,
+			   u8 bitmask)
 {
 	int oldval;
 	u8 newval;
 
-	oldval = em28xx_read_reg(dev, reg);
+	oldval = em28xx_read_reg(dev, reg_r);
 	if (oldval < 0)
 		return oldval;
 
 	newval = (((u8) oldval) & ~bitmask) | (val & bitmask);
 
-	return em28xx_write_regs(dev, reg, &newval, 1);
+	return em28xx_write_regs(dev, reg_w, &newval, 1);
+}
+EXPORT_SYMBOL_GPL(em28xx_write_regs_bits);
+
+/*
+ * em28xx_write_reg_bits()
+ * modifies only the bits specified with the value and bitmask parameters of
+ * a register
+ */
+int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
+				 u8 bitmask)
+{
+	return em28xx_write_regs_bits(dev, reg, reg, val, bitmask);
 }
 EXPORT_SYMBOL_GPL(em28xx_write_reg_bits);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e070de0..a817c3d 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -667,8 +667,9 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			  int len);
 int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len);
 int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val);
-int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
-				 u8 bitmask);
+int em28xx_write_regs_bits(struct em28xx *dev, u16 reg_r, u16 reg_w,
+			   u8 val, u8 bitmask);
+int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val, u8 bitmask);
 
 int em28xx_read_ac97(struct em28xx *dev, u8 reg);
 int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val);
-- 
1.7.10.4

