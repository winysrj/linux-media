Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 37/39] [media] dvb-frontend.h: document struct dvb_frontend_ops
Date: Sat, 22 Aug 2015 14:28:22 -0300
Message-Id: <fbeb9ebf54c79e2deac3cd8c7c4977abba6ede74.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is one of the most important functions of the DVB
frontend, containing the logic needed to set the parameters
at the demux and to send commands via SEC.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index c6c85e6e9874..115995958da6 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -206,7 +206,10 @@ enum dvbfe_search {
  *			resuming from suspend.
  * @set_params:		callback function used to inform the tuner to tune
  *			into a digital TV channel. The properties to be used
- *			are stored at @dvb_frontend.dtv_property_cache;.
+ *			are stored at @dvb_frontend.dtv_property_cache;. The
+ *			tuner demod can change the parameters to reflect the
+ *			changes needed for the channel to be tuned, and
+ *			update statistics.
  * @set_analog_params:	callback function used to tune into an analog TV
  *			channel on hybrid tuners. It passes @analog_parameters;
  *			to the driver.
@@ -332,6 +335,86 @@ struct analog_demod_ops {
 
 struct dtv_frontend_properties;
 
+
+/**
+ * struct dvb_frontend_ops
+ *
+ * @info:		embedded struct dvb_tuner_info with tuner properties
+ * @delsys:		Delivery systems supported by the frontend
+ * @release:		callback function called when frontend is dettached.
+ *			drivers should free any allocated memory.
+ * @release_sec:	callback function requesting that the Satelite Equipment
+ *			Control (SEC) driver to release and free any memory
+ *			allocated by the driver.
+ * @init:		callback function used to initialize the tuner device.
+ * @sleep:		callback function used to put the tuner to sleep.
+ * @write:		callback function used by some demod legacy drivers to
+ *			allow other drivers to write data into their registers.
+ *			Should not be used on new drivers.
+ * @tune:		callback function used by demod drivers that use
+ *			@DVBFE_ALGO_HW; to tune into a frequency.
+ * @get_frontend_algo:	returns the desired hardware algorithm.
+ * @set_frontend:	callback function used to inform the demod to set the
+ *			parameters for demodulating a digital TV channel.
+ *			The properties to be used are stored at
+ *			@dvb_frontend.dtv_property_cache;. The demod can change
+ *			the parameters to reflect the changes needed for the
+ *			channel to be decoded, and update statistics.
+ * @get_tune_settings:	callback function
+ * @get_frontend:	callback function used to inform the parameters
+ *			actuall in use. The properties to be used are stored at
+ *			@dvb_frontend.dtv_property_cache; and update
+ *			statistics. Please notice that it should not return
+ *			an error code if the statistics are not available
+ *			because the demog is not locked.
+ * @read_status:	returns the locking status of the frontend.
+ * @read_ber:		legacy callback function to return the bit error rate.
+ *			Newer drivers should provide such info via DVBv5 API,
+ *			e. g. @set_frontend;/@get_frontend;, implementing this
+ *			callback only if DVBv3 API compatibility is wanted.
+ * @read_signal_strength: legacy callback function to return the signal
+ *			strength. Newer drivers should provide such info via
+ *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			implementing this callback only if DVBv3 API
+ *			compatibility is wanted.
+ * @read_snr:		legacy callback function to return the Signal/Noise
+ * 			rate. Newer drivers should provide such info via
+ *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			implementing this callback only if DVBv3 API
+ *			compatibility is wanted.
+ * @read_ucblocks:	legacy callback function to return the Uncorrected Error
+ *			Blocks. Newer drivers should provide such info via
+ *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			implementing this callback only if DVBv3 API
+ *			compatibility is wanted.
+ * @diseqc_reset_overload: callback function to implement the
+ *			FE_DISEQC_RESET_OVERLOAD ioctl.
+ * @diseqc_send_master_cmd: callback function to implement the
+ *			FE_DISEQC_SEND_MASTER_CMD ioctl.
+ * @diseqc_recv_slave_reply: callback function to implement the
+ *			FE_DISEQC_RECV_SLAVE_REPLY ioctl.
+ * @diseqc_send_burst:	callback function to implement the
+ *			FE_DISEQC_SEND_BURST ioctl.
+ * @set_tone:		callback function to implement the
+ *			FE_SET_TONE ioctl.
+ * @set_voltage:	callback function to implement the
+ *			FE_SET_VOLTAGE ioctl.
+ * @enable_high_lnb_voltage: callback function to implement the
+ *			FE_ENABLE_HIGH_LNB_VOLTAGE ioctl.
+ * @dishnetwork_send_legacy_command: callback function to implement the
+ *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl.
+ * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
+ *			mux support instead.
+ * @ts_bus_ctrl:	callback function used to take control of the TS bus.
+ * @set_lna:		callback function to power on/off/auto the LNA.
+ * @search:		callback function used on some custom algo search algos.
+ * @tuner_ops:		pointer to struct dvb_tuner_ops
+ * @analog_ops:		pointer to struct analog_demod_ops
+ * @set_property:	callback function to allow the frontend to validade
+ *			incoming properties. Should not be used on new drivers.
+ * @get_property:	callback function to allow the frontend to override
+ *			outcoming properties. Should not be used on new drivers.
+ */
 struct dvb_frontend_ops {
 
 	struct dvb_frontend_info info;
@@ -352,6 +435,7 @@ struct dvb_frontend_ops {
 		    unsigned int mode_flags,
 		    unsigned int *delay,
 		    enum fe_status *status);
+
 	/* get frontend tuning algorithm from the module */
 	enum dvbfe_algo (*get_frontend_algo)(struct dvb_frontend *fe);
 
-- 
2.4.3

