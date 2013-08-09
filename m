Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54864 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031428Ab3HIXC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:26 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 03/19] video: display: Add video and stream control operations
Date: Sat, 10 Aug 2013 01:03:02 +0200
Message-Id: <1376089398-13322-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video and stream control operations handle video stream management,
both from the control point of view (called in response to userspace
requests) and the video stream point of view (called by entities to
control the video stream they receive on their input(s)).

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/display-core.c | 82 ++++++++++++++++++++++++++++++++++++
 include/video/display.h              | 49 +++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
index 82fc58b..bb18723 100644
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -25,6 +25,57 @@
  */
 
 /**
+ * display_entity_set_state - Set the display entity operation state
+ * @entity: The display entity
+ * @state: Display entity operation state
+ *
+ * See &enum display_entity_state for information regarding the entity states.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_state(struct display_entity *entity,
+			     enum display_entity_state state)
+{
+	int ret;
+
+	if (entity->state == state)
+		return 0;
+
+	if (!entity->ops->ctrl || !entity->ops->ctrl->set_state)
+		return 0;
+
+	ret = entity->ops->ctrl->set_state(entity, state);
+	if (ret < 0)
+		return ret;
+
+	entity->state = state;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_set_state);
+
+/**
+ * display_entity_update - Update the display
+ * @entity: The display entity
+ *
+ * Make the display entity ready to receive pixel data and start frame transfer.
+ * This operation can only be called if the display entity is in STANDBY or ON
+ * state.
+ *
+ * The display entity will call the upstream entity in the video chain to start
+ * the video stream.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_update(struct display_entity *entity)
+{
+	if (!entity->ops->ctrl || !entity->ops->ctrl->update)
+		return 0;
+
+	return entity->ops->ctrl->update(entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_update);
+
+/**
  * display_entity_get_modes - Get video modes supported by the display entity
  * @entity: The display entity
  * @port: The display entity port
@@ -95,6 +146,36 @@ int display_entity_get_params(struct display_entity *entity, unsigned int port,
 EXPORT_SYMBOL_GPL(display_entity_get_params);
 
 /* -----------------------------------------------------------------------------
+ * Video operations
+ */
+
+/**
+ * display_entity_set_stream - Control the video stream state
+ * @entity: The display entity
+ * @port: The display entity port
+ * @state: Display video stream state
+ *
+ * Control the video stream state at the entity video output.
+ *
+ * See &enum display_entity_stream_state for information regarding the stream
+ * states.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_stream(struct display_entity *entity, unsigned int port,
+			      enum display_entity_stream_state state)
+{
+	if (port >= entity->entity.num_pads)
+		return -EINVAL;
+
+	if (!entity->ops->video || !entity->ops->video->set_stream)
+		return 0;
+
+	return entity->ops->video->set_stream(entity, port, state);
+}
+EXPORT_SYMBOL_GPL(display_entity_set_stream);
+
+/* -----------------------------------------------------------------------------
  * Connections
  */
 
@@ -177,6 +258,7 @@ int display_entity_init(struct display_entity *entity, unsigned int num_sinks,
 	int ret;
 
 	kref_init(&entity->ref);
+	entity->state = DISPLAY_ENTITY_STATE_OFF;
 
 	num_pads = num_sinks + num_sources;
 	pads = kzalloc(sizeof(*pads) * num_pads, GFP_KERNEL);
diff --git a/include/video/display.h b/include/video/display.h
index 74b227d..fef05a68 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -25,6 +25,38 @@
 struct display_entity;
 struct videomode;
 
+/**
+ * enum display_entity_state - State of a display entity
+ * @DISPLAY_ENTITY_STATE_OFF: The entity is turned off completely, possibly
+ *	including its power supplies. Communication with a display entity in
+ *	that state is not possible.
+ * @DISPLAY_ENTITY_STATE_STANDBY: The entity is in a low-power state. Full
+ *	communication with the display entity is supported, including pixel data
+ *	transfer, but the output is kept blanked.
+ * @DISPLAY_ENTITY_STATE_ON: The entity is fully operational.
+ */
+enum display_entity_state {
+	DISPLAY_ENTITY_STATE_OFF,
+	DISPLAY_ENTITY_STATE_STANDBY,
+	DISPLAY_ENTITY_STATE_ON,
+};
+
+/**
+ * enum display_entity_stream_state - State of a video stream
+ * @DISPLAY_ENTITY_STREAM_STOPPED: The video stream is stopped, no frames are
+ *	transferred.
+ * @DISPLAY_ENTITY_STREAM_SINGLE_SHOT: The video stream has been started for
+ *      single shot operation. The source entity will transfer a single frame
+ *      and then stop.
+ * @DISPLAY_ENTITY_STREAM_CONTINUOUS: The video stream is running, frames are
+ *	transferred continuously by the source entity.
+ */
+enum display_entity_stream_state {
+	DISPLAY_ENTITY_STREAM_STOPPED,
+	DISPLAY_ENTITY_STREAM_SINGLE_SHOT,
+	DISPLAY_ENTITY_STREAM_CONTINUOUS,
+};
+
 enum display_entity_interface_type {
 	DISPLAY_ENTITY_INTERFACE_DPI,
 	DISPLAY_ENTITY_INTERFACE_DBI,
@@ -39,6 +71,9 @@ struct display_entity_interface_params {
 struct display_entity_control_ops {
 	int (*get_size)(struct display_entity *ent,
 			unsigned int *width, unsigned int *height);
+	int (*set_state)(struct display_entity *ent,
+			 enum display_entity_state state);
+	int (*update)(struct display_entity *ent);
 
 	/* Port operations */
 	int (*get_modes)(struct display_entity *entity, unsigned int port,
@@ -47,8 +82,14 @@ struct display_entity_control_ops {
 			  struct display_entity_interface_params *params);
 };
 
+struct display_entity_video_ops {
+	int (*set_stream)(struct display_entity *ent, unsigned int port,
+			  enum display_entity_stream_state state);
+};
+
 struct display_entity_ops {
 	const struct display_entity_control_ops *ctrl;
+	const struct display_entity_video_ops *video;
 };
 
 struct display_entity {
@@ -63,6 +104,8 @@ struct display_entity {
 	const struct display_entity_ops *ops;
 
 	void(*release)(struct display_entity *ent);
+
+	enum display_entity_state state;
 };
 
 static inline struct display_entity *
@@ -86,9 +129,15 @@ void display_entity_put(struct display_entity *entity);
 
 int display_entity_get_size(struct display_entity *entity,
 			    unsigned int *width, unsigned int *height);
+int display_entity_set_state(struct display_entity *entity,
+			     enum display_entity_state state);
+int display_entity_update(struct display_entity *entity);
 int display_entity_get_modes(struct display_entity *entity, unsigned int port,
 			     const struct videomode **modes);
 int display_entity_get_params(struct display_entity *entity, unsigned int port,
 			      struct display_entity_interface_params *params);
 
+int display_entity_set_stream(struct display_entity *entity, unsigned int port,
+			      enum display_entity_stream_state state);
+
 #endif /* __DISPLAY_H__ */
-- 
1.8.1.5

