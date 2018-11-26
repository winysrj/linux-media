Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbeKZTEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:04:47 -0500
Date: Mon, 26 Nov 2018 11:10:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: cedrus: Fix a NULL vs IS_ERR() check
Message-ID: <20181126081044.yz5tenssdbt7mugb@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The devm_ioremap_resource() function doesn't return NULL pointers, it
returns error pointers.

Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index 32adbcbe6175..07520a2ce179 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -255,10 +255,10 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	res = platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(dev->dev, res);
-	if (!dev->base) {
+	if (IS_ERR(dev->base)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
 
-		ret = -ENOMEM;
+		ret = PTR_ERR(dev->base);
 		goto err_sram;
 	}
 
-- 
2.11.0
