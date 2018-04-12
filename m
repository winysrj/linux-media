Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:48467 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752846AbeDLQvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:35 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] imx274: actually use IMX274_DEFAULT_MODE
Date: Thu, 12 Apr 2018 18:51:15 +0200
Message-Id: <1523551878-15754-11-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
References: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IMX274_DEFAULT_MODE is defined but not used. Start using it, so the
default can be more easily changed without digging into the code.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 25907d0817a4..39d548ce30c4 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1621,7 +1621,7 @@ static int imx274_probe(struct i2c_client *client,
 	mutex_init(&imx274->lock);
 
 	/* initialize format */
-	imx274->mode = &imx274_formats[IMX274_MODE_3840X2160];
+	imx274->mode = &imx274_formats[IMX274_DEFAULT_MODE];
 	imx274->format.width = imx274->mode->size.width;
 	imx274->format.height = imx274->mode->size.height;
 	imx274->format.field = V4L2_FIELD_NONE;
-- 
2.7.4
