Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48581
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751175AbdFTKNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 06:13:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH] [media] max2175: remove an useless comparision
Date: Tue, 20 Jun 2017 07:12:36 -0300
Message-Id: <8ca00927d61eb4dafe823387f1fb23913ffed5f0.1497953554.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

load is an unsigned integer. So, it is always bigger or equal
to zero, as reported by gcc:

	drivers/media/i2c/max2175.c: In function 'max2175_refout_load_to_bits':
	drivers/media/i2c/max2175.c:1272:11: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
	  if (load >= 0 && load <= 40)
	           ^~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index 0d28a80f8ed2..a4736a8a7792 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -1269,7 +1269,7 @@ static const struct v4l2_ctrl_config max2175_na_rx_mode = {
 static int max2175_refout_load_to_bits(struct i2c_client *client, u32 load,
 				       u32 *bits)
 {
-	if (load >= 0 && load <= 40)
+	if (load <= 40)
 		*bits = load / 10;
 	else if (load >= 60 && load <= 70)
 		*bits = load / 10 - 1;
-- 
2.9.4
