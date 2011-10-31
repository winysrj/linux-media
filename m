Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054Ab1JaQGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:06:40 -0400
Received: by eye27 with SMTP id 27so5425767eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:06:39 -0700 (PDT)
Message-ID: <4eaec78e.8dc5e30a.51c1.ffff9f74@mx.google.com>
Subject: [PATCH 2/2] it913x-fe ver 1.09 amend adc table entries.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 31 Oct 2011 16:06:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Amend adc table entries and size.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe-priv.h |    4 +---
 drivers/media/dvb/frontends/it913x-fe.c      |    5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index abf1395..836a5b8 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -153,8 +153,7 @@ struct table {
 };
 
 static struct table fe_clockTable[] = {
-		{12000000, tab3},	/* FPGA     */
-		{16384000, tab6},	/* 16.38MHz */
+		{12000000, tab3},	/* 12.00MHz */
 		{20480000, tab6},	/* 20.48MHz */
 		{36000000, tab3},	/* 36.00MHz */
 		{30000000, tab1},	/* 30.00MHz */
@@ -164,7 +163,6 @@ static struct table fe_clockTable[] = {
 		{34000000, tab2},	/* 34.00MHz */
 		{24000000, tab1},	/* 24.00MHz */
 		{22000000, tab8},	/* 22.00MHz */
-		{12000000, tab3}	/* 12.00MHz */
 };
 
 /* fe get */
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 5113b89..6d12dcc 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -53,7 +53,6 @@ struct it913x_fe_state {
 	struct ite_config *config;
 	u8 i2c_addr;
 	u32 frequency;
-	u8 adf;
 	u32 crystalFrequency;
 	u32 adcFrequency;
 	u8 tuner_type;
@@ -698,7 +697,7 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	if (state->config->chip_ver == 1)
 		ret = it913x_init_tuner(state);
 
-	if (adf < 12) {
+	if (adf < 10) {
 		state->crystalFrequency = fe_clockTable[adf].xtal ;
 		state->table = fe_clockTable[adf].table;
 		state->adcFrequency = state->table->adcFrequency;
@@ -889,5 +888,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.08");
+MODULE_VERSION("1.09");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


