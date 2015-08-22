Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 34/39] [media] dvb_frontend.h: Document struct dvb_tuner_ops
Date: Sat, 22 Aug 2015 14:28:19 -0300
Message-Id: <05601c9a669fe23462d2e13884456b99f6c88fcf.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct dvb_tuner_ops contains lots of callbacks used
by tuners. Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 8fc8d3a98382..991a6e0265d2 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -192,7 +192,53 @@ enum dvbfe_search {
 	DVBFE_ALGO_SEARCH_ERROR		= (1 << 31),
 };
 
-
+/**
+ * struct dvb_tuner_ops - Tuner information and callbacks
+ *
+ * @info:		embedded struct dvb_tuner_info with tuner properties
+ * @release:		callback function called when frontend is dettached.
+ *			drivers should free any allocated memory.
+ * @init:		callback function used to initialize the tuner device.
+ * @sleep:		callback function used to put the tuner to sleep.
+ * @suspend:		callback function used to inform that the Kernel will
+ *			suspend.
+ * @resume:		callback function used to inform that the Kernel is
+ *			resuming from suspend.
+ * @set_params:		callback function used to inform the tuner to tune
+ *			into a digital TV channel. The properties to be used
+ *			are stored at @dvb_frontend.dtv_property_cache;.
+ * @set_analog_params:	callback function used to tune into an analog TV
+ *			channel on hybrid tuners. It passes @analog_parameters;
+ *			to the driver.
+ * @calc_regs:		callback function used to pass register data settings
+ *			for simple tuners.
+ * @set_config:		callback function used to send some tuner-specific
+ *			parameters.
+ * @get_frequency:	get the actual tuned frequency
+ * @get_bandwidth:	get the bandwitdh used by the low pass filters
+ * @get_if_frequency:	get the Intermediate Frequency, in Hz. For baseband,
+ * 			should return 0.
+ * @get_status:		returns the frontend lock status
+ * @get_rf_strength:	returns the RF signal strengh. Used mostly to support
+ *			analog TV and radio. Digital TV should report, instead,
+ *			via DVBv5 API (@dvb_frontend.dtv_property_cache;).
+ * @get_afc:		Used only by analog TV core. Reports the frequency
+ *			drift due to AFC.
+ * @set_frequency:	Set a new frequency. Please notice that using
+ *			set_params is preferred.
+ * @set_bandwidth:	Set a new frequency. Please notice that using
+ *			set_params is preferred.
+ * @set_state:		callback function used on some legacy drivers that
+ * 			don't implement set_params in order to set properties.
+ * 			Shouldn't be used on new drivers.
+ * @get_state:		callback function used to get properties by some
+ * 			legacy drivers that don't implement set_params.
+ * 			Shouldn't be used on new drivers.
+ *
+ * NOTE: frequencies used on get_frequency and set_frequency are in Hz for
+ * terrestrial/cable or kHz for satellite.
+ *
+ */
 struct dvb_tuner_ops {
 
 	struct dvb_tuner_info info;
-- 
2.4.3

