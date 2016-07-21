Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbcGUUS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 12/12] [media] v4l2-common.h: document the subdev functions
Date: Thu, 21 Jul 2016 17:18:17 -0300
Message-Id: <5d4cd6a8c87ffd6f2a3700f735873f42464d871f.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some subdev-specific functions at v4l2-common.h
that are mentioned at v4l2-subdev.rst.

Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-subdev.rst |  6 ++++
 include/media/v4l2-common.h              | 49 +++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 80982a9d002f..456fdec69042 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -449,3 +449,9 @@ V4L2 sub-device asynchronous kAPI
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-async.h
+
+
+V4L2 common kAPI
+^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-common.h
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1cc0c5ba16b3..9b1dfcd9e229 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -80,8 +80,6 @@
 
 /* ------------------------------------------------------------------------- */
 
-/* Control helper function */
-
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 
 /* ------------------------------------------------------------------------- */
@@ -96,23 +94,60 @@ struct v4l2_device;
 struct v4l2_subdev;
 struct v4l2_subdev_ops;
 
-
-/* Load an i2c module and return an initialized v4l2_subdev struct.
-   The client_type argument is the name of the chip that's on the adapter. */
+/**
+ * v4l2_i2c_new_subdev - Load an i2c module and return an initialized
+ *	&struct v4l2_subdev.
+ *
+ * @v4l2_dev: pointer to &struct v4l2_device
+ * @adapter: pointer to struct i2c_adapter
+ * @client_type:  name of the chip that's on the adapter.
+ * @addr: I2C address. If zero, it will use @probe_addrs
+ * @probe_addrs: array with a list of address. The last entry at such
+ * 	array should be %I2C_CLIENT_END.
+ *
+ * returns a &struct v4l2_subdev pointer.
+ */
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *client_type,
 		u8 addr, const unsigned short *probe_addrs);
 
 struct i2c_board_info;
 
+/**
+ * v4l2_i2c_new_subdev_board - Load an i2c module and return an initialized
+ *	&struct v4l2_subdev.
+ *
+ * @v4l2_dev: pointer to &struct v4l2_device
+ * @adapter: pointer to struct i2c_adapter
+ * @info: pointer to struct i2c_board_info used to replace the irq,
+ *	 platform_data and addr arguments.
+ * @probe_addrs: array with a list of address. The last entry at such
+ * 	array should be %I2C_CLIENT_END.
+ *
+ * returns a &struct v4l2_subdev pointer.
+ */
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, struct i2c_board_info *info,
 		const unsigned short *probe_addrs);
 
-/* Initialize a v4l2_subdev with data from an i2c_client struct */
+/**
+ * v4l2_i2c_subdev_init - Initializes a &struct v4l2_subdev with data from
+ *	an i2c_client struct.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @client: pointer to struct i2c_client
+ * @ops: pointer to &struct v4l2_subdev_ops
+ */
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops);
-/* Return i2c client address of v4l2_subdev. */
+
+/**
+ * v4l2_i2c_subdev_addr - returns i2c client address of &struct v4l2_subdev.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ *
+ * Returns the address of an I2C sub-device
+ */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
 
 enum v4l2_i2c_tuner_type {
-- 
2.7.4

