Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40481 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179AbcGNWfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 10/16] media: Document media device allocation API
Date: Fri, 15 Jul 2016 01:35:05 +0300
Message-Id: <1468535711-13836-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the addition of the media_device_alloc() function to allocate a
media device. Also, document how reference counting and releasing a media
device works.

Deprecate API elements which are no longer needed with dynamically
allocated media devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-device.h | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 34671e1..5243737 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -61,16 +61,28 @@
  *
  * * Media device:
  *
- * A media device is represented by a struct &media_device instance, defined in
- * include/media/media-device.h. Allocation of the structure is handled by the
- * media device driver, usually by embedding the &media_device instance in a
- * larger driver-specific structure.
+ * A media device is represented by a struct &media_device instance,
+ * defined in include/media/media-device.h. The memory for a media
+ * device is allocated using media_device_alloc() function.
+ * media_device_alloc() may also be used to allocate extra memory for
+ * driver's purpose. media_device_priv() may be used to obtain a
+ * driver's private pointer related to a media device. The two are
+ * intended as alternatives, whichever serves the purpose better.
  *
  * Drivers register media device instances by calling
  *	__media_device_register() via the macro media_device_register()
  * and unregistered by calling
  *	media_device_unregister().
  *
+ * The media device structure itself is not reference counted, but it
+ * relies on the kref which is part of struct media_devnode which it
+ * embeds. Acquiring a reference to a media device requires calling
+ * media_device_get() on the media device, likewise releasing a
+ * reference is done using media_device_put(). Once the last reference
+ * is gone, the media device is released iff it was allocated using
+ * media_device_alloc(). The media device's release() callback is
+ * called once the last reference has been released.
+ *
  * * Entities, pads and links:
  *
  * - Entities
@@ -419,6 +431,9 @@ static inline __must_check int media_entity_enum_init(
  *
  * @mdev:	pointer to struct &media_device
  *
+ * DEPRECATED --- use media_device_alloc() and rely on reference
+ * counts and the release callback instead.
+ *
  * This function initializes the media device prior to its registration.
  * The media device initialization and registration is split in two functions
  * to avoid race conditions and make the media device available to user-space
@@ -489,6 +504,9 @@ static inline void *media_device_priv(struct media_device *mdev)
  *
  * @mdev:	pointer to struct &media_device
  *
+ * DEPRECATED --- use media_device_alloc() and rely on reference
+ * counts and the release callback instead.
+ *
  * This function that will destroy the graph_mutex that is
  * initialized in media_device_init().
  */
-- 
2.1.4

