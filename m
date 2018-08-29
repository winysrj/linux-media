Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52060 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727099AbeH2Osy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:48:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/3] =?UTF-8?q?v4l:=20subdev:=20Add=20a=20function=20to=20?= =?UTF-8?q?set=20an=20I=C2=B2C=20sub-device's=20name?=
Date: Wed, 29 Aug 2018 13:52:31 +0300
Message-Id: <20180829105233.3852-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_i2c_subdev_set_name() can be used to assign a name to a sub-device.
This way uniform names can be formed easily without having to resort to
things such as snprintf in drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 18 ++++++++++++++----
 include/media/v4l2-common.h           | 12 ++++++++++++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index b518b92d6d96..9c48b90b4ae8 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -109,6 +109,19 @@ EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 
 #if IS_ENABLED(CONFIG_I2C)
 
+void v4l2_i2c_subdev_set_name(struct v4l2_subdev *sd, struct i2c_client *client,
+			      const char *devname, const char *postfix)
+{
+	if (!devname)
+		devname = client->dev.driver->name;
+	if (!postfix)
+		postfix = "";
+
+	snprintf(sd->name, sizeof(sd->name), "%s%s %d-%04x", devname, postfix,
+		 i2c_adapter_id(client->adapter), client->addr);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_set_name);
+
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops)
 {
@@ -120,10 +133,7 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 	/* i2c_client and v4l2_subdev point to one another */
 	v4l2_set_subdevdata(sd, client);
 	i2c_set_clientdata(client, sd);
-	/* initialize name */
-	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
-		client->dev.driver->name, i2c_adapter_id(client->adapter),
-		client->addr);
+	v4l2_i2c_subdev_set_name(sd, client, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index cdc87ec61e54..bd880a909ecf 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -155,6 +155,18 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		const unsigned short *probe_addrs);
 
 /**
+ * v4l2_i2c_subdev_set_name - Set name for an I²C sub-device
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @client: pointer to struct i2c_client
+ * @devname: the name of the device; if NULL, the I²C device's name will be used
+ * @postfix: sub-device specific string to put right after the I²C device name;
+ *	     may be NULL
+ */
+void v4l2_i2c_subdev_set_name(struct v4l2_subdev *sd, struct i2c_client *client,
+			      const char *devname, const char *postfix);
+
+/**
  * v4l2_i2c_subdev_init - Initializes a &struct v4l2_subdev with data from
  *	an i2c_client struct.
  *
-- 
2.11.0
