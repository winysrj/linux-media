Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48169 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbCBHBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 02:01:10 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] media: adv7604: improve usage of gpiod API
Date: Mon,  2 Mar 2015 08:00:44 +0100
Message-Id: <1425279644-25873-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
which appeared in v3.17-rc1, the gpiod_get* functions take an additional
parameter that allows to specify direction and initial value for output.
Simplify accordingly.

Moreover use devm_gpiod_get_index_optional instead of
devm_gpiod_get_index with ignoring all errors.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
BTW, sparse fails to check this file with many errors like:

	drivers/media/i2c/adv7604.c:311:11: error: unknown field name in initializer

Didn't look into that.
---
 drivers/media/i2c/adv7604.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5a7c9389a605..ddeeb6695a4b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -537,12 +537,8 @@ static void adv7604_set_hpd(struct adv7604_state *state, unsigned int hpd)
 {
 	unsigned int i;
 
-	for (i = 0; i < state->info->num_dv_ports; ++i) {
-		if (IS_ERR(state->hpd_gpio[i]))
-			continue;
-
+	for (i = 0; i < state->info->num_dv_ports; ++i)
 		gpiod_set_value_cansleep(state->hpd_gpio[i], hpd & BIT(i));
-	}
 
 	v4l2_subdev_notify(&state->sd, ADV7604_HOTPLUG, &hpd);
 }
@@ -2720,13 +2716,13 @@ static int adv7604_probe(struct i2c_client *client,
 	/* Request GPIOs. */
 	for (i = 0; i < state->info->num_dv_ports; ++i) {
 		state->hpd_gpio[i] =
-			devm_gpiod_get_index(&client->dev, "hpd", i);
+			devm_gpiod_get_index_optional(&client->dev, "hpd", i,
+						      GPIOD_OUT_LOW);
 		if (IS_ERR(state->hpd_gpio[i]))
-			continue;
-
-		gpiod_direction_output(state->hpd_gpio[i], 0);
+			return PTR_ERR(state->hpd_gpio[i]);
 
-		v4l_info(client, "Handling HPD %u GPIO\n", i);
+		if (state->hpd_gpio[i])
+			v4l_info(client, "Handling HPD %u GPIO\n", i);
 	}
 
 	state->timings = cea640x480;
-- 
2.1.4

