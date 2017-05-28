Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdE1Mb6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:31:58 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/7] staging: atomisp: Set step to 0 for mt9m114 menu control
Date: Sun, 28 May 2017 14:31:49 +0200
Message-Id: <20170528123153.18613-3-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

menu controls are not allowed to have a step size, set step to 0 to
fix an oops from the WARN_ON in v4l2_ctrl_new_custom() triggering
because of this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/i2c/mt9m114.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index ced175c268d1..3fa915313e53 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1499,7 +1499,7 @@ static struct v4l2_ctrl_config mt9m114_controls[] = {
 	 .type = V4L2_CTRL_TYPE_MENU,
 	 .min = 0,
 	 .max = 3,
-	 .step = 1,
+	 .step = 0,
 	 .def = 1,
 	 .flags = 0,
 	 },
-- 
2.13.0
