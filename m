Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1L0BJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:37 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19auZ015644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 87/91] [media] dvb: remove the track() fops
Date: Mon, 26 Dec 2011 23:09:15 -0200
Message-Id: <1324948159-23709-88-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-87-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
 <1324948159-23709-82-git-send-email-mchehab@redhat.com>
 <1324948159-23709-83-git-send-email-mchehab@redhat.com>
 <1324948159-23709-84-git-send-email-mchehab@redhat.com>
 <1324948159-23709-85-git-send-email-mchehab@redhat.com>
 <1324948159-23709-86-git-send-email-mchehab@redhat.com>
 <1324948159-23709-87-git-send-email-mchehab@redhat.com>
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

