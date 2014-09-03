Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 03/46] [media] soc_camera: use kmemdup()
Date: Wed,  3 Sep 2014 17:32:35 -0300
Message-Id: <b7688fe7abdac43a645e7a69748a561cf9960009.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of calling kzalloc and then copying, use kmemdup(). That
avoids zeroing the data structure before copying.

Found by coccinelle.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4308fed5431..ee8cdc95a9f9 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1347,13 +1347,11 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	ssdd = kzalloc(sizeof(*ssdd), GFP_KERNEL);
+	ssdd = kmemdup(&sdesc->subdev_desc, sizeof(*ssdd), GFP_KERNEL);
 	if (!ssdd) {
 		ret = -ENOMEM;
 		goto ealloc;
 	}
-
-	memcpy(ssdd, &sdesc->subdev_desc, sizeof(*ssdd));
 	/*
 	 * In synchronous case we request regulators ourselves in
 	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try
-- 
1.9.3

