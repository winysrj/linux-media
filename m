Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38454 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLRVGF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 16:06:05 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl2832: add name for RegMap
Date: Thu, 18 Dec 2014 23:05:17 +0200
Message-Id: <1418936717-2806-2-git-send-email-crope@iki.fi>
In-Reply-To: <1418936717-2806-1-git-send-email-crope@iki.fi>
References: <1418936717-2806-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass module name to regmap in order to silence lockdep recursive
deadlock warning. Lockdep validator groups mutexes per mutex name by
default. Due to that tuner and demod regmap mutexes were seen as a
single mutex. Tuner register access causes demod register access,
because of I2C mux/repeater and that is seen as a recursive locking
- even those locks are different instances (tuner vs. demod).

Defining name for mutex allows lockdep to separate mutexes and error
is not shown.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index f44dc50..f41bbd0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1187,6 +1187,7 @@ static int rtl2832_probe(struct i2c_client *client,
 		},
 	};
 	static const struct regmap_config regmap_config = {
+		.name = KBUILD_MODNAME,
 		.reg_bits    =  8,
 		.val_bits    =  8,
 		.volatile_reg = rtl2832_volatile_reg,
-- 
http://palosaari.fi/

