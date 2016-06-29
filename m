Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 08/10] dvb_frontend: create a new ops to help returning signals in dB
Date: Wed, 29 Jun 2016 19:43:24 -0300
Message-Id: <790b5e1664c84e806a13143eff1c79b95fb4bf63.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add a new ops that will allow tuners to better report the
dB level of its AGC logic to the demod drivers. As the maximum
gain may vary from tuner to tuner, we'll be reversing the
logic here: instead of reporting the gain, let's report the
attenuation. This way, converting from it to the legacy DVBv3
way is trivial. It is also easy to adjust the level of
the received signal to dBm, as it is just a matter of adding
an offset at the demod and/or at the bridge driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 9592573a0b41..e8a4d341f420 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -227,8 +227,17 @@ enum dvbfe_search {
  * 			should return 0.
  * @get_status:		returns the frontend lock status
  * @get_rf_strength:	returns the RF signal strengh. Used mostly to support
- *			analog TV and radio. Digital TV should report, instead,
- *			via DVBv5 API (@dvb_frontend.dtv_property_cache;).
+ *			analog TV and radio. This is deprecated, in favor of
+ *			@get_rf_attenuation.
+ * @get_rf_attenuation:	returns the RF signal attenuation, relative to the
+ *			maximum supported gain, in 1/1000 dB steps. Please
+ *			notice that 0 means that the tuner is using its maximum
+ *			gain. So, a value of 10000, for example, means a 10dB
+ *			attenuation. This is ops is meant to be used by
+ *			demodulator drivers to estimate the maximum signal
+ *			strength. For that, it will add an offset, in order to
+ *			expose the signal strength to userspace via dvbv5
+ *			stats, in dBm.
  * @get_afc:		Used only by analog TV core. Reports the frequency
  *			drift due to AFC.
  * @calc_regs:		callback function used to pass register data settings
@@ -264,6 +273,7 @@ struct dvb_tuner_ops {
 #define TUNER_STATUS_STEREO 2
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
+	s32 (*get_rf_attenuation)(struct dvb_frontend *fe);
 	int (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 
 	/*
-- 
2.7.4

