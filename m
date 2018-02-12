Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:47751 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933268AbeBLMGu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 07:06:50 -0500
From: Parthiban Nallathambi <pn@denx.de>
To: slongerbeam@gmail.com
Cc: p.zabel@pengutronix.de, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Parthiban Nallathambi <pn@denx.de>
Subject: [PATCH] staging: media: reformat line to 80 chars or less
Date: Mon, 12 Feb 2018 13:05:48 +0100
Message-Id: <20180212120548.7391-1-pn@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cleanup patch to fix line length issue found
by checkpatch.pl script.

In this patch, line 144 have been wrapped.

Signed-off-by: Parthiban Nallathambi <pn@denx.de>
---
 drivers/staging/media/imx/imx-media-capture.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 576bdc7e9c42..0ccabe04b0e1 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -141,7 +141,8 @@ static int capture_enum_frameintervals(struct file *file, void *fh,
 
 	fie.code = cc->codes[0];
 
-	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval, NULL, &fie);
+	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval,
+			       NULL, &fie);
 	if (ret)
 		return ret;
 
-- 
2.14.3
