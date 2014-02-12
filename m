Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42970 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaBLTkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:40:53 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 2/3] tda10071: do not check tuner PLL lock on read_status()
Date: Wed, 12 Feb 2014 21:40:39 +0200
Message-Id: <1392234040-14198-2-git-send-email-crope@iki.fi>
In-Reply-To: <1392234040-14198-1-git-send-email-crope@iki.fi>
References: <1392234040-14198-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuner PLL lock flag was mapped to FE_HAS_SIGNAL, which is wrong. PLL
lock has nothing to do with received signal. In real life that flag
is always set.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index a76df29..13c823a 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -491,10 +491,9 @@ static int tda10071_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (ret)
 		goto error;
 
-	if (tmp & 0x01) /* tuner PLL */
-		*status |= FE_HAS_SIGNAL;
+	/* 0x39[0] tuner PLL */
 	if (tmp & 0x02) /* demod PLL */
-		*status |= FE_HAS_CARRIER;
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
 	if (tmp & 0x04) /* viterbi or LDPC*/
 		*status |= FE_HAS_VITERBI;
 	if (tmp & 0x08) /* RS or BCH */
-- 
1.8.5.3

