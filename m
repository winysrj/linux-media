Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35939 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdEEUSr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 16:18:47 -0400
Received: by mail-wm0-f51.google.com with SMTP id u65so33056527wmu.1
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 13:18:46 -0700 (PDT)
From: Remco <remco@dutchcoders.io>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Remco Verhoef <remco@dutchcoders.io>
Subject: [PATCH] media: fix one code style problem
Date: Fri,  5 May 2017 13:18:24 -0700
Message-Id: <20170505201824.39399-1-remco@dutchcoders.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Remco Verhoef <remco@dutchcoders.io>

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
