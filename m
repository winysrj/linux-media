Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:50349 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbeK0TcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:32:08 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: imx274: declare the correct number of controls
Date: Tue, 27 Nov 2018 09:34:44 +0100
Message-Id: <20181127083445.27737-2-luca@lucaceresoli.net>
In-Reply-To: <20181127083445.27737-1-luca@lucaceresoli.net>
References: <20181127083445.27737-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_handler_init() expects a hint of how many controls this
handler is expected to refer to. Since this number here is always 4,
let's pass exactly 4.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 78746c51071d..40c717f13eb8 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1904,7 +1904,7 @@ static int imx274_probe(struct i2c_client *client,
 	imx274_reset(imx274, 1);
 
 	/* initialize controls */
-	ret = v4l2_ctrl_handler_init(&imx274->ctrls.handler, 2);
+	ret = v4l2_ctrl_handler_init(&imx274->ctrls.handler, 4);
 	if (ret < 0) {
 		dev_err(&client->dev,
 			"%s : ctrl handler init Failed\n", __func__);
-- 
2.17.1
