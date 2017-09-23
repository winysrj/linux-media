Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61813 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdIWToV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:44:21 -0400
Subject: [PATCH 1/3] [media] camss-csid: Use common error handling code in
 csid_set_power()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <168ff884-7ace-c548-7f90-d4f2910bb337@users.sourceforge.net>
Message-ID: <0fe4e31f-02e2-8b48-c8a8-811ecd8a482f@users.sourceforge.net>
Date: Sat, 23 Sep 2017 21:44:15 +0200
MIME-Version: 1.0
In-Reply-To: <168ff884-7ace-c548-7f90-d4f2910bb337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 23 Sep 2017 20:48:33 +0200

Add jump targets so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/qcom/camss-8x16/camss-csid.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
index 64df82817de3..92d4dc6b4a66 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
@@ -330,13 +330,9 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		ret = csid_set_clock_rates(csid);
-		if (ret < 0) {
-			regulator_disable(csid->vdda);
-			return ret;
-		}
+		if (ret < 0)
+			goto disable_regulator;
 
 		ret = camss_enable_clocks(csid->nclocks, csid->clock, dev);
-		if (ret < 0) {
-			regulator_disable(csid->vdda);
-			return ret;
-		}
+		if (ret < 0)
+			goto disable_regulator;
 
 		enable_irq(csid->irq);
@@ -345,8 +341,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		if (ret < 0) {
 			disable_irq(csid->irq);
 			camss_disable_clocks(csid->nclocks, csid->clock);
-			regulator_disable(csid->vdda);
-			return ret;
+			goto disable_regulator;
 		}
 
 		hw_version = readl_relaxed(csid->base + CAMSS_CSID_HW_VERSION);
@@ -357,6 +352,11 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		ret = regulator_disable(csid->vdda);
 	}
 
+	goto exit;
+
+disable_regulator:
+	regulator_disable(csid->vdda);
+exit:
 	return ret;
 }
 
-- 
2.14.1
