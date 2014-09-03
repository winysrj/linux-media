Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaICUdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:32 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 07/46] [media] soc_camera: remove uneeded semicolons
Date: Wed,  3 Sep 2014 17:32:39 -0300
Message-Id: <d3599a11e3a1b7f14a6f402cec5d4bda68a1154f.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't use semicolons after curly braces in the middle of the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 64dc80ccd6f9..66178fc9f9eb 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1694,7 +1694,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 		break;
 	default:
 		break;
-	};
+	}
 
 	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
 		pcdev->platform_flags |= PXA_CAMERA_MASTER;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 85d579f65f52..b122c2cf5b85 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1502,7 +1502,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	} else {
 		priv->ici.nr = of_alias_get_id(pdev->dev.of_node, "vin");
 		priv->chip = (enum chip_id)match->data;
-	};
+	}
 
 	spin_lock_init(&priv->lock);
 	INIT_LIST_HEAD(&priv->capture);
-- 
1.9.3

