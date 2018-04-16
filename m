Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43369 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeDPQhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Rene Hickersberger <renehickersberger@gmx.net>,
        devel@driverdev.osuosl.org
Subject: [PATCH 7/9] media: atomisp-gc0310: return errors at gc0310_init()
Date: Mon, 16 Apr 2018 12:37:10 -0400
Message-Id: <83c5604e70d99b4504169fdb7e6bbd0eaeaaab85.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something wrong gets there, return the error.

Get rid of this warning:

  drivers/staging/media/atomisp/i2c/atomisp-gc0310.c: In function 'gc0310_init':
  drivers/staging/media/atomisp/i2c/atomisp-gc0310.c:713:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
    int ret;
        ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index 512fa87fa11b..3b38cbccf294 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -727,7 +727,7 @@ static int gc0310_init(struct v4l2_subdev *sd)
 	mutex_unlock(&dev->input_lock);
 
 	pr_info("%s E\n", __func__);
-	return 0;
+	return ret;
 }
 
 static int power_ctrl(struct v4l2_subdev *sd, bool flag)
-- 
2.14.3
