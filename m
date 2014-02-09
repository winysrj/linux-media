Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48038 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaBIItz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 08/86] rtl2832_sdr: initial support for FC0013 tuner
Date: Sun,  9 Feb 2014 10:48:13 +0200
Message-Id: <1391935771-18670-9-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tuner via internal DVB API.
It is about same tuner than FC0012 and uses just same settings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index c088957..2c84654 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -753,7 +753,8 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
-	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012) {
+	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012 ||
+			s->cfg->tuner == RTL2832_TUNER_FC0013) {
 		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x2c", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
@@ -788,7 +789,8 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
 		ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
-	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012) {
+	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012 ||
+			s->cfg->tuner == RTL2832_TUNER_FC0013) {
 		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xe9\xbf", 2);
 		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
-- 
1.8.5.3

