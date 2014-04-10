Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44221 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934867AbaDJJCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 05:02:46 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so3711600pbc.20
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 02:02:46 -0700 (PDT)
Date: Thu, 10 Apr 2014 19:02:38 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: media: omap24xx: fix up a checkpatch.pl warning
Message-ID: <20140410090234.GA8654@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tcm825x.c:

changed printk to pr_info

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/media/omap24xx/tcm825x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap24xx/tcm825x.c b/drivers/staging/media/omap24xx/tcm825x.c
index 2326481..3367ccd 100644
--- a/drivers/staging/media/omap24xx/tcm825x.c
+++ b/drivers/staging/media/omap24xx/tcm825x.c
@@ -914,8 +914,8 @@ static int __init tcm825x_init(void)
 
 	rval = i2c_add_driver(&tcm825x_i2c_driver);
 	if (rval)
-		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
-		       __func__);
+		pr_info("%s: failed registering " TCM825X_NAME "\n",
+			__func__);
 
 	return rval;
 }
-- 
1.7.9.5

