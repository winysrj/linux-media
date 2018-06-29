Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55258 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933688AbeF2Hwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:52:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] v4l2-mem2mem: set name and major/minor from video_device
Message-ID: <e986cda6-a02e-755b-5399-76da0a8ed4fd@xs4all.nl>
Date: Fri, 29 Jun 2018 09:52:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Codec devices have two m2m devices in the media topology: one
for decoding, one for encoding. Since the entity names were the
same for both, this was invalid. Also the major/minor numbers
were not set for the I/O entities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

Ezequiel, just fold this in your own patch. With this change in place everything
looks good to me.

PS: don't forget to remove the MEM2MEM_ENT_TYPE_MAX in the enum.

Regards,

	Hans

---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 27 +++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 40d4d645e6a6..e8564c39f7d4 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -647,15 +647,20 @@ void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
 	media_device_unregister_entity(m2m_dev->source);
 	media_device_unregister_entity(&m2m_dev->sink);
 	media_device_unregister_entity(&m2m_dev->proc);
+	kfree(m2m_dev->source->name);
+	kfree(m2m_dev->sink.name);
+	kfree(m2m_dev->proc.name);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);

 static int v4l2_m2m_register_entity(struct media_device *mdev,
 	struct v4l2_m2m_dev *m2m_dev, enum v4l2_m2m_entity_type type,
-	int function)
+	struct video_device *vdev, int function)
 {
 	struct media_entity *entity;
 	struct media_pad *pads;
+	char *name;
+	unsigned int len;
 	int num_pads;
 	int ret;

@@ -671,6 +676,8 @@ static int v4l2_m2m_register_entity(struct media_device *mdev,
 		pads = &m2m_dev->sink_pad;
 		pads[0].flags = MEDIA_PAD_FL_SINK;
 		num_pads = 1;
+		entity->info.dev.major = m2m_dev->source->info.dev.major;
+		entity->info.dev.minor = m2m_dev->source->info.dev.minor;
 		break;
 	case MEM2MEM_ENT_TYPE_PROC:
 		entity = &m2m_dev->proc;
@@ -684,7 +691,14 @@ static int v4l2_m2m_register_entity(struct media_device *mdev,
 	}

 	entity->obj_type = MEDIA_ENTITY_TYPE_BASE;
-	entity->name = m2m_entity_name[type];
+	entity->info.dev.major = VIDEO_MAJOR;
+	entity->info.dev.minor = vdev->minor;
+	len = strlen(vdev->name) + 2 + strlen(m2m_entity_name[type]);
+	name = kmalloc(len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	snprintf(name, len, "%s-%s", vdev->name, m2m_entity_name[type]);
+	entity->name = name;
 	entity->function = function;

 	ret = media_entity_pads_init(entity, num_pads, pads);
@@ -715,15 +729,15 @@ int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
 	/* Create the three entities with their pads */
 	m2m_dev->source = &vdev->entity;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_SOURCE, MEDIA_ENT_F_IO_V4L);
+			MEM2MEM_ENT_TYPE_SOURCE, vdev, MEDIA_ENT_F_IO_V4L);
 	if (ret)
 		return ret;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_PROC, function);
+			MEM2MEM_ENT_TYPE_PROC, vdev, function);
 	if (ret)
 		goto err_rel_entity0;
 	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
-			MEM2MEM_ENT_TYPE_SINK, MEDIA_ENT_F_IO_V4L);
+			MEM2MEM_ENT_TYPE_SINK, vdev, MEDIA_ENT_F_IO_V4L);
 	if (ret)
 		goto err_rel_entity1;

@@ -774,10 +788,13 @@ int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
 	media_entity_remove_links(m2m_dev->source);
 err_rel_entity2:
 	media_device_unregister_entity(&m2m_dev->proc);
+	kfree(m2m_dev->proc.name);
 err_rel_entity1:
 	media_device_unregister_entity(&m2m_dev->sink);
+	kfree(m2m_dev->sink.name);
 err_rel_entity0:
 	media_device_unregister_entity(m2m_dev->source);
+	kfree(m2m_dev->source->name);
 	return ret;
 	return 0;
 }
-- 
2.17.0
