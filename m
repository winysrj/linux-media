Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36497 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaHDT2G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 15:28:06 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com
Cc: fengguang.wu@intel.com, Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] si2165: change return type of si2165_wait_init_done from bool to int
Date: Mon,  4 Aug 2014 21:27:43 +0200
Message-Id: <1407180463-17936-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of an error -EINVAL will be mis-casted to 1.

This was triggered by a coccinelle warning.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 3a2d6c5..f02d946 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -312,9 +312,8 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
 	return state->adc_clk;
 }
 
-static bool si2165_wait_init_done(struct si2165_state *state)
+static int si2165_wait_init_done(struct si2165_state *state)
 {
-	int ret = -EINVAL;
 	u8 val = 0;
 	int i;
 
@@ -326,7 +325,7 @@ static bool si2165_wait_init_done(struct si2165_state *state)
 	}
 	dev_err(&state->i2c->dev, "%s: init_done was not set\n",
 		KBUILD_MODNAME);
-	return ret;
+	return -EINVAL;
 }
 
 static int si2165_upload_firmware_block(struct si2165_state *state,
-- 
2.0.0

