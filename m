Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 38/39] [media] dvb-frontend.h: document struct dtv_frontend_properties
Date: Sat, 22 Aug 2015 14:28:23 -0300
Message-Id: <de2673391f4a85394163c6af2ef4c955937ca8bd.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the parameters here are already well defined at
the userspace documentation. Yet, it is good to add some
documentation, for the developers to be sure that they
are the same as the ones at userspace API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 115995958da6..796cc5dca819 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -337,7 +337,8 @@ struct dtv_frontend_properties;
 
 
 /**
- * struct dvb_frontend_ops
+ * struct dvb_frontend_ops - Demodulation information and callbacks for
+ *			      ditialt TV
  *
  * @info:		embedded struct dvb_tuner_info with tuner properties
  * @delsys:		Delivery systems supported by the frontend
@@ -388,21 +389,21 @@ struct dtv_frontend_properties;
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
  * @diseqc_reset_overload: callback function to implement the
- *			FE_DISEQC_RESET_OVERLOAD ioctl.
+ *			FE_DISEQC_RESET_OVERLOAD ioctl (only Satellite)
  * @diseqc_send_master_cmd: callback function to implement the
- *			FE_DISEQC_SEND_MASTER_CMD ioctl.
+ *			FE_DISEQC_SEND_MASTER_CMD ioctl (only Satellite).
  * @diseqc_recv_slave_reply: callback function to implement the
- *			FE_DISEQC_RECV_SLAVE_REPLY ioctl.
+ *			FE_DISEQC_RECV_SLAVE_REPLY ioctl (only Satellite)
  * @diseqc_send_burst:	callback function to implement the
- *			FE_DISEQC_SEND_BURST ioctl.
+ *			FE_DISEQC_SEND_BURST ioctl (only Satellite).
  * @set_tone:		callback function to implement the
- *			FE_SET_TONE ioctl.
+ *			FE_SET_TONE ioctl (only Satellite).
  * @set_voltage:	callback function to implement the
- *			FE_SET_VOLTAGE ioctl.
+ *			FE_SET_VOLTAGE ioctl (only Satellite).
  * @enable_high_lnb_voltage: callback function to implement the
- *			FE_ENABLE_HIGH_LNB_VOLTAGE ioctl.
+ *			FE_ENABLE_HIGH_LNB_VOLTAGE ioctl (only Satellite).
  * @dishnetwork_send_legacy_command: callback function to implement the
- *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl.
+ *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl (only Satellite).
  * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
  *			mux support instead.
  * @ts_bus_ctrl:	callback function used to take control of the TS bus.
@@ -480,6 +481,7 @@ struct dvb_frontend_ops {
 #ifdef __DVB_CORE__
 #define MAX_EVENT 8
 
+/* Used only internally at dvb_frontend.c */
 struct dvb_fe_events {
 	struct dvb_frontend_event events[MAX_EVENT];
 	int			  eventw;
@@ -490,13 +492,83 @@ struct dvb_fe_events {
 };
 #endif
 
+/**
+ * struct dtv_frontend_properties - contains a list of properties that are
+ *				    specific to a digital TV standard.
+ *
+ * @frequency:		frequency in Hz for terrestrial/cable or in kHz for
+ *			Satellite
+ * @modulation:		Frontend modulation type
+ * @voltage:		SEC voltage (only Satellite)
+ * @sectone:		SEC tone mode (only Satellite)
+ * @inversion:		Spectral inversion
+ * @fec_inner:		Forward error correction inner Code Rate
+ * @transmission_mode:	Transmission Mode
+ * @bandwidth_hz:	Bandwidth, in Hz. A zero value means that userspace
+ * 			wants to autodetect.
+ * @guard_interval:	Guard Interval
+ * @hierarchy:		Hierarchy
+ * @symbol_rate:	Symbol Rate
+ * @code_rate_HP:	high priority stream code rate
+ * @code_rate_LP:	low priority stream code rate
+ * @pilot:		Enable/disable/autodetect pilot tones
+ * @rolloff:		Rolloff factor (alpha)
+ * @delivery_system:	FE delivery system (e. g. digital TV standard)
+ * @interleaving:	interleaving
+ * @isdbt_partial_reception: ISDB-T partial reception (only ISDB standard)
+ * @isdbt_sb_mode:	ISDB-T Sound Broadcast (SB) mode (only ISDB standard)
+ * @isdbt_sb_subchannel:	ISDB-T SB subchannel (only ISDB standard)
+ * @isdbt_sb_segment_idx:	ISDB-T SB segment index (only ISDB standard)
+ * @isdbt_sb_segment_count:	ISDB-T SB segment count (only ISDB standard)
+ * @isdbt_layer_enabled:	ISDB Layer enabled (only ISDB standard)
+ * @layer:		ISDB per-layer data (only ISDB standard)
+ * @layer.segment_count: Segment Count;
+ * @layer.fec:		per layer code rate;
+ * @layer.modulation:	per layer modulation;
+ * @layer.interleaving:	 per layer interleaving.
+ * @stream_id:		If different than zero, enable substream filtering, if
+ *			hardware supports (DVB-S2 and DVB-T2).
+ * @atscmh_fic_ver:	Version number of the FIC (Fast Information Channel)
+ *			signaling data (only ATSC-M/H)
+ * @atscmh_parade_id:	Parade identification number (only ATSC-M/H)
+ * @atscmh_nog:		Number of MH groups per MH subframe for a designated
+ *			parade (only ATSC-M/H)
+ * @atscmh_tnog:	Total number of MH groups including all MH groups
+ *			belonging to all MH parades in one MH subframe
+ *			(only ATSC-M/H)
+ * @atscmh_sgn:		Start group number (only ATSC-M/H)
+ * @atscmh_prc:		Parade repetition cycle (only ATSC-M/H)
+ * @atscmh_rs_frame_mode:	Reed Solomon (RS) frame mode (only ATSC-M/H)
+ * @atscmh_rs_frame_ensemble:	RS frame ensemble (only ATSC-M/H)
+ * @atscmh_rs_code_mode_pri:	RS code mode pri (only ATSC-M/H)
+ * @atscmh_rs_code_mode_sec:	RS code mode sec (only ATSC-M/H)
+ * @atscmh_sccc_block_mode:	Series Concatenated Convolutional Code (SCCC)
+ *				Block Mode (only ATSC-M/H)
+ * @atscmh_sccc_code_mode_a:	SCCC code mode A (only ATSC-M/H)
+ * @atscmh_sccc_code_mode_b:	SCCC code mode B (only ATSC-M/H)
+ * @atscmh_sccc_code_mode_c:	SCCC code mode C (only ATSC-M/H)
+ * @atscmh_sccc_code_mode_d:	SCCC code mode D (only ATSC-M/H)
+ * @lna:		Power ON/OFF/AUTO the Linear Now-noise Amplifier (LNA)
+ * @strength:		DVBv5 API statistics: Signal Strength
+ * @cnr:		DVBv5 API statistics: Signal to Noise ratio of the
+ * 			(main) carrier
+ * @pre_bit_error:	DVBv5 API statistics: pre-Viterbi bit error count
+ * @pre_bit_count:	DVBv5 API statistics: pre-Viterbi bit count
+ * @post_bit_error:	DVBv5 API statistics: post-Viterbi bit error count
+ * @post_bit_count:	DVBv5 API statistics: post-Viterbi bit count
+ * @block_error:	DVBv5 API statistics: block error count
+ * @block_count:	DVBv5 API statistics: block count
+ *
+ * NOTE: derivated statistics like Uncorrected Error blocks (UCE) are
+ * calculated on userspace.
+ *
+ * Only a subset of the properties are needed for a given delivery system.
+ * For more info, consult the media_api.html with the documentation of the
+ * Userspace API.
+ */
 struct dtv_frontend_properties {
-
-	/* Cache State */
-	u32			state;
-
 	u32			frequency;
-	enum fe_modulation		modulation;
+	enum fe_modulation	modulation;
 
 	enum fe_sec_voltage	voltage;
 	enum fe_sec_tone_mode	sectone;
@@ -563,6 +635,11 @@ struct dtv_frontend_properties {
 	struct dtv_fe_stats	post_bit_count;
 	struct dtv_fe_stats	block_error;
 	struct dtv_fe_stats	block_count;
+
+	/* private: */
+	/* Cache State */
+	u32			state;
+
 };
 
 #define DVB_FE_NO_EXIT  0
-- 
2.4.3

