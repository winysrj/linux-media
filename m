Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.43]:37131 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750785AbdFVEB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 00:01:27 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 224249F5C38
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 23:01:24 -0500 (CDT)
Date: Wed, 21 Jun 2017 23:01:22 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] radio: wl1273: add check on core->write() return value
Message-ID: <20170622040122.GA7161@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check return value from call to core->write(), so in case of
error print error message, jump to goto label fail and eventually
return.

Addresses-Coverity-ID: 1226943
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/radio/radio-wl1273.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 7240223..17e82a9 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -610,10 +610,21 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 			}
 		}
 
-		if (radio->rds_on)
+		if (radio->rds_on) {
 			r = core->write(core, WL1273_RDS_DATA_ENB, 1);
-		else
+			if (r) {
+				dev_err(dev, "%s: RDS_DATA_ENB ON fails\n",
+					__func__);
+				goto fail;
+			}
+		} else {
 			r = core->write(core, WL1273_RDS_DATA_ENB, 0);
+			if (r) {
+				dev_err(dev, "%s: RDS_DATA_ENB OFF fails\n",
+					__func__);
+				goto fail;
+			}
+		}
 	} else {
 		dev_warn(dev, "%s: Illegal mode.\n", __func__);
 	}
-- 
2.5.0
