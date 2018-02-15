Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:38620 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755126AbeBOJ0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 04:26:18 -0500
From: Parthiban Nallathambi <pn@denx.de>
To: slongerbeam@gmail.com
Cc: p.zabel@pengutronix.de, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Parthiban Nallathambi <pn@denx.de>
Subject: [PATCH v2] media: imx: capture: reformat line to 80 chars or less
Date: Thu, 15 Feb 2018 10:25:45 +0100
Message-Id: <20180215092545.25475-1-pn@denx.de>
In-Reply-To: <ee47261e-aa6d-150f-e7f0-b80c74fdec1d@gmail.com>
References: <ee47261e-aa6d-150f-e7f0-b80c74fdec1d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cleanup patch to fix line length issue found
by checkpatch.pl script.

In this patch, line 144 have been wrapped.

Signed-off-by: Parthiban Nallathambi <pn@denx.de>
---
Changes in v2:
- Changed commit message

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
