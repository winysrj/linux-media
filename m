Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcCUXcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 19:32:14 -0400
From: Colin King <colin.king@canonical.com>
To: prabhakar.csengg@gmail.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] media: am437x-vpfe: ensure ret is initialized
Date: Mon, 21 Mar 2016 23:32:10 +0000
Message-Id: <1458603130-6158-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

ret should be initialized to 0; for example if pfe->fmt.fmt.pix.field
is V4L2_FIELD_NONE then ret will contain garbage from the
uninitialized state causing garbage to be returned if it is non-zero.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index de32e3a..7d14732 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1047,7 +1047,7 @@ static int vpfe_get_ccdc_image_format(struct vpfe_device *vpfe,
 static int vpfe_config_ccdc_image_format(struct vpfe_device *vpfe)
 {
 	enum ccdc_frmfmt frm_fmt = CCDC_FRMFMT_INTERLACED;
-	int ret;
+	int ret = 0;
 
 	vpfe_dbg(2, vpfe, "vpfe_config_ccdc_image_format\n");
 
-- 
2.7.3

