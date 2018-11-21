Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46787 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731389AbeKVCPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 21:15:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 1/3] uapi/linux/media.h: add property support
Date: Wed, 21 Nov 2018 16:40:22 +0100
Message-Id: <20181121154024.13906-2-hverkuil@xs4all.nl>
In-Reply-To: <20181121154024.13906-1-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new topology struct that includes properties and adds
index fields to quickly find references from one object to
another in the topology arrays.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 88 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e5d0c5c611b5..a81e9723204c 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -144,6 +144,8 @@ struct media_device_info {
 /* Entity flags */
 #define MEDIA_ENT_FL_DEFAULT			(1 << 0)
 #define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
+#define MEDIA_ENT_FL_PAD_IDX			(1 << 2)
+#define MEDIA_ENT_FL_PROP_IDX			(1 << 3)
 
 /* OR with the entity id value to find the next entity */
 #define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
@@ -210,6 +212,9 @@ struct media_entity_desc {
 #define MEDIA_PAD_FL_SINK			(1 << 0)
 #define MEDIA_PAD_FL_SOURCE			(1 << 1)
 #define MEDIA_PAD_FL_MUST_CONNECT		(1 << 2)
+#define MEDIA_PAD_FL_LINK_IDX			(1 << 3)
+#define MEDIA_PAD_FL_PROP_IDX			(1 << 4)
+#define MEDIA_PAD_FL_ENTITY_IDX			(1 << 5)
 
 struct media_pad_desc {
 	__u32 entity;		/* entity ID */
@@ -221,6 +226,8 @@ struct media_pad_desc {
 #define MEDIA_LNK_FL_ENABLED			(1 << 0)
 #define MEDIA_LNK_FL_IMMUTABLE			(1 << 1)
 #define MEDIA_LNK_FL_DYNAMIC			(1 << 2)
+#define MEDIA_LNK_FL_SOURCE_IDX			(1 << 3)
+#define MEDIA_LNK_FL_SINK_IDX			(1 << 4)
 
 #define MEDIA_LNK_FL_LINK_TYPE			(0xf << 28)
 #  define MEDIA_LNK_FL_DATA_LINK		(0 << 28)
@@ -296,7 +303,9 @@ struct media_v2_entity {
 	char name[64];
 	__u32 function;		/* Main function of the entity */
 	__u32 flags;
-	__u32 reserved[5];
+	__u16 pad_idx;
+	__u16 prop_idx;
+	__u32 reserved[4];
 } __attribute__ ((packed));
 
 /* Should match the specific fields at media_intf_devnode */
@@ -305,11 +314,14 @@ struct media_v2_intf_devnode {
 	__u32 minor;
 } __attribute__ ((packed));
 
+#define MEDIA_INTF_FL_LINK_IDX			(1 << 0)
+
 struct media_v2_interface {
 	__u32 id;
 	__u32 intf_type;
 	__u32 flags;
-	__u32 reserved[9];
+	__u16 link_idx;
+	__u16 reserved[17];
 
 	union {
 		struct media_v2_intf_devnode devnode;
@@ -331,7 +343,10 @@ struct media_v2_pad {
 	__u32 entity_id;
 	__u32 flags;
 	__u32 index;
-	__u32 reserved[4];
+	__u16 link_idx;
+	__u16 prop_idx;
+	__u16 entity_idx;
+	__u16 reserved[5];
 } __attribute__ ((packed));
 
 struct media_v2_link {
@@ -339,9 +354,68 @@ struct media_v2_link {
 	__u32 source_id;
 	__u32 sink_id;
 	__u32 flags;
-	__u32 reserved[6];
+	__u16 source_idx;
+	__u16 sink_idx;
+	__u32 reserved[5];
 } __attribute__ ((packed));
 
+#define MEDIA_PROP_TYPE_GROUP	1
+#define MEDIA_PROP_TYPE_U64	2
+#define MEDIA_PROP_TYPE_S64	3
+#define MEDIA_PROP_TYPE_STRING	4
+
+#define MEDIA_PROP_FL_OWNER			0xf
+#  define MEDIA_PROP_FL_ENTITY			0
+#  define MEDIA_PROP_FL_PAD			1
+#  define MEDIA_PROP_FL_LINK			2
+#  define MEDIA_PROP_FL_INTF			3
+#  define MEDIA_PROP_FL_PROP			4
+#define MEDIA_PROP_FL_PROP_IDX			(1 << 4)
+
+/**
+ * struct media_v2_prop - A media property
+ *
+ * @id:		The unique non-zero ID of this property
+ * @owner_id:	The ID of the object this property belongs to
+ * @type:	Property type
+ * @flags:	Property flags
+ * @name:	Property name
+ * @payload_size: Property payload size, 0 for U64/S64
+ * @payload_offset: Property payload starts at this offset from &prop.id.
+ *		This is 0 for U64/S64.
+ * @prop_idx:	Index to sub-properties, 0 means there are no sub-properties.
+ * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
+ *		type.
+ * @reserved:	Property reserved field, will be zeroed.
+ */
+struct media_v2_prop {
+	__u32 id;
+	__u32 owner_id;
+	__u32 type;
+	__u32 flags;
+	char name[32];
+	__u32 payload_size;
+	__u32 payload_offset;
+	__u16 prop_idx;
+	__u16 owner_idx;
+	__u32 reserved[17];
+} __attribute__ ((packed));
+
+static inline const char *media_prop2s(const struct media_v2_prop *prop)
+{
+	return (const char *)prop + prop->payload_offset;
+}
+
+static inline __u64 media_prop2u64(const struct media_v2_prop *prop)
+{
+	return *(const __u64 *)((const char *)prop + prop->payload_offset);
+}
+
+static inline __s64 media_prop2s64(const struct media_v2_prop *prop)
+{
+	return *(const __s64 *)((const char *)prop + prop->payload_offset);
+}
+
 struct media_v2_topology {
 	__u64 topology_version;
 
@@ -360,6 +434,10 @@ struct media_v2_topology {
 	__u32 num_links;
 	__u32 reserved4;
 	__u64 ptr_links;
+
+	__u32 num_props;
+	__u32 props_payload_size;
+	__u64 ptr_props;
 } __attribute__ ((packed));
 
 /* ioctls */
@@ -368,6 +446,8 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
+/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
+#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
 #define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
 
-- 
2.19.1
