Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31442 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaKUQPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:21 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE00GWGD5KL030@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:15:20 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 08/11] mediactl: Add support for media device pipelines
Date: Fri, 21 Nov 2014 17:14:37 +0100
Message-id: <1416586480-19982-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add infrastructure for linking media entities,
discovering pipelines of media entities and
opening/closing all sub-devices in the pipeline
at one go.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |  168 +++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/libv4l2subdev.c |  109 +++++++++++++++++++++++++
 utils/media-ctl/mediactl-priv.h |    7 ++
 utils/media-ctl/mediactl.h      |   70 ++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   42 ++++++++++
 5 files changed, 396 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 9c81711..003902b 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -1243,9 +1243,172 @@ int media_parse_setup_links(struct media_device *media, const char *p)
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
+	struct media_link *link = NULL;
+	int num_sink_pads, ret;
+
+	if (entity == NULL)
+		return -EINVAL;
+
+	for (;;) {
+		/* Make recently discovered entity the pipeline head */
+		if (pipe_head == NULL) {
+			pipe_head = entity;
+		} else {
+			entity->next = pipe_head;
+			pipe_head = entity;
+		}
+
+		/* Cache a source pad used for linking the entity */
+		if (link)
+			entity->pipe_src_pad = link->source;
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
+
+		free(sink_pads);
+
+		ret = media_get_link_by_sink_pad(media, &sink_pad, &link);
+		if (ret < 0)
+			return -EINVAL;
+
+		/* Cache a sink pad used for linking the entity */
+		entity->pipe_sink_pad = link->sink;
+
+		media_dbg(media, "Discovered sink pad %d for the %s entity\n",
+			  entity->pipe_sink_pad->index, media_entity_get_name(entity));
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
+		entity->sd->fd = open(entity->devname, O_RDWR);
+
+		if (entity->sd->fd < 0) {
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
+		if (entity->sd->fd >= 0) {
+			media_dbg(media, "Closing sub-device: %s\n", entity->devname);
+			close(entity->sd->fd);
+		} else {
+			break;
+		}
+
+		entity->sd->fd = -1;
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
 	return entity->sd->fd;
@@ -1255,3 +1418,8 @@ void media_entity_set_fd(struct media_entity *entity, int fd)
 {
 	entity->sd->fd = fd;
 }
+
+struct media_entity *media_entity_get_next(struct media_entity *entity)
+{
+	return entity->next;
+}
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index a96ed7a..458923b 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -108,6 +108,67 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	return 0;
 }
 
+int v4l2_subdev_apply_pipeline_fmt(struct media_device *media,
+				   struct v4l2_format *fmt)
+{
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 };
+	struct media_entity *entity = media->pipeline;
+	struct media_pad *pad;
+	int ret;
+
+	while (entity) {
+		/*
+		 * Source entity is linked only through a source pad
+		 * and this pad should be used for setting the format.
+		 * For other entities set the format on a sink pad.
+		 */
+		pad = entity->pipe_sink_pad ? entity->pipe_sink_pad :
+					      entity->pipe_src_pad;
+		if (pad == NULL)
+			return -EINVAL;
+
+		ret = v4l2_subdev_get_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_TRY);
+
+		if (ret < 0)
+			return ret;
+
+		media_dbg(media, "Format read from entity pad %s:%d: mbus_code: %s, width: %d, height: %d\n",
+			  media_entity_get_name(entity), pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  mbus_fmt.width, mbus_fmt.height);
+
+		ret = v4l2_subdev_set_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_ACTIVE);
+		if (ret < 0)
+			return ret;
+
+		media_dbg(media, "Format set on the entity pad %s:%d: mbus_code: %s, width: %d, height: %d\n",
+			  media_entity_get_name(entity), pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  mbus_fmt.width, mbus_fmt.height);
+
+		entity = entity->next;
+
+		/* Last entity in the pipeline is not a sub-device */
+		if (entity->next == NULL)
+			break;
+	}
+
+	/*
+	 * Sink entity represents a video device node and is not
+	 * a sub-device. Nonetheless because it has associated
+	 * file descriptor and can expose v4l2-controls the
+	 * v4l2-subdev structure is used for caching the
+	 * related data.
+	 */
+	ret = ioctl(entity->sd->fd, VIDIOC_S_FMT, fmt);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 int v4l2_subdev_get_selection(struct media_entity *entity,
 	struct v4l2_rect *rect, unsigned int pad, unsigned int target,
 	enum v4l2_subdev_format_whence which)
@@ -801,6 +862,40 @@ done:
 	return 0;
 }
 
+int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		printf("width mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		printf("height mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		printf("mbus code mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		printf("field mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		printf("colorspace mismatch\n");
+		return 0;
+	}
+
+	return 1;
+}
+
 bool v4l2_subdev_has_v4l2_control(struct media_device *media,
 				  struct media_entity *entity,
 				  int ctrl_id)
@@ -814,3 +909,17 @@ bool v4l2_subdev_has_v4l2_control(struct media_device *media,
 
 	return false;
 }
+
+struct media_entity *v4l2_subdev_get_pipeline_entity_by_cid(struct media_device *media,
+						int cid)
+{
+	struct media_entity *entity = media->pipeline;
+
+	while (entity) {
+		if (v4l2_subdev_has_v4l2_control(media, entity, cid))
+			return entity;
+		entity = entity->next;
+	}
+
+	return NULL;
+}
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index fbf1989..0878776 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -34,9 +34,14 @@ struct media_entity {
 	unsigned int max_links;
 	unsigned int num_links;
 
+	struct media_pad *pipe_src_pad;
+	struct media_pad *pipe_sink_pad;
+
 	struct v4l2_subdev *sd;
 
 	char devname[32];
+
+	struct media_entity *next;
 };
 
 struct v4l2_subdev {
@@ -54,6 +59,8 @@ struct media_device {
 	struct media_device_info info;
 	struct media_entity *entities;
 	unsigned int entities_count;
+	struct media_entity *pipeline;
+
 
 	void (*debug_handler)(void *, ...);
 	void *debug_priv;
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 7f16097..b0451b2 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -565,6 +565,32 @@ int media_get_pad_by_index(struct media_pad *pads, int num_pads,
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
@@ -606,4 +632,48 @@ int media_entity_get_fd(struct media_entity *entity);
  */
 void media_entity_set_fd(struct media_entity *entity, int fd);
 
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
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index ac98b61..bae53f0 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -89,6 +89,21 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	enum v4l2_subdev_format_whence which);
 
 /**
+ * @brief Set media device pipeline format
+ * @param entity - media entity
+ * @param fmt - negotiated format
+ *
+ * Set the active format on all the pipeline entities.
+ * The format has to be at first negotiated with VIDIOC_SUBDEV_S_FMT
+ * by struct v4l2_subdev_format's 'whence' property set to
+ * V4L2_SUBDEV_FORMAT_TRY.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_apply_pipeline_fmt(struct media_device *media,
+				   struct v4l2_format *fmt);
+
+/**
  * @brief Retrieve a selection rectangle on a pad.
  * @param entity - subdev-device media entity.
  * @param r - rectangle to be filled.
@@ -271,6 +286,18 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 	struct media_entity *entity, __u32 ctrl_id);
 
 /**
+ * @brief Compare mbus formats
+ * @param fmt1 - 1st mbus format to compare
+ * @param fmt2 - 2nd mbus format to compare
+ *
+ * Check whether two mbus formats are compatible.
+ *
+ * @return 1 if formats are compatible, 0 otherwise
+ */
+int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
+	struct v4l2_mbus_framefmt *fmt2);
+
+/**
  * @brief Check if the sub-device has a validated control
  * @param media - media device.
  * @param entity - subdev-device media entity.
@@ -283,4 +310,19 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 bool v4l2_subdev_has_v4l2_control(struct media_device *media,
 	struct media_entity *entity, int ctrl_id);
 
+/**
+ * @brief Get the first pipeline entity supporting the control
+ * @param media - media device
+ * @param cid - v4l2 control identifier
+ *
+ * Get the first entity in the media device pipeline,
+ * on which the ctrl with cid has been validated.
+ *
+ * @return associated entity if defined, or NULL when the
+ *	   control hasn't been validated on any entity
+ *	   in the pipeline
+ */
+struct media_entity *v4l2_subdev_get_pipeline_entity_by_cid(
+	struct media_device *media, int cid);
+
 #endif
-- 
1.7.9.5

