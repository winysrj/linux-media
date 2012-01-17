Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab2AQSpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:45:41 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: [PATCH] [RFC] dib8000: return an error if the TMCC is not locked
Date: Tue, 17 Jan 2012 16:45:28 -0200
Message-Id: <1326825928-29894-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ISDB-T, a few carriers are reserved for TMCC decoding
(1 to 20 carriers, depending on the mode). Those carriers
use the DBPSK modulation, and contain the information about
each of the three layers of carriers (modulation, partial
reception, inner code, interleaving, and number of segments).

If the TMCC carrier was not locked and decoded, no information
would be provided by get_frontend(). So, instead of returning
false values, return -EAGAIN.

Another alternative for this patch would be to add a flag to
fe_status (FE_HAS_GET_FRONTEND?), to indicate that the ISDB-T
TMCC carriers (and DVB-T TPS?), required for get_frontend
to work, are locked.

Comments?

Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib8000.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 9ca34f4..c566be2 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -2813,7 +2813,7 @@ EXPORT_SYMBOL(dib8000_set_tune_state);
 static int dib8000_get_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
-	u16 i, val = 0;
+	u16 i, val = 0, lock;
 	fe_status_t stat;
 	u8 index_frontend, sub_index_frontend;
 
@@ -2840,7 +2840,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 					}
 				}
 			}
-			return 0;
+			goto ret;
 		}
 	}
 
@@ -2953,6 +2953,17 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 			state->fe[index_frontend]->dtv_property_cache.layer[i].modulation = fe->dtv_property_cache.layer[i].modulation;
 		}
 	}
+
+ret:
+	if (state->revision != 0x8090)
+		lock = dib8000_read_word(state, 568);
+	else
+		lock = dib8000_read_word(state, 570);
+
+	/* Check if the TMCC decoder is locked */
+	if ((lock & 0x1e) != 0x1e)
+		return -EAGAIN;
+
 	return 0;
 }
 
-- 
1.7.8

