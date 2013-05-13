Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3EMIfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 04:35:07 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMQ00GKVAHC0O70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 May 2013 09:35:04 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v2 2/3] media: added managed v4l2 control initialization
Date: Mon, 13 May 2013 10:34:45 +0200
Message-id: <1368434086-9027-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1368434086-9027-1-git-send-email-a.hajda@samsung.com>
References: <1368434086-9027-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds managed versions of initialization
and cleanup functions for v4l2 control handler.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
	- added missing struct device forward declaration,
	- corrected few comments
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   48 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |   31 ++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ebb8e48..69c9b95 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1421,6 +1421,54 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_free);
 
+static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
+{
+	struct v4l2_ctrl_handler **hdl = res;
+
+	v4l2_ctrl_handler_free(*hdl);
+}
+
+int devm_v4l2_ctrl_handler_init(struct device *dev,
+				struct v4l2_ctrl_handler *hdl,
+				unsigned nr_of_controls_hint)
+{
+	struct v4l2_ctrl_handler **dr;
+	int rc;
+
+	dr = devres_alloc(devm_v4l2_ctrl_handler_release, sizeof(*dr),
+			  GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = v4l2_ctrl_handler_init(hdl, nr_of_controls_hint);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	*dr = hdl;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_v4l2_ctrl_handler_init);
+
+static int devm_v4l2_ctrl_handler_match(struct device *dev, void *res,
+					void *data)
+{
+	struct v4l2_ctrl_handler **this = res, **hdl = data;
+
+	return *this == *hdl;
+}
+
+void devm_v4l2_ctrl_handler_free(struct device *dev,
+				 struct v4l2_ctrl_handler *hdl)
+{
+	WARN_ON(devres_release(dev, devm_v4l2_ctrl_handler_release,
+			       devm_v4l2_ctrl_handler_match, &hdl));
+}
+EXPORT_SYMBOL_GPL(devm_v4l2_ctrl_handler_free);
+
 /* For backwards compatibility: V4L2_CID_PRIVATE_BASE should no longer
    be used except in G_CTRL, S_CTRL, QUERYCTRL and QUERYMENU when dealing
    with applications that do not use the NEXT_CTRL flag.
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7343a27..1986b90 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -25,6 +25,7 @@
 #include <linux/videodev2.h>
 
 /* forward references */
+struct device;
 struct file;
 struct v4l2_ctrl_handler;
 struct v4l2_ctrl_helper;
@@ -306,6 +307,36 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
   */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
 
+/*
+ * devm_v4l2_ctrl_handler_init - managed control handler initialization
+ *
+ * @dev: Device the @hdl belongs to.
+ * @hdl:	The control handler.
+ * @nr_of_controls_hint: A hint of how many controls this handler is
+ *		expected to refer to.
+ *
+ * This is a managed version of v4l2_ctrl_handler_init. Handler initialized with
+ * this function will be automatically cleaned up on driver detach.
+ *
+ * If an handler initialized with this function needs to be cleaned up
+ * separately, devm_v4l2_ctrl_handler_free() must be used.
+ */
+int devm_v4l2_ctrl_handler_init(struct device *dev,
+				struct v4l2_ctrl_handler *hdl,
+				unsigned nr_of_controls_hint);
+
+/**
+ * devm_v4l2_ctrl_handler_free - managed control handler free
+ *
+ * @dev: Device the @hdl belongs to.
+ * @hdl: Handler to be cleaned up.
+ *
+ * This function should be used to manual free of an control handler
+ * initialized with devm_v4l2_ctrl_handler_init().
+ */
+void devm_v4l2_ctrl_handler_free(struct device *dev,
+				 struct v4l2_ctrl_handler *hdl);
+
 /** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
   * to the handler to initialize the hardware to the current control values.
   * @hdl:	The control handler.
-- 
1.7.10.4

