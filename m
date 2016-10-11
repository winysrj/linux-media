Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35420 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbcJKOyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:43 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 01/11] drm: Add writeback connector type
Date: Tue, 11 Oct 2016 15:53:58 +0100
Message-Id: <1476197648-24918-2-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Writeback connectors represent writeback engines which can write the
CRTC output to a memory framebuffer.

Add a writeback connector type, hidden from userspace behind a client
cap. They are hidden from non-aware clients so that they do not attempt
to use writeback connectors to provide visual output to the user.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_connector.c |    4 +++-
 drivers/gpu/drm/drm_crtc.c      |   14 +++++++++++++-
 drivers/gpu/drm/drm_ioctl.c     |    7 +++++++
 include/drm/drmP.h              |    2 ++
 include/uapi/drm/drm.h          |   10 ++++++++++
 include/uapi/drm/drm_mode.h     |    1 +
 6 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 26bb78c7..027d7a9 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -86,6 +86,7 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] = {
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
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 2d7bedf..33f66e2 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -422,6 +422,14 @@ static int drm_mode_create_standard_properties(struct drm_device *dev)
 	return 0;
 }
 
+static bool
+drm_connector_expose_to_userspace(const struct drm_connector *conn,
+				  const struct drm_file *file_priv)
+{
+	return (file_priv->writeback_connectors) ||
+	       (conn->connector_type != DRM_MODE_CONNECTOR_WRITEBACK);
+}
+
 /**
  * drm_mode_getresources - get graphics configuration
  * @dev: drm device for the ioctl
@@ -491,7 +499,8 @@ int drm_mode_getresources(struct drm_device *dev, void *data,
 		crtc_count++;
 
 	drm_for_each_connector(connector, dev)
-		connector_count++;
+		if (drm_connector_expose_to_userspace(connector, file_priv))
+			connector_count++;
 
 	drm_for_each_encoder(encoder, dev)
 		encoder_count++;
@@ -535,6 +544,9 @@ int drm_mode_getresources(struct drm_device *dev, void *data,
 		copied = 0;
 		connector_id = (uint32_t __user *)(unsigned long)card_res->connector_id_ptr;
 		drm_for_each_connector(connector, dev) {
+			if (!drm_connector_expose_to_userspace(connector, file_priv))
+				continue;
+
 			if (put_user(connector->base.id,
 				     connector_id + copied)) {
 				ret = -EFAULT;
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 0ad2c47..838a6e8 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -308,6 +308,13 @@ drm_setclientcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
 		file_priv->atomic = req->value;
 		file_priv->universal_planes = req->value;
 		break;
+	case DRM_CLIENT_CAP_WRITEBACK_CONNECTORS:
+		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
+			return -EINVAL;
+		if (req->value > 1)
+			return -EINVAL;
+		file_priv->writeback_connectors = req->value;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 0e99669..222d5dc 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -388,6 +388,8 @@ struct drm_file {
 	unsigned universal_planes:1;
 	/* true if client understands atomic properties */
 	unsigned atomic:1;
+	/* true if client understands writeback connectors */
+	unsigned writeback_connectors:1;
 	/*
 	 * This client is the creator of @master.
 	 * Protected by struct drm_device::master_mutex.
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index b2c5284..d2b4543 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -678,6 +678,16 @@ struct drm_get_cap {
  */
 #define DRM_CLIENT_CAP_ATOMIC	3
 
+/**
+ * DRM_CLIENT_CAP_WRITEBACK_CONNECTORS
+ *
+ * If set to 1, the DRM core will expose writeback connectors to userspace.
+ * Writeback connectors act differently to normal connectors (e.g. there will
+ * be no screen output if only writeback connectors are enabled), so we hide
+ * them from non-aware clients.
+ */
+#define DRM_CLIENT_CAP_WRITEBACK_CONNECTORS 4
+
 /** DRM_IOCTL_SET_CLIENT_CAP ioctl argument type */
 struct drm_set_client_cap {
 	__u64 capability;
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index df0e350..e9cb4fe 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -247,6 +247,7 @@ struct drm_mode_get_encoder {
 #define DRM_MODE_CONNECTOR_VIRTUAL      15
 #define DRM_MODE_CONNECTOR_DSI		16
 #define DRM_MODE_CONNECTOR_DPI		17
+#define DRM_MODE_CONNECTOR_WRITEBACK	18
 
 struct drm_mode_get_connector {
 
-- 
1.7.9.5

