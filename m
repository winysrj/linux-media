Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40008 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbcF2XlJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:41:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rtl2830: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:40:55 +0300
Message-Id: <1467243657-26426-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index d25d1e0..ec1e94a 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -922,7 +922,8 @@ MODULE_DEVICE_TABLE(i2c, rtl2830_id_table);
 
 static struct i2c_driver rtl2830_driver = {
 	.driver = {
-		.name	= "rtl2830",
+		.name			= "rtl2830",
+		.suppress_bind_attrs	= true,
 	},
 	.probe		= rtl2830_probe,
 	.remove		= rtl2830_remove,
-- 
http://palosaari.fi/

