Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32066 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3EPIPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 04:15:08 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMV00189TKYHT40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 May 2013 09:15:01 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
Date: Thu, 16 May 2013 10:14:33 +0200
Message-id: <1368692074-483-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds managed version of initialization
function for v4l2 control handler.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v3:
	- removed managed cleanup
v2:
	- added missing struct device forward declaration,
	- corrected few comments
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ebb8e48..f47ccfa 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
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
 /* For backwards compatibility: V4L2_CID_PRIVATE_BASE should no longer
    be used except in G_CTRL, S_CTRL, QUERYCTRL and QUERYMENU when dealing
    with applications that do not use the NEXT_CTRL flag.
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7343a27..169443f 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -25,6 +25,7 @@
 #include <linux/videodev2.h>
 
 /* forward references */
+struct device;
 struct file;
 struct v4l2_ctrl_handler;
 struct v4l2_ctrl_helper;
@@ -306,6 +307,21 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
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
+ */
+int devm_v4l2_ctrl_handler_init(struct device *dev,
+				struct v4l2_ctrl_handler *hdl,
+				unsigned nr_of_controls_hint);
+
 /** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
   * to the handler to initialize the hardware to the current control values.
   * @hdl:	The control handler.
-- 
1.7.10.4

