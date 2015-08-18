Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41457 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbbHRIb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:31:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@pengutronix.de, Mats Randgaard <matrandg@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] tc358743: make reset gpio optional
Date: Tue, 18 Aug 2015 10:31:10 +0200
Message-Id: <1439886670-12322-2-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 256148246852 ("[media] tc358743: support probe from device tree")
specified in the device tree binding documentation that the reset gpio
is optional. Make the implementation match accordingly.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6ca6c0817993..c511b43a6ff8 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1749,14 +1749,16 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	state->pdata.ths_trailcnt = 0x2;
 	state->pdata.hstxvregcnt = 0;
 
-	state->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	state->reset_gpio = devm_gpiod_get_optional(dev, "reset",
+						    GPIOD_OUT_LOW);
 	if (IS_ERR(state->reset_gpio)) {
 		dev_err(dev, "failed to get reset gpio\n");
 		ret = PTR_ERR(state->reset_gpio);
 		goto disable_clk;
 	}
 
-	tc358743_gpio_reset(state);
+	if (state->reset_gpio)
+		tc358743_gpio_reset(state);
 
 	ret = 0;
 	goto free_endpoint;
-- 
2.4.6

