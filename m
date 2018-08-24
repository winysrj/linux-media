Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:33160 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHXULd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] media: imx274: don't hard-code the subdev name to DRIVER_NAME
Date: Fri, 24 Aug 2018 18:35:21 +0200
Message-Id: <20180824163525.12694-4-luca@lucaceresoli.net>
In-Reply-To: <20180824163525.12694-1-luca@lucaceresoli.net>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forcibly setting the subdev name to DRIVER_NAME (i.e. "IMX274") makes
it non-unique and less informative.

Let the driver use the default name from i2c, e.g. "IMX274 2-001a".

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 9b524de08470..570706695ca7 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1885,7 +1885,6 @@ static int imx274_probe(struct i2c_client *client,
 	imx274->client = client;
 	sd = &imx274->sd;
 	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/* initialize subdev media pad */
-- 
2.17.1
