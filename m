Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35441 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbcCCHhT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 02:37:19 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-mc.h: fix compiler warnings
Message-ID: <56D7E9AA.90304@xs4all.nl>
Date: Thu, 3 Mar 2016 08:37:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix these warnings when CONFIG_MEDIA_CONTROLLER is not defined:

In file included from /home/hans/work/build/media-git/drivers/media/v4l2-core/v4l2-fh.c:32:0:
/home/hans/work/build/media-git/include/media/v4l2-mc.h:173:12: warning: 'v4l_enable_media_source' defined but not used [-Wunused-function]
 static int v4l_enable_media_source(struct video_device *vdev)
            ^
/home/hans/work/build/media-git/include/media/v4l2-mc.h:183:12: warning: 'v4l_vb2q_enable_media_source' defined but not used [-Wunused-function]
 static int v4l_vb2q_enable_media_source(struct vb2_queue *q)
            ^
In file included from /home/hans/work/build/media-git/include/media/tuner.h:23:0,
                 from /home/hans/work/build/media-git/drivers/media/tuners/tuner-types.c:9:
/home/hans/work/build/media-git/include/media/v4l2-mc.h:173:12: warning: 'v4l_enable_media_source' defined but not used [-Wunused-function]
 static int v4l_enable_media_source(struct video_device *vdev)
            ^
/home/hans/work/build/media-git/include/media/v4l2-mc.h:178:13: warning: 'v4l_disable_media_source' defined but not used [-Wunused-function]
 static void v4l_disable_media_source(struct video_device *vdev)
             ^


Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

Please test without CONFIG_MEDIA_CONTROLLER or at least check the daily build results!
This is the second time I have to clean up a mistake in this header.

Regards,

	Hans

---
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 5cbc209..311885e 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -170,17 +170,17 @@ static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
 	return 0;
 }

-static int v4l_enable_media_source(struct video_device *vdev)
+static inline int v4l_enable_media_source(struct video_device *vdev)
 {
 	return 0;
 }

-static void v4l_disable_media_source(struct video_device *vdev)
+static inline void v4l_disable_media_source(struct video_device *vdev)
 {
 	return;
 }

-static int v4l_vb2q_enable_media_source(struct vb2_queue *q)
+static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 {
 	return 0;
 }
