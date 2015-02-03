Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965956AbbBCSlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 13:41:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] [media] rtl2830: declare functions as static
Date: Tue,  3 Feb 2015 16:40:49 -0200
Message-Id: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/rtl2830.c:21:5: warning: no previous prototype for ‘rtl2830_bulk_write’ [-Wmissing-prototypes]
 int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
     ^
drivers/media/dvb-frontends/rtl2830.c:33:5: warning: no previous prototype for ‘rtl2830_update_bits’ [-Wmissing-prototypes]
 int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
     ^
drivers/media/dvb-frontends/rtl2830.c:45:5: warning: no previous prototype for ‘rtl2830_bulk_read’ [-Wmissing-prototypes]
 int rtl2830_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
     ^

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index a90f155daadf..e1b8df62bd59 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -18,8 +18,8 @@
 #include "rtl2830_priv.h"
 
 /* Our regmap is bypassing I2C adapter lock, thus we do it! */
-int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
-		       const void *val, size_t val_count)
+static int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
+			      const void *val, size_t val_count)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
@@ -30,8 +30,8 @@ int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
 	return ret;
 }
 
-int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
-			unsigned int mask, unsigned int val)
+static int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
+			       unsigned int mask, unsigned int val)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
@@ -42,8 +42,8 @@ int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
 	return ret;
 }
 
-int rtl2830_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
-		      size_t val_count)
+static int rtl2830_bulk_read(struct i2c_client *client, unsigned int reg,
+			     void *val, size_t val_count)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
-- 
2.1.0

