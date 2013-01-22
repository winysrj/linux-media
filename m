Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39296 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753559Ab3AVQYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:24:32 -0500
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 261C7601F4
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 18:24:30 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: implement 32-on-64 bit compat IOCTL handling
Date: Tue, 22 Jan 2013 18:27:56 +0200
Message-Id: <1358872076-5477-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1358872076-5477-1-git-send-email-sakari.ailus@iki.fi>
References: <20130122162343.GO13641@valkosipuli.retiisi.org.uk>
 <1358872076-5477-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the same handlers where the structs are the same. Implement a new
handler for link enumeration since struct media_links_enum is different on
32-bit and 64-bit systems.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c |  102 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 13 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d01fcb7..99b80b6 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,10 +20,11 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/types.h>
+#include <linux/compat.h>
+#include <linux/export.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
-#include <linux/export.h>
+#include <linux/types.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -124,35 +125,31 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
 	upad->flags = kpad->flags;
 }
 
-static long media_device_enum_links(struct media_device *mdev,
-				    struct media_links_enum __user *ulinks)
+static long __media_device_enum_links(struct media_device *mdev,
+				      struct media_links_enum *links)
 {
 	struct media_entity *entity;
-	struct media_links_enum links;
 
-	if (copy_from_user(&links, ulinks, sizeof(links)))
-		return -EFAULT;
-
-	entity = find_entity(mdev, links.entity);
+	entity = find_entity(mdev, links->entity);
 	if (entity == NULL)
 		return -EINVAL;
 
-	if (links.pads) {
+	if (links->pads) {
 		unsigned int p;
 
 		for (p = 0; p < entity->num_pads; p++) {
 			struct media_pad_desc pad;
 			media_device_kpad_to_upad(&entity->pads[p], &pad);
-			if (copy_to_user(&links.pads[p], &pad, sizeof(pad)))
+			if (copy_to_user(&links->pads[p], &pad, sizeof(pad)))
 				return -EFAULT;
 		}
 	}
 
-	if (links.links) {
+	if (links->links) {
 		struct media_link_desc __user *ulink;
 		unsigned int l;
 
-		for (l = 0, ulink = links.links; l < entity->num_links; l++) {
+		for (l = 0, ulink = links->links; l < entity->num_links; l++) {
 			struct media_link_desc link;
 
 			/* Ignore backlinks. */
@@ -169,8 +166,26 @@ static long media_device_enum_links(struct media_device *mdev,
 			ulink++;
 		}
 	}
+
+	return 0;
+}
+
+static long media_device_enum_links(struct media_device *mdev,
+				    struct media_links_enum __user *ulinks)
+{
+	struct media_links_enum links;
+	int rval;
+
+	if (copy_from_user(&links, ulinks, sizeof(links)))
+		return -EFAULT;
+
+	rval = __media_device_enum_links(mdev, &links);
+	if (rval < 0)
+		return rval;
+
 	if (copy_to_user(ulinks, &links, sizeof(*ulinks)))
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -251,10 +266,71 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+
+struct media_links_enum32 {
+	__u32 entity;
+	compat_uptr_t pads; /* struct media_pad_desc * */
+	compat_uptr_t links; /* struct media_link_desc * */
+	__u32 reserved[4];
+};
+
+static long media_device_enum_links32(struct media_device *mdev,
+				      struct media_links_enum32 __user *ulinks)
+{
+	struct media_links_enum links;
+	compat_uptr_t pads_ptr, links_ptr;
+
+	memset(&links, 0, sizeof(links));
+
+	if (get_user(links.entity, &ulinks->entity)
+	    || get_user(pads_ptr, &ulinks->pads)
+	    || get_user(links_ptr, &ulinks->links))
+		return -EFAULT;
+
+	links.pads = compat_ptr(pads_ptr);
+	links.links = compat_ptr(links_ptr);
+
+	return __media_device_enum_links(mdev, &links);
+}
+
+#define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
+
+static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
+				      unsigned long arg)
+{
+	struct media_devnode *devnode = media_devnode_data(filp);
+	struct media_device *dev = to_media_device(devnode);
+	long ret;
+
+	switch (cmd) {
+	case MEDIA_IOC_DEVICE_INFO:
+	case MEDIA_IOC_ENUM_ENTITIES:
+	case MEDIA_IOC_SETUP_LINK:
+		return media_device_ioctl(filp, cmd, arg);
+
+	case MEDIA_IOC_ENUM_LINKS32:
+		mutex_lock(&dev->graph_mutex);
+		ret = media_device_enum_links32(dev,
+				(struct media_links_enum32 __user *)arg);
+		mutex_unlock(&dev->graph_mutex);
+		break;
+
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+#endif /* CONFIG_COMPAT */
+
 static const struct media_file_operations media_device_fops = {
 	.owner = THIS_MODULE,
 	.open = media_device_open,
 	.ioctl = media_device_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = media_device_compat_ioctl,
+#endif /* CONFIG_COMPAT */
 	.release = media_device_close,
 };
 
-- 
1.7.10.4

