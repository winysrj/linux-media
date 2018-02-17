Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50407 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeBQPDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 10:03:37 -0500
Received: by mail-wm0-f68.google.com with SMTP id k87so7929474wmi.0
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 07:03:37 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH v2 4/7] [media] ngene: adapt cxd2099 attach to the new i2c_client way
Date: Sat, 17 Feb 2018 16:03:25 +0100
Message-Id: <20180217150328.686-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180217150328.686-1-d.scheller.oss@gmail.com>
References: <20180217150328.686-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Change the way the cxd2099 hardware is being attached to the new I2C
client interface way. Also, add I2C_FUNC_I2C to the I2C interface
functionality.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/pci/ngene/ngene-core.c | 41 ++++++++++++++++++++++++++++++++----
 drivers/media/pci/ngene/ngene-i2c.c  |  2 +-
 drivers/media/pci/ngene/ngene.h      |  1 +
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 8c92cb7f7e72..80db777cb7ec 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1562,9 +1562,8 @@ static int init_channels(struct ngene *dev)
 	return 0;
 }
 
-static struct cxd2099_cfg cxd_cfg = {
+static const struct cxd2099_cfg cxd_cfgtmpl = {
 	.bitrate = 62000,
-	.adr = 0x40,
 	.polarity = 0,
 	.clock_mode = 0,
 };
@@ -1572,18 +1571,52 @@ static struct cxd2099_cfg cxd_cfg = {
 static void cxd_attach(struct ngene *dev)
 {
 	struct ngene_ci *ci = &dev->ci;
+	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
+	struct i2c_client *client;
+	struct i2c_board_info board_info = {
+		.type = "cxd2099",
+		.addr = 0x40,
+		.platform_data = &cxd_cfg,
+	};
+
+	cxd_cfg.en = &ci->en;
+
+	request_module(board_info.type);
+
+	client = i2c_new_device(&dev->channel[0].i2c_adapter, &board_info);
+	if (!client || !client->dev.driver)
+		goto err_ret;
+
+	if (!try_module_get(client->dev.driver->owner))
+		goto err_i2c;
+
+	if (!ci->en)
+		goto err_i2c;
 
-	ci->en = cxd2099_attach(&cxd_cfg, dev, &dev->channel[0].i2c_adapter);
 	ci->dev = dev;
+	dev->channel[0].i2c_client[0] = client;
+	return;
+
+err_i2c:
+	i2c_unregister_device(client);
+err_ret:
+	printk(KERN_ERR DEVICE_NAME ": CXD2099AR attach failed\n");
 	return;
 }
 
 static void cxd_detach(struct ngene *dev)
 {
 	struct ngene_ci *ci = &dev->ci;
+	struct i2c_client *client;
 
 	dvb_ca_en50221_release(ci->en);
-	kfree(ci->en);
+
+	client = dev->channel[0].i2c_client[0];
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	ci->en = NULL;
 }
 
diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index 3004947f300b..092d46c2a3a9 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -147,7 +147,7 @@ static int ngene_i2c_master_xfer(struct i2c_adapter *adapter,
 
 static u32 ngene_i2c_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm ngene_i2c_algo = {
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 02dbd18f92d0..caf8602c7459 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -630,6 +630,7 @@ struct ngene_vopen {
 struct ngene_channel {
 	struct device         device;
 	struct i2c_adapter    i2c_adapter;
+	struct i2c_client    *i2c_client[1];
 
 	struct ngene         *dev;
 	int                   number;
-- 
2.13.6
