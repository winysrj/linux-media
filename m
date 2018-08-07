Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58342 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387578AbeHGRzG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 13:55:06 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH] media: mt9v111: fix random build errors
Date: Tue,  7 Aug 2018 11:40:09 -0400
Message-Id: <c2d9d6f28de1a10bf0a26b36daa082acab2be5cd.1533656407.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the internal check for it to do the right thing if the
subdev API is not built.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/mt9v111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index 70fad0940435..b5410aeb5fe2 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -797,7 +797,7 @@ static struct v4l2_mbus_framefmt *__mt9v111_get_pad_format(
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
+#if IS_ENABLED(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);
 #else
 		return &cfg->try_fmt;
-- 
2.17.1
