Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9WTk024228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 87/94] [media] dvb: remove the track() fops
Date: Fri, 30 Dec 2011 13:08:24 -0200
Message-Id: <1325257711-12274-88-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This callback is not used anywhere. Maybe it were used in the
past to optimize the custom algo, but, as it is not used anymore,
let's just remove it.

If later needed, some patch may re-add it with a proper
implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c  |    5 +----
 drivers/media/dvb/dvb-core/dvb_frontend.h  |    1 -
 drivers/media/dvb/frontends/stb0899_drv.c  |   21 ---------------------
 drivers/media/dvb/frontends/stv0900_core.c |    7 -------
 4 files changed, 1 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 18a7e23..68d284b 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -637,10 +637,7 @@ restart:
 					}
 				}
 				/* Track the carrier if the search was successful */
-				if (fepriv->algo_status == DVBFE_ALGO_SEARCH_SUCCESS) {
-					if (fe->ops.track)
-						fe->ops.track(fe, &fepriv->parameters_in);
-				} else {
+				if (fepriv->algo_status != DVBFE_ALGO_SEARCH_SUCCESS) {
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 79f01ce..52efcbd 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -307,7 +307,6 @@ struct dvb_frontend_ops {
 	 * tuning algorithms, rather than a simple swzigzag
 	 */
 	enum dvbfe_search (*search)(struct dvb_frontend *fe);
-	int (*track)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 93afc79..9fad627 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1568,26 +1568,6 @@ static enum dvbfe_search stb0899_search(struct dvb_frontend *fe)
 
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
-/*
- * stb0899_track
- * periodically check the signal level against a specified
- * threshold level and perform derotator centering.
- * called once we have a lock from a successful search
- * event.
- *
- * Will be called periodically called to maintain the
- * lock.
- *
- * Will be used to get parameters as well as info from
- * the decoded baseband header
- *
- * Once a new lock has established, the internal state
- * frequency (internal->freq) is updated
- */
-static int stb0899_track(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
-{
-	return 0;
-}
 
 static int stb0899_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *p)
 {
@@ -1647,7 +1627,6 @@ static struct dvb_frontend_ops stb0899_ops = {
 
 	.get_frontend_algo		= stb0899_frontend_algo,
 	.search				= stb0899_search,
-	.track				= stb0899_track,
 	.get_frontend                   = stb0899_get_frontend,
 
 
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 83e9a81..8af1e624 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1658,12 +1658,6 @@ static int stv0900_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	return 0;
 }
 
-static int stv0900_track(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *p)
-{
-	return 0;
-}
-
 static int stv0900_stop_ts(struct dvb_frontend *fe, int stop_ts)
 {
 
@@ -1891,7 +1885,6 @@ static struct dvb_frontend_ops stv0900_ops = {
 	.diseqc_recv_slave_reply	= stv0900_recv_slave_reply,
 	.set_tone			= stv0900_set_tone,
 	.search				= stv0900_search,
-	.track				= stv0900_track,
 	.read_status			= stv0900_read_status,
 	.read_ber			= stv0900_read_ber,
 	.read_signal_strength		= stv0900_read_signal_strength,
-- 
1.7.8.352.g876a6

