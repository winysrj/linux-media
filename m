Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbHWUSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-api@vger.kernel.org
Subject: [PATCH v7 34/44] [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
Date: Sun, 23 Aug 2015 17:17:51 -0300
Message-Id: <f7240933f9d81317ee70210fdeb1a6b13024e1eb.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
new subdev entities as MEDIA_ENT_T_UNKNOWN.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 60da43772de9..07600daf5490 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -584,7 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->host_priv = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	sd->entity.name = sd->name;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_UNKNOWN;
 #endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 7306aeaff807..e9e7ad268a7e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -42,6 +42,14 @@ struct media_device_info {
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
 
+/* Used values for media_entity_desc::type */
+
+/*
+ * Initial value when an entity is created
+ * Drivers should change it to something useful
+ */
+#define MEDIA_ENT_T_UNKNOWN	0x00000000
+
 /*
  * Base numbers for entity types
  *
@@ -52,7 +60,7 @@ struct media_device_info {
  * However, It is kept this way just to avoid binary breakages with the
  * namespace provided on legacy versions of this header.
  */
-#define MEDIA_ENT_T_DVB_BASE		0x00000000
+#define MEDIA_ENT_T_DVB_BASE		0x00000001
 #define MEDIA_ENT_T_V4L2_BASE		0x00010000
 #define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
 
-- 
2.4.3

