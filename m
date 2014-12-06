Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43452 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaLFVfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/22] si2157: trivial ID table changes
Date: Sat,  6 Dec 2014 23:34:52 +0200
Message-Id: <1417901696-5517-18-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Rename ID table.
- Remove magic numbers from ID table driver data field.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 6174c8e..211d500 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -383,12 +383,12 @@ static int si2157_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct i2c_device_id si2157_id[] = {
-	{"si2157", 0},
-	{"si2146", 1},
+static const struct i2c_device_id si2157_id_table[] = {
+	{"si2157", SI2157_CHIPTYPE_SI2157},
+	{"si2146", SI2157_CHIPTYPE_SI2146},
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, si2157_id);
+MODULE_DEVICE_TABLE(i2c, si2157_id_table);
 
 static struct i2c_driver si2157_driver = {
 	.driver = {
@@ -397,7 +397,7 @@ static struct i2c_driver si2157_driver = {
 	},
 	.probe		= si2157_probe,
 	.remove		= si2157_remove,
-	.id_table	= si2157_id,
+	.id_table	= si2157_id_table,
 };
 
 module_i2c_driver(si2157_driver);
-- 
http://palosaari.fi/

