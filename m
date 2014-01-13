Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/7] [media] dib8000: Fix a few warnings when compiled for avr32
Date: Mon, 13 Jan 2014 16:32:35 -0200
Message-Id: <1389637958-3884-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	drivers/media/dvb-frontends/dib8000.c: In function 'dib8000_get_time_us':
	drivers/media/dvb-frontends/dib8000.c:3957: warning: 'interleaving' may be used uninitialized in this function
	drivers/media/dvb-frontends/dib8000.c:3956: warning: 'rate_denum' may be used uninitialized in this function

Those are actually false positives, but it doesn't hurt cleaning them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index dd4a99cff3e7..1632d78a5479 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3953,8 +3953,8 @@ static u32 dib8000_get_time_us(struct dvb_frontend *fe, int layer)
 	int ini_layer, end_layer, i;
 	u64 time_us, tmp64;
 	u32 tmp, denom;
-	int guard, rate_num, rate_denum, bits_per_symbol, nsegs;
-	int interleaving, fft_div;
+	int guard, rate_num, rate_denum = 1, bits_per_symbol, nsegs;
+	int interleaving = 0, fft_div;
 
 	if (layer >= 0) {
 		ini_layer = layer;
-- 
1.8.3.1

