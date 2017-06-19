Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33699 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdFSDyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 23:54:05 -0400
Received: by mail-pf0-f179.google.com with SMTP id 83so48122732pfr.0
        for <linux-media@vger.kernel.org>; Sun, 18 Jun 2017 20:54:04 -0700 (PDT)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH] v4l2-core: Use kvmalloc() for potentially big allocations
Date: Mon, 19 Jun 2017 12:53:43 +0900
Message-Id: <20170619035343.38645-1-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are multiple places where arrays or otherwise variable sized
buffer are allocated through V4L2 core code, including things like
controls, memory pages, staging buffers for ioctls and so on. Such
allocations can potentially require an order > 0 allocation from the
page allocator, which is not guaranteed to be fulfilled and is likely to
fail on a system with severe memory fragmentation (e.g. a system with
very long uptime).

Since the memory being allocated is intended to be used by the CPU
exclusively, we can consider using vmalloc() as a fallback and this is
exactly what the recently merged kvmalloc() helpers do. A kmalloc() call
is still attempted, even for order > 0 allocations, but it is done
with __GFP_NORETRY and __GFP_NOWARN, with expectation of failing if
requested memory is not available instantly. Only then the vmalloc()
fallback is used. This should give us fast and more reliable allocations
even on systems with higher memory pressure and/or more fragmentation,
while still retaining the same performance level on systems not
suffering from such conditions.

While at it, replace explicit array size calculations on changed
allocations with kvmalloc_array().

Purposedly not touching videobuf1, as it is deprecated, has only few
users remaining and would rather be seen removed instead.

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since RFC:
 - added explicit includes for <linux/mm.h>,
 - added Marek's and Sakari's Acked-by.
---
 drivers/media/v4l2-core/v4l2-async.c       |  5 +++--
 drivers/media/v4l2-core/v4l2-ctrls.c       | 26 ++++++++++++++------------
 drivers/media/v4l2-core/v4l2-event.c       |  8 +++++---
 drivers/media/v4l2-core/v4l2-ioctl.c       |  7 ++++---
 drivers/media/v4l2-core/v4l2-subdev.c      |  8 +++++---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |  8 ++++----
 6 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index cbd919d4edd2..46fc8baf8a17 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/list.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -209,7 +210,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	if (!notifier->v4l2_dev)
 		return;
 
-	dev = kmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
+	dev = kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(notifier->v4l2_dev->dev,
 			"Failed to allocate device cache!\n");
@@ -265,7 +266,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		}
 		put_device(d);
 	}
-	kfree(dev);
+	kvfree(dev);
 
 	notifier->v4l2_dev = NULL;
 
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5aed7bd20ad2..1e6363a650c0 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <media/v4l2-ioctl.h>
@@ -1745,8 +1746,9 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
 	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
-	hdl->buckets = kcalloc(hdl->nr_of_buckets, sizeof(hdl->buckets[0]),
-			       GFP_KERNEL);
+	hdl->buckets = kvmalloc_array(hdl->nr_of_buckets,
+				      sizeof(hdl->buckets[0]),
+				      GFP_KERNEL | __GFP_ZERO);
 	hdl->error = hdl->buckets ? 0 : -ENOMEM;
 	return hdl->error;
 }
@@ -1773,9 +1775,9 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 		list_del(&ctrl->node);
 		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
 			list_del(&sev->node);
-		kfree(ctrl);
+		kvfree(ctrl);
 	}
-	kfree(hdl->buckets);
+	kvfree(hdl->buckets);
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
 	hdl->error = 0;
@@ -2023,7 +2025,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		 is_array)
 		sz_extra += 2 * tot_ctrl_size;
 
-	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
+	ctrl = kvzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
 	if (ctrl == NULL) {
 		handler_set_err(hdl, -ENOMEM);
 		return NULL;
@@ -2072,7 +2074,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 
 	if (handler_new_ref(hdl, ctrl)) {
-		kfree(ctrl);
+		kvfree(ctrl);
 		return NULL;
 	}
 	mutex_lock(hdl->lock);
@@ -2842,8 +2844,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		return class_check(hdl, cs->which);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
-		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
-					GFP_KERNEL);
+		helpers = kvmalloc_array(cs->count, sizeof(helper[0]),
+					 GFP_KERNEL);
 		if (helpers == NULL)
 			return -ENOMEM;
 	}
@@ -2895,7 +2897,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	}
 
 	if (cs->count > ARRAY_SIZE(helper))
-		kfree(helpers);
+		kvfree(helpers);
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
@@ -3097,8 +3099,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		return class_check(hdl, cs->which);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
-		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
-					GFP_KERNEL);
+		helpers = kvmalloc_array(cs->count, sizeof(helper[0]),
+					 GFP_KERNEL);
 		if (!helpers)
 			return -ENOMEM;
 	}
@@ -3175,7 +3177,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	}
 
 	if (cs->count > ARRAY_SIZE(helper))
-		kfree(helpers);
+		kvfree(helpers);
 	return ret;
 }
 
diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index a75df6cb141f..968c2eb08b5a 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -21,6 +21,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/export.h>
@@ -214,7 +215,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	if (elems < 1)
 		elems = 1;
 
-	sev = kzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems, GFP_KERNEL);
+	sev = kvzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems,
+		       GFP_KERNEL);
 	if (!sev)
 		return -ENOMEM;
 	for (i = 0; i < elems; i++)
@@ -232,7 +234,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
 	if (found_ev) {
-		kfree(sev);
+		kvfree(sev);
 		return 0; /* Already listening */
 	}
 
@@ -304,7 +306,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	if (sev && sev->ops && sev->ops->del)
 		sev->ops->del(sev);
 
-	kfree(sev);
+	kvfree(sev);
 
 	return 0;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 4f27cfa134a1..a03a5ecbdd87 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -12,6 +12,7 @@
  *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
  */
 
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -2814,7 +2815,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			parg = sbuf;
 		} else {
 			/* too big to allocate from stack */
-			mbuf = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
+			mbuf = kvmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
 			if (NULL == mbuf)
 				return -ENOMEM;
 			parg = mbuf;
@@ -2863,7 +2864,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		 * array) fits into sbuf (so that mbuf will still remain
 		 * unused up to here).
 		 */
-		mbuf = kmalloc(array_size, GFP_KERNEL);
+		mbuf = kvmalloc(array_size, GFP_KERNEL);
 		err = -ENOMEM;
 		if (NULL == mbuf)
 			goto out_array_args;
@@ -2908,7 +2909,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	}
 
 out:
-	kfree(mbuf);
+	kvfree(mbuf);
 	return err;
 }
 EXPORT_SYMBOL(video_usercopy);
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497ae5ed..43fefa73e0a3 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/ioctl.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
@@ -577,13 +578,14 @@ v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd)
 	if (!sd->entity.num_pads)
 		return NULL;
 
-	cfg = kcalloc(sd->entity.num_pads, sizeof(*cfg), GFP_KERNEL);
+	cfg = kvmalloc_array(sd->entity.num_pads, sizeof(*cfg),
+			     GFP_KERNEL | __GFP_ZERO);
 	if (!cfg)
 		return NULL;
 
 	ret = v4l2_subdev_call(sd, pad, init_cfg, cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		kfree(cfg);
+		kvfree(cfg);
 		return NULL;
 	}
 
@@ -593,7 +595,7 @@ EXPORT_SYMBOL_GPL(v4l2_subdev_alloc_pad_config);
 
 void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg)
 {
-	kfree(cfg);
+	kvfree(cfg);
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_free_pad_config);
 #endif /* CONFIG_MEDIA_CONTROLLER */
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 8e8798a74760..5defa1f22ca2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -120,8 +120,8 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	buf->num_pages = size >> PAGE_SHIFT;
 	buf->dma_sgt = &buf->sg_table;
 
-	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
-			     GFP_KERNEL);
+	buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
+				    GFP_KERNEL | __GFP_ZERO);
 	if (!buf->pages)
 		goto fail_pages_array_alloc;
 
@@ -165,7 +165,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	while (num_pages--)
 		__free_page(buf->pages[num_pages]);
 fail_pages_alloc:
-	kfree(buf->pages);
+	kvfree(buf->pages);
 fail_pages_array_alloc:
 	kfree(buf);
 	return ERR_PTR(-ENOMEM);
@@ -187,7 +187,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		sg_free_table(buf->dma_sgt);
 		while (--i >= 0)
 			__free_page(buf->pages[i]);
-		kfree(buf->pages);
+		kvfree(buf->pages);
 		put_device(buf->dev);
 		kfree(buf);
 	}
-- 
2.13.1.518.g3df882009-goog
