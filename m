Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbLECNP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:15 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 22/32] v4l: vsp1: Make the BRU optional
Date: Sat,  5 Dec 2015 04:12:56 +0200
Message-Id: <1449281586-25726-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all VSP instances have a BRU on R-Car Gen3, make it optional. Set
the feature unconditionally for now, this will be fixed when adding Gen3
support.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---

Changes since v1:

- Don't add a new DT property

---
 drivers/media/platform/vsp1/vsp1.h     |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 29a8fd94a0aa..d980f32aac0b 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -42,6 +42,7 @@ struct vsp1_uds;
 #define VSP1_HAS_LIF		(1 << 0)
 #define VSP1_HAS_LUT		(1 << 1)
 #define VSP1_HAS_SRU		(1 << 2)
+#define VSP1_HAS_BRU		(1 << 3)
 
 struct vsp1_platform_data {
 	unsigned int features;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 53a32f6ccbc0..42b6a106cbbb 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -223,13 +223,15 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Instantiate all the entities. */
-	vsp1->bru = vsp1_bru_create(vsp1);
-	if (IS_ERR(vsp1->bru)) {
-		ret = PTR_ERR(vsp1->bru);
-		goto done;
-	}
+	if (vsp1->pdata.features & VSP1_HAS_BRU) {
+		vsp1->bru = vsp1_bru_create(vsp1);
+		if (IS_ERR(vsp1->bru)) {
+			ret = PTR_ERR(vsp1->bru);
+			goto done;
+		}
 
-	list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
+		list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
+	}
 
 	vsp1->hsi = vsp1_hsit_create(vsp1, true);
 	if (IS_ERR(vsp1->hsi)) {
@@ -540,6 +542,7 @@ static int vsp1_parse_dt(struct vsp1_device *vsp1)
 		return -EINVAL;
 	}
 
+	pdata->features |= VSP1_HAS_BRU;
 	pdata->num_bru_inputs = 4;
 
 	return 0;
-- 
2.4.10

