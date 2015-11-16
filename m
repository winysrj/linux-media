Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 08/16] [media] dvb_frontend.h: get rid of unused tuner params/states
Date: Mon, 16 Nov 2015 08:21:05 -0200
Message-Id: <061c5bf9a6c2bbbe6fff1b62495d2d6801dda8e9.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several tuner_param values that aren't by any driver or core:
	DVBFE_TUNER_TUNERSTEP
	DVBFE_TUNER_IFFREQ
	DVBFE_TUNER_REFCLOCK
	DVBFE_TUNER_IQSENSE
	DVBFE_TUNER_DUMMY

Several of those correspond to the values at the tuner_state
struct with is also only initialized by not used anyware:
	u32 tunerstep;
	u32 ifreq;
	u32 refclock;

It doesn't make sense to keep anything at the kABI that it is
not used. So, get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 11 +----------
 drivers/media/dvb-frontends/stb6100.c | 23 ++++++-----------------
 2 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 7c99a9190574..58608ae848bf 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -137,12 +137,7 @@ struct analog_parameters {
 
 enum tuner_param {
 	DVBFE_TUNER_FREQUENCY		= (1 <<  0),
-	DVBFE_TUNER_TUNERSTEP		= (1 <<  1),
-	DVBFE_TUNER_IFFREQ		= (1 <<  2),
-	DVBFE_TUNER_BANDWIDTH		= (1 <<  3),
-	DVBFE_TUNER_REFCLOCK		= (1 <<  4),
-	DVBFE_TUNER_IQSENSE		= (1 <<  5),
-	DVBFE_TUNER_DUMMY		= (1 << 31)
+	DVBFE_TUNER_BANDWIDTH		= (1 <<  1),
 };
 
 /**
@@ -177,11 +172,7 @@ enum dvbfe_algo {
 
 struct tuner_state {
 	u32 frequency;
-	u32 tunerstep;
-	u32 ifreq;
 	u32 bandwidth;
-	u32 iqsense;
-	u32 refclock;
 };
 
 /**
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 4ef8a5c7003e..e7f8d2c55565 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -496,14 +496,15 @@ static int stb6100_init(struct dvb_frontend *fe)
 {
 	struct stb6100_state *state = fe->tuner_priv;
 	struct tuner_state *status = &state->status;
+	int refclk = 27000000; /* Hz */
 
-	status->tunerstep	= 125000;
-	status->ifreq		= 0;
-	status->refclock	= 27000000;	/* Hz	*/
-	status->iqsense		= 1;
+	/*
+	 * iqsense = 1
+	 * tunerstep = 125000
+	 */
 	status->bandwidth	= 36000;	/* kHz	*/
 	state->bandwidth	= status->bandwidth * 1000;	/* Hz	*/
-	state->reference	= status->refclock / 1000;	/* kHz	*/
+	state->reference	= refclk / 1000;	/* kHz	*/
 
 	/* Set default bandwidth. Modified, PN 13-May-10	*/
 	return 0;
@@ -517,15 +518,9 @@ static int stb6100_get_state(struct dvb_frontend *fe,
 	case DVBFE_TUNER_FREQUENCY:
 		stb6100_get_frequency(fe, &state->frequency);
 		break;
-	case DVBFE_TUNER_TUNERSTEP:
-		break;
-	case DVBFE_TUNER_IFFREQ:
-		break;
 	case DVBFE_TUNER_BANDWIDTH:
 		stb6100_get_bandwidth(fe, &state->bandwidth);
 		break;
-	case DVBFE_TUNER_REFCLOCK:
-		break;
 	default:
 		break;
 	}
@@ -544,16 +539,10 @@ static int stb6100_set_state(struct dvb_frontend *fe,
 		stb6100_set_frequency(fe, state->frequency);
 		tstate->frequency = state->frequency;
 		break;
-	case DVBFE_TUNER_TUNERSTEP:
-		break;
-	case DVBFE_TUNER_IFFREQ:
-		break;
 	case DVBFE_TUNER_BANDWIDTH:
 		stb6100_set_bandwidth(fe, state->bandwidth);
 		tstate->bandwidth = state->bandwidth;
 		break;
-	case DVBFE_TUNER_REFCLOCK:
-		break;
 	default:
 		break;
 	}
-- 
2.5.0

