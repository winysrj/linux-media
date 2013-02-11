Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37424 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3BKRxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 12:53:23 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so2959605eaa.9
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 09:53:22 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: remove some obsolete function declarations
Date: Mon, 11 Feb 2013 18:54:01 +0100
Message-Id: <1360605241-3192-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h |    8 --------
 1 Datei geändert, 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7dc27b5..a3c08ae 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -654,11 +654,6 @@ int  em28xx_i2c_register(struct em28xx *dev);
 int  em28xx_i2c_unregister(struct em28xx *dev);
 
 /* Provided by em28xx-core.c */
-
-u32 em28xx_request_buffers(struct em28xx *dev, u32 count);
-void em28xx_queue_unusedframes(struct em28xx *dev);
-void em28xx_release_buffers(struct em28xx *dev);
-
 int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			    char *buf, int len);
 int em28xx_read_reg_req(struct em28xx *dev, u8 req, u16 reg);
@@ -691,7 +686,6 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 					(struct em28xx *dev, struct urb *urb));
 void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
-int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
 void em28xx_wake_i2c(struct em28xx *dev);
@@ -710,10 +704,8 @@ int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
 extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
 
 /* Provided by em28xx-cards.c */
-extern int em2800_variant_detect(struct usb_device *udev, int model);
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
-extern const unsigned int em28xx_bcount;
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
-- 
1.7.10.4

