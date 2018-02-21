Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:32807 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbeBUXNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:13:50 -0500
Received: by mail-qk0-f193.google.com with SMTP id f25so4261386qkm.0
        for <linux-media@vger.kernel.org>; Wed, 21 Feb 2018 15:13:50 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: slongerbeam@gmail.com, ian.arkver.dev@gmail.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v3 2/2] media: imx-ic-prpencvf: Use empty initializer
Date: Wed, 21 Feb 2018 20:13:51 -0300
Message-Id: <1519254831-14452-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1519254831-14452-1-git-send-email-festevam@gmail.com>
References: <1519254831-14452-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

{0} explicitly assigns 0 to the first member of the structure.

Even though the first member of the v4l2_subdev_format structure is of
_u32 type, make the initialization more robust by using the empty
initializer.

This way in case someday the struct is changed so that the first
member becomes a pointer, we will not have sparse warnings.

Reported-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v1:
- Improve commit log

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
