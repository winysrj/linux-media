Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaKFKMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:20 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00D6G4CIBT60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:18 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 08/11] mediactl: Add support for media device
 pipelines
Date: Thu, 06 Nov 2014 11:11:39 +0100
Message-id: <1415268702-23685-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add infrastructure for linking media entities,
discovering pipelines of media entities and
opening/closing all sub-devices in the pipeline
at one go.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |  166 +++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl-priv.h |    6 ++
 utils/media-ctl/mediactl.h      |   79 +++++++++++++++++++
 3 files changed, 251 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 27e7329..75021e7 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -1253,9 +1253,165 @@ struct media_entity *media_config_get_entity_by_cid(struct media_device *media,
 }
 
 /* -----------------------------------------------------------------------------
+ * Pipeline operations
+ */
+
+int media_discover_pipeline_by_entity(struct media_device *media,
+				      struct media_entity *entity)
+{
+	struct media_entity *pipe_head = NULL;
+	struct media_pad *sink_pads, sink_pad, *src_pad;
+	struct media_link *link;
+	int num_sink_pads, ret;
+	struct media_pad *prev_link_src_pad = NULL;
+
+	if (entity == NULL)
+		return -EINVAL;
+
+	for (;;) {
+		if (pipe_head == NULL) {
+			pipe_head = entity;
+		} else {
+			entity->next = pipe_head;
+			pipe_head = entity;
+		}
+
+		entity->pipe_src_pad = prev_link_src_pad;
+
+		ret = media_get_busy_pads_by_entity(media, entity,
+						    MEDIA_PAD_FL_SINK,
+						    &sink_pads,
+						    &num_sink_pads);
+		if (ret < 0)
+			return ret;
+
+		/* check if pipeline source entity has been reached */
+		if (num_sink_pads > 2) {
+			media_dbg(media, "Unexpected number of busy sink pads (%d)\n", num_sink_pads);
+			goto err_check_sink_pads;
+		} else if (num_sink_pads == 2) {
+			/* Allow two active pads only in case of S5C73M3-OIF entity */
+			if (strcmp(entity->info.name, "S5C73M3-OIF")) {
+				media_dbg(media, "Ambiguous media device topology: two busy sink pads");
+				goto err_check_sink_pads;
+			}
+			/*
+			 * Two active links are allowed betwen S5C73M3-OIF and S5C73M3 entities.
+			 * In such a case a route through pad 0 has to be selected.
+			 */
+			ret = media_get_pad_by_index(sink_pads, num_sink_pads,
+							0, &sink_pad);
+			if (ret < 0)
+				goto err_check_sink_pads;
+		} else if (num_sink_pads == 1) {
+			sink_pad = sink_pads[0];
+		} else {
+			break;
+		}
+		if (num_sink_pads > 0)
+			free(sink_pads);
+
+		ret = media_get_link_by_sink_pad(media, &sink_pad, &link);
+
+		prev_link_src_pad = link->source;
+		entity->pipe_sink_pad = link->sink;
+
+		src_pad = media_entity_remote_source(link->sink);
+		if (!src_pad)
+			return -EINVAL;
+
+		entity = src_pad->entity;
+	}
+
+	media->pipeline = pipe_head;
+
+	return 0;
+
+err_check_sink_pads:
+	free(sink_pads);
+	return -EINVAL;
+}
+
+int media_has_pipeline_entity(struct media_entity *pipeline, char *entity_name)
+{
+	if (pipeline == NULL || entity_name == NULL)
+		return -EINVAL;
+
+	while (pipeline) {
+		if (!strcmp(pipeline->info.name, entity_name))
+			return 1;
+		pipeline = pipeline->next;
+	}
+
+	return 0;
+}
+
+int media_open_pipeline_subdevs(struct media_device *media)
+{
+	struct media_entity *entity = media->pipeline;
+
+	if (entity == NULL)
+		return 0;
+
+	while (entity->next) {
+		media_dbg(media, "Opening sub-device: %s\n", entity->devname);
+		entity->fd = open(entity->devname, O_RDWR);
+
+		if (entity->fd < 0) {
+			media_dbg(media, "Could not open device %s", entity->devname);
+			goto err_open_subdev;
+		}
+
+		entity = entity->next;
+	}
+
+	return 0;
+
+err_open_subdev:
+	media_close_pipeline_subdevs(media);
+
+	return -EINVAL;
+}
+
+void media_close_pipeline_subdevs(struct media_device *media)
+{
+	struct media_entity *entity = media->pipeline;
+
+	if (entity == NULL)
+		return;
+
+	while (entity->next) {
+		if (entity->fd >= 0) {
+			media_dbg(media, "Closing sub-device: %s\n", entity->devname);
+			close(entity->fd);
+		} else {
+			break;
+		}
+
+		entity->fd = -1;
+		entity = entity->next;
+	}
+}
+
+/* -----------------------------------------------------------------------------
  * Media entity access
  */
 
+struct media_entity *media_get_pipeline(struct media_device *media)
+{
+	return media->pipeline;
+}
+
+int media_entity_get_src_pad_index(struct media_entity *entity)
+{
+	return entity->pipe_src_pad->index;
+}
+
+int media_entity_get_sink_pad_index(struct media_entity *entity)
+{
+	return entity->pipe_sink_pad->index;
+}
+
 int media_entity_get_fd(struct media_entity *entity)
 {
 	return entity->fd;
@@ -1266,3 +1422,13 @@ void media_entity_set_subdev_fmt(struct media_entity *entity,
 {
 	entity->subdev_fmt = *fmt;
 }
+
+struct media_entity *media_entity_get_next(struct media_entity *entity)
+{
+	return entity->next;
+}
+
+void media_entity_set_next(struct media_entity *entity, struct media_entity *next)
+{
+	entity->next = next;
+}
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index b2c466b..0866491 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -35,10 +35,15 @@ struct media_entity {
 	unsigned int max_links;
 	unsigned int num_links;
 
+	struct media_pad *pipe_src_pad;
+	struct media_pad *pipe_sink_pad;
+
 	struct v4l2_subdev_format subdev_fmt;
 
 	char devname[32];
 	int fd;
+
+	struct media_entity *next;
 };
 
 struct media_device {
@@ -49,6 +54,7 @@ struct media_device {
 	struct media_device_info info;
 	struct media_entity *entities;
 	unsigned int entities_count;
+	struct media_entity *pipeline;
 
 	struct media_v4l2_ctrl_to_subdev *ctrl_to_subdev;
 	unsigned int ctrl_to_subdev_count;
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index d28b0a8..459345a 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -582,6 +582,32 @@ int media_get_pad_by_index(struct media_pad *pads, int num_pads,
 				int index, struct media_pad *out_pad);
 
 /**
+ * @brief Check presence of the entity in the pipeline
+ * @param pipeline - video pipeline within a media device
+ * @param entity_name - name of the entity to search for
+ *
+ * Check if the entity with entity_name belongs to
+ * the pipeline.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_has_pipeline_entity(struct media_entity *pipeline, char *entity_name);
+
+/**
+ * @brief Discover the video pipeline
+ * @param media - media device
+ * @param entity - media entity
+ *
+ * Discover the pipeline of sub-devices, by walking
+ * upstream starting from the passed sink entity until
+ * the camera sensor entity is encountered.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_discover_pipeline_by_entity(struct media_device *media,
+				struct media_entity *entity);
+
+/**
  * @brief Get source pad of the pipeline entity
  * @param entity - media entity
  *
@@ -623,4 +649,57 @@ int media_entity_get_fd(struct media_entity *entity);
 void media_entity_set_subdev_fmt(struct media_entity *entity,
 				struct v4l2_subdev_format *fmt);
 
+/**
+ * @brief Get next entity in the pipeline
+ * @param entity - media entity
+ *
+ * This function gets the entity connected to a
+ * source pad of this entity.
+ *
+ * @return next enetity in the pipeline,
+ *	   or NULL if the entity is not linked
+ */
+struct media_entity *media_entity_get_next(struct media_entity *entity);
+
+/**
+ * @brief Set next entity in the pipeline
+ * @param entity - media entity
+ * @param next - the entity to add
+ *
+ * This function adds a new entity to the pipeline.
+ */
+void media_entity_set_next(struct media_entity *entity, struct media_entity *next);
+
+/**
+ * @brief Get the video pipeline
+ * @param media - media device
+ *
+ * This function gets the pipeline of media entities. The pipeline
+ * source entity is a camera sensor and the sink one is the entity
+ * representing opened video device node. The pipeline has to be
+ * discovered with use of the function media_discover_pipeline_by_entity.
+ *
+ * @return first media_entity in the pipeline,
+ *	   or NULL if the pipeline hasn't been discovered
+ */
+struct media_entity *media_get_pipeline(struct media_device *media);
+
+/**
+ * @brief Open pipeline sub-devices
+ * @param media - media device
+ *
+ * Open all sub-devices in the pipeline.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_open_pipeline_subdevs(struct media_device *media);
+
+/**
+ * @brief Close pipeline sub-devices
+ * @param media - media device
+ *
+ * Close all sub-devices in the pipeline.
+ */
+void media_close_pipeline_subdevs(struct media_device *media);
+
 #endif
-- 
1.7.9.5

