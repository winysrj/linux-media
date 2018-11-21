Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56380 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731402AbeKVCPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 21:15:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 3/3] vimc: add property test code
Date: Wed, 21 Nov 2018 16:40:24 +0100
Message-Id: <20181121154024.13906-4-hverkuil@xs4all.nl>
In-Reply-To: <20181121154024.13906-1-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add properties to entities and pads to be able to test the
properties API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vimc/vimc-common.c | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index dee1b9dfc4f6..2f70e4e64790 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -415,6 +415,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 			 const unsigned long *pads_flag,
 			 const struct v4l2_subdev_ops *sd_ops)
 {
+	struct media_prop *prop = NULL;
 	int ret;
 
 	/* Allocate the pads */
@@ -452,6 +453,55 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 		goto err_clean_m_ent;
 	}
 
+	ret = media_entity_add_prop_u64(&sd->entity, "u64", ~1);
+	if (!ret)
+		ret = media_entity_add_prop_s64(&sd->entity, "s64", -5);
+	if (!ret)
+		ret = media_entity_add_prop_string(&sd->entity, "string",
+						   sd->name);
+	if (!ret) {
+		prop = media_entity_add_prop_group(&sd->entity, "empty-group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret) {
+		prop = media_entity_add_prop_group(&sd->entity, "group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_u64(prop, "u64", 42);
+	if (!ret)
+		ret = media_prop_add_prop_s64(prop, "s64", -42);
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "42");
+	if (!ret)
+		ret = media_pad_add_prop_u64(&sd->entity.pads[num_pads - 1],
+					     "u64", ~1);
+	if (!ret)
+		ret = media_pad_add_prop_s64(&sd->entity.pads[num_pads - 1],
+					     "s64", -5);
+	if (!ret) {
+		prop = media_pad_add_prop_group(&sd->entity.pads[num_pads - 1],
+						"group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_u64(prop, "u64", 24);
+	if (!ret)
+		ret = media_prop_add_prop_s64(prop, "s64", -24);
+	if (!ret)
+		ret = media_pad_add_prop_string(&sd->entity.pads[0],
+						"string", sd->name);
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "24");
+	if (!ret) {
+		prop = media_prop_add_prop_group(prop, "subgroup");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "substring");
+	if (ret)
+		goto err_clean_m_ent;
+
 	return 0;
 
 err_clean_m_ent:
-- 
2.19.1
