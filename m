Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:44421 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936199AbeF2Lnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 07:43:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 08/12] ad9389b/adv7511: set proper media entity function
Date: Fri, 29 Jun 2018 13:43:27 +0200
Message-Id: <20180629114331.7617-9-hverkuil@xs4all.nl>
In-Reply-To: <20180629114331.7617-1-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These two drivers both have function MEDIA_ENT_F_DV_ENCODER.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad9389b.c | 1 +
 drivers/media/i2c/adv7511.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 91ff06088572..5b008b0002c0 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1134,6 +1134,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_hdl;
 	}
 	state->pad.flags = MEDIA_PAD_FL_SINK;
+	sd->entity.function = MEDIA_ENT_F_DV_ENCODER;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 5731751d3f2a..55c2ea0720d9 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1847,6 +1847,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_hdl;
 	}
 	state->pad.flags = MEDIA_PAD_FL_SINK;
+	sd->entity.function = MEDIA_ENT_F_DV_ENCODER;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
-- 
2.17.0
