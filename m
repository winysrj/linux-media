Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:57263 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbbL1JPu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 04:15:50 -0500
Subject: [PATCH] [media] tuners: One check less in
 m88rs6000t_get_rf_strength() after error detection
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5680FDB3.7060305@users.sourceforge.net>
Date: Mon, 28 Dec 2015 10:15:31 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 10:10:34 +0100

This issue was detected by using the Coccinelle software.

Move the jump label directly before the desired log statement
so that the variable "ret" will not be checked once more
after it was determined that a function call failed.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/m88rs6000t.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index 504bfbc..b45594e 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -510,27 +510,27 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 
 	ret = regmap_read(dev->regmap, 0x5A, &val);
 	if (ret)
-		goto err;
+		goto report_failure;
 	RF_GC = val & 0x0f;
 
 	ret = regmap_read(dev->regmap, 0x5F, &val);
 	if (ret)
-		goto err;
+		goto report_failure;
 	IF_GC = val & 0x0f;
 
 	ret = regmap_read(dev->regmap, 0x3F, &val);
 	if (ret)
-		goto err;
+		goto report_failure;
 	TIA_GC = (val >> 4) & 0x07;
 
 	ret = regmap_read(dev->regmap, 0x77, &val);
 	if (ret)
-		goto err;
+		goto report_failure;
 	BB_GC = (val >> 4) & 0x0f;
 
 	ret = regmap_read(dev->regmap, 0x76, &val);
 	if (ret)
-		goto err;
+		goto report_failure;
 	PGA2_GC = val & 0x3f;
 	PGA2_cri = PGA2_GC >> 2;
 	PGA2_crf = PGA2_GC & 0x03;
@@ -562,9 +562,11 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	/* scale value to 0x0000-0xffff */
 	gain = clamp_val(gain, 1000U, 10500U);
 	*strength = (10500 - gain) * 0xffff / (10500 - 1000);
-err:
-	if (ret)
+
+	if (ret) {
+report_failure:
 		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	}
 	return ret;
 }
 
-- 
2.6.3

