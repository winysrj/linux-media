Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Daniel Jeong <gshark.jeong@gmail.com>
Subject: [PATCH 28/46] [media] lm3560: simplify boolean tests
Date: Wed,  3 Sep 2014 17:33:00 -0300
Message-Id: <4e97984ba765f3811f32615b388e698e699b34af.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using if (on == true), just use
if (on).

That allows a faster mental parsing when analyzing the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index c23de593c17d..d9ece4b2d047 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -100,14 +100,14 @@ static int lm3560_enable_ctrl(struct lm3560_flash *flash,
 	int rval;
 
 	if (led_no == LM3560_LED0) {
-		if (on == true)
+		if (on)
 			rval = regmap_update_bits(flash->regmap,
 						  REG_ENABLE, 0x08, 0x08);
 		else
 			rval = regmap_update_bits(flash->regmap,
 						  REG_ENABLE, 0x08, 0x00);
 	} else {
-		if (on == true)
+		if (on)
 			rval = regmap_update_bits(flash->regmap,
 						  REG_ENABLE, 0x10, 0x10);
 		else
-- 
1.9.3

