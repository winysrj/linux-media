Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/16] [media] dvb_frontend: get rid of set_state ops & related data
Date: Mon, 16 Nov 2015 08:21:12 -0200
Message-Id: <836b077320f99074f23a74eecaead8edb94015da.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The get_state()/set_state and the corresponding data types
(struct tuner_state and enum tuner_param) are old DVB interfaces
that came from the DVBv3 time.

Nowadays, set_params() provide a better way to set the tuner
and demod parameters. So, no need to keep those legacy stuff,
as all drivers that were using it got converted.

With this patch, all kABI elements at dvb_frontend.h are now
documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 23 -----------------------
 drivers/media/tuners/mt2063.c         |  1 -
 2 files changed, 24 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 58608ae848bf..43acac72cc32 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -135,11 +135,6 @@ struct analog_parameters {
 	u64 std;
 };
 
-enum tuner_param {
-	DVBFE_TUNER_FREQUENCY		= (1 <<  0),
-	DVBFE_TUNER_BANDWIDTH		= (1 <<  1),
-};
-
 /**
  * enum dvbfe_algo - defines the algorithm used to tune into a channel
  *
@@ -170,11 +165,6 @@ enum dvbfe_algo {
 	DVBFE_ALGO_RECOVERY		= (1 << 31)
 };
 
-struct tuner_state {
-	u32 frequency;
-	u32 bandwidth;
-};
-
 /**
  * enum dvbfe_search - search callback possible return status
  *
@@ -245,12 +235,6 @@ enum dvbfe_search {
  *			set_params is preferred.
  * @set_bandwidth:	Set a new frequency. Please notice that using
  *			set_params is preferred.
- * @set_state:		callback function used on some legacy drivers that
- * 			don't implement set_params in order to set properties.
- * 			Shouldn't be used on new drivers.
- * @get_state:		callback function used to get properties by some
- * 			legacy drivers that don't implement set_params.
- * 			Shouldn't be used on new drivers.
  *
  * NOTE: frequencies used on get_frequency and set_frequency are in Hz for
  * terrestrial/cable or kHz for satellite.
@@ -290,13 +274,6 @@ struct dvb_tuner_ops {
 	 * tuners which require sophisticated tuning loops, controlling each parameter separately. */
 	int (*set_frequency)(struct dvb_frontend *fe, u32 frequency);
 	int (*set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
-
-	/*
-	 * These are provided separately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter separately.
-	 */
-	int (*set_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
-	int (*get_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
 };
 
 /**
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 9e9c5eb4cb66..6457ac91ef09 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -225,7 +225,6 @@ struct mt2063_state {
 	const struct mt2063_config *config;
 	struct dvb_tuner_ops ops;
 	struct dvb_frontend *frontend;
-	struct tuner_state status;
 
 	u32 frequency;
 	u32 srate;
-- 
2.5.0

