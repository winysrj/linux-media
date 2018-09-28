Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60783 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729116AbeI1Qas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 12:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 1/3] uapi/linux/media.h: add property support
Date: Fri, 28 Sep 2018 12:07:43 +0200
Message-Id: <20180928100745.4946-2-hverkuil@xs4all.nl>
In-Reply-To: <20180928100745.4946-1-hverkuil@xs4all.nl>
References: <20180928100745.4946-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new topology struct that includes properties.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 71 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 36f76e777ef9..755e446f699e 100644
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
@@ -210,6 +212,8 @@ struct media_entity_desc {
 #define MEDIA_PAD_FL_SINK			(1 << 0)
 #define MEDIA_PAD_FL_SOURCE			(1 << 1)
 #define MEDIA_PAD_FL_MUST_CONNECT		(1 << 2)
+#define MEDIA_PAD_FL_LINK_IDX			(1 << 3)
+#define MEDIA_PAD_FL_PROP_IDX			(1 << 4)
 
 struct media_pad_desc {
 	__u32 entity;		/* entity ID */
@@ -296,7 +300,9 @@ struct media_v2_entity {
 	char name[64];
 	__u32 function;		/* Main function of the entity */
 	__u32 flags;
-	__u32 reserved[5];
+	__u16 pad_idx;
+	__u16 prop_idx;
+	__u32 reserved[4];
 } __attribute__ ((packed));
 
 /* Should match the specific fields at media_intf_devnode */
@@ -305,11 +311,14 @@ struct media_v2_intf_devnode {
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
@@ -331,7 +340,9 @@ struct media_v2_pad {
 	__u32 entity_id;
 	__u32 flags;
 	__u32 index;
-	__u32 reserved[4];
+	__u16 link_idx;
+	__u16 prop_idx;
+	__u32 reserved[3];
 } __attribute__ ((packed));
 
 struct media_v2_link {
@@ -342,6 +353,54 @@ struct media_v2_link {
 	__u32 reserved[6];
 } __attribute__ ((packed));
 
+#define MEDIA_PROP_TYPE_GROUP	1
+#define MEDIA_PROP_TYPE_U64	2
+#define MEDIA_PROP_TYPE_S64	3
+#define MEDIA_PROP_TYPE_STRING	4
+
+#define MEDIA_PROP_FL_PROP_IDX			(1 << 0)
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
+	__u16 reserved[35];
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
 
@@ -360,6 +419,10 @@ struct media_v2_topology {
 	__u32 num_links;
 	__u32 reserved4;
 	__u64 ptr_links;
+
+	__u32 num_props;
+	__u32 props_payload_size;
+	__u64 ptr_props;
 } __attribute__ ((packed));
 
 /* ioctls */
@@ -368,6 +431,8 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
+/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
+#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
 
 #ifndef __KERNEL__
-- 
2.19.0
