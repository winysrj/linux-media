Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3DAOnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/5] [media] mb86a20s: Fix estimate_rate setting
Date: Mon,  1 Apr 2013 11:41:56 -0300
Message-Id: <1364827319-18332-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
References: <20130401072529.GL18466@mwanda>
 <1364827319-18332-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Dan Carpenter <dan.carpenter@oracle.com>:

	Smatch warnings:
	drivers/media/dvb-frontends/mb86a20s.c:644 mb86a20s_layer_bitrate() error: buffer overflow 'state->estimated_rate' 3 <= 3

What happens there is that estimate_rate index should be the layer
number, and not the guard interval.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 80a8ee0..6ff1375 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -642,7 +642,7 @@ static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 	       __func__, 'A' + layer, segment * isdbt_rate[m][f][i]/1000,
 		rate, rate);
 
-	state->estimated_rate[i] = rate;
+	state->estimated_rate[layer] = rate;
 }
 
 
-- 
1.8.1.4

