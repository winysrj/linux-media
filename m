Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48948 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756699AbeDFOXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 08/21] media: davinci_vpfe: fix a typo for "default"
Date: Fri,  6 Apr 2018 10:23:09 -0400
Message-Id: <b0ed690171b1bc3d77d144271b06e7035da696aa.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

resizer_set_defualt_configuration -> resizer_set_default_configuration

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 1ee216d71d42..1e478755fe2f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -794,7 +794,7 @@ resizer_configure_in_single_shot_mode(struct vpfe_resizer_device *resizer)
 }
 
 static void
-resizer_set_defualt_configuration(struct vpfe_resizer_device *resizer)
+resizer_set_default_configuration(struct vpfe_resizer_device *resizer)
 {
 #define  WIDTH_I 640
 #define  HEIGHT_I 480
@@ -916,7 +916,7 @@ resizer_set_configuration(struct vpfe_resizer_device *resizer,
 			  struct vpfe_rsz_config *chan_config)
 {
 	if (!chan_config->config)
-		resizer_set_defualt_configuration(resizer);
+		resizer_set_default_configuration(resizer);
 	else
 		if (copy_from_user(&resizer->config.user_config,
 		    chan_config->config, sizeof(struct vpfe_rsz_config_params)))
-- 
2.14.3
