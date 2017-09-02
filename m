Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56926 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752684AbdIBPvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 11:51:14 -0400
Subject: [PATCH 4/7] [media] ov9640: Delete an error message for a failed
 memory allocation in ov9640_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c9f2ba21-c742-e1e8-26d9-a56c51c56d65@users.sourceforge.net>
Message-ID: <4938313f-e5ba-a4b9-f5d5-c53f50f976b1@users.sourceforge.net>
Date: Sat, 2 Sep 2017 17:51:04 +0200
MIME-Version: 1.0
In-Reply-To: <c9f2ba21-c742-e1e8-26d9-a56c51c56d65@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 16:34:27 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/i2c/soc_camera/ov9640.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 0146d1f7aacb..0f02f022f3e9 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -679,8 +679,5 @@ static int ov9640_probe(struct i2c_client *client,
-	if (!priv) {
-		dev_err(&client->dev,
-			"Failed to allocate memory for private data!\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
 
-- 
2.14.1
