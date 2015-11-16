Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 16/16] [media] dvb_frontend.h: improve documentation for struct dvb_tuner_ops
Date: Mon, 16 Nov 2015 08:21:13 -0200
Message-Id: <d30845e77ac47621592d29ad8eb36ea9a6e7718f.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the comments at the header, removing kernel-doc
tag from where it doesn't belong, grouping the legacy tuner
functions, and improving the text.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 40 ++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 43acac72cc32..e42af158bf71 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -213,12 +213,12 @@ enum dvbfe_search {
  *			are stored at @dvb_frontend.dtv_property_cache;. The
  *			tuner demod can change the parameters to reflect the
  *			changes needed for the channel to be tuned, and
- *			update statistics.
+ *			update statistics. This is the recommended way to set
+ *			the tuner parameters and should be used on newer
+ *			drivers.
  * @set_analog_params:	callback function used to tune into an analog TV
  *			channel on hybrid tuners. It passes @analog_parameters;
  *			to the driver.
- * @calc_regs:		callback function used to pass register data settings
- *			for simple tuners.
  * @set_config:		callback function used to send some tuner-specific
  *			parameters.
  * @get_frequency:	get the actual tuned frequency
@@ -231,10 +231,10 @@ enum dvbfe_search {
  *			via DVBv5 API (@dvb_frontend.dtv_property_cache;).
  * @get_afc:		Used only by analog TV core. Reports the frequency
  *			drift due to AFC.
- * @set_frequency:	Set a new frequency. Please notice that using
- *			set_params is preferred.
- * @set_bandwidth:	Set a new frequency. Please notice that using
- *			set_params is preferred.
+ * @calc_regs:		callback function used to pass register data settings
+ *			for simple tuners.  Shouldn't be used on newer drivers.
+ * @set_frequency:	Set a new frequency. Shouldn't be used on newer drivers.
+ * @set_bandwidth:	Set a new frequency. Shouldn't be used on newer drivers.
  *
  * NOTE: frequencies used on get_frequency and set_frequency are in Hz for
  * terrestrial/cable or kHz for satellite.
@@ -250,14 +250,10 @@ struct dvb_tuner_ops {
 	int (*suspend)(struct dvb_frontend *fe);
 	int (*resume)(struct dvb_frontend *fe);
 
-	/** This is for simple PLLs - set all parameters in one go. */
+	/* This is the recomended way to set the tuner */
 	int (*set_params)(struct dvb_frontend *fe);
 	int (*set_analog_params)(struct dvb_frontend *fe, struct analog_parameters *p);
 
-	/** This is support for demods like the mt352 - fills out the supplied buffer with what to write. */
-	int (*calc_regs)(struct dvb_frontend *fe, u8 *buf, int buf_len);
-
-	/** This is to allow setting tuner-specific configs */
 	int (*set_config)(struct dvb_frontend *fe, void *priv_cfg);
 
 	int (*get_frequency)(struct dvb_frontend *fe, u32 *frequency);
@@ -270,8 +266,21 @@ struct dvb_tuner_ops {
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
 	int (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 
-	/** These are provided separately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter separately. */
+	/*
+	 * This is support for demods like the mt352 - fills out the supplied
+	 * buffer with what to write.
+	 *
+	 * Don't use on newer drivers.
+	 */
+	int (*calc_regs)(struct dvb_frontend *fe, u8 *buf, int buf_len);
+
+	/*
+	 * These are provided separately from set_params in order to
+	 * facilitate silicon tuners which require sophisticated tuning loops,
+	 * controlling each parameter separately.
+	 *
+	 * Don't use on newer drivers.
+	 */
 	int (*set_frequency)(struct dvb_frontend *fe, u32 frequency);
 	int (*set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
 };
@@ -462,7 +471,8 @@ struct dvb_frontend_ops {
 	int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);
 	int (*set_lna)(struct dvb_frontend *);
 
-	/* These callbacks are for devices that implement their own
+	/*
+	 * These callbacks are for devices that implement their own
 	 * tuning algorithms, rather than a simple swzigzag
 	 */
 	enum dvbfe_search (*search)(struct dvb_frontend *fe);
-- 
2.5.0

