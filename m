Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:65083 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbcFTPsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:48:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, mchehab@osg.samsung.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thaissa Falbo <thaissa.falbo@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging: davinci_vpfe: fix W=1 build warnings
Date: Mon, 20 Jun 2016 17:47:56 +0200
Message-Id: <20160620154852.2336421-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building with "make W=1", we get multiple harmless build warnings
for the vpfe driver:

drivers/staging/media/davinci_vpfe/dm365_resizer.c:241:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]
drivers/staging/media/davinci_vpfe/dm365_resizer.c: In function 'resizer_set_defualt_configuration':
drivers/staging/media/davinci_vpfe/dm365_resizer.c:831:16: error: initialized field overwritten [-Werror=override-init]
drivers/staging/media/davinci_vpfe/dm365_resizer.c:831:16: note: (near initialization for 'rsz_default_config.rsz_rsc_param[0].h_typ_c')
drivers/staging/media/davinci_vpfe/dm365_resizer.c:849:16: error: initialized field overwritten [-Werror=override-init]
drivers/staging/media/davinci_vpfe/dm365_resizer.c:849:16: note: (near initialization for 'rsz_default_config.rsz_rsc_param[1].h_typ_c')

All of them are trivial to fix without changing the behavior of the
driver, as "static const" is interpreted the same as "const static",
and VPFE_RSZ_INTP_CUBIC is defined as zero, so the initializations
are not really needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 3cd56cc132c7..567f995fd0f9 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -237,9 +237,8 @@ resizer_calculate_resize_ratios(struct vpfe_resizer_device *resizer, int index)
 			((informat->width) * 256) / (outformat->width);
 }
 
-void
-static resizer_enable_422_420_conversion(struct resizer_params *param,
-					 int index, bool en)
+static void resizer_enable_422_420_conversion(struct resizer_params *param,
+					      int index, bool en)
 {
 	param->rsz_rsc_param[index].cen = en;
 	param->rsz_rsc_param[index].yen = en;
@@ -825,7 +824,7 @@ resizer_set_defualt_configuration(struct vpfe_resizer_device *resizer)
 				.o_hsz = WIDTH_O - 1,
 				.v_dif = 256,
 				.v_typ_y = VPFE_RSZ_INTP_CUBIC,
-				.h_typ_c = VPFE_RSZ_INTP_CUBIC,
+				.v_typ_c = VPFE_RSZ_INTP_CUBIC,
 				.h_dif = 256,
 				.h_typ_y = VPFE_RSZ_INTP_CUBIC,
 				.h_typ_c = VPFE_RSZ_INTP_CUBIC,
@@ -843,7 +842,7 @@ resizer_set_defualt_configuration(struct vpfe_resizer_device *resizer)
 				.o_hsz = WIDTH_O - 1,
 				.v_dif = 256,
 				.v_typ_y = VPFE_RSZ_INTP_CUBIC,
-				.h_typ_c = VPFE_RSZ_INTP_CUBIC,
+				.v_typ_c = VPFE_RSZ_INTP_CUBIC,
 				.h_dif = 256,
 				.h_typ_y = VPFE_RSZ_INTP_CUBIC,
 				.h_typ_c = VPFE_RSZ_INTP_CUBIC,
-- 
2.9.0

