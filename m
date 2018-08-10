Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:34547 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbeHJOSi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 10:18:38 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls: add v4l2_ctrl_del_handler()
Message-ID: <8877bbf6-eaf8-732d-ee5f-6e2fbe2371bf@xs4all.nl>
Date: Fri, 10 Aug 2018 13:48:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a sub-device is unbound, then it should also remove its controls from
other control handlers that it was added to using v4l2_ctrl_add_handler().

So create a v4l2_ctrl_del_handler() function that removes the controls that
were earlier added with v4l2_ctrl_add_handler().

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
I'm not sure if this should be merged. It is necessary to safely unbind
subdevs, but since we don't do that yet anyway it is debatable if this
should be merged without anyone using it. But at least it will be archived
in patchwork so it isn't lost.

This function is used in our out-of-tree driver when we unconfigure an
FPGA where we do exactly this type of unbinding.

Regards,

	Hans
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 39 ++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           | 12 +++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 599c1cbff3b9..b40cea8ec436 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2421,6 +2421,45 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_add_handler);

+void v4l2_ctrl_del_handler(struct v4l2_ctrl_handler *hdl,
+			  struct v4l2_ctrl_handler *del)
+{
+	struct v4l2_ctrl_ref *ref, *ref_safe;
+
+	/* Do nothing if either handler is NULL or if they are the same */
+	if (!hdl || !del || hdl == del)
+		return;
+
+	mutex_lock(hdl->lock);
+	list_for_each_entry_safe(ref, ref_safe, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *ctrl = ref->ctrl;
+		struct v4l2_ctrl_ref *bucket_ref;
+		int bucket;
+
+		if (ctrl->handler != del)
+			continue;
+
+		bucket = ctrl->id % hdl->nr_of_buckets;	/* which bucket to use */
+		bucket_ref = hdl->buckets[bucket];
+
+		list_del(&ref->node);
+		if (bucket_ref == ref)
+			hdl->buckets[bucket] = ref->next;
+		else {
+			while (bucket_ref->next && bucket_ref->next != ref)
+				bucket_ref = bucket_ref->next;
+			if (bucket_ref)
+				bucket_ref->next = ref->next;
+			else
+				pr_err("could not find ctrl '%s'\n", ctrl->name);
+		}
+		kfree(ref);
+	}
+	hdl->cached = NULL;
+	mutex_unlock(hdl->lock);
+}
+EXPORT_SYMBOL(v4l2_ctrl_del_handler);
+
 bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl)
 {
 	if (V4L2_CTRL_ID2WHICH(ctrl->id) == V4L2_CTRL_CLASS_FM_TX)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index f615ba1b29dd..c32d3500db54 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -644,6 +644,18 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
 			  v4l2_ctrl_filter filter);

+/**
+ * v4l2_ctrl_del_handler() - Remove all controls in handler @del from
+ * handler @hdl.
+ * @hdl:	The control handler.
+ * @del:	The control handler whose controls you want to delete from
+ *		the @hdl control handler.
+ *
+ * Does nothing if either of the two handlers is a NULL pointer.
+ */
+void v4l2_ctrl_del_handler(struct v4l2_ctrl_handler *hdl,
+			   struct v4l2_ctrl_handler *del);
+
 /**
  * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
  *
-- 
2.18.0
