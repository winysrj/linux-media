Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0051.outbound.protection.outlook.com ([104.47.41.51]:45568
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750853AbeBIUqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 15:46:32 -0500
From: Fabio Estevam <fabio.estevam@nxp.com>
To: <mchehab@kernel.org>
CC: <slongerbeam@gmail.com>, <p.zabel@pengutronix.de>,
        <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] media: imx-media-internal-sd: Use memset to clear pdevinfo struct
Date: Fri, 9 Feb 2018 14:36:40 -0200
Message-ID: <20180209163640.8759-1-fabio.estevam@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building with W=1 the following warning shows up:

drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: Using plain integer as NULL pointer

Fix this problem by using memset() to clear the pdevinfo structure.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/staging/media/imx/imx-media-internal-sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 70833fe503b5..377c20863b76 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -271,7 +271,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 			       int ipu_id)
 {
 	struct imx_media_internal_sd_platformdata pdata;
-	struct platform_device_info pdevinfo = {0};
+	struct platform_device_info pdevinfo;
 	struct platform_device *pdev;
 
 	pdata.grp_id = isd->id->grp_id;
@@ -283,6 +283,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 	imx_media_grp_id_to_sd_name(pdata.sd_name, sizeof(pdata.sd_name),
 				    pdata.grp_id, ipu_id);
 
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	pdevinfo.name = isd->id->name;
 	pdevinfo.id = ipu_id * num_isd + isd->id->index;
 	pdevinfo.parent = imxmd->md.dev;
-- 
2.14.1
