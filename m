Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbbBCSlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 13:41:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] [media] rtl2832: declare functions as static
Date: Tue,  3 Feb 2015 16:40:50 -0200
Message-Id: <bda977b7318a4ec10648fe5f80b6ecb42edea7bb.1422988845.git.mchehab@osg.samsung.com>
In-Reply-To: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
References: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
In-Reply-To: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
References: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/rtl2832.c:157:5: warning: no previous prototype for ‘rtl2832_bulk_write’ [-Wmissing-prototypes]
 int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
     ^
drivers/media/dvb-frontends/rtl2832.c:169:5: warning: no previous prototype for ‘rtl2832_update_bits’ [-Wmissing-prototypes]
 int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
     ^
drivers/media/dvb-frontends/rtl2832.c:181:5: warning: no previous prototype for ‘rtl2832_bulk_read’ [-Wmissing-prototypes]
 int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg, void *val,

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 0f2a743bb195..5d2d8f45b4b6 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -154,8 +154,8 @@ static const struct rtl2832_reg_entry registers[] = {
 };
 
 /* Our regmap is bypassing I2C adapter lock, thus we do it! */
-int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
-		       const void *val, size_t val_count)
+static int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
+			      const void *val, size_t val_count)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
@@ -166,8 +166,8 @@ int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
 	return ret;
 }
 
-int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
-			unsigned int mask, unsigned int val)
+static int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
+			       unsigned int mask, unsigned int val)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
@@ -178,8 +178,8 @@ int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
 	return ret;
 }
 
-int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
-		      size_t val_count)
+static int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg,
+			     void *val, size_t val_count)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
-- 
2.1.0

