Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5/7] [media] omap3isp: remove unused var
Date: Wed, 24 Jun 2015 07:49:09 -0300
Message-Id: <7a9327cd8788da75b44d3bafb058bcfd6ae34319.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/omap3isp/isppreview.c:932:6: warning: variable ‘features’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 15cb254ccc39..13803270d104 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -929,14 +929,10 @@ static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
 			     u32 active)
 {
 	unsigned int i;
-	u32 features;
 
 	if (update == 0)
 		return;
 
-	features = (prev->params.params[0].features & active)
-		 | (prev->params.params[1].features & ~active);
-
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		const struct preview_update *attr = &update_attrs[i];
 		struct prev_params *params;
-- 
2.4.3

