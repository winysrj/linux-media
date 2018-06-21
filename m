Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:54316 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753987AbeFUHTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 03:19:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 6/8] ad9389b/adv7511: set proper media entity function
Date: Thu, 21 Jun 2018 09:19:12 +0200
Message-Id: <20180621071914.28729-7-hverkuil@xs4all.nl>
In-Reply-To: <20180621071914.28729-1-hverkuil@xs4all.nl>
References: <20180621071914.28729-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These two drivers both have function MEDIA_ENT_F_DTV_ENCODER.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 1 +
 drivers/media/i2c/adv7511.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 91ff06088572..0dfd94fcd18e 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1134,6 +1134,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_hdl;
 	}
 	state->pad.flags = MEDIA_PAD_FL_SINK;
+	sd->entity.function = MEDIA_ENT_F_DTV_ENCODER;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 5731751d3f2a..d837617930b9 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1847,6 +1847,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_hdl;
 	}
 	state->pad.flags = MEDIA_PAD_FL_SINK;
+	sd->entity.function = MEDIA_ENT_F_DTV_ENCODER;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
-- 
2.17.0
