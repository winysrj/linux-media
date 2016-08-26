Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54128 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754712AbcHZXoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 13/21] media device: Deprecate media_device_{init,cleanup}() for drivers
Date: Sat, 27 Aug 2016 02:43:21 +0300
Message-Id: <1472255009-28719-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers should no longer directly allocate media_device but rely on
media_device_alloc(), media_device_get() and media_device_put() instead.
Deprecate media_device_init() and media_device_cleanup().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-device.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index d29dec7..a3d8dd4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -193,6 +193,10 @@ static inline __must_check int media_entity_enum_init(
  * So drivers need to first initialize the media device, register any entity
  * within the media device, create pad to pad links and then finally register
  * the media device by calling media_device_register() as a final step.
+ *
+ * Note that using this function in drivers is DEPRECATED. New drivers
+ * must use media_device_alloc() and manage references using
+ * media_device_get() and media_device_put() instead.
  */
 void media_device_init(struct media_device *mdev);
 
@@ -241,6 +245,10 @@ struct media_device *media_device_alloc(struct device *dev);
  *
  * This function that will destroy the graph_mutex that is
  * initialized in media_device_init().
+ *
+ * Note that using this function in drivers is DEPRECATED. New drivers
+ * must use media_device_alloc() and manage references using
+ * media_device_get() and media_device_put() instead.
  */
 void media_device_cleanup(struct media_device *mdev);
 
-- 
2.1.4

