Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbbLKTdd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 14:33:33 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH 2/2] media-device: Use u64 ints for pointers
Date: Fri, 11 Dec 2015 17:33:18 -0200
Message-Id: <ff80c1c4d1a1f83f0c0069e28f58b4c66350b7e6.1449862315.git.mchehab@osg.samsung.com>
In-Reply-To: <9f249ef05975239a207a626a611778e955fff1c7.1449862315.git.mchehab@osg.samsung.com>
References: <9f249ef05975239a207a626a611778e955fff1c7.1449862315.git.mchehab@osg.samsung.com>
In-Reply-To: <9f249ef05975239a207a626a611778e955fff1c7.1449862315.git.mchehab@osg.samsung.com>
References: <9f249ef05975239a207a626a611778e955fff1c7.1449862315.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By using u64 integers and pointers, we can get rid of compat32
logic. So, let's do it!

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

This patch is the result of the today's meeting at IRC. In order to test it, a
new version of the mc_nextgen_test is needed. It can be found at:
	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/commit/?h=mc-next-gen-v2

 drivers/media/media-device.c | 77 +++++++++++++++++++++++---------------------
 include/uapi/linux/media.h   | 32 +++++++++---------
 2 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index f09f3a6f9c50..6406914a9bf5 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -240,10 +240,10 @@ static long __media_device_get_topology(struct media_device *mdev,
 	struct media_interface *intf;
 	struct media_pad *pad;
 	struct media_link *link;
-	struct media_v2_entity uentity;
-	struct media_v2_interface uintf;
-	struct media_v2_pad upad;
-	struct media_v2_link ulink;
+	struct media_v2_entity kentity, *uentity;
+	struct media_v2_interface kintf, *uintf;
+	struct media_v2_pad kpad, *upad;
+	struct media_v2_link klink, *ulink;
 	unsigned int i;
 	int ret = 0;
 
@@ -251,10 +251,10 @@ static long __media_device_get_topology(struct media_device *mdev,
 
 	/* Get entities and number of entities */
 	i = 0;
+	uentity = media_get_uptr(topo->ptr_entities);
 	media_device_for_each_entity(entity, mdev) {
 		i++;
-
-		if (ret || !topo->entities)
+		if (ret || !uentity)
 			continue;
 
 		if (i > topo->num_entities) {
@@ -263,23 +263,24 @@ static long __media_device_get_topology(struct media_device *mdev,
 		}
 
 		/* Copy fields to userspace struct if not error */
-		memset(&uentity, 0, sizeof(uentity));
-		uentity.id = entity->graph_obj.id;
-		uentity.function = entity->function;
-		strncpy(uentity.name, entity->name,
-			sizeof(uentity.name));
+		memset(&kentity, 0, sizeof(kentity));
+		kentity.id = entity->graph_obj.id;
+		kentity.function = entity->function;
+		strncpy(kentity.name, entity->name,
+			sizeof(kentity.name));
 
-		if (copy_to_user(&topo->entities[i - 1], &uentity, sizeof(uentity)))
+		if (copy_to_user(uentity, &kentity, sizeof(kentity)))
 			ret = -EFAULT;
+		uentity++;
 	}
 	topo->num_entities = i;
 
 	/* Get interfaces and number of interfaces */
 	i = 0;
+	uintf = media_get_uptr(topo->ptr_interfaces);
 	media_device_for_each_intf(intf, mdev) {
 		i++;
-
-		if (ret || !topo->interfaces)
+		if (ret || !uintf)
 			continue;
 
 		if (i > topo->num_interfaces) {
@@ -287,33 +288,34 @@ static long __media_device_get_topology(struct media_device *mdev,
 			continue;
 		}
 
-		memset(&uintf, 0, sizeof(uintf));
+		memset(&kintf, 0, sizeof(kintf));
 
 		/* Copy intf fields to userspace struct */
-		uintf.id = intf->graph_obj.id;
-		uintf.intf_type = intf->type;
-		uintf.flags = intf->flags;
+		kintf.id = intf->graph_obj.id;
+		kintf.intf_type = intf->type;
+		kintf.flags = intf->flags;
 
 		if (media_type(&intf->graph_obj) == MEDIA_GRAPH_INTF_DEVNODE) {
 			struct media_intf_devnode *devnode;
 
 			devnode = intf_to_devnode(intf);
 
-			uintf.devnode.major = devnode->major;
-			uintf.devnode.minor = devnode->minor;
+			kintf.devnode.major = devnode->major;
+			kintf.devnode.minor = devnode->minor;
 		}
 
-		if (copy_to_user(&topo->interfaces[i - 1], &uintf, sizeof(uintf)))
+		if (copy_to_user(uintf, &kintf, sizeof(kintf)))
 			ret = -EFAULT;
+		uintf++;
 	}
 	topo->num_interfaces = i;
 
 	/* Get pads and number of pads */
 	i = 0;
+	upad = media_get_uptr(topo->ptr_pads);
 	media_device_for_each_pad(pad, mdev) {
 		i++;
-
-		if (ret || !topo->pads)
+		if (ret || !upad)
 			continue;
 
 		if (i > topo->num_pads) {
@@ -321,27 +323,29 @@ static long __media_device_get_topology(struct media_device *mdev,
 			continue;
 		}
 
-		memset(&upad, 0, sizeof(upad));
+		memset(&kpad, 0, sizeof(kpad));
 
 		/* Copy pad fields to userspace struct */
-		upad.id = pad->graph_obj.id;
-		upad.entity_id = pad->entity->graph_obj.id;
-		upad.flags = pad->flags;
+		kpad.id = pad->graph_obj.id;
+		kpad.entity_id = pad->entity->graph_obj.id;
+		kpad.flags = pad->flags;
 
-		if (copy_to_user(&topo->pads[i - 1], &upad, sizeof(upad)))
+		if (copy_to_user(upad, &kpad, sizeof(kpad)))
 			ret = -EFAULT;
+		upad++;
 	}
 	topo->num_pads = i;
 
 	/* Get links and number of links */
 	i = 0;
+	ulink = media_get_uptr(topo->ptr_links);
 	media_device_for_each_link(link, mdev) {
 		if (link->is_backlink)
 			continue;
 
 		i++;
 
-		if (ret || !topo->links)
+		if (ret || !ulink)
 			continue;
 
 		if (i > topo->num_links) {
@@ -349,19 +353,20 @@ static long __media_device_get_topology(struct media_device *mdev,
 			continue;
 		}
 
-		memset(&ulink, 0, sizeof(ulink));
+		memset(&klink, 0, sizeof(klink));
 
 		/* Copy link fields to userspace struct */
-		ulink.id = link->graph_obj.id;
-		ulink.source_id = link->gobj0->id;
-		ulink.sink_id = link->gobj1->id;
-		ulink.flags = link->flags;
+		klink.id = link->graph_obj.id;
+		klink.source_id = link->gobj0->id;
+		klink.sink_id = link->gobj1->id;
+		klink.flags = link->flags;
 
 		if (media_type(link->gobj0) != MEDIA_GRAPH_PAD)
-			ulink.flags |= MEDIA_LNK_FL_INTERFACE_LINK;
+			klink.flags |= MEDIA_LNK_FL_INTERFACE_LINK;
 
-		if (copy_to_user(&topo->links[i - 1], &ulink, sizeof(ulink)))
+		if (copy_to_user(ulink, &klink, sizeof(klink)))
 			ret = -EFAULT;
+		ulink++;
 	}
 	topo->num_links = i;
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 8d8e1a3e6e1a..86f9753e5c03 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -23,6 +23,9 @@
 #ifndef __LINUX_MEDIA_H
 #define __LINUX_MEDIA_H
 
+#ifndef __KERNEL__
+#include <stdint.h>
+#endif
 #include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/version.h>
@@ -320,27 +323,26 @@ struct media_v2_link {
 };
 
 struct media_v2_topology {
-	__u32 topology_version;
+	__u64 topology_version;
 
-	__u32 num_entities;
-	struct media_v2_entity *entities;
+	__u64 num_entities;
+	__u64 ptr_entities;
 
-	__u32 num_interfaces;
-	struct media_v2_interface *interfaces;
+	__u64 num_interfaces;
+	__u64 ptr_interfaces;
 
-	__u32 num_pads;
-	struct media_v2_pad *pads;
+	__u64 num_pads;
+	__u64 ptr_pads;
 
-	__u32 num_links;
-	struct media_v2_link *links;
-
-	struct {
-		__u32 reserved_num;
-		void *reserved_ptr;
-	} reserved_types[16];
-	__u32 reserved[8];
+	__u64 num_links;
+	__u64 ptr_links;
 };
 
+static inline void __user *media_get_uptr(__u64 arg)
+{
+	return (void __user *)(uintptr_t)arg;
+}
+
 /* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
-- 
2.5.0


