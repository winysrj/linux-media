Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbeAYOPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 09:15:40 -0500
Date: Thu, 25 Jan 2018 17:15:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] sr030pc30: prevent array underflow in try_fmt()
Message-ID: <20180125141525.GA7351@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 0bf031b7e4fa..2a4882cddc51 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -511,13 +511,16 @@ static int sr030pc30_get_fmt(struct v4l2_subdev *sd,
 static const struct sr030pc30_format *try_fmt(struct v4l2_subdev *sd,
 					      struct v4l2_mbus_framefmt *mf)
 {
-	int i = ARRAY_SIZE(sr030pc30_formats);
+	int i;
 
 	sr030pc30_try_frame_size(mf);
 
-	while (i--)
+	for (i = 0; i < ARRAY_SIZE(sr030pc30_formats); i++) {
 		if (mf->code == sr030pc30_formats[i].code)
 			break;
+	}
+	if (i == ARRAY_SIZE(sr030pc30_formats))
+		i = 0;
 
 	mf->code = sr030pc30_formats[i].code;
 
