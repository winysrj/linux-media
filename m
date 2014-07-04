Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGDS0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 14:26:53 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 01/14] dib8000: Fix handling of interleave bigger than 2
Date: Fri,  4 Jul 2014 14:15:27 -0300
Message-Id: <1404494140-17777-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If interleave is bigger than 2, the code will set it to 0, as
dib8000 registers use a log2(). So, change the code to handle
it accordingly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 270a58e3e837..cf837158f822 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2033,10 +2033,10 @@ static u16 dib8000_set_layer(struct dib8000_state *state, u8 layer_index, u16 ma
 			break;
 	}
 
-	if ((c->layer[layer_index].interleaving > 0) && ((c->layer[layer_index].interleaving <= 3) || (c->layer[layer_index].interleaving == 4 && c->isdbt_sb_mode == 1)))
-		time_intlv = c->layer[layer_index].interleaving;
-	else
+	time_intlv = fls(c->layer[layer_index].interleaving);
+	if (time_intlv > 3 && !(time_intlv == 4 && c->isdbt_sb_mode == 1))
 		time_intlv = 0;
+	dprintk("Time interleave = %d (interleaving=%d)", time_intlv, c->layer[layer_index].interleaving);
 
 	dib8000_write_word(state, 2 + layer_index, (constellation << 10) | ((c->layer[layer_index].segment_count & 0xf) << 6) | (cr << 3) | time_intlv);
 	if (c->layer[layer_index].segment_count > 0) {
-- 
1.9.3

