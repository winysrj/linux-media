Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030568AbaLMLyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:54:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/10] hd29l2: fix sparse error and warnings
Date: Sat, 13 Dec 2014 12:52:56 +0100
Message-Id: <1418471580-26510-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/hd29l2.c:29:18: warning: Variable length array is used.
drivers/media/dvb-frontends/hd29l2.c:34:32: error: cannot size expression
drivers/media/dvb-frontends/hd29l2.c:125:5: warning: symbol 'hd29l2_rd_reg_mask' was not declared. Should it be static?

Variable length arrays are frowned upon, so replace with a fixed length and check
that there won't be a buffer overrun.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/hd29l2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
index d7b9d54..67c8e6d 100644
--- a/drivers/media/dvb-frontends/hd29l2.c
+++ b/drivers/media/dvb-frontends/hd29l2.c
@@ -22,20 +22,24 @@
 
 #include "hd29l2_priv.h"
 
+#define HD29L2_MAX_LEN (3)
+
 /* write multiple registers */
 static int hd29l2_wr_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[2 + len];
+	u8 buf[2 + HD29L2_MAX_LEN];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = 2 + len,
 			.buf = buf,
 		}
 	};
 
+	if (len > HD29L2_MAX_LEN)
+		return -EINVAL;
 	buf[0] = 0x00;
 	buf[1] = reg;
 	memcpy(&buf[2], val, len);
@@ -118,7 +122,7 @@ static int hd29l2_wr_reg_mask(struct hd29l2_priv *priv, u8 reg, u8 val, u8 mask)
 }
 
 /* read single register with mask */
-int hd29l2_rd_reg_mask(struct hd29l2_priv *priv, u8 reg, u8 *val, u8 mask)
+static int hd29l2_rd_reg_mask(struct hd29l2_priv *priv, u8 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
-- 
2.1.3

