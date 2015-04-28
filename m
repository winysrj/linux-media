Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965462AbbD1MAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:00:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Benoit Parrot <bparrot@ti.com>
Subject: [PATCH 2/3] am437x: Fix a wrong identation
Date: Tue, 28 Apr 2015 08:59:55 -0300
Message-Id: <c1cdcbbcbde261b1c8c96e8880ac84b03cf797d9.1430222388.git.mchehab@osg.samsung.com>
In-Reply-To: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
In-Reply-To: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/am437x/am437x-vpfe.c:513 vpfe_ccdc_set_params() warn: inconsistent indenting

Cc: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 9c037ac10e10..57c8a653da4a 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -510,7 +510,7 @@ static int vpfe_ccdc_set_params(struct vpfe_ccdc *ccdc, void __user *params)
 
 	if (!vpfe_ccdc_validate_param(ccdc, &raw_params)) {
 		vpfe_ccdc_update_raw_params(ccdc, &raw_params);
-			return 0;
+		return 0;
 	}
 
 	return -EINVAL;
-- 
2.1.0

