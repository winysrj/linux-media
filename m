Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3EHNqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:52 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 84BAC35A50
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:24 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 3/9] media: i2c: Convert to gpio_request_one()
Date: Wed,  8 May 2013 15:46:28 +0200
Message-Id: <1368020794-21264-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace gpio_request() with gpio_request_one() and remove the associated
gpio_direction_output() calls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/adv7183.c            | 14 +++++++-------
 drivers/media/i2c/m5mols/m5mols_core.c |  6 ++++--
 drivers/media/i2c/noon010pc30.c        |  8 ++++----
 drivers/media/i2c/vs6624.c             |  3 +--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 56a1fa4..2bc0328 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -474,9 +474,9 @@ static int adv7183_s_stream(struct v4l2_subdev *sd, int enable)
 	struct adv7183 *decoder = to_adv7183(sd);
 
 	if (enable)
-		gpio_direction_output(decoder->oe_pin, 0);
+		gpio_set_value(decoder->oe_pin, 0);
 	else
-		gpio_direction_output(decoder->oe_pin, 1);
+		gpio_set_value(decoder->oe_pin, 1);
 	udelay(1);
 	return 0;
 }
@@ -580,13 +580,15 @@ static int adv7183_probe(struct i2c_client *client,
 	decoder->reset_pin = pin_array[0];
 	decoder->oe_pin = pin_array[1];
 
-	if (gpio_request(decoder->reset_pin, "ADV7183 Reset")) {
+	if (gpio_request_one(decoder->reset_pin, GPIOF_OUT_INIT_LOW,
+			     "ADV7183 Reset")) {
 		v4l_err(client, "failed to request GPIO %d\n", decoder->reset_pin);
 		ret = -EBUSY;
 		goto err_free_decoder;
 	}
 
-	if (gpio_request(decoder->oe_pin, "ADV7183 Output Enable")) {
+	if (gpio_request_one(decoder->oe_pin, GPIOF_OUT_INIT_HIGH,
+			     "ADV7183 Output Enable")) {
 		v4l_err(client, "failed to request GPIO %d\n", decoder->oe_pin);
 		ret = -EBUSY;
 		goto err_free_reset;
@@ -619,12 +621,10 @@ static int adv7183_probe(struct i2c_client *client,
 	decoder->input = ADV7183_COMPOSITE4;
 	decoder->output = ADV7183_8BIT_OUT;
 
-	gpio_direction_output(decoder->oe_pin, 1);
 	/* reset chip */
-	gpio_direction_output(decoder->reset_pin, 0);
 	/* reset pulse width at least 5ms */
 	mdelay(10);
-	gpio_direction_output(decoder->reset_pin, 1);
+	gpio_set_value(decoder->reset_pin, 1);
 	/* wait 5ms before any further i2c writes are performed */
 	mdelay(5);
 
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 0b899cb..f0b870c 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -930,6 +930,7 @@ static int m5mols_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	const struct m5mols_platform_data *pdata = client->dev.platform_data;
+	unsigned long gpio_flags;
 	struct m5mols_info *info;
 	struct v4l2_subdev *sd;
 	int ret;
@@ -956,12 +957,13 @@ static int m5mols_probe(struct i2c_client *client,
 	info->pdata = pdata;
 	info->set_power	= pdata->set_power;
 
-	ret = gpio_request(pdata->gpio_reset, "M5MOLS_NRST");
+	gpio_flags = pdata->reset_polarity
+		   ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	ret = gpio_request_one(pdata->gpio_reset, gpio_flags, "M5MOLS_NRST");
 	if (ret) {
 		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
 		goto out_free;
 	}
-	gpio_direction_output(pdata->gpio_reset, pdata->reset_polarity);
 
 	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 8554b47..a115842 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -746,24 +746,24 @@ static int noon010_probe(struct i2c_client *client,
 	info->curr_win		= &noon010_sizes[0];
 
 	if (gpio_is_valid(pdata->gpio_nreset)) {
-		ret = gpio_request(pdata->gpio_nreset, "NOON010PC30 NRST");
+		ret = gpio_request_one(pdata->gpio_nreset, GPIOF_OUT_INIT_LOW,
+				       "NOON010PC30 NRST");
 		if (ret) {
 			dev_err(&client->dev, "GPIO request error: %d\n", ret);
 			goto np_err;
 		}
 		info->gpio_nreset = pdata->gpio_nreset;
-		gpio_direction_output(info->gpio_nreset, 0);
 		gpio_export(info->gpio_nreset, 0);
 	}
 
 	if (gpio_is_valid(pdata->gpio_nstby)) {
-		ret = gpio_request(pdata->gpio_nstby, "NOON010PC30 NSTBY");
+		ret = gpio_request_one(pdata->gpio_nstby, GPIOF_OUT_INIT_LOW,
+				      "NOON010PC30 NSTBY");
 		if (ret) {
 			dev_err(&client->dev, "GPIO request error: %d\n", ret);
 			goto np_gpio_err;
 		}
 		info->gpio_nstby = pdata->gpio_nstby;
-		gpio_direction_output(info->gpio_nstby, 0);
 		gpio_export(info->gpio_nstby, 0);
 	}
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index f366fad..6b8c0b7 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -805,12 +805,11 @@ static int vs6624_probe(struct i2c_client *client,
 	if (ce == NULL)
 		return -EINVAL;
 
-	ret = gpio_request(*ce, "VS6624 Chip Enable");
+	ret = gpio_request_one(*ce, GPIOF_OUT_INIT_HIGH, "VS6624 Chip Enable");
 	if (ret) {
 		v4l_err(client, "failed to request GPIO %d\n", *ce);
 		return ret;
 	}
-	gpio_direction_output(*ce, 1);
 	/* wait 100ms before any further i2c writes are performed */
 	mdelay(100);
 
-- 
1.8.1.5

