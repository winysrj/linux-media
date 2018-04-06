Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40078 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756408AbeDFOXb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 05/21] media: davinci_vpfe: get rid of an unused var at dm365_isif.c
Date: Fri,  6 Apr 2018 10:23:06 -0400
Message-Id: <d6c8a62f783a617e44bb561ddc511e3f1b244107.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure what was the original idea here, but the implementation
went into a different way, and the fmt var is not used
anymore, as warned:

drivers/staging/media/davinci_vpfe/dm365_isif.c: In function '__isif_get_format':
drivers/staging/media/davinci_vpfe/dm365_isif.c:1401:29: warning: variable 'fmt' set but not used [-Wunused-but-set-variable]
   struct v4l2_subdev_format fmt;
                             ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_isif.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 569bcdc9ce2f..745e33fa6bea 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1397,14 +1397,9 @@ __isif_get_format(struct vpfe_isif_device *isif,
 		  struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		  enum v4l2_subdev_format_whence which)
 {
-	if (which == V4L2_SUBDEV_FORMAT_TRY) {
-		struct v4l2_subdev_format fmt;
-
-		fmt.pad = pad;
-		fmt.which = which;
-
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(&isif->subdev, cfg, pad);
-	}
+
 	return &isif->formats[pad];
 }
 
-- 
2.14.3
