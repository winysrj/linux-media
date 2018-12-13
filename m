Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36087C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5E0220879
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5E0220879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbeLMNlT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:41:19 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39997 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729467AbeLMNlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:41:19 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XREngf3iadllcXREpgEECW; Thu, 13 Dec 2018 14:41:15 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [RFCv5 PATCH 3/4] media: add functions to add properties to objects
Date:   Thu, 13 Dec 2018 14:41:12 +0100
Message-Id: <20181213134113.15247-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHOaWAa9T0hX0cy0lvLPmonAa9fBNHICWnMmB+u3IVCGCsJHEggH9FjzVoprc6YFyE5n8/zTY61pZmuyKsRoUVYHLbEAvZBVXmnG4CxVUyorrptV0uC2
 B1EIofqPJQdckMVnBOI5VBLMa0dcYn2QTxUXCUg8JFPEtmEng+fdpBOuzMAx7qePBdRu9/BLE3rFnWL0amksxRQpudWZ0XZI77EfkHeWYpniDKlAV7c9ZvW/
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add functions to add properties to entities, pads and other
properties. This can be extended to include interfaces and links
in the future when needed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/media-entity.c |  64 +++++++++
 include/media/media-entity.h | 264 +++++++++++++++++++++++++++++++++++
 2 files changed, 328 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 62c4d5b4d33f..cdb35bc8e9a0 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -251,6 +251,70 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 }
 EXPORT_SYMBOL_GPL(media_entity_pads_init);
 
+static struct media_prop *media_create_prop(struct media_gobj *owner, u32 type,
+					    const char *name, const void *ptr,
+					    u32 payload_size)
+{
+	struct media_prop *prop = kzalloc(sizeof(*prop) + payload_size,
+					  GFP_KERNEL);
+
+	if (!prop)
+		return ERR_PTR(-ENOMEM);
+	prop->type = type;
+	strscpy(prop->name, name, sizeof(prop->name));
+	if (owner->mdev)
+		media_gobj_create(owner->mdev, MEDIA_GRAPH_PROP,
+				  &prop->graph_obj);
+	prop->owner = owner;
+	prop->payload_size = payload_size;
+	if (payload_size && ptr)
+		memcpy(prop->payload, ptr, payload_size);
+	INIT_LIST_HEAD(&prop->props);
+	return prop;
+}
+
+struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
+					 const char *name, const void *ptr,
+					 u32 payload_size)
+{
+	struct media_prop *prop;
+
+	if (!ent->inited)
+		media_entity_init(ent);
+	prop = media_create_prop(&ent->graph_obj, type,
+				 name, ptr, payload_size);
+	if (!IS_ERR(prop))
+		list_add_tail(&prop->list, &ent->props);
+	return prop;
+}
+EXPORT_SYMBOL_GPL(media_entity_add_prop);
+
+struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
+				      const char *name, const void *ptr,
+				      u32 payload_size)
+{
+	struct media_prop *prop = media_create_prop(&pad->graph_obj, type,
+						    name, ptr, payload_size);
+
+	if (!IS_ERR(prop))
+		list_add_tail(&prop->list, &pad->props);
+	return prop;
+}
+EXPORT_SYMBOL_GPL(media_pad_add_prop);
+
+struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
+				       const char *name, const void *ptr,
+				       u32 payload_size)
+{
+	struct media_prop *subprop = media_create_prop(&prop->graph_obj, type,
+						       name, ptr, payload_size);
+
+	if (!IS_ERR(subprop))
+		list_add_tail(&subprop->list, &prop->props);
+	return subprop;
+}
+EXPORT_SYMBOL_GPL(media_prop_add_prop);
+
 /* -----------------------------------------------------------------------------
  * Graph traversal
  */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 5d05ebf712d0..695acfd3fe9c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -833,6 +833,270 @@ int media_create_pad_links(const struct media_device *mdev,
 
 void __media_entity_remove_links(struct media_entity *entity);
 
+/**
+ * media_entity_add_prop() - Add property to entity
+ *
+ * @entity:	entity where to add the property
+ * @type:	property type
+ * @name:	property name
+ * @ptr:	property pointer to payload
+ * @payload_size: property payload size
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
+					 const char *name, const void *ptr,
+					 u32 payload_size);
+
+/**
+ * media_pad_add_prop() - Add property to pad
+ *
+ * @pad:	pad where to add the property
+ * @type:	property type
+ * @name:	property name
+ * @ptr:	property pointer to payload
+ * @payload_size: property payload size
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
+				      const char *name, const void *ptr,
+				      u32 payload_size);
+
+/**
+ * media_prop() - Add sub-property to property
+ *
+ * @prop:	property where to add the sub-property
+ * @type:	sub-property type
+ * @name:	sub-property name
+ * @ptr:	sub-property pointer to payload
+ * @payload_size: sub-property payload size
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
+				       const char *name, const void *ptr,
+				       u32 payload_size);
+
+/**
+ * media_entity_add_prop_group() - Add group property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+static inline struct media_prop *
+media_entity_add_prop_group(struct media_entity *entity, const char *name)
+{
+	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_GROUP,
+				     name, NULL, 0);
+}
+
+/**
+ * media_entity_add_prop_u64() - Add u64 property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_u64(struct media_entity *entity,
+					    const char *name, u64 val)
+{
+	struct media_prop *prop =
+		media_entity_add_prop(entity, MEDIA_PROP_TYPE_U64,
+				      name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_entity_add_prop_s64() - Add s64 property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_s64(struct media_entity *entity,
+					    const char *name, s64 val)
+{
+	struct media_prop *prop =
+		media_entity_add_prop(entity, MEDIA_PROP_TYPE_S64,
+				      name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_entity_add_prop_string() - Add string property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @string:	property string value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_string(struct media_entity *entity,
+					       const char *name,
+					       const char *string)
+{
+	struct media_prop *prop =
+		media_entity_add_prop(entity, MEDIA_PROP_TYPE_STRING,
+				      name, string, strlen(string) + 1);
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_pad_add_prop_group() - Add group property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+static inline struct media_prop *media_pad_add_prop_group(struct media_pad *pad,
+							  const char *name)
+{
+	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_GROUP,
+				  name, NULL, 0);
+}
+
+/**
+ * media_pad_add_prop_u64() - Add u64 property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_u64(struct media_pad *pad,
+					 const char *name, u64 val)
+{
+	struct media_prop *prop =
+		media_pad_add_prop(pad, MEDIA_PROP_TYPE_U64,
+				   name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_pad_add_prop_s64() - Add s64 property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_s64(struct media_pad *pad,
+					 const char *name, s64 val)
+{
+	struct media_prop *prop =
+		media_pad_add_prop(pad, MEDIA_PROP_TYPE_S64,
+				   name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_pad_add_prop_string() - Add string property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @string:	property string value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_string(struct media_pad *pad,
+					    const char *name,
+					    const char *string)
+{
+	struct media_prop *prop =
+		media_pad_add_prop(pad, MEDIA_PROP_TYPE_STRING,
+				   name, string, strlen(string) + 1);
+
+	return PTR_ERR_OR_ZERO(prop);
+}
+
+/**
+ * media_prop_add_prop_group() - Add group sub-property to property
+ *
+ * @prop:	property where to add the sub-property
+ * @name:	sub-property name
+ *
+ * Returns the new property on success, or an error pointer on failure.
+ */
+static inline struct media_prop *
+media_prop_add_prop_group(struct media_prop *prop, const char *name)
+{
+	return media_prop_add_prop(prop, MEDIA_PROP_TYPE_GROUP,
+				  name, NULL, 0);
+}
+
+/**
+ * media_prop_add_prop_u64() - Add u64 property to property
+ *
+ * @prop:	property where to add the sub-property
+ * @name:	sub-property name
+ * @val:	sub-property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_prop_add_prop_u64(struct media_prop *prop,
+					  const char *name, u64 val)
+{
+	struct media_prop *subprop =
+		media_prop_add_prop(prop, MEDIA_PROP_TYPE_U64,
+				    name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(subprop);
+}
+
+/**
+ * media_prop_add_prop_s64() - Add s64 property to property
+ *
+ * @prop:	property where to add the sub-property
+ * @name:	sub-property name
+ * @val:	sub-property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_prop_add_prop_s64(struct media_prop *prop,
+					  const char *name, s64 val)
+{
+	struct media_prop *subprop =
+		media_prop_add_prop(prop, MEDIA_PROP_TYPE_S64,
+				    name, &val, sizeof(val));
+
+	return PTR_ERR_OR_ZERO(subprop);
+}
+
+/**
+ * media_prop_add_prop_string() - Add string property to property
+ *
+ * @prop:	property where to add the sub-property
+ * @name:	sub-property name
+ * @string:	sub-property string value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_prop_add_prop_string(struct media_prop *prop,
+					     const char *name,
+					     const char *string)
+{
+	struct media_prop *subprop =
+		media_prop_add_prop(prop, MEDIA_PROP_TYPE_STRING,
+				    name, string, strlen(string) + 1);
+
+	return PTR_ERR_OR_ZERO(subprop);
+}
+
 /**
  * media_entity_remove_links() - remove all links associated with an entity
  *
-- 
2.19.2

