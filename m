Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389066AbeHGR7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 13:59:37 -0400
Date: Tue, 7 Aug 2018 12:44:39 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH] media: mt9v111: fix random build errors
Message-ID: <20180807124439.5d8b96a2@coco.lan>
In-Reply-To: <c2d9d6f28de1a10bf0a26b36daa082acab2be5cd.1533656407.git.mchehab+samsung@kernel.org>
References: <c2d9d6f28de1a10bf0a26b36daa082acab2be5cd.1533656407.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  7 Aug 2018 11:40:09 -0400
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Fix the internal check for it to do the right thing if the
> subdev API is not built.
> 
Please ignore this one. I'm merging, instead, the one sent by
Jacopo.

Thanks,
Mauro

[PATCH] media: mt9v111: Fix build error with no VIDEO_V4L2_SUBDEV_API

The v4l2_subdev_get_try_format() function is only defined if the
VIDEO_V4L2_SUBDEV_API Kconfig option is enabled. Builds configured
without that symbol fails with:

drivers/media/i2c/mt9v111.c:801:10: error: implicit declaration of function
'v4l2_subdev_get_try_format';

Fix this by protecting the function call by testing for the right symbol.

media: mt9v111: fix random build errors

Fix the internal check for it to do the right thing if the
subdev API is not built.

Fixes: aab7ed1c ("media: i2c: Add driver for Aptina MT9V111")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

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
