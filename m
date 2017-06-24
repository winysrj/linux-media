Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36149
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751482AbdFXSu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 14:50:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH] media: Replace initalized ->initialized
Date: Sat, 24 Jun 2017 15:49:38 -0300
Message-Id: <1250a85b1b5c6b40c2ae32cd61a7029094530d31.1498330061.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While committing a change on em28xx, I got a warning of a
typo there. So, fix it on em28xx and on two other media drivers
with the same typo.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h | 2 +-
 drivers/media/usb/au0828/au0828-input.c           | 2 +-
 drivers/media/usb/em28xx/em28xx-input.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 4442e478db72..0bba34d493dc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -307,7 +307,7 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 * \def DRX_UNKNOWN
 * \brief Generic UNKNOWN value for DRX enumerated types.
 *
-* Used to indicate that the parameter value is unknown or not yet initalized.
+* Used to indicate that the parameter value is unknown or not yet initialized.
 */
 #ifndef DRX_UNKNOWN
 #define DRX_UNKNOWN (254)
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 9ec919c68482..9d82ec0a4b64 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -351,7 +351,7 @@ int au0828_rc_register(struct au0828_dev *dev)
 	if (err)
 		goto error;
 
-	pr_info("Remote controller %s initalized\n", ir->name);
+	pr_info("Remote controller %s initialized\n", ir->name);
 
 	return 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index eba75736e654..ca9673917ad5 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -821,7 +821,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	if (err)
 		goto error;
 
-	dev_info(&dev->intf->dev, "Input extension successfully initalized\n");
+	dev_info(&dev->intf->dev, "Input extension successfully initialized\n");
 
 	return 0;
 
-- 
2.9.4
