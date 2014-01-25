Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45106 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaAYRLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:01 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/52] rtl2832_sdr: initial support for FC0012 tuner
Date: Sat, 25 Jan 2014 19:10:01 +0200
Message-Id: <1390669846-8131-8-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tuner via internal DVB API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 0e12e1a..c088957 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -753,6 +753,12 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
+	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012) {
+		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x2c", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x16", 1);
 	} else {
 		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x30", 1);
@@ -782,6 +788,19 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
 		ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
+	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012) {
+		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xe9\xbf", 2);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x11", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xef", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x008, "\xcd", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
 	} else {
 		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xd4", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
-- 
1.8.5.3

