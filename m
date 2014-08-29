Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37357 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaH2N21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 09:28:27 -0400
Received: by mail-wg0-f47.google.com with SMTP id z12so2112338wgg.6
        for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 06:28:26 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org
Cc: lars@metafoo.de, w.sang@pengutronix.de, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH 1/2] Allow DT parsing of secondary devices
Date: Fri, 29 Aug 2014 15:28:16 +0200
Message-Id: <1409318897-12668-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is based on reg and reg-names in DT.
Example:

reg = <0x10 0x20 0x30>;
reg-names = "main", "io", "test";

This function will create dummy devices io and test
with addresses 0x20 and 0x30 respectively.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/i2c/i2c-core.c | 20 ++++++++++++++++++++
 include/linux/i2c.h    |  6 ++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a..5eb414d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -798,6 +798,26 @@ struct i2c_client *i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
 }
 EXPORT_SYMBOL_GPL(i2c_new_dummy);
 
+struct i2c_client *i2c_new_secondary_device(struct i2c_client *client,
+						const char *name,
+						u32 default_addr)
+{
+	int i, addr;
+	struct device_node *np;
+
+	np = client->dev.of_node;
+	i = of_property_match_string(np, "reg-names", name);
+	if (i >= 0)
+		of_property_read_u32_index(np, "reg", i, &addr);
+	else
+		addr = default_addr;
+
+	dev_dbg(&client->adapter->dev, "Address for %s : 0x%x\n", name, addr);
+	return i2c_new_dummy(client->adapter, addr);
+}
+EXPORT_SYMBOL_GPL(i2c_new_secondary_device);
+
+
 /* ------------------------------------------------------------------------- */
 
 /* I2C bus adapters -- one roots each I2C or SMBUS segment */
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a95efeb..2d143d7 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -322,6 +322,12 @@ extern int i2c_probe_func_quick_read(struct i2c_adapter *, unsigned short addr);
 extern struct i2c_client *
 i2c_new_dummy(struct i2c_adapter *adap, u16 address);
 
+/* Use reg/reg-names in DT in order to get extra addresses */
+extern struct i2c_client *
+i2c_new_secondary_device(struct i2c_client *client,
+				const char *name,
+				u32 default_addr);
+
 extern void i2c_unregister_device(struct i2c_client *);
 #endif /* I2C */
 
-- 
2.0.4

