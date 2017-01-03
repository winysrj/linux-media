Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55465 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757814AbdACUHG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 15:07:06 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] [media] ov2659: remove NOP assignment
Date: Tue,  3 Jan 2017 22:06:56 +0200
Message-Id: <482780de49218de0cb275cad11a83aff3d556db2.1483474016.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The loop over the ov2659_formats[] array just a few line above verifies that
mf->code matches the selected array entry.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/i2c/ov2659.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 1f999e9c0118..6e6367214d40 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1121,7 +1121,6 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	mf->colorspace = V4L2_COLORSPACE_SRGB;
-	mf->code = ov2659_formats[index].code;
 	mf->field = V4L2_FIELD_NONE;
 
 	mutex_lock(&ov2659->lock);
-- 
2.11.0

