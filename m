Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbdGMWe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 18:34:26 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Saatvik Arya <aryasaatvik@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Derek Robson <robsonde@gmail.com>,
        Elizabeth Ferdman <gnudevliz@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging: media: davinci_vpfe: fix spelling mistake in variable
Date: Thu, 13 Jul 2017 23:34:16 +0100
Message-Id: <20170713223416.15077-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake, rename the function name
resizer_configure_in_continious_mode to
resizer_configure_in_continuous_mode and also remove an extraneous space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 857b0e847c5e..d751d590a894 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -480,7 +480,7 @@ resizer_configure_common_in_params(struct vpfe_resizer_device *resizer)
 	return 0;
 }
 static int
-resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
+resizer_configure_in_continuous_mode(struct vpfe_resizer_device *resizer)
 {
 	struct device *dev = resizer->crop_resizer.subdev.v4l2_dev->dev;
 	struct resizer_params *param = &resizer->config;
@@ -1242,7 +1242,7 @@ static int resizer_do_hw_setup(struct vpfe_resizer_device *resizer)
 		    ipipeif_source == IPIPEIF_OUTPUT_RESIZER)
 			ret = resizer_configure_in_single_shot_mode(resizer);
 		else
-			ret =  resizer_configure_in_continious_mode(resizer);
+			ret = resizer_configure_in_continuous_mode(resizer);
 		if (ret)
 			return ret;
 		ret = config_rsz_hw(resizer, param);
-- 
2.11.0
