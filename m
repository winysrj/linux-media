Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61643 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752176AbbGWMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 08:21:48 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
Date: Thu, 23 Jul 2015 13:21:33 +0100
Message-Id: <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prior to commit f862f57d ("[media] media: i2c: ADV7604: Migrate to
regmap"), the local variable 'val' contained the combined register
reads used in the chipset version ID test. Restore this expectation
so that the comparison works as it used to.
---
 drivers/media/i2c/adv7604.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index bfb0b6a..0587d27 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3108,7 +3108,7 @@ static int adv76xx_probe(struct i2c_client *client,
 			v4l2_err(sd, "Error %d reading IO Regmap\n", err);
 			return -ENODEV;
 		}
-		val2 |= val;
+		val |= val2;
 		if ((state->info->type == ADV7611 && val != 0x2051) ||
 			(state->info->type == ADV7612 && val != 0x2041)) {
 			v4l2_err(sd, "not an adv761x on address 0x%x\n",
-- 
1.7.10.4

