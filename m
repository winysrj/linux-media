Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965457AbbD1MAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:00:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Benoit Parrot <bparrot@ti.com>
Subject: [PATCH 3/3] am437x: remove unused variable
Date: Tue, 28 Apr 2015 08:59:56 -0300
Message-Id: <2a685cc104d1621c0519b35555d562f9d2d29cbd.1430222388.git.mchehab@osg.samsung.com>
In-Reply-To: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
In-Reply-To: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_get_subdev_input_index':
drivers/media/platform/am437x/am437x-vpfe.c:1679:27: warning: variable 'sdinfo' set but not used [-Wunused-but-set-variable]
  struct vpfe_subdev_info *sdinfo;
                           ^

Cc: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 57c8a653da4a..73359652e486 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1675,12 +1675,9 @@ vpfe_get_subdev_input_index(struct vpfe_device *vpfe,
 			    int *subdev_input_index,
 			    int app_input_index)
 {
-	struct vpfe_config *cfg = vpfe->cfg;
-	struct vpfe_subdev_info *sdinfo;
 	int i, j = 0;
 
 	for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
-		sdinfo = &cfg->sub_devs[i];
 		if (app_input_index < (j + 1)) {
 			*subdev_index = i;
 			*subdev_input_index = app_input_index - j;
-- 
2.1.0

