Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54635 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbcF2Xki (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:40:38 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] it913x: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:40:23 +0300
Message-Id: <1467243623-26315-3-git-send-email-crope@iki.fi>
In-Reply-To: <1467243623-26315-1-git-send-email-crope@iki.fi>
References: <1467243623-26315-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 5c96da6..6c3ef21 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -464,6 +464,7 @@ MODULE_DEVICE_TABLE(i2c, it913x_id_table);
 static struct i2c_driver it913x_driver = {
 	.driver = {
 		.name	= "it913x",
+		.suppress_bind_attrs	= true,
 	},
 	.probe		= it913x_probe,
 	.remove		= it913x_remove,
-- 
http://palosaari.fi/

