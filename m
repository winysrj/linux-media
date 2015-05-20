Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56249 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753677AbbEUJCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:45 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 17/20] media: adv7604: Support V4L_FIELD_INTERLACED
Date: Wed, 20 May 2015 17:39:37 +0100
Message-Id: <1432139980-12619-18-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When hardware reports interlaced input, correctly set field to
V4L_FIELD_INTERLACED ini adv76xx_fill_format.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/i2c/adv7604.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 4bde3e1..d77ee1f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1791,7 +1791,12 @@ static void adv76xx_fill_format(struct adv76xx_state *state,
 
 	format->width = state->timings.bt.width;
 	format->height = state->timings.bt.height;
-	format->field = V4L2_FIELD_NONE;
+
+	if (state->timings.bt.interlaced)
+		format->field= V4L2_FIELD_INTERLACED;
+	else
+		format->field= V4L2_FIELD_NONE;
+
 	format->colorspace = V4L2_COLORSPACE_SRGB;
 
 	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO)
-- 
1.7.10.4

