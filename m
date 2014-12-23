Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44738 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 38/66] rtl2832: define more demod lock statuses
Date: Tue, 23 Dec 2014 22:49:31 +0200
Message-Id: <1419367799-14263-38-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Demod lock flags are derived from demod state machine states. States
are running from 1 to 11, where highest state 11 means demod is
fully locked and streaming. Naturally smaller state numbers means
there is some partial locks.

Define now state 10 as missing synch and lock.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 94d08fb..b80e1c0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -753,12 +753,10 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (tmp == 11) {
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-	}
-	/* TODO find out if this is also true for rtl2832? */
-	/*else if (tmp == 10) {
+	} else if (tmp == 10) {
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 				FE_HAS_VITERBI;
-	}*/
+	}
 
 	dev->fe_status = *status;
 	return ret;
-- 
http://palosaari.fi/

