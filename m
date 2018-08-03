Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:33793 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732497AbeHCQdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 12:33:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] vimc: add test properties
Date: Fri,  3 Aug 2018 16:36:26 +0200
Message-Id: <20180803143626.48191-4-hverkuil@xs4all.nl>
In-Reply-To: <20180803143626.48191-1-hverkuil@xs4all.nl>
References: <20180803143626.48191-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vimc/vimc-common.c | 18 ++++++++++++++++++
 drivers/media/platform/vimc/vimc-core.c   |  6 +++---
 2 files changed, 21 insertions(+), 3 deletions(-)

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
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 9246f265de31..d8d3803a47f9 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -309,13 +309,13 @@ static int vimc_probe(struct platform_device *pdev)
 	if (!vimc->subdevs)
 		return -ENOMEM;
 
+	/* Link the media device within the v4l2_device */
+	vimc->v4l2_dev.mdev = &vimc->mdev;
+
 	match = vimc_add_subdevs(vimc);
 	if (IS_ERR(match))
 		return PTR_ERR(match);
 
-	/* Link the media device within the v4l2_device */
-	vimc->v4l2_dev.mdev = &vimc->mdev;
-
 	/* Initialize media device */
 	strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
 		sizeof(vimc->mdev.model));
-- 
2.18.0
