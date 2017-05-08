Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36180 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754834AbdEHRjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 13:39:23 -0400
Received: by mail-wm0-f41.google.com with SMTP id u65so92971818wmu.1
        for <linux-media@vger.kernel.org>; Mon, 08 May 2017 10:39:22 -0700 (PDT)
From: Remco Verhoef <remco@dutchcoders.io>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Remco Verhoef <remco@dutchcoders.io>
Subject: [PATCH] staging: media: fix one code style problem
Date: Mon,  8 May 2017 10:39:01 -0700
Message-Id: <20170508173901.85440-1-remco@dutchcoders.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this patch will fix one code style problem (ctx:WxE), space
prohibited before that

Signed-off-by: Remco Verhoef <remco@dutchcoders.io>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a..b0f9188 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -51,7 +51,7 @@ struct gmin_subdev {
 
 static struct gmin_subdev gmin_subdevs[MAX_SUBDEVS];
 
-static enum { PMIC_UNSET = 0, PMIC_REGULATOR, PMIC_AXP, PMIC_TI ,
+static enum { PMIC_UNSET = 0, PMIC_REGULATOR, PMIC_AXP, PMIC_TI,
 	PMIC_CRYSTALCOVE } pmic_id;
 
 /* The atomisp uses type==0 for the end-of-list marker, so leave space. */
-- 
1.9.1
