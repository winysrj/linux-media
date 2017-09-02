Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49551 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752399AbdIBNIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 09:08:00 -0400
Subject: [PATCH 2/4] [media] adv7604: Adjust a null pointer check in three
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Message-ID: <b0d8f437-f0ea-154a-c68a-71ee73aa6587@users.sourceforge.net>
Date: Sat, 2 Sep 2017 15:07:51 +0200
MIME-Version: 1.0
In-Reply-To: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 11:43:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/i2c/adv7604.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cc693ef71f33..0a774d025858 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1948,7 +1948,7 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	info = adv76xx_format_info(state, format->format.code);
-	if (info == NULL)
+	if (!info)
 		info = adv76xx_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
 	adv76xx_fill_format(state, &format->format);
@@ -2256,7 +2256,7 @@ static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return 0;
 	}
 
-	if (data == NULL)
+	if (!data)
 		return -ENODATA;
 
 	if (edid->start_block >= state->edid.blocks)
@@ -3480,7 +3480,7 @@ static int adv76xx_probe(struct i2c_client *client,
 		state->i2c_clients[i] =
 			adv76xx_dummy_client(sd, state->pdata.i2c_addresses[i],
 					     0xf2 + i);
-		if (state->i2c_clients[i] == NULL) {
+		if (!state->i2c_clients[i]) {
 			err = -ENOMEM;
 			v4l2_err(sd, "failed to create i2c client %u\n", i);
 			goto err_i2c;
-- 
2.14.1
