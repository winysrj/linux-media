Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:49984 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbcCZEiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 00:38:50 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH 2/4] media: Add Media Device Allocator API documentation
Date: Fri, 25 Mar 2016 22:38:43 -0600
Message-Id: <33083175297b174a68b937e9bf2d867add363e23.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Media Device Allocator API documentation.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-dev-allocator.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
index 2932c90..174840c 100644
--- a/include/media/media-dev-allocator.h
+++ b/include/media/media-dev-allocator.h
@@ -20,6 +20,38 @@
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 /**
+ * DOC: Media Controller Device Allocator API
+ * There are known problems with media device life time management. When media
+ * device is released while an media ioctl is in progress, ioctls fail with
+ * use-after-free errors and kernel hangs in some cases.
+ * 
+ * Media Device can be in any the following states:
+ * 
+ * - Allocated
+ * - Registered (could be tied to more than one driver)
+ * - Unregistered, not in use (media device file is not open)
+ * - Unregistered, in use (media device file is not open)
+ * - Released
+ * 
+ * When media device belongs to  more than one driver, registrations should be
+ * refcounted to avoid unregistering when one of the drivers does unregister.
+ * A refcount field in the struct media_device covers this case. Unregister on
+ * a Media Allocator media device is a kref_put() call. The media device should
+ * be unregistered only when the last unregister occurs.
+ * 
+ * When a media device is in use when it is unregistered, it should not be
+ * released until the application exits when it detects the unregistered
+ * status. Media device that is in use when it is unregistered is moved to
+ * to_delete_list. When the last unregister occurs, media device is unregistered
+ * and becomes an unregistered, still allocated device. Unregister marks the
+ * device to be deleted.
+ * 
+ * When media device belongs to more than one driver, as both drivers could be
+ * unbound/bound, driver should not end up getting stale media device that is
+ * on its way out. Moving the unregistered media device to to_delete_list helps
+ * this case as well.
+ */
+/**
  * media_device_get() - Allocate and return global media device
  *
  * @mdev
-- 
2.5.0

