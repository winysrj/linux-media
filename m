Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:32682 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 18/35] v4l: Allow changing control handler lock
Date: Tue,  6 Mar 2012 18:32:59 +0200
Message-Id: <1331051596-8261-18-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow choosing the lock used by the control handler. This may be handy
sometimes when a driver providing multiple subdevs does not want to use
several locks to serialise its functions.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/adp1653.c    |    8 +++---
 drivers/media/video/v4l2-ctrls.c |   39 +++++++++++++++++++------------------
 drivers/media/video/vivi.c       |    4 +-
 include/media/v4l2-ctrls.h       |    9 +++++--
 4 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 12eedf4..becaba4 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -283,19 +283,19 @@ adp1653_init_device(struct adp1653_flash *flash)
 		return -EIO;
 	}
 
-	mutex_lock(&flash->ctrls.lock);
+	mutex_lock(flash->ctrls.lock);
 	/* Reset faults before reading new ones. */
 	flash->fault = 0;
 	rval = adp1653_get_fault(flash);
-	mutex_unlock(&flash->ctrls.lock);
+	mutex_unlock(flash->ctrls.lock);
 	if (rval > 0) {
 		dev_err(&client->dev, "faults detected: 0x%1.1x\n", rval);
 		return -EIO;
 	}
 
-	mutex_lock(&flash->ctrls.lock);
+	mutex_lock(flash->ctrls.lock);
 	rval = adp1653_update_hw(flash);
-	mutex_unlock(&flash->ctrls.lock);
+	mutex_unlock(flash->ctrls.lock);
 	if (rval) {
 		dev_err(&client->dev,
 			"adp1653_update_hw failed at %s\n", __func__);
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 1cbf97f..c38055f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1153,7 +1153,8 @@ static inline int handler_set_err(struct v4l2_ctrl_handler *hdl, int err)
 int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 			   unsigned nr_of_controls_hint)
 {
-	mutex_init(&hdl->lock);
+	hdl->lock = &hdl->_lock;
+	mutex_init(hdl->lock);
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
 	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
@@ -1174,7 +1175,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
 
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 	/* Free all nodes */
 	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
 		list_del(&ref->node);
@@ -1191,7 +1192,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
 	hdl->error = 0;
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_free);
 
@@ -1256,9 +1257,9 @@ static struct v4l2_ctrl_ref *find_ref_lock(
 	struct v4l2_ctrl_ref *ref = NULL;
 
 	if (hdl) {
-		mutex_lock(&hdl->lock);
+		mutex_lock(hdl->lock);
 		ref = find_ref(hdl, id);
-		mutex_unlock(&hdl->lock);
+		mutex_unlock(hdl->lock);
 	}
 	return ref;
 }
@@ -1305,7 +1306,7 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 
 	INIT_LIST_HEAD(&new_ref->node);
 
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 
 	/* Add immediately at the end of the list if the list is empty, or if
 	   the last element in the list has a lower ID.
@@ -1335,7 +1336,7 @@ insert_in_hash:
 	hdl->buckets[bucket] = new_ref;
 
 unlock:
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 	return 0;
 }
 
@@ -1421,9 +1422,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		kfree(ctrl);
 		return NULL;
 	}
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 	list_add_tail(&ctrl->node, &hdl->ctrls);
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 	return ctrl;
 }
 
@@ -1540,7 +1541,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		return 0;
 	if (hdl->error)
 		return hdl->error;
-	mutex_lock(&add->lock);
+	mutex_lock(add->lock);
 	list_for_each_entry(ctrl, &add->ctrls, node) {
 		/* Skip handler-private controls. */
 		if (ctrl->is_private)
@@ -1552,7 +1553,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		if (ret)
 			break;
 	}
-	mutex_unlock(&add->lock);
+	mutex_unlock(add->lock);
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_add_handler);
@@ -1716,11 +1717,11 @@ void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 	len = strlen(prefix);
 	if (len && prefix[len - 1] != ' ')
 		colon = ": ";
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 	list_for_each_entry(ctrl, &hdl->ctrls, node)
 		if (!(ctrl->flags & V4L2_CTRL_FLAG_DISABLED))
 			log_ctrl(ctrl, prefix, colon);
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
 
@@ -1732,7 +1733,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 
 	if (hdl == NULL)
 		return 0;
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 	list_for_each_entry(ctrl, &hdl->ctrls, node)
 		ctrl->done = false;
 
@@ -1757,7 +1758,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		if (ret)
 			break;
 	}
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
@@ -1772,7 +1773,7 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	if (hdl == NULL)
 		return -EINVAL;
 
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 
 	/* Try to find it */
 	ref = find_ref(hdl, id);
@@ -1797,7 +1798,7 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 					break;
 		}
 	}
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 	if (!ref)
 		return -EINVAL;
 
@@ -1974,7 +1975,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 	   belong to the same cluster. */
 
 	/* This has to be done with the handler lock taken. */
-	mutex_lock(&hdl->lock);
+	mutex_lock(hdl->lock);
 
 	/* First zero the helper field in the master control references */
 	for (i = 0; i < cs->count; i++)
@@ -1996,7 +1997,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		/* Point the mref helper to the current helper struct. */
 		mref->helper = h;
 	}
-	mutex_unlock(&hdl->lock);
+	mutex_unlock(hdl->lock);
 	return 0;
 }
 
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index d75a1e4..256e9ba 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -485,7 +485,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 
 	gain = v4l2_ctrl_g_ctrl(dev->gain);
-	mutex_lock(&dev->ctrl_handler.lock);
+	mutex_lock(dev->ctrl_handler.lock);
 	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
 			dev->brightness->cur.val,
 			dev->contrast->cur.val,
@@ -508,7 +508,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
 			dev->int_menu->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	mutex_unlock(&dev->ctrl_handler.lock);
+	mutex_unlock(dev->ctrl_handler.lock);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	if (dev->button_pressed) {
 		dev->button_pressed--;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 533315b..71abac0 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -168,7 +168,9 @@ struct v4l2_ctrl_ref {
 /** struct v4l2_ctrl_handler - The control handler keeps track of all the
   * controls: both the controls owned by the handler and those inherited
   * from other handlers.
+  * @_lock:	Default for "lock".
   * @lock:	Lock to control access to this handler and its controls.
+  *		May be replaced by the user right after init.
   * @ctrls:	The list of controls owned by this handler.
   * @ctrl_refs:	The list of control references.
   * @cached:	The last found control reference. It is common that the same
@@ -179,7 +181,8 @@ struct v4l2_ctrl_ref {
   * @error:	The error code of the first failed control addition.
   */
 struct v4l2_ctrl_handler {
-	struct mutex lock;
+	struct mutex _lock;
+	struct mutex *lock;
 	struct list_head ctrls;
 	struct list_head ctrl_refs;
 	struct v4l2_ctrl_ref *cached;
@@ -456,7 +459,7 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
   */
 static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
 {
-	mutex_lock(&ctrl->handler->lock);
+	mutex_lock(ctrl->handler->lock);
 }
 
 /** v4l2_ctrl_lock() - Helper function to unlock the handler
@@ -465,7 +468,7 @@ static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
   */
 static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 {
-	mutex_unlock(&ctrl->handler->lock);
+	mutex_unlock(ctrl->handler->lock);
 }
 
 /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
-- 
1.7.2.5

