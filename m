Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36384 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbcF2Xie (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:38:34 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] si2168: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:38:18 +0300
Message-Id: <1467243499-26093-2-git-send-email-crope@iki.fi>
In-Reply-To: <1467243499-26093-1-git-send-email-crope@iki.fi>
References: <1467243499-26093-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 124addc..20b4a65 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -745,7 +745,8 @@ MODULE_DEVICE_TABLE(i2c, si2168_id_table);
 
 static struct i2c_driver si2168_driver = {
 	.driver = {
-		.name	= "si2168",
+		.name                = "si2168",
+		.suppress_bind_attrs = true,
 	},
 	.probe		= si2168_probe,
 	.remove		= si2168_remove,
-- 
http://palosaari.fi/

