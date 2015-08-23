Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH v7 39/44] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
Date: Sun, 23 Aug 2015 17:17:56 -0300
Message-Id: <31b28b78f6a37ca7ff4554207bb05cd1a1db788c.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new ioctl that will report the entire topology on
one go.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 796e4a490af8..0111d9652b78 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -181,6 +181,8 @@ struct media_interface {
  */
 struct media_intf_devnode {
 	struct media_interface		intf;
+
+	/* Should match the fields at media_v2_intf_devnode */
 	u32				major;
 	u32				minor;
 };
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ceea791dd6e9..7fcf7f477ae3 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -238,11 +238,94 @@ struct media_links_enum {
 #define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
 #define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
 
-/* TBD: declare the structs needed for the new G_TOPOLOGY ioctl */
+/*
+ * MC next gen API definitions
+ *
+ * NOTE: The declarations below are close to the MC RFC for the Media
+ *	 Controller, the next generation. Yet, there are a few adjustments
+ *	 to do, as we want to be able to have a functional API before
+ *	 the MC properties change. Those will be properly marked below.
+ *	 Please also notice that I removed "num_pads", "num_links",
+ *	 from the proposal, as a proper userspace application will likely
+ *	 use lists for pads/links, just as we intend todo in Kernelspace.
+ *	 The API definition should be freed from fields that are bound to
+ *	 some specific data structure.
+ *
+ * FIXME: Currently, I opted to name the new types as "media_v2", as this
+ *	  won't cause any conflict with the Kernelspace namespace, nor with
+ *	  the previous kAPI media_*_desc namespace. This can be changed
+ *	  latter, before the adding this API upstream.
+ */
+
+
+#define MEDIA_NEW_LNK_FL_ENABLED		MEDIA_LNK_FL_ENABLED
+#define MEDIA_NEW_LNK_FL_IMMUTABLE		MEDIA_LNK_FL_IMMUTABLE
+#define MEDIA_NEW_LNK_FL_DYNAMIC		MEDIA_NEW_FL_DYNAMIC
+#define MEDIA_NEW_LNK_FL_INTERFACE_LINK		(1 << 3)
+
+struct media_v2_entity {
+	__u32 id;
+	char name[64];		/* FIXME: move to a property? (RFC says so) */
+	__u16 reserved[14];
+};
+
+/* Should match the specific fields at media_intf_devnode */
+struct media_v2_intf_devnode {
+	__u32 major;
+	__u32 minor;
+};
+
+struct media_v2_interface {
+	__u32 id;
+	__u32 intf_type;
+	__u32 flags;
+	__u32 reserved[9];
+
+	union {
+		struct media_v2_intf_devnode devnode;
+		__u32 raw[16];
+	};
+};
+
+struct media_v2_pad {
+	__u32 id;
+	__u32 entity_id;
+	__u32 flags;
+	__u16 reserved[9];
+};
+
+struct media_v2_link {
+    __u32 id;
+    __u32 source_id;
+    __u32 sink_id;
+    __u32 flags;
+    __u32 reserved[5];
+};
+
+struct media_v2_topology {
+	__u32 topology_version;
+
+	__u32 num_entities;
+	struct media_v2_entity *entities;
+
+	__u32 num_interfaces;
+	struct media_v2_interface *interfaces;
+
+	__u32 num_pads;
+	struct media_v2_pad *pads;
+
+	__u32 num_links;
+	struct media_v2_link *links;
+
+	__u32 reserved[64];
+};
+
+/* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
+#define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.4.3

