Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59015 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbaDWCBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 22:01:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] si2168: relax demod lock checks a little
Date: Wed, 23 Apr 2014 05:01:01 +0300
Message-Id: <1398218462-29539-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bit3 was not cleared always leaving driver reporting demod is not
fully locked. Do not check bit0 as it seems to be always 0.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index dc5b64a..8637d2e 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -132,14 +132,11 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	 * [b4] statistics ready? Set in a few secs after lock is gained.
 	 */
 
-	switch ((cmd.args[2] >> 0) & 0x0f) {
-	case 0x0a:
+	switch ((cmd.args[2] >> 1) & 0x03) {
+	case 0x01:
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
 		break;
-	case 0x0e:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI;
-		break;
-	case 0x06:
+	case 0x03:
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
 				FE_HAS_SYNC | FE_HAS_LOCK;
 		break;
-- 
1.9.0

