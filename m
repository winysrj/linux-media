Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33615 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753875AbdC1Alv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:41:51 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 15/39] [media] v4l2-mc: add a function to inherit controls from a pipeline
Date: Mon, 27 Mar 2017 17:40:32 -0700
Message-Id: <1490661656-10318-16-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_pipeline_inherit_controls() will add the v4l2 controls from
all subdev entities in a pipeline to a given video device.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 50 +++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           | 31 ++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 303980b..fda580e 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -22,6 +22,7 @@
 #include <linux/usb.h>
 #include <media/media-device.h>
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mc.h>
 #include <media/v4l2-subdev.h>
@@ -238,6 +239,55 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
 
+int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
+				     struct media_entity *start_entity)
+{
+	struct media_device *mdev = start_entity->graph_obj.mdev;
+	struct media_entity *entity;
+	struct media_graph graph;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	lockdep_assert_held(&mdev->graph_mutex);
+
+	ret = media_graph_walk_init(&graph, mdev);
+	if (ret)
+		return ret;
+
+	media_graph_walk_start(&graph, start_entity);
+
+	while ((entity = media_graph_walk_next(&graph))) {
+		if (!is_media_entity_v4l2_subdev(entity))
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+
+		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
+					    sd->ctrl_handler,
+					    NULL);
+		if (ret)
+			break;
+	}
+
+	media_graph_walk_cleanup(&graph);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__v4l2_pipeline_inherit_controls);
+
+int v4l2_pipeline_inherit_controls(struct video_device *vfd,
+				   struct media_entity *start_entity)
+{
+	struct media_device *mdev = start_entity->graph_obj.mdev;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+	ret = __v4l2_pipeline_inherit_controls(vfd, start_entity);
+	mutex_unlock(&mdev->graph_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_pipeline_inherit_controls);
+
 /* -----------------------------------------------------------------------------
  * Pipeline power management
  *
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 2634d9d..299d75d 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -171,6 +171,23 @@ void v4l_disable_media_source(struct video_device *vdev);
  */
 int v4l_vb2q_enable_media_source(struct vb2_queue *q);
 
+/**
+ * v4l2_pipeline_inherit_controls - Add the v4l2 controls from all
+ *				    subdev entities in a pipeline to
+ *				    the given video device.
+ * @vfd: the video device
+ * @start_entity: Starting entity
+ *
+ * This function is intended to be called from the link_notify callback,
+ * which holds the media graph mutex lock. __v4l2_pipeline_inherit_controls
+ * is provided (which does not acquire the lock) for this purpose.
+ * v4l2_pipeline_inherit_controls is also provided for use in other
+ * locations where the graph mutex is not held.
+ */
+int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
+				     struct media_entity *start_entity);
+int v4l2_pipeline_inherit_controls(struct video_device *vfd,
+				   struct media_entity *start_entity);
 
 /**
  * v4l2_pipeline_pm_use - Update the use count of an entity
@@ -231,6 +248,20 @@ static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 	return 0;
 }
 
+static inline int __v4l2_pipeline_inherit_controls(
+	struct video_device *vfd,
+	struct media_entity *start_entity)
+{
+	return 0;
+}
+
+static inline int v4l2_pipeline_inherit_controls(
+	struct video_device *vfd,
+	struct media_entity *start_entity)
+{
+	return 0;
+}
+
 static inline int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 {
 	return 0;
-- 
2.7.4
