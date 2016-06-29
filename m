Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbcF2Xkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:40:37 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] af9033: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:40:22 +0300
Message-Id: <1467243623-26315-2-git-send-email-crope@iki.fi>
In-Reply-To: <1467243623-26315-1-git-send-email-crope@iki.fi>
References: <1467243623-26315-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 42fbd0f..6c2f9b8 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1373,6 +1373,7 @@ MODULE_DEVICE_TABLE(i2c, af9033_id_table);
 static struct i2c_driver af9033_driver = {
 	.driver = {
 		.name	= "af9033",
+		.suppress_bind_attrs	= true,
 	},
 	.probe		= af9033_probe,
 	.remove		= af9033_remove,
-- 
http://palosaari.fi/

