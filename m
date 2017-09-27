Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33143
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752198AbdI0Vkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuahkg@osg.samsung.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 15/37] media: dvb_frontend.h: improve kernel-doc markups
Date: Wed, 27 Sep 2017 18:40:16 -0300
Message-Id: <3ec059eb0e0005a3897b215e1aa5aa44f1d1ee00.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several minor adjustments at the kernel-doc markups:

- some syntax fixes;
- some cross-references;
- add cross-references for the mentioned ioctls;
- some constants marked as such.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 94 +++++++++++++++++------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index d273ed2f72c9..ace0c2fb26c2 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -180,8 +180,8 @@ enum dvbfe_search {
 /**
  * struct dvb_tuner_ops - Tuner information and callbacks
  *
- * @info:		embedded struct dvb_tuner_info with tuner properties
- * @release:		callback function called when frontend is dettached.
+ * @info:		embedded &struct dvb_tuner_info with tuner properties
+ * @release:		callback function called when frontend is detached.
  *			drivers should free any allocated memory.
  * @init:		callback function used to initialize the tuner device.
  * @sleep:		callback function used to put the tuner to sleep.
@@ -191,14 +191,14 @@ enum dvbfe_search {
  *			resuming from suspend.
  * @set_params:		callback function used to inform the tuner to tune
  *			into a digital TV channel. The properties to be used
- *			are stored at @dvb_frontend.dtv_property_cache;. The
- *			tuner demod can change the parameters to reflect the
- *			changes needed for the channel to be tuned, and
+ *			are stored at &struct dvb_frontend.dtv_property_cache.
+ *			The tuner demod can change the parameters to reflect
+ *			the changes needed for the channel to be tuned, and
  *			update statistics. This is the recommended way to set
  *			the tuner parameters and should be used on newer
  *			drivers.
  * @set_analog_params:	callback function used to tune into an analog TV
- *			channel on hybrid tuners. It passes @analog_parameters;
+ *			channel on hybrid tuners. It passes @analog_parameters
  *			to the driver.
  * @set_config:		callback function used to send some tuner-specific
  *			parameters.
@@ -207,9 +207,9 @@ enum dvbfe_search {
  * @get_if_frequency:	get the Intermediate Frequency, in Hz. For baseband,
  * 			should return 0.
  * @get_status:		returns the frontend lock status
- * @get_rf_strength:	returns the RF signal strengh. Used mostly to support
+ * @get_rf_strength:	returns the RF signal strength. Used mostly to support
  *			analog TV and radio. Digital TV should report, instead,
- *			via DVBv5 API (@dvb_frontend.dtv_property_cache;).
+ *			via DVBv5 API (&struct dvb_frontend.dtv_property_cache).
  * @get_afc:		Used only by analog TV core. Reports the frequency
  *			drift due to AFC.
  * @calc_regs:		callback function used to pass register data settings
@@ -217,7 +217,7 @@ enum dvbfe_search {
  * @set_frequency:	Set a new frequency. Shouldn't be used on newer drivers.
  * @set_bandwidth:	Set a new frequency. Shouldn't be used on newer drivers.
  *
- * NOTE: frequencies used on get_frequency and set_frequency are in Hz for
+ * NOTE: frequencies used on @get_frequency and @set_frequency are in Hz for
  * terrestrial/cable or kHz for satellite.
  *
  */
@@ -283,14 +283,14 @@ struct analog_demod_info {
  * @set_params:		callback function used to inform the demod to set the
  *			demodulator parameters needed to decode an analog or
  *			radio channel. The properties are passed via
- *			struct @analog_params;.
+ *			&struct analog_params.
  * @has_signal:		returns 0xffff if has signal, or 0 if it doesn't.
  * @get_afc:		Used only by analog TV core. Reports the frequency
  *			drift due to AFC.
  * @tuner_status:	callback function that returns tuner status bits, e. g.
- *			TUNER_STATUS_LOCKED and TUNER_STATUS_STEREO.
+ *			%TUNER_STATUS_LOCKED and %TUNER_STATUS_STEREO.
  * @standby:		set the tuner to standby mode.
- * @release:		callback function called when frontend is dettached.
+ * @release:		callback function called when frontend is detached.
  *			drivers should free any allocated memory.
  * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
  *			mux support instead.
@@ -321,10 +321,10 @@ struct dtv_frontend_properties;
  * struct dvb_frontend_ops - Demodulation information and callbacks for
  *			      ditialt TV
  *
- * @info:		embedded struct dvb_tuner_info with tuner properties
+ * @info:		embedded &struct dvb_tuner_info with tuner properties
  * @delsys:		Delivery systems supported by the frontend
  * @detach:		callback function called when frontend is detached.
- *			drivers should clean up, but not yet free the struct
+ *			drivers should clean up, but not yet free the &struct
  *			dvb_frontend allocation.
  * @release:		callback function called when frontend is ready to be
  *			freed.
@@ -338,57 +338,57 @@ struct dtv_frontend_properties;
  *			allow other drivers to write data into their registers.
  *			Should not be used on new drivers.
  * @tune:		callback function used by demod drivers that use
- *			@DVBFE_ALGO_HW; to tune into a frequency.
+ *			@DVBFE_ALGO_HW to tune into a frequency.
  * @get_frontend_algo:	returns the desired hardware algorithm.
  * @set_frontend:	callback function used to inform the demod to set the
  *			parameters for demodulating a digital TV channel.
- *			The properties to be used are stored at
- *			@dvb_frontend.dtv_property_cache;. The demod can change
+ *			The properties to be used are stored at &struct
+ *			dvb_frontend.dtv_property_cache. The demod can change
  *			the parameters to reflect the changes needed for the
  *			channel to be decoded, and update statistics.
  * @get_tune_settings:	callback function
  * @get_frontend:	callback function used to inform the parameters
  *			actuall in use. The properties to be used are stored at
- *			@dvb_frontend.dtv_property_cache; and update
+ *			&struct dvb_frontend.dtv_property_cache and update
  *			statistics. Please notice that it should not return
  *			an error code if the statistics are not available
  *			because the demog is not locked.
  * @read_status:	returns the locking status of the frontend.
  * @read_ber:		legacy callback function to return the bit error rate.
  *			Newer drivers should provide such info via DVBv5 API,
- *			e. g. @set_frontend;/@get_frontend;, implementing this
+ *			e. g. @set_frontend;/@get_frontend, implementing this
  *			callback only if DVBv3 API compatibility is wanted.
  * @read_signal_strength: legacy callback function to return the signal
  *			strength. Newer drivers should provide such info via
- *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			DVBv5 API, e. g. @set_frontend/@get_frontend,
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
  * @read_snr:		legacy callback function to return the Signal/Noise
  * 			rate. Newer drivers should provide such info via
- *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			DVBv5 API, e. g. @set_frontend/@get_frontend,
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
  * @read_ucblocks:	legacy callback function to return the Uncorrected Error
  *			Blocks. Newer drivers should provide such info via
- *			DVBv5 API, e. g. @set_frontend;/@get_frontend;,
+ *			DVBv5 API, e. g. @set_frontend/@get_frontend,
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
  * @diseqc_reset_overload: callback function to implement the
- *			FE_DISEQC_RESET_OVERLOAD ioctl (only Satellite)
+ *			FE_DISEQC_RESET_OVERLOAD() ioctl (only Satellite)
  * @diseqc_send_master_cmd: callback function to implement the
- *			FE_DISEQC_SEND_MASTER_CMD ioctl (only Satellite).
+ *			FE_DISEQC_SEND_MASTER_CMD() ioctl (only Satellite).
  * @diseqc_recv_slave_reply: callback function to implement the
- *			FE_DISEQC_RECV_SLAVE_REPLY ioctl (only Satellite)
+ *			FE_DISEQC_RECV_SLAVE_REPLY() ioctl (only Satellite)
  * @diseqc_send_burst:	callback function to implement the
- *			FE_DISEQC_SEND_BURST ioctl (only Satellite).
+ *			FE_DISEQC_SEND_BURST() ioctl (only Satellite).
  * @set_tone:		callback function to implement the
- *			FE_SET_TONE ioctl (only Satellite).
+ *			FE_SET_TONE() ioctl (only Satellite).
  * @set_voltage:	callback function to implement the
- *			FE_SET_VOLTAGE ioctl (only Satellite).
+ *			FE_SET_VOLTAGE() ioctl (only Satellite).
  * @enable_high_lnb_voltage: callback function to implement the
- *			FE_ENABLE_HIGH_LNB_VOLTAGE ioctl (only Satellite).
+ *			FE_ENABLE_HIGH_LNB_VOLTAGE() ioctl (only Satellite).
  * @dishnetwork_send_legacy_command: callback function to implement the
- *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl (only Satellite).
+ *			FE_DISHNETWORK_SEND_LEGACY_CMD() ioctl (only Satellite).
  *			Drivers should not use this, except when the DVB
  *			core emulation fails to provide proper support (e.g.
  *			if @set_voltage takes more than 8ms to work), and
@@ -399,8 +399,8 @@ struct dtv_frontend_properties;
  * @ts_bus_ctrl:	callback function used to take control of the TS bus.
  * @set_lna:		callback function to power on/off/auto the LNA.
  * @search:		callback function used on some custom algo search algos.
- * @tuner_ops:		pointer to struct dvb_tuner_ops
- * @analog_ops:		pointer to struct analog_demod_ops
+ * @tuner_ops:		pointer to &struct dvb_tuner_ops
+ * @analog_ops:		pointer to &struct analog_demod_ops
  */
 struct dvb_frontend_ops {
 	struct dvb_frontend_info info;
@@ -630,16 +630,16 @@ struct dtv_frontend_properties {
 /**
  * struct dvb_frontend - Frontend structure to be used on drivers.
  *
- * @refcount:		refcount to keep track of struct dvb_frontend
+ * @refcount:		refcount to keep track of &struct dvb_frontend
  *			references
- * @ops:		embedded struct dvb_frontend_ops
- * @dvb:		pointer to struct dvb_adapter
+ * @ops:		embedded &struct dvb_frontend_ops
+ * @dvb:		pointer to &struct dvb_adapter
  * @demodulator_priv:	demod private data
  * @tuner_priv:		tuner private data
  * @frontend_priv:	frontend private data
  * @sec_priv:		SEC private data
  * @analog_demod_priv:	Analog demod private data
- * @dtv_property_cache:	embedded struct dtv_frontend_properties
+ * @dtv_property_cache:	embedded &struct dtv_frontend_properties
  * @callback:		callback function used on some drivers to call
  *			either the tuner or the demodulator.
  * @id:			Frontend ID
@@ -668,8 +668,8 @@ struct dvb_frontend {
 /**
  * dvb_register_frontend() - Registers a DVB frontend at the adapter
  *
- * @dvb: pointer to the dvb adapter
- * @fe: pointer to the frontend struct
+ * @dvb: pointer to &struct dvb_adapter
+ * @fe: pointer to &struct dvb_frontend
  *
  * Allocate and initialize the private data needed by the frontend core to
  * manage the frontend and calls dvb_register_device() to register a new
@@ -682,7 +682,7 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 /**
  * dvb_unregister_frontend() - Unregisters a DVB frontend
  *
- * @fe: pointer to the frontend struct
+ * @fe: pointer to &struct dvb_frontend
  *
  * Stops the frontend kthread, calls dvb_unregister_device() and frees the
  * private frontend data allocated by dvb_register_frontend().
@@ -696,14 +696,14 @@ int dvb_unregister_frontend(struct dvb_frontend *fe);
 /**
  * dvb_frontend_detach() - Detaches and frees frontend specific data
  *
- * @fe: pointer to the frontend struct
+ * @fe: pointer to &struct dvb_frontend
  *
  * This function should be called after dvb_unregister_frontend(). It
  * calls the SEC, tuner and demod release functions:
  * &dvb_frontend_ops.release_sec, &dvb_frontend_ops.tuner_ops.release,
  * &dvb_frontend_ops.analog_ops.release and &dvb_frontend_ops.release.
  *
- * If the driver is compiled with CONFIG_MEDIA_ATTACH, it also decreases
+ * If the driver is compiled with %CONFIG_MEDIA_ATTACH, it also decreases
  * the module reference count, needed to allow userspace to remove the
  * previously used DVB frontend modules.
  */
@@ -712,7 +712,7 @@ void dvb_frontend_detach(struct dvb_frontend *fe);
 /**
  * dvb_frontend_suspend() - Suspends a Digital TV frontend
  *
- * @fe: pointer to the frontend struct
+ * @fe: pointer to &struct dvb_frontend
  *
  * This function prepares a Digital TV frontend to suspend.
  *
@@ -730,7 +730,7 @@ int dvb_frontend_suspend(struct dvb_frontend *fe);
 /**
  * dvb_frontend_resume() - Resumes a Digital TV frontend
  *
- * @fe: pointer to the frontend struct
+ * @fe: pointer to &struct dvb_frontend
  *
  * This function resumes the usual operation of the tuner after resume.
  *
@@ -751,7 +751,7 @@ int dvb_frontend_resume(struct dvb_frontend *fe);
 /**
  * dvb_frontend_reinitialise() - forces a reinitialisation at the frontend
  *
- * @fe: pointer to the frontend struct
+ * @fe: pointer to &struct dvb_frontend
  *
  * Calls &dvb_frontend_ops.init\(\) and &dvb_frontend_ops.tuner_ops.init\(\),
  * and resets SEC tone and voltage (for Satellite systems).
@@ -766,16 +766,16 @@ void dvb_frontend_reinitialise(struct dvb_frontend *fe);
  * dvb_frontend_sleep_until() - Sleep for the amount of time given by
  *                      add_usec parameter
  *
- * @waketime: pointer to a struct ktime_t
+ * @waketime: pointer to &struct ktime_t
  * @add_usec: time to sleep, in microseconds
  *
  * This function is used to measure the time required for the
- * %FE_DISHNETWORK_SEND_LEGACY_CMD ioctl to work. It needs to be as precise
+ * FE_DISHNETWORK_SEND_LEGACY_CMD() ioctl to work. It needs to be as precise
  * as possible, as it affects the detection of the dish tone command at the
  * satellite subsystem.
  *
  * Its used internally by the DVB frontend core, in order to emulate
- * %FE_DISHNETWORK_SEND_LEGACY_CMD using the &dvb_frontend_ops.set_voltage\(\)
+ * FE_DISHNETWORK_SEND_LEGACY_CMD() using the &dvb_frontend_ops.set_voltage\(\)
  * callback.
  *
  * NOTE: it should not be used at the drivers, as the emulation for the
-- 
2.13.5
