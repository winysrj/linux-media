Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43538 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729910AbeHGMmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 08:42:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 3/3] vimc: add test properties
Date: Tue,  7 Aug 2018 12:28:47 +0200
Message-Id: <20180807102847.13200-4-hverkuil@xs4all.nl>
In-Reply-To: <20180807102847.13200-1-hverkuil@xs4all.nl>
References: <20180807102847.13200-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vimc/vimc-common.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 617415c224fe..db8a8d1eca54 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -452,6 +452,24 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 		goto err_clean_m_ent;
 	}
 
+	ret = media_entity_add_prop_u64(&sd->entity, "u64", ~1);
+	if (!ret)
+		ret = media_entity_add_prop_s64(&sd->entity, "s64", -5);
+	if (!ret)
+		ret = media_entity_add_prop_string(&sd->entity, "string",
+						   sd->name);
+	if (!ret)
+		ret = media_pad_add_prop_u64(&sd->entity.pads[num_pads - 1],
+					     "u64", ~1);
+	if (!ret)
+		ret = media_pad_add_prop_s64(&sd->entity.pads[num_pads - 1],
+					     "s64", -5);
+	if (!ret)
+		ret = media_pad_add_prop_string(&sd->entity.pads[0],
+						"string", sd->name);
+	if (ret)
+		goto err_clean_m_ent;
+
 	return 0;
 
 err_clean_m_ent:
-- 
2.18.0
