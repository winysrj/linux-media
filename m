Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbZLKQLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 11:11:07 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] V4L/DVB: lgs8gxx: Use shifts rather than multiply/divide when
	possible
To: davidtlwong@gmail.com, mchehab@redhat.com
Cc: dhowells@redhat.com, linux-media@vger.kernel.org
Date: Fri, 11 Dec 2009 16:11:05 +0000
Message-ID: <20091211161105.16160.26479.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If val is a u64, then following:

	val *= (u64)1 << 32;
	val /= (u64)1 << 32;

should surely be better represented as:

	val <<= 32;
	val >>= 32;

Especially as, for the division, the compiler might want to actually do a
division:

drivers/built-in.o: In function `lgs8gxx_get_afc_phase':
drivers/media/dvb/frontends/lgs8gxx.c:250: undefined reference to `__udivdi3'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/dvb/frontends/lgs8gxx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index eabcadc..dee5396 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -199,7 +199,7 @@ static int lgs8gxx_set_if_freq(struct lgs8gxx_state *priv, u32 freq /*in kHz*/)
 
 	val = freq;
 	if (freq != 0) {
-		val *= (u64)1 << 32;
+		val <<= 32;
 		if (if_clk != 0)
 			do_div(val, if_clk);
 		v32 = val & 0xFFFFFFFF;
@@ -246,7 +246,7 @@ static int lgs8gxx_get_afc_phase(struct lgs8gxx_state *priv)
 
 	val = v32;
 	val *= priv->config->if_clk_freq;
-	val /= (u64)1 << 32;
+	val >>= 32;
 	dprintk("AFC = %u kHz\n", (u32)val);
 	return 0;
 }

