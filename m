Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:49539 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdIRXFS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 19:05:18 -0400
Received: by mail-pf0-f180.google.com with SMTP id l188so1000401pfc.6
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 16:05:18 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: imx: Fix VDIC CSI1 selection
Date: Mon, 18 Sep 2017 16:08:16 -0700
Message-Id: <1505776096-15867-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using VDIC with CSI1, make sure to select the correct CSI in
IPU_CONF.

Fixes: f0d9c8924e2c3376 ("[media] media: imx: Add IC subdev drivers")
Suggested-by: Marek Vasut <marex@denx.de>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/staging/media/imx/imx-ic-prp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index c2bb5ef..9e41987 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -320,9 +320,10 @@ static int prp_link_validate(struct v4l2_subdev *sd,
 		 * the ->PRPENC link cannot be enabled if the source
 		 * is the VDIC
 		 */
-		if (priv->sink_sd_prpenc)
+		if (priv->sink_sd_prpenc) {
 			ret = -EINVAL;
-		goto out;
+			goto out;
+		}
 	} else {
 		/* the source is a CSI */
 		if (!csi) {
-- 
2.7.4
