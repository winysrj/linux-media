Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34426 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdHJM0W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 08:26:22 -0400
Date: Thu, 10 Aug 2017 15:23:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        sayli karnik <karniksayli1995@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] staging: atomisp: fix bounds checking in
 mt9m114_s_exposure_selection()
Message-ID: <20170810122334.tqruyh6xelk7fg6i@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These clamp_t() calls are no-ops because we don't save the results.  It
leads to an array out of bounds bug.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 448e072ca037..7816bc428641 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1209,10 +1209,10 @@ static int mt9m114_s_exposure_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	clamp_t(int, win_left, 0, 4);
-	clamp_t(int, win_top, 0, 4);
-	clamp_t(int, win_right, 0, 4);
-	clamp_t(int, win_bottom, 0, 4);
+	win_left   = clamp_t(int, win_left, 0, 4);
+	win_top    = clamp_t(int, win_top, 0, 4);
+	win_right  = clamp_t(int, win_right, 0, 4);
+	win_bottom = clamp_t(int, win_bottom, 0, 4);
 
 	ret = mt9m114_write_reg_array(client, mt9m114_exp_average, NO_POLLING);
 	if (ret) {
