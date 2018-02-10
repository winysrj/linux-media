Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:39101 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeBJOjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 09:39:16 -0500
Received: by mail-qk0-f194.google.com with SMTP id d72so13538840qkc.6
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 06:39:16 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: slongerbeam@gmail.com, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] media: imx-ic-prpencvf: Use empty initializer to clear all struct members
Date: Sat, 10 Feb 2018 12:38:50 -0200
Message-Id: <1518273530-7265-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

{0} only cleans the first member of the structure.

Use {} instead, which cleans all the members of the structure.

Reported-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 143038c..60f392a 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -923,7 +923,7 @@ static int prp_enum_frame_size(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct prp_priv *priv = sd_to_priv(sd);
-	struct v4l2_subdev_format format = {0};
+	struct v4l2_subdev_format format = {};
 	const struct imx_media_pixfmt *cc;
 	int ret = 0;
 
-- 
2.7.4
