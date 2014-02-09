Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50857 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaBIItz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 04/86] rtl2832_sdr: initial support for R820T tuner
Date: Sun,  9 Feb 2014 10:48:09 +0200
Message-Id: <1391935771-18670-5-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tuner via internal DVB API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 84 +++++++++++++++---------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 208520e..513da22 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -646,8 +646,16 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x00", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x119, "\x00\x00", 2);
-	ret = rtl2832_sdr_wr_regs(s, 0x11b, "\x00", 1);
+
+	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
+		ret = rtl2832_sdr_wr_regs(s, 0x119, "\x38\x11", 2);
+		ret = rtl2832_sdr_wr_regs(s, 0x11b, "\x12", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
+	} else {
+		ret = rtl2832_sdr_wr_regs(s, 0x119, "\x00\x00", 2);
+		ret = rtl2832_sdr_wr_regs(s, 0x11b, "\x00", 1);
+	}
+
 	ret = rtl2832_sdr_wr_regs(s, 0x19f, "\x03\x84", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x1a1, "\x00\x00", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x11c, "\xca", 1);
@@ -686,11 +694,21 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	ret = rtl2832_sdr_wr_regs(s, 0x006, "\x80", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x30", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x104, "\xd0", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x18", 1);
+
+	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
+		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x24", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
+	} else {
+		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x30", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xd0", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x18", 1);
+	}
+
 	ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
@@ -704,30 +722,34 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
 	ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x011, "\xd4", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x14", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xec", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x83", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x010, "\x49", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x87", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x85", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x013, "\x02", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x008, "\xcd", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1b1, "\x01", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x10c, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\xe3", 2);
-	ret = rtl2832_sdr_wr_regs(s, 0x118, "\x8e", 1);
+
+	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
+		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xf4", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
+		ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
+	} else {
+		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xd4", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xec", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x83", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x010, "\x49", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x87", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x85", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x013, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x008, "\xcd", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10c, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
+	}
 
 	return ret;
 };
-- 
1.8.5.3

