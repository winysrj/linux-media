Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:42457 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753114AbeBIXLf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 18:11:35 -0500
Received: by mail-qk0-f193.google.com with SMTP id c185so4570540qkg.9
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 15:11:35 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: slongerbeam@gmail.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, ian.arkver.dev@gmail.com,
        hans.verkuil@cisco.com, p.zabel@pengutronix.de,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v2] media: imx-media-internal-sd: Use empty initializer
Date: Fri,  9 Feb 2018 21:11:16 -0200
Message-Id: <1518217876-7037-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

When building with W=1 the following warning shows up:

drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: Using plain integer as NULL pointer

Fix this problem by using an empty initializer, which guarantees that all
struct members are zero-cleared.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
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
