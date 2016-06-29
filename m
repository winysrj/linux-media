Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45029 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbcF2Xid (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:38:33 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] si2157: do not allow driver unbind
Date: Thu, 30 Jun 2016 02:38:19 +0300
Message-Id: <1467243499-26093-3-git-send-email-crope@iki.fi>
In-Reply-To: <1467243499-26093-1-git-send-email-crope@iki.fi>
References: <1467243499-26093-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable runtime unbind as driver does not support it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index b07a681..57b2508 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -514,7 +514,8 @@ MODULE_DEVICE_TABLE(i2c, si2157_id_table);
 
 static struct i2c_driver si2157_driver = {
 	.driver = {
-		.name	= "si2157",
+		.name	             = "si2157",
+		.suppress_bind_attrs = true,
 	},
 	.probe		= si2157_probe,
 	.remove		= si2157_remove,
-- 
http://palosaari.fi/

