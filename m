Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57929 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/14] it913x: make checkpatch.pl happy
Date: Sat,  9 Aug 2014 23:27:12 +0300
Message-Id: <1407616032-2722-15-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct issues reported by checkpatch.pl

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner_it913x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 281d8c5..b92d599 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -46,6 +46,7 @@ static int it913x_rd_regs(struct it913x_state *state,
 		{ .addr = state->i2c_addr, .flags = I2C_M_RD,
 			.buf = data, .len = count }
 	};
+
 	b[0] = (u8)(reg >> 16) & 0xff;
 	b[1] = (u8)(reg >> 8) & 0xff;
 	b[2] = (u8) reg & 0xff;
@@ -61,6 +62,7 @@ static int it913x_rd_reg(struct it913x_state *state, u32 reg)
 {
 	int ret;
 	u8 b[1];
+
 	ret = it913x_rd_regs(state, reg, &b[0], sizeof(b));
 	return (ret < 0) ? -ENODEV : b[0];
 }
@@ -75,6 +77,7 @@ static int it913x_wr_regs(struct it913x_state *state,
 		  .buf = b, .len = 3 + count }
 	};
 	int ret;
+
 	b[0] = (u8)(reg >> 16) & 0xff;
 	b[1] = (u8)(reg >> 8) & 0xff;
 	b[2] = (u8) reg & 0xff;
@@ -122,6 +125,7 @@ static int it913x_script_loader(struct it913x_state *state,
 		struct it913xset *loadscript)
 {
 	int ret, i;
+
 	if (loadscript == NULL)
 		return -EINVAL;
 
-- 
http://palosaari.fi/

