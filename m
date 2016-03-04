Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58230 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbcCDIrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 03:47:03 -0500
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id C6A3C1809C5
	for <linux-media@vger.kernel.org>; Fri,  4 Mar 2016 09:46:58 +0100 (CET)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-mc.h: fix yet more compiler errors
Message-ID: <56D94B82.4050305@xs4all.nl>
Date: Fri, 4 Mar 2016 09:46:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove spurious return, remove copy-and-pasted semi-colons, add static inline.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

Third time in quick succession that these stubs are messed up. Please do a build
without CONFIG_MEDIA_CONTROLLER before merging!

---
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 96cfca9..98a938a 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -221,7 +221,6 @@ static inline int v4l_enable_media_source(struct video_device *vdev)

 static inline void v4l_disable_media_source(struct video_device *vdev)
 {
-	return;
 }

 static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
@@ -229,13 +228,13 @@ static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 	return 0;
 }

-int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
+static inline int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 {
 	return 0;
 }

-int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
-			      unsigned int notification);
+static inline int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
+					    unsigned int notification)
 {
 	return 0;
 }
