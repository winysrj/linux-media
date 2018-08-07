Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55956 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727984AbeHGMmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 08:42:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 1/3] uapi/linux/media.h: add property support
Date: Tue,  7 Aug 2018 12:28:45 +0200
Message-Id: <20180807102847.13200-2-hverkuil@xs4all.nl>
In-Reply-To: <20180807102847.13200-1-hverkuil@xs4all.nl>
References: <20180807102847.13200-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new topology struct that includes properties.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 36f76e777ef9..1910c091601e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -342,6 +342,40 @@ struct media_v2_link {
 	__u32 reserved[6];
 } __attribute__ ((packed));
 
+#define MEDIA_PROP_TYPE_U64	1
+#define MEDIA_PROP_TYPE_S64	2
+#define MEDIA_PROP_TYPE_STRING	3
+
+/**
+ * struct media_v2_prop - A media property
+ *
+ * @id:		The unique non-zero ID of this property
+ * @owner_id:	The ID of the object this property belongs to
+ * @type:	Property type
+ * @flags:	Property flags
+ * @payload_size: Property payload size, 0 for U64/S64
+ * @payload_offset: Property payload starts at this offset from &prop.id.
+ *		This is 0 for U64/S64.
+ * @reserved:	Property reserved field, will be zeroed.
+ * @name:	Property name
+ * @uval:	Property value (unsigned)
+ * @sval:	Property value (signed)
+ */
+struct media_v2_prop {
+	__u32 id;
+	__u32 owner_id;
+	__u32 type;
+	__u32 flags;
+	__u32 payload_size;
+	__u32 payload_offset;
+	__u32 reserved[18];
+	char name[32];
+	union {
+		__u64 uval;
+		__s64 sval;
+	};
+} __attribute__ ((packed));
+
 struct media_v2_topology {
 	__u64 topology_version;
 
@@ -360,6 +394,10 @@ struct media_v2_topology {
 	__u32 num_links;
 	__u32 reserved4;
 	__u64 ptr_links;
+
+	__u32 num_props;
+	__u32 props_payload_size;
+	__u64 ptr_props;
 } __attribute__ ((packed));
 
 /* ioctls */
@@ -368,6 +406,8 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
+/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
+#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
 
 #ifndef __KERNEL__
-- 
2.18.0
