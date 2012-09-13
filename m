Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35229 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/16] rtl2830: declare two tables as constant
Date: Thu, 13 Sep 2012 03:23:49 +0300
Message-Id: <1347495837-3244-8-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This optimizes few hundred bytes from data to text segment.
Also remove one unused function that was commented out already.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 3954760..b0f6ec0 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -28,7 +28,7 @@
 #include "rtl2830_priv.h"
 
 /* write multiple hardware registers */
-static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
+static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 {
 	int ret;
 	u8 buf[1+len];
@@ -85,7 +85,8 @@ static int rtl2830_rd(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
 }
 
 /* write multiple registers */
-static int rtl2830_wr_regs(struct rtl2830_priv *priv, u16 reg, u8 *val, int len)
+static int rtl2830_wr_regs(struct rtl2830_priv *priv, u16 reg, const u8 *val,
+		int len)
 {
 	int ret;
 	u8 reg2 = (reg >> 0) & 0xff;
@@ -122,14 +123,6 @@ static int rtl2830_rd_regs(struct rtl2830_priv *priv, u16 reg, u8 *val, int len)
 	return rtl2830_rd(priv, reg2, val, len);
 }
 
-#if 0 /* currently not used */
-/* write single register */
-static int rtl2830_wr_reg(struct rtl2830_priv *priv, u16 reg, u8 val)
-{
-	return rtl2830_wr_regs(priv, reg, &val, 1);
-}
-#endif
-
 /* read single register */
 static int rtl2830_rd_reg(struct rtl2830_priv *priv, u16 reg, u8 *val)
 {
@@ -281,7 +274,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	u64 num;
 	u8 buf[3], tmp;
 	u32 if_ctl, if_frequency;
-	static u8 bw_params1[3][34] = {
+	static const u8 bw_params1[3][34] = {
 		{
 		0x1f, 0xf0, 0x1f, 0xf0, 0x1f, 0xfa, 0x00, 0x17, 0x00, 0x41,
 		0x00, 0x64, 0x00, 0x67, 0x00, 0x38, 0x1f, 0xde, 0x1f, 0x7a,
@@ -299,10 +292,10 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		0x04, 0x24, 0x04, 0xdb, /* 8 MHz */
 		},
 	};
-	static u8 bw_params2[3][6] = {
-		{0xc3, 0x0c, 0x44, 0x33, 0x33, 0x30,}, /* 6 MHz */
-		{0xb8, 0xe3, 0x93, 0x99, 0x99, 0x98,}, /* 7 MHz */
-		{0xae, 0xba, 0xf3, 0x26, 0x66, 0x64,}, /* 8 MHz */
+	static const u8 bw_params2[3][6] = {
+		{0xc3, 0x0c, 0x44, 0x33, 0x33, 0x30}, /* 6 MHz */
+		{0xb8, 0xe3, 0x93, 0x99, 0x99, 0x98}, /* 7 MHz */
+		{0xae, 0xba, 0xf3, 0x26, 0x66, 0x64}, /* 8 MHz */
 	};
 
 	dev_dbg(&priv->i2c->dev,
-- 
1.7.11.4

