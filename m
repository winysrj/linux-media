Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43611 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2CZNNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:13:50 -0400
Received: by mail-gx0-f174.google.com with SMTP id e5so3751115ggh.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:13:50 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: rsalvaterra@gmail.com, crope@iki.fi, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/5] em28xx: Move ir/rc related initialization to em28xx_ir_init()
Date: Mon, 26 Mar 2012 10:13:32 -0300
Message-Id: <1332767615-24218-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
References: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moving this helps isolating em28xx_input and will help
converting it into a separate module.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |   10 ----------
 drivers/media/video/em28xx/em28xx-i2c.c   |    3 ---
 drivers/media/video/em28xx/em28xx-input.c |   11 +++++++++++
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ce1b60f..ba99e22 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2770,13 +2770,6 @@ void em28xx_card_setup(struct em28xx *dev)
 		break;
 	}
 
-#if defined(CONFIG_MODULES) && defined(MODULE)
-	if (dev->board.has_ir_i2c && !disable_ir)
-		request_module("ir-kbd-i2c");
-#endif
-	if (dev->board.has_snapshot_button)
-		em28xx_register_snapshot_button(dev);
-
 	if (dev->board.valid == EM28XX_BOARD_NOT_VALIDATED) {
 		em28xx_errdev("\n\n");
 		em28xx_errdev("The support for this board weren't "
@@ -2893,9 +2886,6 @@ static void flush_request_modules(struct em28xx *dev)
 */
 void em28xx_release_resources(struct em28xx *dev)
 {
-	if (dev->sbutton_input_dev)
-		em28xx_deregister_snapshot_button(dev);
-
 	if (dev->ir)
 		em28xx_ir_fini(dev);
 
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 36f5a9b..91bf163 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -561,9 +561,6 @@ int em28xx_i2c_register(struct em28xx *dev)
 	if (i2c_scan)
 		em28xx_do_i2c_scan(dev);
 
-	/* Instantiate the IR receiver device, if present */
-	em28xx_register_i2c_ir(dev);
-
 	return 0;
 }
 
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 2630b26..dd6e3f2 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -448,6 +448,15 @@ int em28xx_ir_init(struct em28xx *dev)
 	if (err)
 		goto err_out_stop;
 
+	em28xx_register_i2c_ir(dev);
+
+#if defined(CONFIG_MODULES) && defined(MODULE)
+	if (dev->board.has_ir_i2c)
+		request_module("ir-kbd-i2c");
+#endif
+	if (dev->board.has_snapshot_button)
+		em28xx_register_snapshot_button(dev);
+
 	return 0;
 
  err_out_stop:
@@ -462,6 +471,8 @@ int em28xx_ir_fini(struct em28xx *dev)
 {
 	struct em28xx_IR *ir = dev->ir;
 
+	em28xx_deregister_snapshot_button(dev);
+
 	/* skip detach on non attached boards */
 	if (!ir)
 		return 0;
-- 
1.7.3.4

