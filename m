Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbcF2XlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:41:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rtl2832: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:40:57 +0300
Message-Id: <1467243657-26426-3-git-send-email-crope@iki.fi>
In-Reply-To: <1467243657-26426-1-git-send-email-crope@iki.fi>
References: <1467243657-26426-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index c16c69e..0ced01f 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1148,6 +1148,7 @@ MODULE_DEVICE_TABLE(i2c, rtl2832_id_table);
 static struct i2c_driver rtl2832_driver = {
 	.driver = {
 		.name	= "rtl2832",
+		.suppress_bind_attrs	= true,
 	},
 	.probe		= rtl2832_probe,
 	.remove		= rtl2832_remove,
-- 
http://palosaari.fi/

