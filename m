Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab3LPKZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 05:25:46 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] dib8000: report Interleaving 4 correctly
Date: Mon, 16 Dec 2013 05:22:39 -0200
Message-Id: <1387178559-5477-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ISDB-T, the valid values for interleaving are 0, 1, 2 and 4.
While the first 3 are properly reported, the last one is reported
as 3 instead. Fix it.

Tested with a Dektec DTA-2111 RF generator.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index f11c9f8f35b3..13fdc3d5f762 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3429,9 +3429,13 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 		fe->dtv_property_cache.layer[i].segment_count = val & 0x0F;
 		dprintk("dib8000_get_frontend : Layer %d segments = %d ", i, fe->dtv_property_cache.layer[i].segment_count);
 
-		val = dib8000_read_word(state, 499 + i);
-		fe->dtv_property_cache.layer[i].interleaving = val & 0x3;
-		dprintk("dib8000_get_frontend : Layer %d time_intlv = %d ", i, fe->dtv_property_cache.layer[i].interleaving);
+		val = dib8000_read_word(state, 499 + i) & 0x3;
+		/* Interleaving can be 0, 1, 2 or 4 */
+		if (val == 3)
+			val = 4;
+		fe->dtv_property_cache.layer[i].interleaving = val;
+		dprintk("dib8000_get_frontend : Layer %d time_intlv = %d ",
+			i, fe->dtv_property_cache.layer[i].interleaving);
 
 		val = dib8000_read_word(state, 481 + i);
 		switch (val & 0x7) {
-- 
1.8.3.1

