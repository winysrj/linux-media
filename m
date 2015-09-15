Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36260 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbIOKdE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 06:33:04 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v4 1/2] [media] media-device: check before unregister if mdev was registered
Date: Tue, 15 Sep 2015 12:32:26 +0200
Message-Id: <1442313147-24566-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1442313147-24566-1-git-send-email-javier@osg.samsung.com>
References: <1442313147-24566-1-git-send-email-javier@osg.samsung.com>
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

Changes in v4: None
Changes in v3: None
Changes in v2:
- Reword the documentation for media_device_unregister(). Suggested by Sakari.
- Added Sakari's Acked-by tag for patch #1.

 drivers/media/media-device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1312e93ebd6e..47d09ffe6a9b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -574,6 +574,8 @@ EXPORT_SYMBOL_GPL(__media_device_register);
  * media_device_unregister - unregister a media device
  * @mdev:	The media device
  *
+ * It is safe to call this function on an unregistered
+ * (but initialised) media device.
  */
 void media_device_unregister(struct media_device *mdev)
 {
@@ -582,6 +584,10 @@ void media_device_unregister(struct media_device *mdev)
 	struct media_link *link, *tmp_link;
 	struct media_interface *intf, *tmp_intf;
 
+	/* Check if mdev was ever registered at all */
+	if (!media_devnode_is_registered(&mdev->devnode))
+		return;
+
 	/* Remove interface links from the media device */
 	list_for_each_entry_safe(link, tmp_link, &mdev->links,
 				 graph_obj.list) {
-- 
2.4.3

