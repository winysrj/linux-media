Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43327 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3EBLEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 07:04:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH] mt9p031: Use gpio_is_valid()
Date: Thu,  2 May 2013 13:04:12 +0200
Message-Id: <1367492652-28704-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the manual validity checks for the reset GPIO with the
gpio_is_valid() function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 8de84c0..bf49899 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -272,7 +272,7 @@ static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
 static int mt9p031_power_on(struct mt9p031 *mt9p031)
 {
 	/* Ensure RESET_BAR is low */
-	if (mt9p031->reset != -1) {
+	if (gpio_is_valid(mt9p031->reset)) {
 		gpio_set_value(mt9p031->reset, 0);
 		usleep_range(1000, 2000);
 	}
@@ -287,7 +287,7 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 		clk_prepare_enable(mt9p031->clk);
 
 	/* Now RESET_BAR must be high */
-	if (mt9p031->reset != -1) {
+	if (gpio_is_valid(mt9p031->reset)) {
 		gpio_set_value(mt9p031->reset, 1);
 		usleep_range(1000, 2000);
 	}
@@ -297,7 +297,7 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 
 static void mt9p031_power_off(struct mt9p031 *mt9p031)
 {
-	if (mt9p031->reset != -1) {
+	if (gpio_is_valid(mt9p031->reset)) {
 		gpio_set_value(mt9p031->reset, 0);
 		usleep_range(1000, 2000);
 	}
@@ -1031,7 +1031,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->format.field = V4L2_FIELD_NONE;
 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
 
-	if (pdata->reset != -1) {
+	if (gpio_is_valid(pdata->reset)) {
 		ret = devm_gpio_request_one(&client->dev, pdata->reset,
 					    GPIOF_OUT_INIT_LOW, "mt9p031_rst");
 		if (ret < 0)
-- 
Regards,

Laurent Pinchart

