Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43611 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2CZNNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:13:48 -0400
Received: by gghe5 with SMTP id e5so3751115ggh.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:13:47 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: rsalvaterra@gmail.com, crope@iki.fi, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 1/5] em28xx: Export em28xx_[read,write]_reg functions as SYMBOL_GPL
Date: Mon, 26 Mar 2012 10:13:31 -0300
Message-Id: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 53a9fb9..237d44f 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -139,6 +139,7 @@ int em28xx_read_reg(struct em28xx *dev, u16 reg)
 {
 	return em28xx_read_reg_req(dev, USB_REQ_GET_STATUS, reg);
 }
+EXPORT_SYMBOL_GPL(em28xx_read_reg);
 
 /*
  * em28xx_write_regs_req()
@@ -205,6 +206,7 @@ int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(em28xx_write_regs);
 
 /* Write a single register */
 int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val)
@@ -239,6 +241,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 
 	return em28xx_write_regs(dev, reg, &newval, 1);
 }
+EXPORT_SYMBOL_GPL(em28xx_write_reg_bits);
 
 /*
  * em28xx_is_ac97_ready()
-- 
1.7.3.4

