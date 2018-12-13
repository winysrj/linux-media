Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4A5C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6B52087F
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E6B52087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbeLMNlT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:41:19 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59410 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729524AbeLMNlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:41:18 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XREngf3iadllcXREpgEECJ; Thu, 13 Dec 2018 14:41:15 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 1/4] uapi/linux/media.h: add property support
Date:   Thu, 13 Dec 2018 14:41:10 +0100
Message-Id: <20181213134113.15247-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHOaWAa9T0hX0cy0lvLPmonAa9fBNHICWnMmB+u3IVCGCsJHEggH9FjzVoprc6YFyE5n8/zTY61pZmuyKsRoUVYHLbEAvZBVXmnG4CxVUyorrptV0uC2
 B1EIofqPJQdckMVnBOI5VBLMa0dcYn2QTxUXCUg8JFPEtmEng+fdpBOuzMAx7qePBdRu9/BLE3rFnTattHBcHkXqpAQfESrkQL5CkhWiJ1/Qk96CQmvjy8RJ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Extend the topology struct with a properties array.

Add a new media_v2_prop structure to store property information.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 56 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e5d0c5c611b5..12982327381e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -342,6 +342,58 @@ struct media_v2_link {
 	__u32 reserved[6];
 } __attribute__ ((packed));
 
+#define MEDIA_PROP_TYPE_GROUP	1
+#define MEDIA_PROP_TYPE_U64	2
+#define MEDIA_PROP_TYPE_S64	3
+#define MEDIA_PROP_TYPE_STRING	4
+
+#define MEDIA_OWNER_TYPE_ENTITY			0
+#define MEDIA_OWNER_TYPE_PAD			1
+#define MEDIA_OWNER_TYPE_LINK			2
+#define MEDIA_OWNER_TYPE_INTF			3
+#define MEDIA_OWNER_TYPE_PROP			4
+
+/**
+ * struct media_v2_prop - A media property
+ *
+ * @id:		The unique non-zero ID of this property
+ * @type:	Property type
+ * @owner_id:	The ID of the object this property belongs to
+ * @owner_type:	The type of the object this property belongs to
+ * @flags:	Property flags
+ * @name:	Property name
+ * @payload_size: Property payload size, 0 for U64/S64
+ * @payload_offset: Property payload starts at this offset from &prop.id.
+ *		This is 0 for U64/S64.
+ * @reserved:	Property reserved field, will be zeroed.
+ */
+struct media_v2_prop {
+	__u32 id;
+	__u32 type;
+	__u32 owner_id;
+	__u32 owner_type;
+	__u32 flags;
+	char name[32];
+	__u32 payload_size;
+	__u32 payload_offset;
+	__u32 reserved[18];
+} __attribute__ ((packed));
+
+static inline const char *media_prop2string(const struct media_v2_prop *prop)
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
 
@@ -360,6 +412,10 @@ struct media_v2_topology {
 	__u32 num_links;
 	__u32 reserved4;
 	__u64 ptr_links;
+
+	__u32 num_props;
+	__u32 props_payload_size;
+	__u64 ptr_props;
 } __attribute__ ((packed));
 
 /* ioctls */
-- 
2.19.2

