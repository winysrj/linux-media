Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24030 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSOLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 10:11:13 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MON0071O8QDFEE0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Jun 2013 15:11:10 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: laurent.pinchart@ideasonboard.com
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: [PATCH RFC v4] media: added managed v4l2/i2c subdevice initialization
Date: Wed, 19 Jun 2013 16:10:54 +0200
Message-id: <1371651054-28684-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <4084534.7DE24ipEqE@avalon>
References: <4084534.7DE24ipEqE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds managed version of initialization
function for v4l2 i2c subdevices.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v4:
	- added description to devm_v4l2_subdev_bind
v3:
	- removed devm_v4l2_subdev_(init|free),
v2:
	- changes of v4l2-ctrls.h moved to proper patch
---
 drivers/media/v4l2-core/v4l2-common.c | 10 ++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h           |  2 ++
 include/media/v4l2-subdev.h           |  2 ++
 4 files changed, 49 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 3fed63f..96aac931 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -301,7 +301,17 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
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
index 996c248..2242962 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -474,3 +474,38 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
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
+/**
+ * devm_v4l2_subdev_bind - Add subdevice to device managed resource list
+ * @dev: Device to bind subdev to
+ * @sd:  Subdevice to bind
+ *
+ * Function adds device managed release code to the subdev.
+ * If the function succeedes then on driver detach subdev will be automatically
+ * unregistered and the media entity will be cleaned up. Function can be used
+ * with subdevs not initialized by devm_v4l2_i2c_subdev_init.
+ */
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
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1d93c48..da62e2b 100644
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
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5298d67..e086cfe 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -657,6 +657,8 @@ int v4l2_subdev_link_validate(struct media_link *link);
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
+int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd);
+
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
 
-- 
1.8.1.2

