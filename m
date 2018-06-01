Return-path: <linux-media-owner@vger.kernel.org>
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:53430 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbeFAJWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 05:22:54 -0400
From: Nicholas Mc Guire <hofrat@opentech.at>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@opentech.at>
Subject: [PATCH] media: adv7604: simplify of_node_put()
Date: Fri,  1 Jun 2018 09:21:32 +0000
Message-Id: <1527844892-30309-1-git-send-email-hofrat@opentech.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the of_node_put() is unconditional here there is no need to have it
twice.

Signed-off-by: Nicholas Mc Guire <hofrat@opentech.at>
---

Problem located by experimental coccinelle script

Not sure if such a change makes this much more readable - it is a trivial
simplification of the code though. Pleas let me know if such micro
refactoring makes sense or not.

Patch was compile tested with: x86_64_defconfig + GPIOLIB=y,
Multimedia support=y, CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y,
CONFIG_MEDIA_CAMERA_SUPPORT=y CONFIG_VIDEO_V4L2_SUBDEV_API=y,
CONFIG_VIDEO_ADV7604=y

Patch is against 4.17-rc5 (localversion-next is -next-20180529)

 drivers/media/i2c/adv7604.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cac2081..cc8eac3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3108,12 +3108,9 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		return -EINVAL;
 
 	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg);
-	if (ret) {
-		of_node_put(endpoint);
-		return ret;
-	}
-
 	of_node_put(endpoint);
+	if (ret)
+		return ret;
 
 	if (!of_property_read_u32(np, "default-input", &v))
 		state->pdata.default_input = v;
-- 
2.1.4
