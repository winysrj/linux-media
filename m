Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbcCDKno (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 05:43:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] media-device: map new functions into old types for legacy API
Date: Fri,  4 Mar 2016 07:43:37 -0300
Message-Id: <07c81fda0c8b187be238a8428fd370d156082f8c.1457088214.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media-ctl tool, on versions <= 1.10 relies on detecting the
media_type to identify V4L2 sub-devices and MEDIA_ENT_T_DEVNODE.

If the device doesn't match the MEDIA_ENT_T_V4L2_SUBDEV range, it
ignores the major/minor and won't be getting the device name on
udev or sysfs. It will also ignore the entity when printing the
graphviz diagram.

As we're now adding devices outside the old range, the legacy ioctl
needs to map the new entity functions into a type at the old range,
or otherwise we'll have a regression.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 23 +++++++++++++++++++++++
 include/uapi/linux/media.h   |  6 +++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 17cd349e485f..1e82c59abb94 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,6 +20,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+/* We need to access legacy defines from linux/media.h */
+#define __MEDIA_DEVICE_C__
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
index 95e126edb1c3..bc27e34ce3a1 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -132,7 +132,7 @@ struct media_device_info {
 
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
 
-#ifndef __KERNEL__
+#if !defined(__KERNEL__) || defined(__MEDIA_DEVICE_C__)
 
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

