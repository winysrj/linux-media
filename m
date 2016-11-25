Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51122 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754852AbcKYQtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 11:49:25 -0500
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, daniel@ffwll.ch, gustavo@padovan.org,
        laurent.pinchart@ideasonboard.com, eric@anholt.net,
        ville.syrjala@linux.intel.com, liviu.dudau@arm.com
Subject: [PATCH 1/6] drm: Add writeback connector type
Date: Fri, 25 Nov 2016 16:48:59 +0000
Message-Id: <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Writeback connectors represent writeback engines which can write the
CRTC output to a memory framebuffer. Add a writeback connector type and
related support functions.

Drivers should initialize a writeback connector with
drm_writeback_connector_init() which takes care of setting up all the
writeback-specific details on top of the normal functionality of
drm_connector_init().

Writeback connectors have a WRITEBACK_FB_ID property, used to set the
output framebuffer, and a PIXEL_FORMATS blob used to expose the
supported writeback formats to userspace.

When a framebuffer is attached to a writeback connector with the
WRITEBACK_FB_ID property, it is used only once (for the commit in which
it was included), and userspace can never read back the value of
WRITEBACK_FB_ID. WRITEBACK_FB_ID can only be set if the connector is
attached to a CRTC.

Changes since v1:
 - Added drm_writeback.c + documentation
 - Added helper to initialize writeback connector in one go
 - Added core checks
 - Squashed into a single commit
 - Dropped the client cap
 - Writeback framebuffers are no longer persistent

Changes since v2:
 Daniel Vetter:
 - Subclass drm_connector to drm_writeback_connector
 - Relax check to allow CRTC to be set without an FB
 - Add some writeback_ prefixes
 - Drop PIXEL_FORMATS_SIZE property, as it was unnecessary
 Gustavo Padovan:
 - Add drm_writeback_job to handle writeback signalling centrally

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 Documentation/gpu/drm-kms.rst       |    9 ++
 drivers/gpu/drm/Makefile            |    2 +-
 drivers/gpu/drm/drm_atomic.c        |  130 ++++++++++++++++++++
 drivers/gpu/drm/drm_atomic_helper.c |    6 +
 drivers/gpu/drm/drm_connector.c     |    4 +-
 drivers/gpu/drm/drm_writeback.c     |  230 +++++++++++++++++++++++++++++++++++
 include/drm/drm_atomic.h            |    3 +
 include/drm/drm_connector.h         |   13 ++
 include/drm/drm_mode_config.h       |   14 +++
 include/drm/drm_writeback.h         |   78 ++++++++++++
 include/uapi/drm/drm_mode.h         |    1 +
 11 files changed, 488 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_writeback.c
 create mode 100644 include/drm/drm_writeback.h

diff --git a/Documentation/gpu/drm-kms.rst b/Documentation/gpu/drm-kms.rst
index 568f3c2..3a4f35b 100644
--- a/Documentation/gpu/drm-kms.rst
+++ b/Documentation/gpu/drm-kms.rst
@@ -122,6 +122,15 @@ Connector Functions Reference
 .. kernel-doc:: drivers/gpu/drm/drm_connector.c
    :export:
 
+Writeback Connectors
+--------------------
+
+.. kernel-doc:: drivers/gpu/drm/drm_writeback.c
+  :doc: overview
+
+.. kernel-doc:: drivers/gpu/drm/drm_writeback.c
+  :export:
+
 Encoder Abstraction
 ===================
 
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 883f3e7..3209aa4 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -16,7 +16,7 @@ drm-y       :=	drm_auth.o drm_bufs.o drm_cache.o \
 		drm_framebuffer.o drm_connector.o drm_blend.o \
 		drm_encoder.o drm_mode_object.o drm_property.o \
 		drm_plane.o drm_color_mgmt.o drm_print.o \
-		drm_dumb_buffers.o drm_mode_config.o
+		drm_dumb_buffers.o drm_mode_config.o drm_writeback.o
 
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 drm-$(CONFIG_DRM_GEM_CMA_HELPER) += drm_gem_cma_helper.o
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index b476ec5..343e2b7 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -31,6 +31,7 @@
 #include <drm/drm_mode.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_print.h>
+#include <drm/drm_writeback.h>
 #include <linux/sync_file.h>
 
 #include "drm_crtc_internal.h"
@@ -659,6 +660,46 @@ static void drm_atomic_crtc_print_state(struct drm_printer *p,
 }
 
 /**
+ * drm_atomic_connector_check - check connector state
+ * @connector: connector to check
+ * @state: connector state to check
+ *
+ * Provides core sanity checks for connector state.
+ *
+ * RETURNS:
+ * Zero on success, error code on failure
+ */
+static int drm_atomic_connector_check(struct drm_connector *connector,
+		struct drm_connector_state *state)
+{
+	struct drm_crtc_state *crtc_state;
+	struct drm_writeback_job *writeback_job = state->writeback_job;
+
+	if ((connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK) ||
+	    !writeback_job)
+		return 0;
+
+	if (writeback_job->fb && !state->crtc) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] framebuffer without CRTC\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
+	if (state->crtc)
+		crtc_state = drm_atomic_get_existing_crtc_state(state->state,
+								state->crtc);
+
+	if (writeback_job->fb && !crtc_state->active) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] has framebuffer, but [CRTC:%d] is off\n",
+				 connector->base.id, connector->name,
+				 state->crtc->base.id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
  * drm_atomic_get_plane_state - get plane state
  * @state: global atomic state object
  * @plane: plane to get state object for
@@ -1087,6 +1128,12 @@ int drm_atomic_connector_set_property(struct drm_connector *connector,
 		 * now?) atomic writes to DPMS property:
 		 */
 		return -EINVAL;
+	} else if (property == config->writeback_fb_id_property) {
+		struct drm_framebuffer *fb = drm_framebuffer_lookup(dev, val);
+		int ret = drm_atomic_set_writeback_fb_for_connector(state, fb);
+		if (fb)
+			drm_framebuffer_unreference(fb);
+		return ret;
 	} else if (connector->funcs->atomic_set_property) {
 		return connector->funcs->atomic_set_property(connector,
 				state, property, val);
@@ -1135,6 +1182,9 @@ static void drm_atomic_connector_print_state(struct drm_printer *p,
 		*val = (state->crtc) ? state->crtc->base.id : 0;
 	} else if (property == config->dpms_property) {
 		*val = connector->dpms;
+	} else if (property == config->writeback_fb_id_property) {
+		/* Writeback framebuffer is one-shot, write and forget */
+		*val = 0;
 	} else if (connector->funcs->atomic_get_property) {
 		return connector->funcs->atomic_get_property(connector,
 				state, property, val);
@@ -1347,6 +1397,75 @@ int drm_atomic_get_property(struct drm_mode_object *obj,
 }
 EXPORT_SYMBOL(drm_atomic_set_crtc_for_connector);
 
+/*
+ * drm_atomic_get_writeback_job - return or allocate a writeback job
+ * @conn_state: Connector state to get the job for
+ *
+ * Writeback jobs have a different lifetime to the atomic state they are
+ * associated with. This convenience function takes care of allocating a job
+ * if there isn't yet one associated with the connector state, otherwise
+ * it just returns the existing job.
+ *
+ * Returns: The writeback job for the given connector state
+ */
+static struct drm_writeback_job *
+drm_atomic_get_writeback_job(struct drm_connector_state *conn_state)
+{
+	WARN_ON(conn_state->connector->connector_type !=
+		DRM_MODE_CONNECTOR_WRITEBACK);
+
+	if (!conn_state->writeback_job)
+		conn_state->writeback_job =
+			kzalloc(sizeof(*conn_state->writeback_job), GFP_KERNEL);
+
+	return conn_state->writeback_job;
+}
+
+/**
+ * drm_atomic_set_writeback_fb_for_connector - set writeback framebuffer
+ * @conn_state: atomic state object for the connector
+ * @fb: fb to use for the connector
+ *
+ * This is used to set the framebuffer for a writeback connector, which outputs
+ * to a buffer instead of an actual physical connector.
+ * Changing the assigned framebuffer requires us to grab a reference to the new
+ * fb and drop the reference to the old fb, if there is one. This function
+ * takes care of all these details besides updating the pointer in the
+ * state object itself.
+ *
+ * Note: The only way conn_state can already have an fb set is if the commit
+ * sets the property more than once.
+ *
+ * See also: drm_writeback_connector_init()
+ *
+ * Returns: 0 on success
+ */
+int drm_atomic_set_writeback_fb_for_connector(
+		struct drm_connector_state *conn_state,
+		struct drm_framebuffer *fb)
+{
+	struct drm_writeback_job *job =
+		drm_atomic_get_writeback_job(conn_state);
+	if (!job)
+		return -ENOMEM;
+
+	if (job->fb)
+		drm_framebuffer_unreference(job->fb);
+	if (fb)
+		drm_framebuffer_reference(fb);
+	job->fb = fb;
+
+	if (fb)
+		DRM_DEBUG_ATOMIC("Set [FB:%d] for connector state %p\n",
+				 fb->base.id, conn_state);
+	else
+		DRM_DEBUG_ATOMIC("Set [NOFB] for connector state %p\n",
+				 conn_state);
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_atomic_set_writeback_fb_for_connector);
+
 /**
  * drm_atomic_add_affected_connectors - add connectors for crtc
  * @state: atomic state
@@ -1501,6 +1620,8 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 	struct drm_plane_state *plane_state;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *crtc_state;
+	struct drm_connector *conn;
+	struct drm_connector_state *conn_state;
 	int i, ret = 0;
 
 	DRM_DEBUG_ATOMIC("checking %p\n", state);
@@ -1523,6 +1644,15 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 		}
 	}
 
+	for_each_connector_in_state(state, conn, conn_state, i) {
+		ret = drm_atomic_connector_check(conn, conn_state);
+		if (ret) {
+			DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] atomic core check failed\n",
+					 conn->base.id, conn->name);
+			return ret;
+		}
+	}
+
 	if (config->funcs->atomic_check)
 		ret = config->funcs->atomic_check(state->dev, state);
 
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 0b16587..75812b9 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -30,6 +30,7 @@
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_writeback.h>
 #include <linux/dma-fence.h>
 
 #include "drm_crtc_internal.h"
@@ -3192,6 +3193,9 @@ void drm_atomic_helper_connector_reset(struct drm_connector *connector)
 	memcpy(state, connector->state, sizeof(*state));
 	if (state->crtc)
 		drm_connector_reference(connector);
+
+	/* Don't copy over a writeback job, they are used only once */
+	state->writeback_job = NULL;
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_duplicate_state);
 
@@ -3319,6 +3323,8 @@ struct drm_atomic_state *
 	 */
 	if (state->crtc)
 		drm_connector_unreference(state->connector);
+	if (state->writeback_job)
+		drm_writeback_cleanup_job(state->writeback_job);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
 
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index b5c6a8e..6bbd93f 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -86,6 +86,7 @@ struct drm_conn_prop_enum_list {
 	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual" },
 	{ DRM_MODE_CONNECTOR_DSI, "DSI" },
 	{ DRM_MODE_CONNECTOR_DPI, "DPI" },
+	{ DRM_MODE_CONNECTOR_WRITEBACK, "Writeback" },
 };
 
 void drm_connector_ida_init(void)
@@ -235,7 +236,8 @@ int drm_connector_init(struct drm_device *dev,
 	list_add_tail(&connector->head, &config->connector_list);
 	config->num_connector++;
 
-	if (connector_type != DRM_MODE_CONNECTOR_VIRTUAL)
+	if ((connector_type != DRM_MODE_CONNECTOR_VIRTUAL) &&
+	    (connector_type != DRM_MODE_CONNECTOR_WRITEBACK))
 		drm_object_attach_property(&connector->base,
 					      config->edid_property,
 					      0);
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
new file mode 100644
index 0000000..75a1dbf
--- /dev/null
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -0,0 +1,230 @@
+/*
+ * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
+ * Author: Brian Starkey <brian.starkey@arm.com>
+ *
+ * This program is free software and is provided to you under the terms of the
+ * GNU General Public License version 2 as published by the Free Software
+ * Foundation, and any use by you of this program is subject to the terms
+ * of such GNU licence.
+ */
+
+#include <drm/drm_crtc.h>
+#include <drm/drm_property.h>
+#include <drm/drm_writeback.h>
+#include <drm/drmP.h>
+
+/**
+ * DOC: overview
+ *
+ * Writeback connectors are used to expose hardware which can write the output
+ * from a CRTC to a memory buffer. They are used and act similarly to other
+ * types of connectors, with some important differences:
+ *  - Writeback connectors don't provide a way to output visually to the user.
+ *  - Writeback connectors should always report as "disconnected" (so that
+ *    clients which don't understand them will ignore them).
+ *  - Writeback connectors don't have EDID.
+ *
+ * A framebuffer may only be attached to a writeback connector when the
+ * connector is attached to a CRTC. The WRITEBACK_FB_ID property which sets the
+ * framebuffer applies only to a single commit (see below). A framebuffer may
+ * not be attached while the CRTC is off.
+ *
+ * Writeback connectors have some additional properties, which userspace
+ * can use to query and control them:
+ *
+ *  "WRITEBACK_FB_ID":
+ *	Write-only object property storing a DRM_MODE_OBJECT_FB: it stores the
+ *	framebuffer to be written by the writeback connector. This property is
+ *	similar to the FB_ID property on planes, but will always read as zero
+ *	and is not preserved across commits.
+ *	Userspace must set this property to an output buffer every time it
+ *	wishes the buffer to get filled.
+ *
+ *  "PIXEL_FORMATS":
+ *	Immutable blob property to store the supported pixel formats table. The
+ *	data is an array of u32 DRM_FORMAT_* fourcc values.
+ *	Userspace can use this blob to find out what pixel formats are supported
+ *	by the connector's writeback engine.
+ */
+
+static bool create_writeback_properties(struct drm_device *dev)
+{
+	struct drm_property *prop;
+
+	if (!dev->mode_config.writeback_fb_id_property) {
+		prop = drm_property_create_object(dev, DRM_MODE_PROP_ATOMIC,
+						  "WRITEBACK_FB_ID",
+						  DRM_MODE_OBJECT_FB);
+		if (!prop)
+			return false;
+		dev->mode_config.writeback_fb_id_property = prop;
+	}
+
+	if (!dev->mode_config.writeback_pixel_formats_property) {
+		prop = drm_property_create(dev, DRM_MODE_PROP_BLOB | DRM_MODE_PROP_IMMUTABLE,
+					   "PIXEL_FORMATS", 0);
+		if (!prop)
+			return false;
+		dev->mode_config.writeback_pixel_formats_property = prop;
+	}
+
+	return true;
+}
+
+/**
+ * drm_writeback_connector_init - Initialize a writeback connector and its properties
+ * @dev: DRM device
+ * @wb_connector: Writeback connector to initialize
+ * @funcs: Connector funcs vtable
+ * @formats: Array of supported pixel formats for the writeback engine
+ * @n_formats: Length of the formats array
+ *
+ * This function creates the writeback-connector-specific properties if they
+ * have not been already created, initializes the connector as
+ * type DRM_MODE_CONNECTOR_WRITEBACK, and correctly initializes the property
+ * values.
+ *
+ * Drivers should always use this function instead of drm_connector_init() to
+ * set up writeback connectors.
+ *
+ * Returns: 0 on success, or a negative error code
+ */
+int drm_writeback_connector_init(struct drm_device *dev,
+				 struct drm_writeback_connector *wb_connector,
+				 const struct drm_connector_funcs *funcs,
+				 u32 *formats, int n_formats)
+{
+	int ret;
+	struct drm_property_blob *blob;
+	struct drm_connector *connector = &wb_connector->base;
+	struct drm_mode_config *config = &dev->mode_config;
+
+	if (!create_writeback_properties(dev))
+		return -EINVAL;
+
+	blob = drm_property_create_blob(dev, n_formats * sizeof(*formats),
+					formats);
+	if (IS_ERR(blob))
+		return PTR_ERR(blob);
+
+	ret = drm_connector_init(dev, connector, funcs,
+				 DRM_MODE_CONNECTOR_WRITEBACK);
+	if (ret)
+		goto fail;
+
+	INIT_LIST_HEAD(&wb_connector->job_queue);
+	spin_lock_init(&wb_connector->job_lock);
+
+	drm_object_attach_property(&connector->base,
+				   config->writeback_fb_id_property, 0);
+
+	drm_object_attach_property(&connector->base,
+				   config->writeback_pixel_formats_property,
+				   blob->base.id);
+	wb_connector->pixel_formats_blob_ptr = blob;
+
+	return 0;
+
+fail:
+	drm_property_unreference_blob(blob);
+	return ret;
+}
+EXPORT_SYMBOL(drm_writeback_connector_init);
+
+/**
+ * @drm_writeback_queue_job: Queue a writeback job for later signalling
+ * @wb_connector: The writeback connector to queue a job on
+ * @job: The job to queue
+ *
+ * This function adds a job to the job_queue for a writeback connector. It
+ * should be considered to take ownership of the writeback job, and so any other
+ * references to the job must be cleared after calling this function.
+ *
+ * Drivers must ensure that for a given writeback connector, jobs are queued in
+ * exactly the same order as they will be completed by the hardware (and
+ * signaled via drm_writeback_signal_completion).
+ *
+ * For every call to drm_writeback_queue_job() there must be exactly one call to
+ * drm_writeback_signal_completion()
+ *
+ * See also: drm_writeback_signal_completion()
+ */
+void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
+			     struct drm_writeback_job *job)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wb_connector->job_lock, flags);
+	list_add_tail(&job->list_entry, &wb_connector->job_queue);
+	spin_unlock_irqrestore(&wb_connector->job_lock, flags);
+}
+EXPORT_SYMBOL(drm_writeback_queue_job);
+
+/**
+ * @drm_writeback_cleanup_job: Cleanup and free a writeback job
+ * @job: The writeback job to free
+ *
+ * Drops any references held by the writeback job, and frees the structure.
+ */
+void drm_writeback_cleanup_job(struct drm_writeback_job *job)
+{
+	if (!job)
+		return;
+
+	if (job->fb)
+		drm_framebuffer_unreference(job->fb);
+	kfree(job);
+}
+EXPORT_SYMBOL(drm_writeback_cleanup_job);
+
+/*
+ * @cleanup_work: deferred cleanup of a writeback job
+ *
+ * The job cannot be cleaned up directly in drm_writeback_signal_completion,
+ * because it may be called in interrupt context. Dropping the framebuffer
+ * reference can sleep, and so the cleanup is deferred to a workqueue.
+ */
+static void cleanup_work(struct work_struct *work)
+{
+	struct drm_writeback_job *job = container_of(work,
+						     struct drm_writeback_job,
+						     cleanup_work);
+	drm_writeback_cleanup_job(job);
+}
+
+/**
+ * @drm_writeback_signal_completion: Signal the completion of a writeback job
+ * @wb_connector: The writeback connector whose job is complete
+ *
+ * Drivers should call this to signal the completion of a previously queued
+ * writeback job. It should be called as soon as possible after the hardware
+ * has finished writing, and may be called from interrupt context.
+ * It is the driver's responsibility to ensure that for a given connector, the
+ * hardware completes writeback jobs in the same order as they are queued.
+ *
+ * Unless the driver is holding its own reference to the framebuffer, it must
+ * not be accessed after calling this function.
+ *
+ * See also: drm_writeback_queue_job()
+ */
+void
+drm_writeback_signal_completion(struct drm_writeback_connector *wb_connector)
+{
+	unsigned long flags;
+	struct drm_writeback_job *job;
+
+	spin_lock_irqsave(&wb_connector->job_lock, flags);
+	job = list_first_entry_or_null(&wb_connector->job_queue,
+				       struct drm_writeback_job,
+				       list_entry);
+	if (job)
+		list_del(&job->list_entry);
+	spin_unlock_irqrestore(&wb_connector->job_lock, flags);
+
+	if (WARN_ON(!job))
+		return;
+
+	INIT_WORK(&job->cleanup_work, cleanup_work);
+	queue_work(system_long_wq, &job->cleanup_work);
+}
+EXPORT_SYMBOL(drm_writeback_signal_completion);
diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
index c0eaec7..476561d 100644
--- a/include/drm/drm_atomic.h
+++ b/include/drm/drm_atomic.h
@@ -351,6 +351,9 @@ void drm_atomic_set_fence_for_plane(struct drm_plane_state *plane_state,
 int __must_check
 drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
 				  struct drm_crtc *crtc);
+int drm_atomic_set_writeback_fb_for_connector(
+		struct drm_connector_state *conn_state,
+		struct drm_framebuffer *fb);
 int __must_check
 drm_atomic_add_affected_connectors(struct drm_atomic_state *state,
 				   struct drm_crtc *crtc);
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 34f9741..dc4910d6 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -214,6 +214,19 @@ struct drm_connector_state {
 	struct drm_encoder *best_encoder;
 
 	struct drm_atomic_state *state;
+
+	/**
+	 * @writeback_job: Writeback job for writeback connectors
+	 *
+	 * Holds the framebuffer for a writeback connector. As the writeback
+	 * completion may be asynchronous to the normal commit cycle, the
+	 * writeback job lifetime is managed separately from the normal atomic
+	 * state by this object.
+	 *
+	 * See also: drm_writeback_queue_job() and
+	 * drm_writeback_signal_completion()
+	 */
+	struct drm_writeback_job *writeback_job;
 };
 
 /**
diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
index bf9991b2..3d3d07f 100644
--- a/include/drm/drm_mode_config.h
+++ b/include/drm/drm_mode_config.h
@@ -634,6 +634,20 @@ struct drm_mode_config {
 	 */
 	struct drm_property *suggested_y_property;
 
+	/**
+	 * @writeback_fb_id_property: Property for writeback connectors, storing
+	 * the ID of the output framebuffer.
+	 * See also: drm_writeback_connector_init()
+	 */
+	struct drm_property *writeback_fb_id_property;
+	/**
+	 * @writeback_pixel_formats_property: Property for writeback connectors,
+	 * storing an array of the supported pixel formats for the writeback
+	 * engine (read-only).
+	 * See also: drm_writeback_connector_init()
+	 */
+	struct drm_property *writeback_pixel_formats_property;
+
 	/* dumb ioctl parameters */
 	uint32_t preferred_depth, prefer_shadow;
 
diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
new file mode 100644
index 0000000..6b2ac45
--- /dev/null
+++ b/include/drm/drm_writeback.h
@@ -0,0 +1,78 @@
+/*
+ * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
+ * Author: Brian Starkey <brian.starkey@arm.com>
+ *
+ * This program is free software and is provided to you under the terms of the
+ * GNU General Public License version 2 as published by the Free Software
+ * Foundation, and any use by you of this program is subject to the terms
+ * of such GNU licence.
+ */
+
+#ifndef __DRM_WRITEBACK_H__
+#define __DRM_WRITEBACK_H__
+#include <drm/drm_connector.h>
+#include <linux/workqueue.h>
+
+struct drm_writeback_connector {
+	struct drm_connector base;
+
+	/**
+	 * @pixel_formats_blob_ptr:
+	 *
+	 * DRM blob property data for the pixel formats list on writeback
+	 * connectors
+	 * See also drm_writeback_connector_init()
+	 */
+	struct drm_property_blob *pixel_formats_blob_ptr;
+
+	/** @job_lock: Protects job_queue */
+	spinlock_t job_lock;
+	/**
+	 * @job_queue:
+	 *
+	 * Holds a list of a connector's writeback jobs; the last item is the
+	 * most recent. The first item may be either waiting for the hardware
+	 * to begin writing, or currently being written.
+	 *
+	 * See also: drm_writeback_queue_job() and
+	 * drm_writeback_signal_completion()
+	 */
+	struct list_head job_queue;
+};
+
+struct drm_writeback_job {
+	/**
+	 * @cleanup_work:
+	 *
+	 * Used to allow drm_writeback_signal_completion to defer dropping the
+	 * framebuffer reference to a workqueue.
+	 */
+	struct work_struct cleanup_work;
+	/**
+	 * @list_entry:
+	 *
+	 * List item for the connector's @job_queue
+	 */
+	struct list_head list_entry;
+	/**
+	 * @fb:
+	 *
+	 * Framebuffer to be written to by the writeback connector. Do not set
+	 * directly, use drm_atomic_set_writeback_fb_for_connector()
+	 */
+	struct drm_framebuffer *fb;
+};
+
+int drm_writeback_connector_init(struct drm_device *dev,
+				 struct drm_writeback_connector *wb_connector,
+				 const struct drm_connector_funcs *funcs,
+				 u32 *formats, int n_formats);
+
+void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
+			     struct drm_writeback_job *job);
+
+void drm_writeback_cleanup_job(struct drm_writeback_job *job);
+
+void
+drm_writeback_signal_completion(struct drm_writeback_connector *wb_connector);
+#endif
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index ebf622f..ae5e4f7 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -263,6 +263,7 @@ struct drm_mode_get_encoder {
 #define DRM_MODE_CONNECTOR_VIRTUAL      15
 #define DRM_MODE_CONNECTOR_DSI		16
 #define DRM_MODE_CONNECTOR_DPI		17
+#define DRM_MODE_CONNECTOR_WRITEBACK	18
 
 struct drm_mode_get_connector {
 
-- 
1.7.9.5

