Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34132 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLWWBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 17:01:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 58/66] rtl2832: remove internal mux I2C adapter
Date: Tue, 23 Dec 2014 22:49:51 +0200
Message-Id: <1419367799-14263-58-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was 2 muxed I2C adapters, one for demod tuner bus and one for
internal use. Idea of internal I2C adapter was to force I2C repeater
close when demod access its registers. Driver has also delayed work
queue based method to close I2C repeater.

After regmap conversion internal I2C adapter based repeater close
left unused - only work queue method was in use. We could not use
internal mux adapter method with regmap as it makes recursive regmap
call, which causes deadlock as regmap has own locking. Due to that
remove whole method totally.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 24 ++++--------------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 -
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index e620a61..6de4f2f 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -868,15 +868,10 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	cancel_delayed_work(&dev->i2c_gate_work);
 
 	/*
-	 * chan_id 1 is muxed adapter demod provides and chan_id 0 is demod
-	 * itself. We need open gate when request is for chan_id 1. On that case
 	 * I2C adapter lock is already taken and due to that we will use
 	 * regmap_update_bits() which does not lock again I2C adapter.
 	 */
-	if (chan_id == 1)
-		ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x08);
-	else
-		ret = rtl2832_update_bits(dev->client, 0x101, 0x08, 0x00);
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x08);
 	if (ret)
 		goto err;
 
@@ -1229,25 +1224,18 @@ static int rtl2832_probe(struct i2c_client *client,
 		ret = PTR_ERR(dev->regmap);
 		goto err_kfree;
 	}
-	/* create muxed i2c adapter for demod itself */
-	dev->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, dev, 0, 0, 0,
-			rtl2832_select, NULL);
-	if (dev->i2c_adapter == NULL) {
-		ret = -ENODEV;
-		goto err_regmap_exit;
-	}
 
 	/* check if the demod is there */
 	ret = rtl2832_bulk_read(client, 0x000, &tmp, 1);
 	if (ret)
-		goto err_i2c_del_mux_adapter;
+		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for demod tuner bus */
 	dev->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, dev,
-			0, 1, 0, rtl2832_select, rtl2832_deselect);
+			0, 0, 0, rtl2832_select, rtl2832_deselect);
 	if (dev->i2c_adapter_tuner == NULL) {
 		ret = -ENODEV;
-		goto err_i2c_del_mux_adapter;
+		goto err_regmap_exit;
 	}
 
 	/* create dvb_frontend */
@@ -1266,8 +1254,6 @@ static int rtl2832_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
-err_i2c_del_mux_adapter:
-	i2c_del_mux_adapter(dev->i2c_adapter);
 err_regmap_exit:
 	regmap_exit(dev->regmap);
 err_kfree:
@@ -1287,8 +1273,6 @@ static int rtl2832_remove(struct i2c_client *client)
 
 	i2c_del_mux_adapter(dev->i2c_adapter_tuner);
 
-	i2c_del_mux_adapter(dev->i2c_adapter);
-
 	regmap_exit(dev->regmap);
 
 	kfree(dev);
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index e25d748..9ff4f65 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -34,7 +34,6 @@ struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
 	struct i2c_client *client;
 	struct regmap *regmap;
-	struct i2c_adapter *i2c_adapter;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
 	struct delayed_work stat_work;
-- 
http://palosaari.fi/

