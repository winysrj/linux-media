Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:60037 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932763AbeFRIHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:07:16 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/2] media: ov5645: Supported external clock is 24MHz
Date: Mon, 18 Jun 2018 11:06:58 +0300
Message-Id: <1529309219-27404-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The external clock frequency was set to 23.88MHz by mistake
because of a platform which cannot get closer to 24MHz.
The supported by the driver external clock is 24MHz so
set it correctly and also fix the values of the pixel
clock and link clock.
However allow 1% tolerance to the external clock as this
difference is small enough to be insignificant.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index b3f7625..1722cda 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -510,8 +510,8 @@ static const struct reg_value ov5645_setting_full[] = {
 };
 
 static const s64 link_freq[] = {
-	222880000,
-	334320000
+	224000000,
+	336000000
 };
 
 static const struct ov5645_mode_info ov5645_mode_info_data[] = {
@@ -520,7 +520,7 @@ static const struct ov5645_mode_info ov5645_mode_info_data[] = {
 		.height = 960,
 		.data = ov5645_setting_sxga,
 		.data_size = ARRAY_SIZE(ov5645_setting_sxga),
-		.pixel_clock = 111440000,
+		.pixel_clock = 112000000,
 		.link_freq = 0 /* an index in link_freq[] */
 	},
 	{
@@ -528,7 +528,7 @@ static const struct ov5645_mode_info ov5645_mode_info_data[] = {
 		.height = 1080,
 		.data = ov5645_setting_1080p,
 		.data_size = ARRAY_SIZE(ov5645_setting_1080p),
-		.pixel_clock = 167160000,
+		.pixel_clock = 168000000,
 		.link_freq = 1 /* an index in link_freq[] */
 	},
 	{
@@ -536,7 +536,7 @@ static const struct ov5645_mode_info ov5645_mode_info_data[] = {
 		.height = 1944,
 		.data = ov5645_setting_full,
 		.data_size = ARRAY_SIZE(ov5645_setting_full),
-		.pixel_clock = 167160000,
+		.pixel_clock = 168000000,
 		.link_freq = 1 /* an index in link_freq[] */
 	},
 };
@@ -1145,7 +1145,8 @@ static int ov5645_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (xclk_freq != 23880000) {
+	/* external clock must be 24MHz, allow 1% tolerance */
+	if (xclk_freq < 23760000 || xclk_freq > 24240000) {
 		dev_err(dev, "external clock frequency %u is not supported\n",
 			xclk_freq);
 		return -EINVAL;
-- 
2.7.4
