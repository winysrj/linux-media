Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38057 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbbLKW5Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 17:57:25 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v5 1/3] [media] media-device: check before unregister if mdev was registered
Date: Fri, 11 Dec 2015 19:57:07 -0300
Message-Id: <1449874629-8973-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
References: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most media functions that unregister, check if the corresponding register
function succeed before. So these functions can safely be called even if a
registration was never made or the component as already been unregistered.

Add the same check to media_device_unregister() function for consistency.

This will also allow to split the media_device_register() function in an
initialization and registration functions without the need to change the
generic cleanup functions and error code paths for all the media drivers.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2:
- Reword the documentation for media_device_unregister(). Suggested by Sakari.
- Added Sakari's Acked-by tag for patch #1.

 drivers/media/media-device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c12481c753a0..11c1c7383361 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -577,6 +577,8 @@ EXPORT_SYMBOL_GPL(__media_device_register);
  * media_device_unregister - unregister a media device
  * @mdev:	The media device
  *
+ * It is safe to call this function on an unregistered
+ * (but initialised) media device.
  */
 void media_device_unregister(struct media_device *mdev)
 {
@@ -584,6 +586,10 @@ void media_device_unregister(struct media_device *mdev)
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
 
+	/* Check if mdev was ever registered at all */
+	if (!media_devnode_is_registered(&mdev->devnode))
+		return;
+
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		media_device_unregister_entity(entity);
-- 
2.4.3

