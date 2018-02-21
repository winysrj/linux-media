Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39149 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeBUXNs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:13:48 -0500
Received: by mail-qk0-f196.google.com with SMTP id z197so4240214qkb.6
        for <linux-media@vger.kernel.org>; Wed, 21 Feb 2018 15:13:47 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: slongerbeam@gmail.com, ian.arkver.dev@gmail.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v3 1/2] media: imx-media-internal-sd: Use empty initializer
Date: Wed, 21 Feb 2018 20:13:50 -0300
Message-Id: <1519254831-14452-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

{0} explicitly assigns 0 to the first member of the structure.

The first element of the platform_device_info struct is a pointer and
when writing 0 to a pointer the following sparse error is seen:

drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: Using plain integer as NULL pointer

Fix this problem by using an empty initializer, which also clears the
struct members and avoids the sparse warning.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes sice v2:
- Improve commit log

Changes since v1:
- Use empty initializer insted of memset() - Ian

 drivers/staging/media/imx/imx-media-internal-sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 70833fe..daf66c2 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -271,7 +271,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 			       int ipu_id)
 {
 	struct imx_media_internal_sd_platformdata pdata;
-	struct platform_device_info pdevinfo = {0};
+	struct platform_device_info pdevinfo = {};
 	struct platform_device *pdev;
 
 	pdata.grp_id = isd->id->grp_id;
-- 
2.7.4
