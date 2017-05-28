Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdE1McD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:32:03 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 6/7] staging: atomisp: Ignore errors from second gpio in ov2680 driver
Date: Sun, 28 May 2017 14:31:52 +0200
Message-Id: <20170528123153.18613-6-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the existing comment in the driver indicates the sensor has only 1 pin,
but some boards may have 2 gpios defined and we toggle both as we we don't
know which one is the right one. However if the ACPI resources table
defines only 1 gpio (as expected) the gpio1_ctrl call will always fail,
causing the probing of the driver to file.

This commit ignore the return value of the gpio1_ctrl call, fixing this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 449aa2aa276f..6dd466558701 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -885,11 +885,12 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (flag) {
 		ret = dev->platform_data->gpio0_ctrl(sd, 1);
 		usleep_range(10000, 15000);
-		ret |= dev->platform_data->gpio1_ctrl(sd, 1);
+		/* Ignore return from second gpio, it may not be there */
+		dev->platform_data->gpio1_ctrl(sd, 1);
 		usleep_range(10000, 15000);
 	} else {
-		ret = dev->platform_data->gpio1_ctrl(sd, 0);
-		ret |= dev->platform_data->gpio0_ctrl(sd, 0);
+		dev->platform_data->gpio1_ctrl(sd, 0);
+		ret = dev->platform_data->gpio0_ctrl(sd, 0);
 	}
 	return ret;
 }
-- 
2.13.0
