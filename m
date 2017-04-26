Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34764 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932322AbdDZQnK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 12:43:10 -0400
Received: by mail-wm0-f68.google.com with SMTP id z129so2625865wmb.1
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 09:43:09 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: fix+improve the register (usb control message) debugging
Date: Wed, 26 Apr 2017 18:43:12 +0200
Message-Id: <20170426164312.3906-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- avoid duplicate debugging messages in em28xx_read_reg_req_len()
- do not describe successful usb transfers in em28xx_read_reg_len()
  as "failed"
- report errors in em28xx_write_regs_req(), too
- print the usb error numbers, too

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 35 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 19ccff41c7eb..76d3c2a5f9e4 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -91,22 +91,16 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	if (len > URB_MAX_CTRL_SIZE)
 		return -EINVAL;
 
-	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
-		     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		     req, 0, 0,
-		     reg & 0xff, reg >> 8,
-		     len & 0xff, len >> 8);
-
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
-		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed\n",
+		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed with error %i\n",
 			     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			     req, 0, 0,
 			     reg & 0xff, reg >> 8,
-			     len & 0xff, len >> 8);
+			     len & 0xff, len >> 8, ret);
 		mutex_unlock(&dev->ctrl_urb_lock);
 		return usb_translate_errors(ret);
 	}
@@ -116,7 +110,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 
 	mutex_unlock(&dev->ctrl_urb_lock);
 
-	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed <<< %*ph\n",
+	em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x <<< %*ph\n",
 		     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		     req, 0, 0,
 		     reg & 0xff, reg >> 8,
@@ -164,13 +158,6 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	if ((len < 1) || (len > URB_MAX_CTRL_SIZE))
 		return -EINVAL;
 
-	em28xx_regdbg("(pipe 0x%08x): OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>> %*ph\n",
-		      pipe,
-		      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		      req, 0, 0,
-		      reg & 0xff, reg >> 8,
-		      len & 0xff, len >> 8, len, buf);
-
 	mutex_lock(&dev->ctrl_urb_lock);
 	memcpy(dev->urb_buf, buf, len);
 	ret = usb_control_msg(udev, pipe, req,
@@ -178,8 +165,22 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
-	if (ret < 0)
+	if (ret < 0) {
+		em28xx_regdbg("(pipe 0x%08x): OUT:  %02x %02x %02x %02x %02x %02x %02x %02x >>> %*ph  failed with error %i\n",
+			      pipe,
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      req, 0, 0,
+			      reg & 0xff, reg >> 8,
+			      len & 0xff, len >> 8, len, buf, ret);
 		return usb_translate_errors(ret);
+	}
+
+	em28xx_regdbg("(pipe 0x%08x): OUT:  %02x %02x %02x %02x %02x %02x %02x %02x >>> %*ph\n",
+		      pipe,
+		      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		      req, 0, 0,
+		      reg & 0xff, reg >> 8,
+		      len & 0xff, len >> 8, len, buf);
 
 	if (dev->wait_after_write)
 		msleep(dev->wait_after_write);
-- 
2.12.2
