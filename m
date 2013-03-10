Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57752 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 19/41] it913x: remove unused variables
Date: Sun, 10 Mar 2013 04:03:11 +0200
Message-Id: <1362881013-5271-19-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      | 14 ++------------
 drivers/media/tuners/it913x_priv.h | 12 ------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 66d4b72..6ae9d5a 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -23,25 +23,15 @@
 #include "it913x_priv.h"
 
 struct it913x_state {
-	struct dvb_frontend frontend;
 	struct i2c_adapter *i2c_adap;
-	u8 chip_ver;
-	u8 firmware_ver;
 	u8 i2c_addr;
-	u32 frequency;
-	fe_modulation_t constellation;
-	fe_transmit_mode_t transmission_mode;
-	u8 priority;
-	u32 crystalFrequency;
-	u32 adcFrequency;
+	u8 chip_ver;
 	u8 tuner_type;
-	struct adctable *table;
-	fe_status_t it913x_status;
+	u8 firmware_ver;
 	u16 tun_xtal;
 	u8 tun_fdiv;
 	u8 tun_clk_mode;
 	u32 tun_fn_min;
-	u32 ucblocks;
 };
 
 /* read multiple registers */
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index e4a0136..315ff6c 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -34,22 +34,10 @@
 #define IT9135_61 0x61
 #define IT9135_62 0x62
 
-#define I2C_BASE_ADDR		0x10
-#define DEV_0			0x0
-#define DEV_1			0x10
 #define PRO_LINK		0x0
 #define PRO_DMOD		0x1
-#define DEV_0_DMOD		(PRO_DMOD << 0x7)
-#define DEV_1_DMOD		(DEV_0_DMOD | DEV_1)
-#define CHIP2_I2C_ADDR		0x3a
-
-#define	PADODPU			0xd827
-#define THIRDODPU		0xd828
-#define AGC_O_D			0xd829
-
 #define TRIGGER_OFSM		0x0000
 
-
 struct it913xset {	u32 pro;
 			u32 address;
 			u8 reg[15];
-- 
1.7.11.7

