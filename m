Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2419 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700Ab3E2LBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 08/38] saa6752hs: drop obsolete g_chip_ident.
Date: Wed, 29 May 2013 12:59:41 +0200
Message-Id: <1369825211-29770-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op and the v4l2-chip-ident.h header are no longer needed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/saa7134/saa6752hs.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa6752hs.c b/drivers/media/pci/saa7134/saa6752hs.c
index f147b05..244b286 100644
--- a/drivers/media/pci/saa7134/saa6752hs.c
+++ b/drivers/media/pci/saa7134/saa6752hs.c
@@ -35,7 +35,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 #include <linux/init.h>
 #include <linux/crc32.h>
 
@@ -92,7 +91,6 @@ static const struct v4l2_format v4l2_format_table[] =
 
 struct saa6752hs_state {
 	struct v4l2_subdev            sd;
-	int 			      chip;
 	u32 			      revision;
 	int 			      has_ac3;
 	struct saa6752hs_mpeg_params  params;
@@ -914,19 +912,9 @@ static int saa6752hs_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
-static int saa6752hs_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct saa6752hs_state *h = to_state(sd);
-
-	return v4l2_chip_ident_i2c_client(client,
-			chip, h->chip, h->revision);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
-	.g_chip_ident = saa6752hs_g_chip_ident,
 	.init = saa6752hs_init,
 	.queryctrl = saa6752hs_queryctrl,
 	.querymenu = saa6752hs_querymenu,
@@ -963,11 +951,9 @@ static int saa6752hs_probe(struct i2c_client *client,
 
 	i2c_master_send(client, &addr, 1);
 	i2c_master_recv(client, data, sizeof(data));
-	h->chip = V4L2_IDENT_SAA6752HS;
 	h->revision = (data[8] << 8) | data[9];
 	h->has_ac3 = 0;
 	if (h->revision == 0x0206) {
-		h->chip = V4L2_IDENT_SAA6752HS_AC3;
 		h->has_ac3 = 1;
 		v4l_info(client, "support AC-3\n");
 	}
-- 
1.7.10.4

