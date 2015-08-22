Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 35/39] [media] dvb_frontend.h: document struct analog_demod_ops
Date: Sat, 22 Aug 2015 14:28:20 -0300
Message-Id: <bbc9f5f80821c47a6cc3e73e52c9ec9aafd27dbe.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for struct analog_demod_info and
struct analog_demod_ops.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 991a6e0265d2..c6c85e6e9874 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -282,10 +282,37 @@ struct dvb_tuner_ops {
 	int (*get_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
 };
 
+/**
+ * struct analog_demod_info - Information struct for analog TV part of the demod
+ *
+ * @name:	Name of the analog TV demodulator
+ */
 struct analog_demod_info {
 	char *name;
 };
 
+/**
+ * struct analog_demod_ops  - Demodulation information and callbacks for
+ *			      analog TV and radio
+ *
+ * @info:		pointer to struct analog_demod_info
+ * @set_params:		callback function used to inform the demod to set the
+ *			demodulator parameters needed to decode an analog or
+ *			radio channel. The properties are passed via
+ *			struct @analog_params;.
+ * @has_signal:		returns 0xffff if has signal, or 0 if it doesn't.
+ * @get_afc:		Used only by analog TV core. Reports the frequency
+ *			drift due to AFC.
+ * @tuner_status:	callback function that returns tuner status bits, e. g.
+ *			TUNER_STATUS_LOCKED and TUNER_STATUS_STEREO.
+ * @standby:		set the tuner to standby mode.
+ * @release:		callback function called when frontend is dettached.
+ *			drivers should free any allocated memory.
+ * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
+ *			mux support instead.
+ * @set_config:		callback function used to send some tuner-specific
+ *			parameters.
+ */
 struct analog_demod_ops {
 
 	struct analog_demod_info info;
-- 
2.4.3

