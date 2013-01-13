Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3AMMah (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 07:30:37 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGK007KKDEY6Y20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:35 +0900 (KST)
Received: from chrome-ubuntu.sisodomain.com ([107.108.73.106])
 by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MGK00B86DEGTC60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:35 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	inki.dae@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH 1/4] video: display: add event handling,
 set mode and hdmi ops to cdf core
Date: Sun, 13 Jan 2013 07:52:11 -0500
Message-id: <1358081534-21372-2-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
References: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds
1) Event Notification to CDF Core:
	Adds simple event notification mechanism supports multiple
	subscribers. This is used for hot-plug notification to the clients
	of hdmi display i.e. exynos-drm and alsa-codec. CDF Core maintains
	multiple subscriber list. When entity reports a event Core will
	route it to all of them. Un-superscription is not implemented which
	can be done if notification callback is Null.

2) set_mode to generic ops:
	It is meaningful for a panel like hdmi which supports multiple
	resolutions.

3) Provision for platform specific interfaces through void *private in display
entity:

	It has added void *private to display entity which can be used to
	expose interfaces which are very much specific to a particular platform.

	In exynos, hpd is connected to the soc via gpio bus. During initial
	hdmi poweron, hpd interrupt is not raised as there is no change in the
	gpio status. This is solved by providing a platform specific interface
	which is queried by the drm to get the hpd state. This interface may
	not be required by all platforms.

4) hdmi ops:
	get_edid: to query raw EDID data and length from the panel.
	check_mode: To check if a given mode is supported by exynos HDMI IP
			"AND" Connected HDMI Sink (tv/monitor).
	init_audio: Configure hdmi audio registers for Audio interface type
	(i2s/ spdif), SF, Audio Channels, BPS.
	set_audiostate: enable disable audio.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/video/display/display-core.c |  85 +++++++++++++++++++++++++++
 include/video/display.h              | 111 ++++++++++++++++++++++++++++++++++-
 2 files changed, 193 insertions(+), 3 deletions(-)
 mode change 100755 => 100644 drivers/video/display/display-core.c
 mode change 100755 => 100644 include/video/display.h

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
old mode 100755
new mode 100644
index 55a7399..12fb882
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -99,6 +99,14 @@ int display_entity_get_modes(struct display_entity *entity,
 }
 EXPORT_SYMBOL_GPL(display_entity_get_modes);
 
+int display_entity_set_mode(struct display_entity *entity,
+		   const struct videomode *mode)
+{
+	if (!entity->opt_ctrl.hdmi || !entity->ops.ctrl->set_mode)
+		return 0;
+	return entity->ops.ctrl->set_mode(entity, mode);
+}
+EXPORT_SYMBOL_GPL(display_entity_set_mode);
 /**
 * display_entity_get_size - Get display entity physical size
 * @entity: The display entity
@@ -140,6 +148,37 @@ int display_entity_get_params(struct display_entity *entity,
 }
 EXPORT_SYMBOL_GPL(display_entity_get_params);
 
+int display_entity_subscribe_event(struct display_entity *entity,
+		struct display_event_subscriber *subscriber)
+{
+	if (!entity || !subscriber || !subscriber->notify)
+		return -EINVAL;
+
+	mutex_lock(&entity->entity_mutex);
+	list_add_tail(&subscriber->list, &entity->list_subscribers);
+	mutex_unlock(&entity->entity_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_subscribe_event);
+
+int display_entity_notify_event_subscriber(struct display_entity *entity,
+		enum display_entity_event_type type, unsigned int value)
+{
+	struct display_event_subscriber *subscriber;
+
+	if (!entity || type < 0)
+		return -EINVAL;
+
+	mutex_lock(&entity->entity_mutex);
+	list_for_each_entry(subscriber, &entity->list_subscribers, list) {
+		subscriber->notify(entity, type, value, subscriber->context);
+	}
+	mutex_unlock(&entity->entity_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_notify_event_subscriber);
+
 /* -----------------------------------------------------------------------------
 * Video operations
 */
@@ -312,6 +351,9 @@ int __must_check __display_entity_register(struct display_entity *entity,
 	kref_init(&entity->ref);
 	entity->owner = owner;
 	entity->state = DISPLAY_ENTITY_STATE_OFF;
+	entity->list_subscribers.next = &entity->list_subscribers;
+	entity->list_subscribers.prev = &entity->list_subscribers;
+	mutex_init(&entity->entity_mutex);
 
 	mutex_lock(&display_entity_mutex);
 	list_add(&entity->list, &display_entity_list);
@@ -357,6 +399,49 @@ void display_entity_unregister(struct display_entity *entity)
 }
 EXPORT_SYMBOL_GPL(display_entity_unregister);
 
+/* -----------------------------------------------------------------------------
+ * Display Entity Hdmi ops
+ */
+
+int display_entity_hdmi_get_edid(struct display_entity *entity,
+			struct display_entity_edid *edid)
+{
+	if (!entity->opt_ctrl.hdmi || !entity->opt_ctrl.hdmi->get_edid)
+		return 0;
+
+	return entity->opt_ctrl.hdmi->get_edid(entity, edid);
+}
+EXPORT_SYMBOL_GPL(display_entity_hdmi_get_edid);
+
+int display_entity_hdmi_check_mode(struct display_entity *entity,
+		   const struct videomode *mode)
+{
+	if (!entity->opt_ctrl.hdmi || !entity->opt_ctrl.hdmi->check_mode)
+		return 0;
+
+	return entity->opt_ctrl.hdmi->check_mode(entity, mode);
+}
+EXPORT_SYMBOL_GPL(display_entity_hdmi_check_mode);
+
+int display_entity_hdmi_init_audio(struct display_entity *entity,
+		const struct display_entity_audio_params *params)
+{
+	if (!entity->opt_ctrl.hdmi || !entity->opt_ctrl.hdmi->init_audio)
+		return 0;
+
+	return entity->opt_ctrl.hdmi->init_audio(entity, params);
+}
+EXPORT_SYMBOL_GPL(display_entity_hdmi_init_audio);
+
+int display_entity_hdmi_set_audiostate(struct display_entity *entity,
+	enum display_entity_audiostate state)
+{
+	if (!entity->opt_ctrl.hdmi || !entity->opt_ctrl.hdmi->set_audiostate)
+		return 0;
+
+	return entity->opt_ctrl.hdmi->set_audiostate(entity, state);
+}
+EXPORT_SYMBOL_GPL(display_entity_hdmi_set_audiostate);
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Display Core");
 MODULE_LICENSE("GPL");
diff --git a/include/video/display.h b/include/video/display.h
old mode 100755
new mode 100644
index 817f4ae..eae373f
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -66,22 +66,64 @@ enum display_entity_stream_state {
 	DISPLAY_ENTITY_STREAM_CONTINUOUS,
 };
 
+enum display_entity_event_type {
+	DISPLAY_ENTITY_HDMI_HOTPLUG,
+};
+
 enum display_entity_interface_type {
 	DISPLAY_ENTITY_INTERFACE_DPI,
+	DISPLAY_ENTITY_INTERFACE_HDMI,
+};
+
+enum display_entity_audio_interface {
+	DISPLAY_ENTITY_AUDIO_I2S,
+	DISPLAY_ENTITY_AUDIO_SPDIF,
+};
+
+enum display_entity_audiostate {
+	DISPLAY_ENTITY_AUDIOSTATE_OFF,
+	DISPLAY_ENTITY_AUDIOSTATE_ON,
 };
 
 struct display_entity_interface_params {
 	enum display_entity_interface_type type;
 };
 
+struct display_event_subscriber {
+	struct list_head list;
+	void(*notify)(struct display_entity *ent,
+		enum display_entity_event_type type,
+		unsigned int value, void *context);
+	void *context;
+};
+
+struct display_entity_edid {
+	u8		*edid;
+	int		len;
+};
+
+struct display_entity_audio_params {
+	enum display_entity_audio_interface	type;
+	int	channels;
+	int	sf;
+	int	bits_per_sample;
+};
+
 struct display_entity_control_ops {
 	int (*set_state)(struct display_entity *ent,
 			enum display_entity_state state);
+
 	int (*update)(struct display_entity *ent);
+
 	int (*get_modes)(struct display_entity *ent,
 			const struct videomode **modes);
+
+	int (*set_mode)(struct display_entity *entity,
+		const struct videomode *modes);
+
 	int (*get_params)(struct display_entity *ent,
 			struct display_entity_interface_params *params);
+
 	int (*get_size)(struct display_entity *ent,
 			unsigned int *width, unsigned int *height);
 };
@@ -91,8 +133,29 @@ struct display_entity_video_ops {
 			enum display_entity_stream_state state);
 };
 
+struct display_entity_hdmi_control_ops {
+
+	int (*get_edid)(struct display_entity *ent,
+		struct display_entity_edid *edid);
+
+	int (*check_mode)(struct display_entity *entity,
+		const struct videomode *modes);
+
+	int (*init_audio)(struct display_entity *entity,
+		const struct display_entity_audio_params *params);
+
+	int (*set_audiostate)(struct display_entity *entity,
+		enum display_entity_audiostate state);
+};
+
+struct display_entity_hdmi_video_ops {
+	int (*get_edid)(struct display_entity *ent,
+			    enum display_entity_stream_state state);
+};
+
 struct display_entity {
 	struct list_head list;
+	struct list_head list_subscribers;
 	struct device *dev;
 	struct module *owner;
 	struct kref ref;
@@ -104,26 +167,51 @@ struct display_entity {
 		const struct display_entity_video_ops *video;
 	} ops;
 
+	union {
+		const struct display_entity_hdmi_control_ops *hdmi;
+	} opt_ctrl;
+
+	union {
+		const struct display_entity_hdmi_video_ops *hdmi;
+	} opt_video;
+
 	void(*release)(struct display_entity *ent);
 
 	enum display_entity_state state;
+	struct mutex	entity_mutex;
+	void		*private;
 };
 
+/* generic display entity ops */
+
 int display_entity_set_state(struct display_entity *entity,
 				enum display_entity_state state);
+
 int display_entity_update(struct display_entity *entity);
+
 int display_entity_get_modes(struct display_entity *entity,
 				const struct videomode **modes);
+
+int display_entity_set_mode(struct display_entity *entity,
+		const struct videomode *modes);
+
 int display_entity_get_params(struct display_entity *entity,
-				struct display_entity_interface_params *params);
+		struct display_entity_interface_params *params);
+
 int display_entity_get_size(struct display_entity *entity,
-			unsigned int *width, unsigned int *height);
+		unsigned int *width, unsigned int *height);
 
 int display_entity_set_stream(struct display_entity *entity,
 				enum display_entity_stream_state state);
 
+int display_entity_subscribe_event(struct display_entity *entity,
+		struct display_event_subscriber *subscriber);
+
+int display_entity_notify_event_subscriber(struct display_entity *entity,
+		enum display_entity_event_type type, unsigned int value);
+
 static inline void display_entity_connect(struct display_entity *source,
-					struct display_entity *sink)
+				struct display_entity *sink)
 {
 	sink->source = source;
 }
@@ -147,4 +235,21 @@ void display_entity_unregister_notifier(struct display_entity_notifier *notifier
 #define display_entity_register(display_entity) \
 	__display_entity_register(display_entity, THIS_MODULE)
 
+/* hdmi ops */
+
+int display_entity_hdmi_get_edid(struct display_entity *entity,
+		struct display_entity_edid *edid);
+
+int display_entity_hdmi_check_mode(struct display_entity *entity,
+		const struct videomode *modes);
+
+int display_entity_hdmi_get_hpdstate(struct display_entity *entity,
+			unsigned int *hpd_state);
+
+int display_entity_hdmi_init_audio(struct display_entity *entity,
+	const struct display_entity_audio_params *params);
+
+int display_entity_hdmi_set_audiostate(struct display_entity *entity,
+	enum display_entity_audiostate state);
+
 #endif /* __DISPLAY_H__ */
-- 
1.8.0

