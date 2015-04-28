Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452AbbD1MAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:00:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Benoit Parrot <bparrot@ti.com>
Subject: [PATCH 1/3] am437x-vpfe: really update the vpfe_ccdc_update_raw_params data
Date: Tue, 28 Apr 2015 08:59:54 -0300
Message-Id: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_ccdc_update_raw_params':
drivers/media/platform/am437x/am437x-vpfe.c:430:38: warning: variable 'config_params' set but not used [-Wunused-but-set-variable]
  struct vpfe_ccdc_config_params_raw *config_params =
                                      ^

vpfe_ccdc_update_raw_params() is supposed to update the raw
params at ccdc. However, it is just creating a local var and changing
it.

Compile-tested only.

Cc: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index a30cc2f7e4f1..9c037ac10e10 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -430,7 +430,7 @@ vpfe_ccdc_update_raw_params(struct vpfe_ccdc *ccdc,
 	struct vpfe_ccdc_config_params_raw *config_params =
 				&ccdc->ccdc_cfg.bayer.config_params;
 
-	config_params = raw_params;
+	*config_params = *raw_params;
 }
 
 /*
-- 
2.1.0

