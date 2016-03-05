Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbcCEKNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2016 05:13:49 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] [media] media-device: map new functions into old types for legacy API
Date: Sat,  5 Mar 2016 07:13:39 -0300
Message-Id: <d2caef627f843e45165566135f63eafef9f4fc84.1457172768.git.mchehab@osg.samsung.com>
In-Reply-To: <07c81fda0c8b187be238a8428fd370d156082f8c.1457088214.git.mchehab@osg.samsung.com>
References: <07c81fda0c8b187be238a8428fd370d156082f8c.1457088214.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The legacy media controller userspace API exposes entity types that
carry both type and function information. The new API replaces the type
with a function. It preserves backward compatibility by defining legacy
functions for the existing types and using them in drivers.

This works fine, as long as newer entity functions won't be added.

Unfortunately, some tools, like media-ctl with --print-dot argument
rely on the now legacy MEDIA_ENT_T_V4L2_SUBDEV and MEDIA_ENT_T_DEVNODE
numeric ranges to identify what entities will be shown.

Also, if the entity doesn't match those ranges, it will ignore the
major/minor information on devnodes, and won't be getting the devnode
name via udev or sysfs.

As we're now adding devices outside the old range, the legacy ioctl
needs to map the new entity functions into a type at the old range,
or otherwise we'll have a regression.

Detected on all released media-ctl versions (e. g. versions <= 1.10).

Fix this by deriving the type from the function to emulate the legacy
API if the function isn't in the legacy functions range.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 23 +++++++++++++++++++++++
 include/uapi/linux/media.h   |  6 +++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 17cd349e485f..afe64ddeeaec 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,6 +20,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+/* We need to access legacy defines from linux/media.h */
+#define __NEED_MEDIA_LEGACY_API
+
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/idr.h>
@@ -121,6 +124,26 @@ static long media_device_enum_entities(struct media_device *mdev,
 	u_ent.group_id = 0;		/* Unused */
 	u_ent.pads = ent->num_pads;
 	u_ent.links = ent->num_links - ent->num_backlinks;
+
+	/*
+	 * Workaround for a bug at media-ctl <= v1.10 that makes it to
+	 * do the wrong thing if the entity function doesn't belong to
+	 * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
+	 * Ranges.
+	 *
+	 * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
+	 * or, otherwise, will be silently ignored by media-ctl when
+	 * printing the graphviz diagram. So, map them into the devnode
+	 * old range.
+	 */
+	if (ent->function < MEDIA_ENT_F_OLD_BASE ||
+	    ent->function > MEDIA_ENT_T_DEVNODE_UNKNOWN) {
+		if (is_media_entity_v4l2_subdev(ent))
+			u_ent.type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
+		else if (ent->function != MEDIA_ENT_F_IO_V4L)
+			u_ent.type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
+	}
+
 	memcpy(&u_ent.raw, &ent->info, sizeof(ent->info));
 	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
 		return -EFAULT;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 95e126edb1c3..ef046b4ccb0d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -132,7 +132,7 @@ struct media_device_info {
 
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
 
-#ifndef __KERNEL__
+#if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
 
 /*
  * Legacy symbols used to avoid userspace compilation breakages
@@ -145,6 +145,10 @@ struct media_device_info {
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
 #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
 
+/* End of the old subdev reserved numberspace */
+#define MEDIA_ENT_T_DEVNODE_UNKNOWN	(MEDIA_ENT_T_DEVNODE | \
+					 MEDIA_ENT_SUBTYPE_MASK)
+
 #define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
 #define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
-- 
2.5.0

