Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57702 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3EIMyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:54:20 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ0003P7U99M10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 13:54:18 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 3/3] media: added managed v4l2 subdevice initialization
Date: Thu, 09 May 2013 14:52:44 +0200
Message-id: <1368103965-15232-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1368103965-15232-1-git-send-email-a.hajda@samsung.com>
References: <1368103965-15232-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds managed versions of initialization
functions for v4l2 subdevices.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-common.c |   10 +++++++
 drivers/media/v4l2-core/v4l2-subdev.c |   52 +++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h           |    2 ++
 include/media/v4l2-ctrls.h            |    7 +++--
 include/media/v4l2-subdev.h           |    5 ++++
 5 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 614316f..714d07c 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -302,7 +302,17 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
+int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
+			      const struct v4l2_subdev_ops *ops)
+{
+	int ret;
 
+	ret = devm_v4l2_subdev_bind(&client->dev, sd);
+	if (!ret)
+		v4l2_i2c_subdev_init(sd, client, ops);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_v4l2_i2c_subdev_init);
 
 /* Load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..87ce2f6 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -474,3 +474,55 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 #endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
+
+static void devm_v4l2_subdev_release(struct device *dev, void *res)
+{
+	struct v4l2_subdev **sd = res;
+
+	v4l2_device_unregister_subdev(*sd);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&(*sd)->entity);
+#endif
+}
+
+int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev **dr;
+
+	dr = devres_alloc(devm_v4l2_subdev_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	*dr = sd;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_v4l2_subdev_bind);
+
+int devm_v4l2_subdev_init(struct device *dev, struct v4l2_subdev *sd,
+			  const struct v4l2_subdev_ops *ops)
+{
+	int ret;
+
+	ret = devm_v4l2_subdev_bind(dev, sd);
+	if (!ret)
+		v4l2_subdev_init(sd, ops);
+	return ret;
+}
+EXPORT_SYMBOL(devm_v4l2_subdev_init);
+
+static int devm_v4l2_subdev_match(struct device *dev, void *res,
+					void *data)
+{
+	struct v4l2_subdev **this = res, **sd = data;
+
+	return *this == *sd;
+}
+
+void devm_v4l2_subdev_free(struct device *dev, struct v4l2_subdev *sd)
+{
+	WARN_ON(devres_release(dev, devm_v4l2_subdev_release,
+			       devm_v4l2_subdev_match, &sd));
+}
+EXPORT_SYMBOL_GPL(devm_v4l2_subdev_free);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index ec7c9c0..440d6b7 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -136,6 +136,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 /* Initialize a v4l2_subdev with data from an i2c_client struct */
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops);
+int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
+		const struct v4l2_subdev_ops *ops);
 /* Return i2c client address of v4l2_subdev. */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a1d06db..fe6dcef 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -286,7 +286,10 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
 /*
  * devm_v4l2_ctrl_handler_init - managed control handler initialization
  *
- * @dev: Device for which @hdl belongs to.
+ * @dev: Device the @hdl belongs to.
+ * @hdl:	The control handler.
+ * @nr_of_controls_hint: A hint of how many controls this handler is
+ *		expected to refer to.
  *
  * This is a managed version of v4l2_ctrl_handler_init. Handler initialized with
  * this function will be automatically cleaned up on driver detach.
@@ -301,7 +304,7 @@ int devm_v4l2_ctrl_handler_init(struct device *dev,
 /**
  * devm_v4l2_ctrl_handler_free - managed control handler free
  *
- * @dev: Device for which @hdl belongs to.
+ * @dev: Device the @hdl belongs to.
  * @hdl: Handler to be cleaned up.
  *
  * This function should be used to manual free of an control handler
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b137a5e..0eab5b0 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -673,6 +673,11 @@ int v4l2_subdev_link_validate(struct media_link *link);
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
+int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd);
+int devm_v4l2_subdev_init(struct device *dev, struct v4l2_subdev *sd,
+			  const struct v4l2_subdev_ops *ops);
+void devm_v4l2_subdev_free(struct device *dev, struct v4l2_subdev *sd);
+
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
 
-- 
1.7.10.4

