Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36129 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbAUERh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 23:17:37 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so50232334pab.4
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 20:17:36 -0800 (PST)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Cc: linaro-kernel@lists.linaro.org, robdclark@gmail.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFCv2 2/2] dma-buf: add helpers for sharing attacher constraints with dma-parms
Date: Wed, 21 Jan 2015 09:46:47 +0530
Message-Id: <1421813807-9178-3-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1421813807-9178-1-git-send-email-sumit.semwal@linaro.org>
References: <1421813807-9178-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some helpers to share the constraints of devices while attaching
to the dmabuf buffer.

At each attach, the constraints are calculated based on the following:
- dma_mask, coherent_dma_mask from struct device,
- max_segment_size, max_segment_count, segment_boundary_mask from
   device_dma_parameters.

In case the attaching device's constraints don't match up, attach() fails.

At detach, the constraints are recalculated based on the remaining
attached devices.

Two helpers are added:
- dma_buf_get_constraints - which gives the current constraints as calculated
      during each attach on the buffer till the time,
- dma_buf_recalc_constraints - which recalculates the constraints for all
      currently attached devices for the 'paranoid' ones amongst us.

The idea of this patch is largely taken from Rob Clark's RFC at
https://lkml.org/lkml/2012/7/19/285, and the comments received on it.

Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c | 132 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h   |  22 ++++++++
 2 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 5be225c..3781f43 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -264,6 +264,77 @@ static inline int is_dma_buf_file(struct file *file)
 	return file->f_op == &dma_buf_fops;
 }
 
+static inline void init_constraints(struct dma_buf_constraints *cons)
+{
+	cons->coherent_dma_mask = (u64)-1;
+	cons->dma_mask = (u64)-1;
+	cons->dma_parms.max_segment_count = (unsigned int)-1;
+	cons->dma_parms.max_segment_size = (unsigned int)-1;
+	cons->dma_parms.segment_boundary_mask = (unsigned int)-1;
+}
+
+/*
+ * calc_constraints - calculates if the new attaching device's constraints
+ * match, with the constraints of already attached devices; if yes, returns
+ * the constraints; else return ERR_PTR(-EINVAL)
+ */
+static int calc_constraints(struct device *dev,
+			    struct dma_buf_constraints *calc_cons)
+{
+	struct dma_buf_constraints cons = *calc_cons;
+
+	cons.dma_mask &= dma_get_mask(dev);
+	/* TODO: Check if this is the right way for coherent_mask ? */
+	cons.coherent_dma_mask &= dev->coherent_dma_mask;
+
+	cons.dma_parms.max_segment_count =
+			min(cons.dma_parms.max_segment_count,
+			    dma_get_max_seg_count(dev));
+	cons.dma_parms.max_segment_size =
+			min(cons.dma_parms.max_segment_size,
+			    dma_get_max_seg_size(dev));
+	cons.dma_parms.segment_boundary_mask &=
+			dma_get_seg_boundary(dev);
+
+	if (!cons.dma_parms.max_segment_count ||
+	    !cons.dma_parms.max_segment_size ||
+	    !cons.dma_parms.segment_boundary_mask ||
+	    !cons.dma_mask ||
+	    !cons.coherent_dma_mask) {
+		pr_err("Dev: %s's constraints don't match\n", dev_name(dev));
+		return -EINVAL;
+	}
+
+	*calc_cons = cons;
+
+	return 0;
+}
+
+/*
+ * recalc_constraints - recalculates constraints for all attached devices;
+ *  useful for detach() recalculation, and for dma_buf_recalc_constraints()
+ *  helper.
+ *  Returns recalculated constraints in recalc_cons, or error in the unlikely
+ *  case when constraints of attached devices might have changed.
+ */
+static int recalc_constraints(struct dma_buf *dmabuf,
+			      struct dma_buf_constraints *recalc_cons)
+{
+	struct dma_buf_constraints calc_cons;
+	struct dma_buf_attachment *attach;
+	int ret = 0;
+
+	init_constraints(&calc_cons);
+
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		ret = calc_constraints(attach->dev, &calc_cons);
+		if (ret)
+			return ret;
+	}
+	*recalc_cons = calc_cons;
+	return 0;
+}
+
 /**
  * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
  * with this buffer, so it can be exported.
@@ -313,6 +384,9 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	dmabuf->ops = ops;
 	dmabuf->size = size;
 	dmabuf->exp_name = exp_name;
+
+	init_constraints(&dmabuf->constraints);
+
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
@@ -422,7 +496,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 					  struct device *dev)
 {
 	struct dma_buf_attachment *attach;
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON(!dmabuf || !dev))
 		return ERR_PTR(-EINVAL);
@@ -436,6 +510,9 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 
 	mutex_lock(&dmabuf->lock);
 
+	if (calc_constraints(dev, &dmabuf->constraints))
+		goto err_constraints;
+
 	if (dmabuf->ops->attach) {
 		ret = dmabuf->ops->attach(dmabuf, dev, attach);
 		if (ret)
@@ -448,6 +525,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 
 err_attach:
 	kfree(attach);
+err_constraints:
 	mutex_unlock(&dmabuf->lock);
 	return ERR_PTR(ret);
 }
@@ -470,6 +548,8 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 	if (dmabuf->ops->detach)
 		dmabuf->ops->detach(dmabuf, attach);
 
+	recalc_constraints(dmabuf, &dmabuf->constraints);
+
 	mutex_unlock(&dmabuf->lock);
 	kfree(attach);
 }
@@ -770,6 +850,56 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 }
 EXPORT_SYMBOL_GPL(dma_buf_vunmap);
 
+/**
+ * dma_buf_get_constraints - get the *current* constraints of the dmabuf,
+ *  as calculated during each attach(); returns error on invalid inputs
+ *
+ * @dmabuf:		[in]	buffer to get constraints of
+ * @constraints:	[out]	current constraints are returned in this
+ */
+int dma_buf_get_constraints(struct dma_buf *dmabuf,
+			    struct dma_buf_constraints *constraints)
+{
+	if (WARN_ON(!dmabuf || !constraints))
+		return -EINVAL;
+
+	mutex_lock(&dmabuf->lock);
+	*constraints = dmabuf->constraints;
+	mutex_unlock(&dmabuf->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_buf_get_constraints);
+
+/**
+ * dma_buf_recalc_constraints - *recalculate* the constraints for the buffer
+ *  afresh, from the list of currently attached devices; this could be useful
+ *  cross-check the current constraints, for exporters that might want to be
+ *  'paranoid' about the device constraints.
+ *
+ *  returns error on invalid inputs
+ *
+ * @dmabuf:		[in]	buffer to get constraints of
+ * @constraints:	[out]	recalculated constraints are returned in this
+ */
+int dma_buf_recalc_constraints(struct dma_buf *dmabuf,
+			    struct dma_buf_constraints *constraints)
+{
+	struct dma_buf_constraints calc_cons;
+	int ret = 0;
+
+	if (WARN_ON(!dmabuf || !constraints))
+		return -EINVAL;
+
+	mutex_lock(&dmabuf->lock);
+	ret = recalc_constraints(dmabuf, &calc_cons);
+	if (!ret)
+		*constraints = calc_cons;
+
+	mutex_unlock(&dmabuf->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_buf_recalc_constraints);
+
 #ifdef CONFIG_DEBUG_FS
 static int dma_buf_describe(struct seq_file *s)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 694e1fe..e1f7cbe 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -34,10 +34,28 @@
 #include <linux/wait.h>
 
 struct device;
+struct device_dma_parameters;
 struct dma_buf;
 struct dma_buf_attachment;
 
 /**
+ * struct dma_buf_constraints - holds constraints for the dma-buf
+ * @dma_mask:	dma_mask if the device is dma'able
+ * @coherent_dma_mask: like dma_mask, but for alloc_coherent mappings
+ * @dma_parms: collated dma_parms from all devices.
+ *
+ * This structure holds the constraints of the dma_buf, dependent on the
+ * currently attached devices. Semantics for each of the members are the same
+ * as defined in device.h
+ */
+struct dma_buf_constraints {
+	u64		dma_mask;
+	u64		coherent_dma_mask;
+	struct device_dma_parameters dma_parms;
+};
+
+
+/**
  * struct dma_buf_ops - operations possible on struct dma_buf
  * @attach: [optional] allows different devices to 'attach' themselves to the
  *	    given buffer. It might return -EBUSY to signal that backing storage
@@ -130,6 +148,7 @@ struct dma_buf {
 	void *vmap_ptr;
 	const char *exp_name;
 	struct list_head list_node;
+	struct dma_buf_constraints constraints;
 	void *priv;
 	struct reservation_object *resv;
 
@@ -211,4 +230,7 @@ void *dma_buf_vmap(struct dma_buf *);
 void dma_buf_vunmap(struct dma_buf *, void *vaddr);
 int dma_buf_debugfs_create_file(const char *name,
 				int (*write)(struct seq_file *));
+
+int dma_buf_get_constraints(struct dma_buf *, struct dma_buf_constraints *);
+int dma_buf_recalc_constraints(struct dma_buf *, struct dma_buf_constraints *);
 #endif /* __DMA_BUF_H__ */
-- 
1.9.1

