Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33260 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbdJIKTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 01/24] media: v4l2-dev.h: add kernel-doc to two macros
Date: Mon,  9 Oct 2017 07:19:07 -0300
Message-Id: <2169c19a54e142dcdba99d7c9011552944c74c84.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two macros at v4l2-dev.h that aren't documented.

Document them, for completeness.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-dev.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index e657614521e3..de1a1453cfd9 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -260,9 +260,21 @@ struct video_device
 	struct mutex *lock;
 };
 
-#define media_entity_to_video_device(__e) \
-	container_of(__e, struct video_device, entity)
-/* dev to video-device */
+/**
+ * media_entity_to_video_device - Returns a &struct video_device from
+ * 	the &struct media_entity embedded on it.
+ *
+ * @entity: pointer to &struct media_entity
+ */
+#define media_entity_to_video_device(entity) \
+	container_of(entity, struct video_device, entity)
+
+/**
+ * media_entity_to_video_device - Returns a &struct video_device from
+ * 	the &struct device embedded on it.
+ *
+ * @cd: pointer to &struct device
+ */
 #define to_video_device(cd) container_of(cd, struct video_device, dev)
 
 /**
-- 
2.13.6
