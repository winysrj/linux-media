Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33736 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcCJFHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 00:07:15 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] media: add change_source handler function pointer
Date: Wed,  9 Mar 2016 22:07:07 -0700
Message-Id: <779a882295f11b1a7ab1ac4851f467f2d1b3470d.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add change_source handler function pointer to struct media_device. Using
the change_source handler, driver can disable current source and enable
new one in one step when user selects a new input.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index df74cfa..d9867ed 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -309,9 +309,11 @@ struct media_entity_notify {
  * @pm_count_walk: Graph walk for power state walk. Access serialised using
  *		   graph_mutex.
  *
- * @source_priv: Driver Private data for enable/disable source handlers
+ * @source_priv: Driver Private data for enable/disable/change source
+ *		 handlers
  * @enable_source: Enable Source Handler function pointer
  * @disable_source: Disable Source Handler function pointer
+ * @change_source: Change Source Handler function pointer
  *
  * @link_notify: Link state change notification callback
  *
@@ -326,14 +328,22 @@ struct media_entity_notify {
  * be unique.
  *
  * @enable_source is a handler to find source entity for the
- * sink entity  and activate the link between them if source
+ * sink entity and activate the link between them if source
  * entity is free. Drivers should call this handler before
  * accessing the source.
  *
  * @disable_source is a handler to find source entity for the
- * sink entity  and deactivate the link between them. Drivers
+ * sink entity and deactivate the link between them. Drivers
  * should call this handler to release the source.
  *
+ * @change_source is a handler to find source entity for the
+ * sink entity and deactivate the link between them. Once the
+ * existing link is deactivated, it will find and activate the
+ * source for the sink for the newly selected input. Drivers
+ * should call this handler to change the source when user
+ * changes input. Using change_source helps not loose the hold
+ * on the media resource when a new input is selected.
+ *
  * Note: Bridge driver is expected to implement and set the
  * handler when media_device is registered or when
  * bridge driver finds the media_device during probe.
@@ -381,6 +391,8 @@ struct media_device {
 	int (*enable_source)(struct media_entity *entity,
 			     struct media_pipeline *pipe);
 	void (*disable_source)(struct media_entity *entity);
+	int (*change_source)(struct media_entity *entity,
+			     struct media_pipeline *pipe);
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
-- 
2.5.0

