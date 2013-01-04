Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3ADVQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] em28xx: initialize button/I2C IR earlier
Date: Fri,  4 Jan 2013 19:15:49 -0200
Message-Id: <1357334152-3811-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx-input is used by 3 different types of input devices:
	- devices with buttons (like cameras and grabber devices);
	- devices with I2C remotes;
	- em2860 or latter chips with RC support embedded.
When the device has an I2C remote, all it needs to do is to call
the proper I2C driver (ir-i2c-kbd), passing the proper data to
it, and just leave the code.
Also, button devices have its own init code that doesn't depend on
having an IR or not (as a general rule, they don't have).
So, move its init code to fix bugs introduced by earlier patches
that prevent them to work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 3598221..2a1b3d2 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -590,6 +590,17 @@ static int em28xx_ir_init(struct em28xx *dev)
 	int err = -ENOMEM;
 	u64 rc_type;
 
+	if (dev->board.has_snapshot_button)
+		em28xx_register_snapshot_button(dev);
+
+	if (dev->board.has_ir_i2c) {
+		em28xx_register_i2c_ir(dev);
+#if defined(CONFIG_MODULES) && defined(MODULE)
+		request_module("ir-kbd-i2c");
+#endif
+		return 0;
+	}
+
 	if (dev->board.ir_codes == NULL) {
 		/* No remote control support */
 		em28xx_warn("Remote control support is not available for "
@@ -663,15 +674,6 @@ static int em28xx_ir_init(struct em28xx *dev)
 	if (err)
 		goto error;
 
-	em28xx_register_i2c_ir(dev);
-
-#if defined(CONFIG_MODULES) && defined(MODULE)
-	if (dev->board.has_ir_i2c)
-		request_module("ir-kbd-i2c");
-#endif
-	if (dev->board.has_snapshot_button)
-		em28xx_register_snapshot_button(dev);
-
 	return 0;
 
 error:
-- 
1.7.11.7

