Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48474 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752328AbeF2HBs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:01:48 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-mem2mem: add name argument to
 v4l2_m2m_register_media_controller()
Message-ID: <5a847697-17fb-5fe5-098b-a0f2f26c1574@xs4all.nl>
Date: Fri, 29 Jun 2018 09:01:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

I added support for this to a codec and I discovered that we are missing a 'name'
argument to v4l2_m2m_register_media_controller(): a typical codec driver has two
m2m video nodes: one for encoding, one for decoding. That works fine, except that
the names of the source, sink and proc entities are the same for both encoder and
decoder node.

So add an extra name argument to help differentiate between the two.

Can you fold this in your v4l2-mem2mem patch?

Thanks!

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 40d4d645e6a6..b3ecd5a41c48 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -76,10 +76,13 @@ struct v4l2_m2m_dev {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_entity	*source;
 	struct media_pad	source_pad;
+	char			*source_name;
 	struct media_entity	sink;
 	struct media_pad	sink_pad;
+	char			*sink_name;
 	struct media_entity	proc;
 	struct media_pad	proc_pads[2];
+	char			*proc_name;
 	struct media_intf_devnode *intf_devnode;
 #endif

@@ -647,33 +650,41 @@ void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
 	media_device_unregister_entity(m2m_dev->source);
 	media_device_unregister_entity(&m2m_dev->sink);
 	media_device_unregister_entity(&m2m_dev->proc);
+	kfree(m2m_dev->source_name);
+	kfree(m2m_dev->sink_name);
+	kfree(m2m_dev->proc_name);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);

 static int v4l2_m2m_register_entity(struct media_device *mdev,
 	struct v4l2_m2m_dev *m2m_dev, enum v4l2_m2m_entity_type type,
-	int function)
+	const char *name, int function)
 {
 	struct media_entity *entity;
 	struct media_pad *pads;
+	char **p_name;
+	unsigned int len;
 	int num_pads;
 	int ret;

 	switch (type) {
 	case MEM2MEM_ENT_TYPE_SOURCE:
 		entity = m2m_dev->source;
+		p_name = &m2m_dev->source_name;
 		pads = &m2m_dev->source_pad;
 		pads[0].flags = MEDIA_PAD_FL_SOURCE;
 		num_pads = 1;
 		break;
 	case MEM2MEM_ENT_TYPE_SINK:
 		entity = &m2m_dev->sink;
+		p_name = &m2m_dev->sink_name;
 		pads = &m2m_dev->sink_pad;
 		pads[0].flags = MEDIA_PAD_FL_SINK;
 		num_pads = 1;
 		break;
 	case MEM2MEM_ENT_TYPE_PROC:
 		entity = &m2m_dev->proc;
+		p_name = &m2m_dev->proc_name;
 		pads = m2m_dev->proc_pads;
 		pads[0].flags = MEDIA_PAD_FL_SINK;
 		pads[1].flags = MEDIA_PAD_FL_SOURCE;
@@ -683,8 +694,11 @@ static int v4l2_m2m_register_entity(struct media_device *mdev,
 		return -EINVAL;
 	}

+	len = strlen(name) + 2 + strlen(m2m_entity_name[type]);
 	entity->obj_type = MEDIA_ENTITY_TYPE_BASE;
-	entity->name = m2m_entity_name[type];
+	*p_name = kmalloc(len, GFP_KERNEL);
+	snprintf(*p_name, len, "%s-%s", name, m2m_entity_name[type]);
+	entity->name = *p_name;
 	entity->function = function;

 	ret = media_entity_pads_init(entity, num_pads, pads);
@@ -698,7 +712,8 @@ static int v4l2_m2m_register_entity(struct media_device *mdev,
 }

 int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
-		struct video_device *vdev, int function)
+		struct video_device *vdev, const char *name,
+		int function)
 {
 	struct media_device *mdev = vdev->v4l2_dev->mdev;
 	struct media_link *link;
@@ -715,15 +730,15 @@ int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
 	/* Create the three entities with their pads */
 	m2m_dev->source = &vdev->entity;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_SOURCE, MEDIA_ENT_F_IO_V4L);
+			MEM2MEM_ENT_TYPE_SOURCE, name, MEDIA_ENT_F_IO_V4L);
 	if (ret)
 		return ret;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_PROC, function);
+			MEM2MEM_ENT_TYPE_PROC, name, function);
 	if (ret)
 		goto err_rel_entity0;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_SINK, MEDIA_ENT_F_IO_V4L);
+			MEM2MEM_ENT_TYPE_SINK, name, MEDIA_ENT_F_IO_V4L);
 	if (ret)
 		goto err_rel_entity1;

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 4c14818c270e..6d52e9c06440 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -332,7 +332,8 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev);
 int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
-			struct video_device *vdev, int function);
+			struct video_device *vdev, const char *name,
+			int function);
 #else
 static inline void
 v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
@@ -341,7 +342,8 @@ v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)

 static inline int
 v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
-		struct video_device *vdev, int function)
+			struct video_device *vdev, const char *name,
+			int function)
 {
 	return 0;
 }
