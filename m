Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52783 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2LJAqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH RFC 08/11] it913x: remove unused define and increase module version
Date: Mon, 10 Dec 2012 02:45:32 +0200
Message-Id: <1355100335-2123-8-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/it913x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 5dc352b..3d20e38 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -309,7 +309,6 @@ static struct i2c_algorithm it913x_i2c_algo = {
 
 /* Callbacks for DVB USB */
 #if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
-#define IT913X_POLL 250
 static int it913x_rc_query(struct dvb_usb_device *d)
 {
 	u8 ibuf[4];
@@ -801,7 +800,7 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.32");
+MODULE_VERSION("1.33");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_IT9135_V1);
 MODULE_FIRMWARE(FW_IT9135_V2);
-- 
1.7.11.7

