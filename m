Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:19675 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762765AbdEZIWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 04:22:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: chiranjeevi.rapolu@intel.com
Subject: [PATCH 1/1] v4l2-ctrls.c: Implement unlocked variant of v4l2_ctrl_handler_setup()
Date: Fri, 26 May 2017 11:21:37 +0300
Message-Id: <1495786897-29085-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes the caller is already holding the control handler mutex and
using it to serialise something. Provide an unlocked variant of the same
function to be used in those cases.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 21 +++++++++++++++++++--
 include/media/v4l2-ctrls.h           | 13 +++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ec42872..dec55d5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2444,14 +2444,16 @@ int v4l2_ctrl_subdev_log_status(struct v4l2_subdev *sd)
 EXPORT_SYMBOL(v4l2_ctrl_subdev_log_status);
 
 /* Call s_ctrl for all controls owned by the handler */
-int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
+int __v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 {
 	struct v4l2_ctrl *ctrl;
 	int ret = 0;
 
 	if (hdl == NULL)
 		return 0;
-	mutex_lock(hdl->lock);
+
+	lockdep_assert_held(hdl->lock);
+
 	list_for_each_entry(ctrl, &hdl->ctrls, node)
 		ctrl->done = false;
 
@@ -2476,7 +2478,22 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		if (ret)
 			break;
 	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__v4l2_ctrl_handler_setup);
+
+int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
+{
+	int ret;
+
+	if (hdl == NULL)
+		return 0;
+
+	mutex_lock(hdl->lock);
+	ret = __v4l2_ctrl_handler_setup(hdl);
 	mutex_unlock(hdl->lock);
+
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index bee1404..2d2aed5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -458,6 +458,19 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 }
 
 /**
+ * __v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
+ * to the handler to initialize the hardware to the current control values. The
+ * caller is responsible for acquiring the control handler mutex on behalf of
+ * __v4l2_ctrl_handler_setup().
+ * @hdl:	The control handler.
+ *
+ * Button controls will be skipped, as are read-only controls.
+ *
+ * If @hdl == NULL, then this just returns 0.
+ */
+int __v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl);
+
+/**
  * v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
  * to the handler to initialize the hardware to the current control values.
  * @hdl:	The control handler.
-- 
2.7.4
