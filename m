Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.148.2]:38391 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755291AbdJQSEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 14:04:53 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id EF4F61860D
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 12:19:08 -0500 (CDT)
Date: Tue, 17 Oct 2017 12:19:07 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] staging: media: imx: fix inconsistent IS_ERR and PTR_ERR
Message-ID: <20171017171907.GA3957@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix inconsistent IS_ERR and PTR_ERR in csi_link_validate.
The proper pointer to be passed as argument is sensor.

This issue was detected with the help of Coccinelle.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
This code was tested by compilation only.

 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6d85611..2fa72c1 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -989,7 +989,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 	sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
 	if (IS_ERR(sensor)) {
 		v4l2_err(&priv->sd, "no sensor attached\n");
-		return PTR_ERR(priv->sensor);
+		return PTR_ERR(sensor);
 	}
 
 	mutex_lock(&priv->lock);
-- 
2.7.4
