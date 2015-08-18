Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39573 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbbHRIbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:31:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@pengutronix.de, Mats Randgaard <matrandg@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] tc358743: set direction of reset gpio using devm_gpiod_get
Date: Tue, 18 Aug 2015 10:31:09 +0200
Message-Id: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 256148246852 ("[media] tc358743: support probe from device tree")
failed to explicitly set the direction of the reset gpio. Use the
optional flag of devm_gpiod_get to make up leeway.

This is also necessary because the flag parameter will become mandatory
soon.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 76d0aaa19493..6ca6c0817993 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1648,7 +1648,6 @@ static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
 #ifdef CONFIG_OF
 static void tc358743_gpio_reset(struct tc358743_state *state)
 {
-	gpiod_set_value(state->reset_gpio, 0);
 	usleep_range(5000, 10000);
 	gpiod_set_value(state->reset_gpio, 1);
 	usleep_range(1000, 2000);
@@ -1750,7 +1749,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	state->pdata.ths_trailcnt = 0x2;
 	state->pdata.hstxvregcnt = 0;
 
-	state->reset_gpio = devm_gpiod_get(dev, "reset");
+	state->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(state->reset_gpio)) {
 		dev_err(dev, "failed to get reset gpio\n");
 		ret = PTR_ERR(state->reset_gpio);
-- 
2.4.6

