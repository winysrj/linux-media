Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:60888 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:46 -0400
Message-ID: <4E99F313.4050103@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:43 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 4/7] staging/as102: cleanup - formatting code
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E9992F9.7000101@poczta.onet.pl>
In-Reply-To: <4E9992F9.7000101@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging as102: cleanup - formatting code

Cleanup code: change double spaces into single, put tabs instead of spaces where they should be.

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_drv.c linux.as102.04-tabs/drivers/staging/as102/as102_drv.c
--- linux.as102.03-typedefs/drivers/staging/as102/as102_drv.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_drv.c	2011-10-14 23:20:05.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -115,7 +115,7 @@
  }

  static int as10x_pid_filter(struct as102_dev_t *dev,
-			    int index, u16 pid, int onoff) {
+		int index, u16 pid, int onoff) {

  	struct as102_bus_adapter_t *bus_adap =&dev->bus_adap;
  	int ret = -EFAULT;
@@ -129,22 +129,22 @@

  	switch (onoff) {
  	case 0:
-	    ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-	    dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
-		    index, pid, ret);
-	    break;
+		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
+		dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+				index, pid, ret);
+		break;
  	case 1:
  	{
-	    struct as10x_ts_filter filter;
+		struct as10x_ts_filter filter;

-	    filter.type = TS_PID_TYPE_TS;
-	    filter.idx = 0xFF;
-	    filter.pid = pid;
-
-	    ret = as10x_cmd_add_PID_filter(bus_adap,&filter);
-	    dprintk(debug, "ADD_PID_FILTER([%02d ->  %02d], 0x%04x) ret = %d\n",
-		    index, filter.idx, filter.pid, ret);
-	    break;
+		filter.type = TS_PID_TYPE_TS;
+		filter.idx = 0xFF;
+		filter.pid = pid;
+
+		ret = as10x_cmd_add_PID_filter(bus_adap,&filter);
+		dprintk(debug, "ADD_PID_FILTER([%02d ->  %02d], 0x%04x) ret = %d\n",
+				index, filter.idx, filter.pid, ret);
+		break;
  	}
  	}

@@ -209,22 +209,22 @@

  #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
  	ret = dvb_register_adapter(&as102_dev->dvb_adap,
-				   as102_dev->name,
-				   THIS_MODULE,
+			as102_dev->name,
+			THIS_MODULE,
  #if defined(CONFIG_AS102_USB)
-				&as102_dev->bus_adap.usb_dev->dev
+			&as102_dev->bus_adap.usb_dev->dev
  #elif defined(CONFIG_AS102_SPI)
-				&as102_dev->bus_adap.spi_dev->dev
+			&as102_dev->bus_adap.spi_dev->dev
  #else
  #error>>>  dvb_register_adapter<<<
  #endif
  #ifdef DVB_DEFINE_MOD_OPT_ADAPTER_NR
-				   , adapter_nr
+			, adapter_nr
  #endif
-				   );
+	);
  	if (ret<  0) {
  		err("%s: dvb_register_adapter() failed (errno = %d)",
-		    __func__, ret);
+				__func__, ret);
  		goto failed;
  	}

@@ -235,7 +235,7 @@
  	as102_dev->dvb_dmx.stop_feed = as102_dvb_dmx_stop_feed;

  	as102_dev->dvb_dmx.dmx.capabilities = DMX_TS_FILTERING |
-					      DMX_SECTION_FILTERING;
+			DMX_SECTION_FILTERING;

  	as102_dev->dvb_dmxdev.filternum = as102_dev->dvb_dmx.filternum;
  	as102_dev->dvb_dmxdev.demux =&as102_dev->dvb_dmx.dmx;
@@ -250,14 +250,14 @@
  	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev,&as102_dev->dvb_adap);
  	if (ret<  0) {
  		err("%s: dvb_dmxdev_init() failed (errno = %d)", __func__,
-		    ret);
+				ret);
  		goto failed;
  	}

  	ret = as102_dvb_register_fe(as102_dev,&as102_dev->dvb_fe);
  	if (ret<  0) {
  		err("%s: as102_dvb_register_frontend() failed (errno = %d)",
-		    __func__, ret);
+				__func__, ret);
  		goto failed;
  	}
  #endif
@@ -278,7 +278,7 @@
  				"firmware_class");
  #endif

-failed:
+	failed:
  	LEAVE();
  	/* FIXME: free dvb_XXX */
  	return ret;
@@ -332,7 +332,7 @@

  /**
   * \brief as102 driver exit point. This function is called when device has
- *       to be removed.
+ *		to be removed.
   */
  static void __exit as102_driver_exit(void)
  {
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_drv.h linux.as102.04-tabs/drivers/staging/as102/as102_drv.h
--- linux.as102.03-typedefs/drivers/staging/as102/as102_drv.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_drv.h	2011-10-14 22:21:58.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -48,8 +48,8 @@
  	} } while (0)

  #ifdef TRACE
-#define ENTER()                 printk(">>  enter %s\n", __FUNCTION__)
-#define LEAVE()                 printk("<<  leave %s\n", __FUNCTION__)
+#define ENTER()		printk(">>  enter %s\n", __FUNCTION__)
+#define LEAVE()		printk("<<  leave %s\n", __FUNCTION__)
  #else
  #define ENTER()
  #define LEAVE()
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_fe.c linux.as102.04-tabs/drivers/staging/as102/as102_fe.c
--- linux.as102.03-typedefs/drivers/staging/as102/as102_fe.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_fe.c	2011-10-14 23:21:51.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -27,10 +27,10 @@

  #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
  static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
-					 struct as10x_tps *src);
+		struct as10x_tps *src);

  static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
-					  struct dvb_frontend_parameters *src);
+		struct dvb_frontend_parameters *src);

  #if (LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19))
  static void as102_fe_release(struct dvb_frontend *fe)
@@ -60,7 +60,7 @@
  	dev->ber = -1;

  	/* reset tuner private data */
-/* 	fe->tuner_priv = NULL; */
+	/* 	fe->tuner_priv = NULL; */

  	LEAVE();
  }
@@ -93,7 +93,7 @@
  #endif

  static int as102_fe_set_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *params)
+		struct dvb_frontend_parameters *params)
  {
  	int ret = 0;
  	struct as102_dev_t *dev;
@@ -111,7 +111,7 @@
  	as102_fe_copy_tune_parameters(&tune_args, params);

  	/* send abilis command: SET_TUNE */
-	ret =  as10x_cmd_set_tune(&dev->bus_adap,&tune_args);
+	ret = as10x_cmd_set_tune(&dev->bus_adap,&tune_args);
  	if (ret != 0)
  		dprintk(debug, "as10x_cmd_set_tune failed. (err = %d)\n", ret);

@@ -122,7 +122,7 @@
  }

  static int as102_fe_get_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p) {
+		struct dvb_frontend_parameters *p) {
  	int ret = 0;
  	struct as102_dev_t *dev;
  	struct as10x_tps tps = { 0 };
@@ -149,14 +149,14 @@
  }

  static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
-			struct dvb_frontend_tune_settings *settings) {
+		struct dvb_frontend_tune_settings *settings) {
  	ENTER();

  #if 0
  	dprintk(debug, "step_size    = %d\n", settings->step_size);
  	dprintk(debug, "max_drift    = %d\n", settings->max_drift);
  	dprintk(debug, "min_delay_ms = %d ->  %d\n", settings->min_delay_ms,
-		1000);
+			1000);
  #endif

  	settings->min_delay_ms = 1000;
@@ -185,12 +185,12 @@
  	ret = as10x_cmd_get_tune_status(&dev->bus_adap,&tstate);
  	if (ret<  0) {
  		dprintk(debug, "as10x_cmd_get_tune_status failed (err = %d)\n",
-			ret);
+				ret);
  		goto out;
  	}

-	dev->signal_strength  = tstate.signal_strength;
-	dev->ber  = tstate.BER;
+	dev->signal_strength = tstate.signal_strength;
+	dev->ber = tstate.BER;

  	switch (tstate.tune_state) {
  	case TUNE_STATUS_SIGNAL_DVB_OK:
@@ -201,7 +201,7 @@
  		break;
  	case TUNE_STATUS_STREAM_TUNED:
  		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
-			FE_HAS_LOCK;
+		FE_HAS_LOCK;
  		break;
  	default:
  		*status = TUNE_STATUS_NOT_TUNED;
@@ -213,24 +213,24 @@

  	if (*status&  FE_HAS_LOCK) {
  		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
-			(struct as10x_demod_stats *)&dev->demod_stats)<  0) {
+				(struct as10x_demod_stats *)&dev->demod_stats)<  0) {
  			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
  			dprintk(debug, "as10x_cmd_get_demod_stats failed "
-				"(probably not tuned)\n");
+					"(probably not tuned)\n");
  		} else {
  			dprintk(debug,
-				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
-				"bytes corrected: 0x%08x , MER: 0x%04x\n",
-				dev->demod_stats.frame_count,
-				dev->demod_stats.bad_frame_count,
-				dev->demod_stats.bytes_fixed_by_rs,
-				dev->demod_stats.mer);
+					"demod status: fc: 0x%08x, bad fc: 0x%08x, "
+					"bytes corrected: 0x%08x , MER: 0x%04x\n",
+					dev->demod_stats.frame_count,
+					dev->demod_stats.bad_frame_count,
+					dev->demod_stats.bytes_fixed_by_rs,
+					dev->demod_stats.mer);
  		}
  	} else {
  		memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
  	}

-out:
+	out:
  	mutex_unlock(&dev->bus_adap.lock);
  	LEAVE();
  	return ret;
@@ -239,9 +239,9 @@
  /*
   * Note:
   * - in AS102 SNR=MER
- *   - the SNR will be returned in linear terms, i.e. not in dB
- *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
- *   - the accuracy is>2dB for SNR values outside this range
+ * - the SNR will be returned in linear terms, i.e. not in dB
+ * - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
+ * - the accuracy is>2dB for SNR values outside this range
   */
  static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
  {
@@ -276,7 +276,7 @@
  }

  static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
-					 u16 *strength)
+		u16 *strength)
  {
  	struct as102_dev_t *dev;

@@ -343,40 +343,40 @@
  #endif

  static struct dvb_frontend_ops as102_fe_ops = {
-	.info = {
-		.name			= "Unknown AS102 device",
-		.type			= FE_OFDM,
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.caps = FE_CAN_INVERSION_AUTO
-			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
-			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
-			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
-			| FE_CAN_QAM_AUTO
-			| FE_CAN_TRANSMISSION_MODE_AUTO
-			| FE_CAN_GUARD_INTERVAL_AUTO
-			| FE_CAN_HIERARCHY_AUTO
-			| FE_CAN_RECOVER
-			| FE_CAN_MUTE_TS
-	},
-
-	.set_frontend		= as102_fe_set_frontend,
-	.get_frontend		= as102_fe_get_frontend,
-	.get_tune_settings	= as102_fe_get_tune_settings,
-
-
-	.read_status		= as102_fe_read_status,
-	.read_snr		= as102_fe_read_snr,
-	.read_ber		= as102_fe_read_ber,
-	.read_signal_strength	= as102_fe_read_signal_strength,
-	.read_ucblocks		= as102_fe_read_ucblocks,
+		.info = {
+				.name			= "Unknown AS102 device",
+				.type			= FE_OFDM,
+				.frequency_min		= 174000000,
+				.frequency_max		= 862000000,
+				.frequency_stepsize	= 166667,
+				.caps = FE_CAN_INVERSION_AUTO
+				| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+				| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
+				| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
+				| FE_CAN_QAM_AUTO
+				| FE_CAN_TRANSMISSION_MODE_AUTO
+				| FE_CAN_GUARD_INTERVAL_AUTO
+				| FE_CAN_HIERARCHY_AUTO
+				| FE_CAN_RECOVER
+				| FE_CAN_MUTE_TS
+		},
+
+		.set_frontend		= as102_fe_set_frontend,
+		.get_frontend		= as102_fe_get_frontend,
+		.get_tune_settings	= as102_fe_get_tune_settings,
+
+
+		.read_status		= as102_fe_read_status,
+		.read_snr		= as102_fe_read_snr,
+		.read_ber		= as102_fe_read_ber,
+		.read_signal_strength	= as102_fe_read_signal_strength,
+		.read_ucblocks		= as102_fe_read_ucblocks,

  #if (LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 19))
-	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+		.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
  #else
-	.release		= as102_fe_release,
-	.init			= as102_fe_init,
+		.release		= as102_fe_release,
+		.init			= as102_fe_init,
  #endif
  };

@@ -393,7 +393,7 @@
  }

  int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
-			  struct dvb_frontend *dvb_fe)
+		struct dvb_frontend *dvb_fe)
  {
  	int errno;
  	struct dvb_adapter *dvb_adap;
@@ -407,7 +407,7 @@
  	/* init frontend callback ops */
  	memcpy(&dvb_fe->ops,&as102_fe_ops, sizeof(struct dvb_frontend_ops));
  	strncpy(dvb_fe->ops.info.name, as102_dev->name,
-		sizeof(dvb_fe->ops.info.name));
+			sizeof(dvb_fe->ops.info.name));

  	/* register dbvb frontend */
  	errno = dvb_register_frontend(dvb_adap, dvb_fe);
@@ -418,7 +418,7 @@
  }

  static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
-					 struct as10x_tps *as10x_tps)
+		struct as10x_tps *as10x_tps)
  {

  	struct dvb_ofdm_parameters *fe_tps =&dst->u.ofdm;
@@ -546,7 +546,7 @@
  }

  static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
-			  struct dvb_frontend_parameters *params)
+		struct dvb_frontend_parameters *params)
  {

  	/* set frequency */
@@ -642,32 +642,32 @@
  	 * if HP/LP are both set to FEC_NONE, HP will be selected.
  	 */
  	if ((tune_args->hierarchy != HIER_NONE)&&
-		       ((params->u.ofdm.code_rate_LP == FEC_NONE) ||
-			(params->u.ofdm.code_rate_HP == FEC_NONE))) {
+			((params->u.ofdm.code_rate_LP == FEC_NONE) ||
+					(params->u.ofdm.code_rate_HP == FEC_NONE))) {

  		if (params->u.ofdm.code_rate_LP == FEC_NONE) {
  			tune_args->hier_select = HIER_HIGH_PRIORITY;
  			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+					as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
  		}

  		if (params->u.ofdm.code_rate_HP == FEC_NONE) {
  			tune_args->hier_select = HIER_LOW_PRIORITY;
  			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
+					as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
  		}

  		dprintk(debug, "\thierarchy: 0x%02x  "
  				"selected: %s  code_rate_%s: 0x%02x\n",
-			tune_args->hierarchy,
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args->code_rate);
+				tune_args->hierarchy,
+				tune_args->hier_select == HIER_HIGH_PRIORITY ?
+						"HP" : "LP",
+						tune_args->hier_select == HIER_HIGH_PRIORITY ?
+								"HP" : "LP",
+								tune_args->code_rate);
  	} else {
  		tune_args->code_rate =
-			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+				as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
  	}
  }
  #endif
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_fw.c linux.as102.04-tabs/drivers/staging/as102/as102_fw.c
--- linux.as102.03-typedefs/drivers/staging/as102/as102_fw.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_fw.c	2011-10-14 23:22:33.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -52,8 +52,8 @@
   * Parse INTEL HEX firmware file to extract address and data.
   */
  static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
-			  unsigned char *data, int *dataLength,
-			  unsigned char *addr_has_changed) {
+		unsigned char *data, int *dataLength,
+		unsigned char *addr_has_changed) {

  	int count = 0;
  	unsigned char *src, dst;
@@ -84,8 +84,8 @@
  			else
  				*addr_has_changed = 0;
  			break;
-		case  4:
-		case  5:
+		case 4:
+		case 5:
  			if (*addr_has_changed)
  				addr[(count - 4)] = dst;
  			else
@@ -103,8 +103,8 @@
  }

  static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
-				 unsigned char *cmd,
-				 const struct firmware *firmware) {
+		unsigned char *cmd,
+		const struct firmware *firmware) {

  	struct as10x_fw_pkt_t fw_pkt;
  	int total_read_bytes = 0, errno = 0;
@@ -134,8 +134,8 @@

  			/* send EOF command */
  			errno = bus_adap->ops->upload_fw_pkt(bus_adap,
-							     (uint8_t *)
-							&fw_pkt, 2, 0);
+					(uint8_t *)
+					&fw_pkt, 2, 0);
  			if (errno<  0)
  				goto error;
  		} else {
@@ -149,16 +149,16 @@

  				/* send cmd to device */
  				errno = bus_adap->ops->upload_fw_pkt(bus_adap,
-								     (uint8_t *)
-								&fw_pkt,
-								     data_len,
-								     0);
+						(uint8_t *)
+						&fw_pkt,
+						data_len,
+						0);
  				if (errno<  0)
  					goto error;
  			}
  		}
  	}
-error:
+	error:
  	LEAVE();
  	return (errno == 0) ? total_read_bytes : errno;
  }
@@ -199,7 +199,7 @@
  	errno = request_firmware(&firmware, fw1,&dev->dev);
  	if (errno<  0) {
  		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
-				 DRIVER_NAME, fw1);
+				DRIVER_NAME, fw1);
  		goto error;
  	}

@@ -207,12 +207,12 @@
  	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
  	if (errno<  0) {
  		printk(KERN_ERR "%s: error during firmware upload part1\n",
-				 DRIVER_NAME);
+				DRIVER_NAME);
  		goto error;
  	}

  	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
-			 DRIVER_NAME, fw1);
+			DRIVER_NAME, fw1);
  	release_firmware(firmware);

  	/* wait for boot to complete */
@@ -222,7 +222,7 @@
  	errno = request_firmware(&firmware, fw2,&dev->dev);
  	if (errno<  0) {
  		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
-				 DRIVER_NAME, fw2);
+				DRIVER_NAME, fw2);
  		goto error;
  	}

@@ -230,13 +230,13 @@
  	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
  	if (errno<  0) {
  		printk(KERN_ERR "%s: error during firmware upload part2\n",
-				 DRIVER_NAME);
+				DRIVER_NAME);
  		goto error;
  	}

  	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
  			DRIVER_NAME, fw2);
-error:
+	error:
  	/* free data buffer */
  	kfree(cmd_buf);
  	/* release firmware if needed */
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_fw.h linux.as102.04-tabs/drivers/staging/as102/as102_fw.h
--- linux.as102.03-typedefs/drivers/staging/as102/as102_fw.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_fw.h	2011-10-14 23:36:54.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_usb_drv.c linux.as102.04-tabs/drivers/staging/as102/as102_usb_drv.c
--- linux.as102.03-typedefs/drivers/staging/as102/as102_usb_drv.c	2011-10-14 18:21:36.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_usb_drv.c	2011-10-14 23:23:14.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -29,7 +29,7 @@

  static void as102_usb_disconnect(struct usb_interface *interface);
  static int as102_usb_probe(struct usb_interface *interface,
-			   const struct usb_device_id *id);
+		const struct usb_device_id *id);

  static int as102_usb_start_stream(struct as102_dev_t *dev);
  static void as102_usb_stop_stream(struct as102_dev_t *dev);
@@ -38,59 +38,59 @@
  static int as102_release(struct inode *inode, struct file *file);

  static struct usb_device_id as102_usb_id_table[] = {
-	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
-	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
-	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
-	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
-	{ } /* Terminating entry */
+		{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
+		{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
+		{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
+		{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
+		{ } /* Terminating entry */
  };

  /* Note that this table must always have the same number of entries as the
-   as102_usb_id_table struct */
+	as102_usb_id_table struct */
  static const char *as102_device_names[] = {
-	AS102_REFERENCE_DESIGN,
-	AS102_PCTV_74E,
-	AS102_ELGATO_EYETV_DTT_NAME,
-	AS102_NBOX_DVBT_DONGLE_NAME,
-	NULL /* Terminating entry */
+		AS102_REFERENCE_DESIGN,
+		AS102_PCTV_74E,
+		AS102_ELGATO_EYETV_DTT_NAME,
+		AS102_NBOX_DVBT_DONGLE_NAME,
+		NULL /* Terminating entry */
  };

  struct usb_driver as102_usb_driver = {
-	.name       =  DRIVER_FULL_NAME,
-	.probe      =  as102_usb_probe,
-	.disconnect =  as102_usb_disconnect,
-	.id_table   =  as102_usb_id_table
+		.name		= DRIVER_FULL_NAME,
+		.probe		= as102_usb_probe,
+		.disconnect	= as102_usb_disconnect,
+		.id_table	= as102_usb_id_table
  };

  static const struct file_operations as102_dev_fops = {
-	.owner   = THIS_MODULE,
-	.open    = as102_open,
-	.release = as102_release,
+		.owner		= THIS_MODULE,
+		.open		= as102_open,
+		.release	= as102_release,
  };

  static struct usb_class_driver as102_usb_class_driver = {
-	.name		= "aton2-%d",
-	.fops		=&as102_dev_fops,
-	.minor_base	= AS102_DEVICE_MAJOR,
+		.name		= "aton2-%d",
+		.fops		=&as102_dev_fops,
+		.minor_base	= AS102_DEVICE_MAJOR,
  };

  static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
-			      unsigned char *send_buf, int send_buf_len,
-			      unsigned char *recv_buf, int recv_buf_len)
+		unsigned char *send_buf, int send_buf_len,
+		unsigned char *recv_buf, int recv_buf_len)
  {
  	int ret = 0;
  	ENTER();

  	if (send_buf != NULL) {
  		ret = usb_control_msg(bus_adap->usb_dev,
-				      usb_sndctrlpipe(bus_adap->usb_dev, 0),
-				      AS102_USB_DEVICE_TX_CTRL_CMD,
-				      USB_DIR_OUT | USB_TYPE_VENDOR |
-				      USB_RECIP_DEVICE,
-				      bus_adap->cmd_xid, /* value */
-				      0, /* index */
-				      send_buf, send_buf_len,
-				      USB_CTRL_SET_TIMEOUT /* 200 */);
+				usb_sndctrlpipe(bus_adap->usb_dev, 0),
+				AS102_USB_DEVICE_TX_CTRL_CMD,
+				USB_DIR_OUT | USB_TYPE_VENDOR |
+				USB_RECIP_DEVICE,
+				bus_adap->cmd_xid, /* value */
+				0, /* index */
+				send_buf, send_buf_len,
+				USB_CTRL_SET_TIMEOUT /* 200 */);
  		if (ret<  0) {
  			dprintk(debug, "usb_control_msg(send) failed, err %i\n",
  					ret);
@@ -109,14 +109,14 @@
  		dprintk(debug, "want to read: %d bytes\n", recv_buf_len);
  #endif
  		ret = usb_control_msg(bus_adap->usb_dev,
-				      usb_rcvctrlpipe(bus_adap->usb_dev, 0),
-				      AS102_USB_DEVICE_RX_CTRL_CMD,
-				      USB_DIR_IN | USB_TYPE_VENDOR |
-				      USB_RECIP_DEVICE,
-				      bus_adap->cmd_xid, /* value */
-				      0, /* index */
-				      recv_buf, recv_buf_len,
-				      USB_CTRL_GET_TIMEOUT /* 200 */);
+				usb_rcvctrlpipe(bus_adap->usb_dev, 0),
+				AS102_USB_DEVICE_RX_CTRL_CMD,
+				USB_DIR_IN | USB_TYPE_VENDOR |
+				USB_RECIP_DEVICE,
+				bus_adap->cmd_xid, /* value */
+				0, /* index */
+				recv_buf, recv_buf_len,
+				USB_CTRL_GET_TIMEOUT /* 200 */);
  		if (ret<  0) {
  			dprintk(debug, "usb_control_msg(recv) failed, err %i\n",
  					ret);
@@ -132,15 +132,15 @@
  }

  static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
-			  unsigned char *send_buf,
-			  int send_buf_len,
-			  int swap32)
+		unsigned char *send_buf,
+		int send_buf_len,
+		int swap32)
  {
  	int ret = 0, actual_len;

  	ret = usb_bulk_msg(bus_adap->usb_dev,
-			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
-			   send_buf, send_buf_len,&actual_len, 200);
+			usb_sndbulkpipe(bus_adap->usb_dev, 1),
+			send_buf, send_buf_len,&actual_len, 200);
  	if (ret) {
  		dprintk(debug, "usb_bulk_msg(send) failed, err %i\n", ret);
  		return ret;
@@ -155,7 +155,7 @@
  }

  static int as102_read_ep2(struct as102_bus_adapter_t *bus_adap,
-		   unsigned char *recv_buf, int recv_buf_len)
+		unsigned char *recv_buf, int recv_buf_len)
  {
  	int ret = 0, actual_len;

@@ -163,8 +163,8 @@
  		return -EINVAL;

  	ret = usb_bulk_msg(bus_adap->usb_dev,
-			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
-			   recv_buf, recv_buf_len,&actual_len, 200);
+			usb_rcvbulkpipe(bus_adap->usb_dev, 2),
+			recv_buf, recv_buf_len,&actual_len, 200);
  	if (ret) {
  		dprintk(debug, "usb_bulk_msg(recv) failed, err %i\n", ret);
  		return ret;
@@ -179,11 +179,11 @@
  }

  struct as102_priv_ops_t as102_priv_ops = {
-	.upload_fw_pkt	= as102_send_ep1,
-	.xfer_cmd	= as102_usb_xfer_cmd,
-	.as102_read_ep2	= as102_read_ep2,
-	.start_stream	= as102_usb_start_stream,
-	.stop_stream	= as102_usb_stop_stream,
+		.upload_fw_pkt	= as102_send_ep1,
+		.xfer_cmd	= as102_usb_xfer_cmd,
+		.as102_read_ep2	= as102_read_ep2,
+		.start_stream	= as102_usb_start_stream,
+		.stop_stream	= as102_usb_stop_stream,
  };

  static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
@@ -191,12 +191,12 @@
  	int err;

  	usb_fill_bulk_urb(urb,
-			  dev->bus_adap.usb_dev,
-			  usb_rcvbulkpipe(dev->bus_adap.usb_dev, 0x2),
-			  urb->transfer_buffer,
-			  AS102_USB_BUF_SIZE,
-			  as102_urb_stream_irq,
-			  dev);
+			dev->bus_adap.usb_dev,
+			usb_rcvbulkpipe(dev->bus_adap.usb_dev, 0x2),
+			urb->transfer_buffer,
+			AS102_USB_BUF_SIZE,
+			as102_urb_stream_irq,
+			dev);

  	err = usb_submit_urb(urb, GFP_ATOMIC);
  	if (err)
@@ -216,8 +216,8 @@
  	if (urb->actual_length>  0) {
  #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
  		dvb_dmx_swfilter(&as102_dev->dvb_dmx,
-				 urb->transfer_buffer,
-				 urb->actual_length);
+				urb->transfer_buffer,
+				urb->actual_length);
  #else
  		/* do nothing ? */
  #endif
@@ -254,9 +254,9 @@
  	ENTER();

  	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
-				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
-				       GFP_KERNEL,
-				&dev->dma_addr);
+			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
+			GFP_KERNEL,
+			&dev->dma_addr);
  	if (!dev->stream) {
  		dprintk(debug, "%s: usb_buffer_alloc failed\n", __func__);
  		return -ENOMEM;
@@ -351,7 +351,7 @@
  }

  static int as102_usb_probe(struct usb_interface *intf,
-			   const struct usb_device_id *id)
+		const struct usb_device_id *id)
  {
  	int ret;
  	struct as102_dev_t *as102_dev;
@@ -367,14 +367,14 @@

  	/* This should never actually happen */
  	if ((sizeof(as102_usb_id_table) / sizeof(struct usb_device_id)) !=
-	    (sizeof(as102_device_names) / sizeof(const char *))) {
+			(sizeof(as102_device_names) / sizeof(const char *))) {
  		printk(KERN_ERR "Device names table invalid size");
  		return -EINVAL;
  	}

  	/* Assign the user-friendly device name */
  	for (i = 0; i<  (sizeof(as102_usb_id_table) /
-			 sizeof(struct usb_device_id)); i++) {
+			sizeof(struct usb_device_id)); i++) {
  		if (id ==&as102_usb_id_table[i])
  			as102_dev->name = as102_device_names[i];
  	}
@@ -403,7 +403,7 @@
  	if (ret<  0) {
  		/* something prevented us from registering this driver */
  		err("%s: usb_register_dev() failed (errno = %d)",
-		    __func__, ret);
+				__func__, ret);
  		goto failed;
  	}

@@ -420,7 +420,7 @@
  	LEAVE();
  	return ret;

-failed:
+	failed:
  	usb_set_intfdata(intf, NULL);
  	kfree(as102_dev);
  	return ret;
@@ -459,7 +459,7 @@
  	/* increment our usage count for the device */
  	kref_get(&dev->kref);

-exit:
+	exit:
  	LEAVE();
  	return ret;
  }
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_usb_drv.h linux.as102.04-tabs/drivers/staging/as102/as102_usb_drv.h
--- linux.as102.03-typedefs/drivers/staging/as102/as102_usb_drv.h	2011-10-14 18:20:32.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as102_usb_drv.h	2011-10-14 22:22:15.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.c linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.c
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.c	2011-10-14 23:25:27.000000000 +0200
@@ -10,7 +10,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -22,24 +22,24 @@
  #include<linux/kernel.h>
  #include "as102_drv.h"
  #elif defined(WIN32)
-   #if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
-      /* win32 ddk implementation */
-      #include "wdm.h"
-      #include "Device.h"
-      #include "endian_mgmt.h" /* FIXME */
-   #else /* win32 sdk implementation */
-      #include<windows.h>
-      #include "types.h"
-      #include "util.h"
-      #include "as10x_handle.h"
-      #include "endian_mgmt.h"
-   #endif
+#if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
+/* win32 ddk implementation */
+#include "wdm.h"
+#include "Device.h"
+#include "endian_mgmt.h" /* FIXME */
+#else /* win32 sdk implementation */
+#include<windows.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h"
+#endif
  #else /* all other cases */
-   #include<string.h>
-   #include "types.h"
-   #include "util.h"
-   #include "as10x_handle.h"
-   #include "endian_mgmt.h" /* FIXME */
+#include<string.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h" /* FIXME */
  #endif /* __KERNEL__ */

  #include "as10x_types.h"
@@ -50,7 +50,7 @@
     \param  phandle:   pointer to AS10x handle
     \return 0 when no error,<  0 in case of error.
    \callgraph
-*/
+ */
  int as10x_cmd_turn_on(as10x_handle_t *phandle)
  {
  	int error;
@@ -71,11 +71,11 @@
  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
-					       sizeof(pcmd->body.turn_on.req) +
-					       HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.turn_on.rsp) +
-					       HEADER_SIZE);
+				sizeof(pcmd->body.turn_on.req) +
+				HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.turn_on.rsp) +
+				HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -86,7 +86,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -96,7 +96,7 @@
     \param  phandle:   pointer to AS10x handle
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_turn_off(as10x_handle_t *phandle)
  {
  	int error;
@@ -117,10 +117,10 @@
  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(
-			phandle, (uint8_t *) pcmd,
-			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
+				phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -131,7 +131,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -164,22 +164,22 @@
  	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
  	preq->body.set_tune.req.args.constellation = ptune->constellation;
  	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
-	preq->body.set_tune.req.args.interleaving_mode  =
-		ptune->interleaving_mode;
-	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
+	preq->body.set_tune.req.args.interleaving_mode =
+			ptune->interleaving_mode;
+	preq->body.set_tune.req.args.code_rate = ptune->code_rate;
  	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
-	preq->body.set_tune.req.args.transmission_mode  =
-		ptune->transmission_mode;
+	preq->body.set_tune.req.args.transmission_mode =
+			ptune->transmission_mode;

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(phandle,
-					       (uint8_t *) preq,
-					       sizeof(preq->body.set_tune.req)
-					       + HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.set_tune.rsp)
-					       + HEADER_SIZE);
+				(uint8_t *) preq,
+				sizeof(preq->body.set_tune.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.set_tune.rsp)
+				+ HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -190,7 +190,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -203,10 +203,10 @@
     \callgraph
   */
  int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
-			      struct as10x_tune_status *pstatus)
+		struct as10x_tune_status *pstatus)
  {
  	int error;
-	struct as10x_cmd_t  *preq, *prsp;
+	struct as10x_cmd_t *preq, *prsp;

  	ENTER();

@@ -219,16 +219,16 @@

  	/* fill command */
  	preq->body.get_tune_status.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
+			cpu_to_le16(CONTROL_PROC_GETTUNESTAT);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(
-			phandle,
-			(uint8_t *) preq,
-			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
+				phandle,
+				(uint8_t *) preq,
+				sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -243,12 +243,12 @@

  	/* Response OK ->  get response data */
  	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
-	pstatus->signal_strength  =
-		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
+	pstatus->signal_strength =
+			le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
  	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
  	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -276,17 +276,17 @@

  	/* fill command */
  	pcmd->body.get_tune_status.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GETTPS);
+			cpu_to_le16(CONTROL_PROC_GETTPS);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(phandle,
-					       (uint8_t *) pcmd,
-					       sizeof(pcmd->body.get_tps.req) +
-					       HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.get_tps.rsp) +
-					       HEADER_SIZE);
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.get_tps.req) +
+				HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_tps.rsp) +
+				HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -306,12 +306,12 @@
  	ptps->code_rate_HP = prsp->body.get_tps.rsp.tps.code_rate_HP;
  	ptps->code_rate_LP = prsp->body.get_tps.rsp.tps.code_rate_LP;
  	ptps->guard_interval = prsp->body.get_tps.rsp.tps.guard_interval;
-	ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
+	ptps->transmission_mode = prsp->body.get_tps.rsp.tps.transmission_mode;
  	ptps->DVBH_mask_HP = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
  	ptps->DVBH_mask_LP = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
  	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -322,9 +322,9 @@
     \param  pdemod_stats:  pointer to demod stats parameters structure
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
-int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
-			      struct as10x_demod_stats *pdemod_stats)
+ */
+int as10x_cmd_get_demod_stats(as10x_handle_t *phandle,
+		struct as10x_demod_stats *pdemod_stats)
  {
  	int error;
  	struct as10x_cmd_t *pcmd, *prsp;
@@ -340,7 +340,7 @@

  	/* fill command */
  	pcmd->body.get_demod_stats.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
+			cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
@@ -365,17 +365,17 @@

  	/* Response OK ->  get response data */
  	pdemod_stats->frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
+			le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
  	pdemod_stats->bad_frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
+			le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
  	pdemod_stats->bytes_fixed_by_rs =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
+			le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
  	pdemod_stats->mer =
-		le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
+			le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
  	pdemod_stats->has_started =
-		prsp->body.get_demod_stats.rsp.stats.has_started;
+			prsp->body.get_demod_stats.rsp.stats.has_started;

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -387,9 +387,9 @@
  			   response data is ready
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
-int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
-			       uint8_t *is_ready)
+ */
+int as10x_cmd_get_impulse_resp(as10x_handle_t *phandle,
+		uint8_t *is_ready)
  {
  	int error;
  	struct as10x_cmd_t *pcmd, *prsp;
@@ -405,17 +405,17 @@

  	/* fill command */
  	pcmd->body.get_impulse_rsp.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
+			cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
  		error = phandle->ops->xfer_cmd(phandle,
-					(uint8_t *) pcmd,
-					sizeof(pcmd->body.get_impulse_rsp.req)
-					+ HEADER_SIZE,
-					(uint8_t *) prsp,
-					sizeof(prsp->body.get_impulse_rsp.rsp)
-					+ HEADER_SIZE);
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.get_impulse_rsp.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_impulse_rsp.rsp)
+				+ HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -431,7 +431,7 @@
  	/* Response OK ->  get response data */
  	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -445,9 +445,9 @@
     \param  cmd_len:  lenght of the command
     \return -
     \callgraph
-*/
+ */
  void as10x_cmd_build(struct as10x_cmd_t *pcmd,
-		     uint16_t xid, uint16_t cmd_len)
+		uint16_t xid, uint16_t cmd_len)
  {
  	pcmd->header.req_id = cpu_to_le16(xid);
  	pcmd->header.prog = cpu_to_le16(SERVICE_PROG_ID);
@@ -462,7 +462,7 @@
     \param  cmd_len:    lenght of the command
     \return 0 when no error,<  0 in case of error
     \callgraph
-*/
+ */
  int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
  {
  	int error;
@@ -471,7 +471,7 @@
  	error = prsp->body.common.rsp.error;

  	if ((error == 0)&&
-	    (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
+			(le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
  		return 0;
  	}

diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd_cfg.c linux.as102.04-tabs/drivers/staging/as102/as10x_cmd_cfg.c
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd_cfg.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_cmd_cfg.c	2011-10-14 23:24:05.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -21,31 +21,31 @@
  #include<linux/kernel.h>
  #include "as102_drv.h"
  #elif defined(WIN32)
-   #if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
-      /* win32 ddk implementation */
-      #include "wdm.h"
-      #include "Device.h"
-      #include "endian_mgmt.h" /* FIXME */
-   #else /* win32 sdk implementation */
-      #include<windows.h>
-      #include "types.h"
-      #include "util.h"
-      #include "as10x_handle.h"
-      #include "endian_mgmt.h"
-   #endif
+#if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
+/* win32 ddk implementation */
+#include "wdm.h"
+#include "Device.h"
+#include "endian_mgmt.h" /* FIXME */
+#else /* win32 sdk implementation */
+#include<windows.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h"
+#endif
  #else /* all other cases */
-   #include<string.h>
-   #include "types.h"
-   #include "util.h"
-   #include "as10x_handle.h"
-   #include "endian_mgmt.h" /* FIXME */
+#include<string.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h" /* FIXME */
  #endif /* __KERNEL__ */

  #include "as10x_types.h"
  #include "as10x_cmd.h"

  /***************************/
-/* FUNCTION DEFINITION     */
+/* FUNCTION DEFINITION		*/
  /***************************/

  /**
@@ -55,11 +55,11 @@
     \param  pvalue:    pointer where to store context value read
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
-			  uint32_t *pvalue)
+		uint32_t *pvalue)
  {
-	int  error;
+	int error;
  	struct as10x_cmd_t *pcmd, *prsp;

  	ENTER();
@@ -78,13 +78,13 @@

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle,
-						(uint8_t *) pcmd,
-						sizeof(pcmd->body.context.req)
-						+ HEADER_SIZE,
-						(uint8_t *) prsp,
-						sizeof(prsp->body.context.rsp)
-						+ HEADER_SIZE);
+		error = phandle->ops->xfer_cmd(phandle,
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.context.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.context.rsp)
+				+ HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -102,7 +102,7 @@
  		/* value returned is always a 32-bit value */
  	}

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -114,9 +114,9 @@
     \param  value:     value to set in context
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
-			  uint32_t value)
+		uint32_t value)
  {
  	int error;
  	struct as10x_cmd_t *pcmd, *prsp;
@@ -139,13 +139,13 @@

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle,
-						(uint8_t *) pcmd,
-						sizeof(pcmd->body.context.req)
-						+ HEADER_SIZE,
-						(uint8_t *) prsp,
-						sizeof(prsp->body.context.rsp)
-						+ HEADER_SIZE);
+		error = phandle->ops->xfer_cmd(phandle,
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.context.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.context.rsp)
+				+ HEADER_SIZE);
  	} else {
  		error = AS10X_CMD_ERROR;
  	}
@@ -157,7 +157,7 @@
  	/* structure ->  specific handling response parse required            */
  	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -173,7 +173,7 @@
  				      ON or OFF
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
  {
  	int error;
@@ -190,12 +190,12 @@

  	/* fill command */
  	pcmd->body.cfg_change_mode.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
+			cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
  	pcmd->body.cfg_change_mode.req.mode = mode;

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
  				sizeof(pcmd->body.cfg_change_mode.req)
  				+ HEADER_SIZE, (uint8_t *) prsp,
  				sizeof(prsp->body.cfg_change_mode.rsp)
@@ -210,7 +210,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -223,7 +223,7 @@
     \return 0 when no error,<  0 in case of error.
  	   ABILIS_RC_NOK
     \callgraph
-*/
+ */
  int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
  {
  	int err;
@@ -231,7 +231,7 @@
  	err = prsp->body.context.rsp.error;

  	if ((err == 0)&&
-	    (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
+			(le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
  		return 0;
  	}
  	return AS10X_CMD_ERROR;
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.h linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.h
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.h	2011-10-14 18:48:39.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.h	2011-10-14 23:34:17.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -26,469 +26,468 @@
  #include "as10x_types.h"

  /*********************************/
-/*       MACRO DEFINITIONS       */
+/* MACRO DEFINITIONS			 */
  /*********************************/
  #define AS10X_CMD_ERROR -1

-#define SERVICE_PROG_ID        0x0002
-#define SERVICE_PROG_VERSION   0x0001
+#define SERVICE_PROG_ID			0x0002
+#define SERVICE_PROG_VERSION	0x0001

-#define HIER_NONE              0x00
-#define HIER_LOW_PRIORITY      0x01
+#define HIER_NONE				0x00
+#define HIER_LOW_PRIORITY		 0x01

  #define HEADER_SIZE (sizeof(struct as10x_cmd_header_t))

  /* context request types */
-#define GET_CONTEXT_DATA        1
-#define SET_CONTEXT_DATA        2
+#define GET_CONTEXT_DATA		1
+#define SET_CONTEXT_DATA		2

  /* ODSP suspend modes */
-#define CFG_MODE_ODSP_RESUME  0
-#define CFG_MODE_ODSP_SUSPEND 1
+#define CFG_MODE_ODSP_RESUME	0
+#define CFG_MODE_ODSP_SUSPEND	1

  /* Dump memory size */
-#define DUMP_BLOCK_SIZE_MAX   0x20
+#define DUMP_BLOCK_SIZE_MAX		0x20

  /*********************************/
-/*     TYPE DEFINITION           */
+/* TYPE DEFINITION				 */
  /*********************************/
  enum control_proc {
-   CONTROL_PROC_TURNON               = 0x0001,
-   CONTROL_PROC_TURNON_RSP           = 0x0100,
-   CONTROL_PROC_SET_REGISTER         = 0x0002,
-   CONTROL_PROC_SET_REGISTER_RSP     = 0x0200,
-   CONTROL_PROC_GET_REGISTER         = 0x0003,
-   CONTROL_PROC_GET_REGISTER_RSP     = 0x0300,
-   CONTROL_PROC_SETTUNE              = 0x000A,
-   CONTROL_PROC_SETTUNE_RSP          = 0x0A00,
-   CONTROL_PROC_GETTUNESTAT          = 0x000B,
-   CONTROL_PROC_GETTUNESTAT_RSP      = 0x0B00,
-   CONTROL_PROC_GETTPS               = 0x000D,
-   CONTROL_PROC_GETTPS_RSP           = 0x0D00,
-   CONTROL_PROC_SETFILTER            = 0x000E,
-   CONTROL_PROC_SETFILTER_RSP        = 0x0E00,
-   CONTROL_PROC_REMOVEFILTER         = 0x000F,
-   CONTROL_PROC_REMOVEFILTER_RSP     = 0x0F00,
-   CONTROL_PROC_GET_IMPULSE_RESP     = 0x0012,
-   CONTROL_PROC_GET_IMPULSE_RESP_RSP = 0x1200,
-   CONTROL_PROC_START_STREAMING      = 0x0013,
-   CONTROL_PROC_START_STREAMING_RSP  = 0x1300,
-   CONTROL_PROC_STOP_STREAMING       = 0x0014,
-   CONTROL_PROC_STOP_STREAMING_RSP   = 0x1400,
-   CONTROL_PROC_GET_DEMOD_STATS      = 0x0015,
-   CONTROL_PROC_GET_DEMOD_STATS_RSP  = 0x1500,
-   CONTROL_PROC_ELNA_CHANGE_MODE     = 0x0016,
-   CONTROL_PROC_ELNA_CHANGE_MODE_RSP = 0x1600,
-   CONTROL_PROC_ODSP_CHANGE_MODE     = 0x0017,
-   CONTROL_PROC_ODSP_CHANGE_MODE_RSP = 0x1700,
-   CONTROL_PROC_AGC_CHANGE_MODE      = 0x0018,
-   CONTROL_PROC_AGC_CHANGE_MODE_RSP  = 0x1800,
-
-   CONTROL_PROC_CONTEXT              = 0x00FC,
-   CONTROL_PROC_CONTEXT_RSP          = 0xFC00,
-   CONTROL_PROC_DUMP_MEMORY          = 0x00FD,
-   CONTROL_PROC_DUMP_MEMORY_RSP      = 0xFD00,
-   CONTROL_PROC_DUMPLOG_MEMORY       = 0x00FE,
-   CONTROL_PROC_DUMPLOG_MEMORY_RSP   = 0xFE00,
-   CONTROL_PROC_TURNOFF              = 0x00FF,
-   CONTROL_PROC_TURNOFF_RSP          = 0xFF00
+	CONTROL_PROC_TURNON					= 0x0001,
+	CONTROL_PROC_TURNON_RSP				= 0x0100,
+	CONTROL_PROC_SET_REGISTER			= 0x0002,
+	CONTROL_PROC_SET_REGISTER_RSP		= 0x0200,
+	CONTROL_PROC_GET_REGISTER			= 0x0003,
+	CONTROL_PROC_GET_REGISTER_RSP		= 0x0300,
+	CONTROL_PROC_SETTUNE				= 0x000A,
+	CONTROL_PROC_SETTUNE_RSP			= 0x0A00,
+	CONTROL_PROC_GETTUNESTAT			= 0x000B,
+	CONTROL_PROC_GETTUNESTAT_RSP		= 0x0B00,
+	CONTROL_PROC_GETTPS					= 0x000D,
+	CONTROL_PROC_GETTPS_RSP				= 0x0D00,
+	CONTROL_PROC_SETFILTER				= 0x000E,
+	CONTROL_PROC_SETFILTER_RSP			= 0x0E00,
+	CONTROL_PROC_REMOVEFILTER			= 0x000F,
+	CONTROL_PROC_REMOVEFILTER_RSP		= 0x0F00,
+	CONTROL_PROC_GET_IMPULSE_RESP		= 0x0012,
+	CONTROL_PROC_GET_IMPULSE_RESP_RSP	= 0x1200,
+	CONTROL_PROC_START_STREAMING		= 0x0013,
+	CONTROL_PROC_START_STREAMING_RSP	= 0x1300,
+	CONTROL_PROC_STOP_STREAMING			= 0x0014,
+	CONTROL_PROC_STOP_STREAMING_RSP		= 0x1400,
+	CONTROL_PROC_GET_DEMOD_STATS		= 0x0015,
+	CONTROL_PROC_GET_DEMOD_STATS_RSP	= 0x1500,
+	CONTROL_PROC_ELNA_CHANGE_MODE		= 0x0016,
+	CONTROL_PROC_ELNA_CHANGE_MODE_RSP	= 0x1600,
+	CONTROL_PROC_ODSP_CHANGE_MODE		= 0x0017,
+	CONTROL_PROC_ODSP_CHANGE_MODE_RSP	= 0x1700,
+	CONTROL_PROC_AGC_CHANGE_MODE		= 0x0018,
+	CONTROL_PROC_AGC_CHANGE_MODE_RSP	= 0x1800,
+
+	CONTROL_PROC_CONTEXT				= 0x00FC,
+	CONTROL_PROC_CONTEXT_RSP			= 0xFC00,
+	CONTROL_PROC_DUMP_MEMORY			= 0x00FD,
+	CONTROL_PROC_DUMP_MEMORY_RSP		= 0xFD00,
+	CONTROL_PROC_DUMPLOG_MEMORY			= 0x00FE,
+	CONTROL_PROC_DUMPLOG_MEMORY_RSP		= 0xFE00,
+	CONTROL_PROC_TURNOFF				= 0x00FF,
+	CONTROL_PROC_TURNOFF_RSP			= 0xFF00
  };


  #pragma pack(1)
  union TURN_ON {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  union TURN_OFF {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t err;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t err;
+	} rsp;
  };

  union SET_TUNE {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* tune params */
-      struct as10x_tune_args args;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* tune params */
+		struct as10x_tune_args args;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
  };

  union GET_TUNE_STATUS {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* tune status */
-      struct as10x_tune_status sts;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tune status */
+		struct as10x_tune_status sts;
+	} rsp;
  };

  union GET_TPS {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* tps details */
-      struct as10x_tps tps;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tps details */
+		struct as10x_tps tps;
+	} rsp;
  };

  union COMMON {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
  };

  union ADD_PID_FILTER {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-      /* PID to filter */
-      uint16_t  pid;
-      /* stream type (MPE, PSI/SI or PES )*/
-      uint8_t stream_type;
-      /* PID index in filter table */
-      uint8_t idx;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* Filter id */
-      uint8_t filter_id;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* PID to filter */
+		uint16_t pid;
+		/* stream type (MPE, PSI/SI or PES )*/
+		uint8_t stream_type;
+		/* PID index in filter table */
+		uint8_t idx;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* Filter id */
+		uint8_t filter_id;
+	} rsp;
  };

  union DEL_PID_FILTER {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-      /* PID to remove */
-      uint16_t  pid;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* PID to remove */
+		uint16_t pid;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
  };

  union START_STREAMING {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  union STOP_STREAMING {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  union GET_DEMOD_STATS {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* demod stats */
-      struct as10x_demod_stats stats;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* demod stats */
+		struct as10x_demod_stats stats;
+	} rsp;
  };

  union GET_IMPULSE_RESP {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* impulse response ready */
-      uint8_t is_ready;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* impulse response ready */
+		uint8_t is_ready;
+	} rsp;
  };

  union FW_CONTEXT {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* value to write (for set context)*/
-      struct as10x_register_value reg_val;
-      /* context tag */
-      uint16_t tag;
-      /* context request type */
-      uint16_t type;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* value read (for get context) */
-      struct as10x_register_value reg_val;
-      /* context request type */
-      uint16_t type;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* value to write (for set context)*/
+		struct as10x_register_value reg_val;
+		/* context tag */
+		uint16_t tag;
+		/* context request type */
+		uint16_t type;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* value read (for get context) */
+		struct as10x_register_value reg_val;
+		/* context request type */
+		uint16_t type;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  union SET_REGISTER {
-   /* request */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-      /* register content */
-      struct as10x_register_value reg_val;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  union GET_REGISTER {
-   /* request */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* register content */
-      struct as10x_register_value reg_val;
-   } rsp;
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} rsp;
  };

  union CFG_CHANGE_MODE {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* mode */
-      uint8_t mode;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* mode */
+		uint8_t mode;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
  };

  struct as10x_cmd_header_t {
-   uint16_t req_id;
-   uint16_t prog;
-   uint16_t version;
-   uint16_t data_len;
+	uint16_t req_id;
+	uint16_t prog;
+	uint16_t version;
+	uint16_t data_len;
  };

  #define DUMP_BLOCK_SIZE 16
  union DUMP_MEMORY {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* dump memory type request */
-      uint8_t dump_req;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-      /* nb blocks to read */
-      uint16_t num_blocks;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* dump response */
-      uint8_t dump_rsp;
-      /* data */
-      union {
-	 uint8_t  data8[DUMP_BLOCK_SIZE];
-	 uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
-	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
-      } u;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* nb blocks to read */
+		uint16_t num_blocks;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* data */
+		union {
+			uint8_t data8[DUMP_BLOCK_SIZE];
+			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
+			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
+		} u;
+	} rsp;
  };

  union DUMPLOG_MEMORY {
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* dump memory type request */
-      uint8_t dump_req;
-   } req;
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* dump response */
-      uint8_t dump_rsp;
-      /* dump data */
-      uint8_t data[DUMP_BLOCK_SIZE];
-   } rsp;
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+	} req;
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* dump data */
+		uint8_t data[DUMP_BLOCK_SIZE];
+	} rsp;
  };

  union RAW_DATA {
-   /* request */
-   struct {
-      uint16_t proc_id;
-      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) -2 /* proc_id */];
-   } req;
-   /* response */
-   struct {
-      uint16_t proc_id;
-      uint8_t error;
-      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
-		      - 2 /* proc_id */ - 1 /* rc */];
-   } rsp;
+	/* request */
+	struct {
+		uint16_t proc_id;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t) -2 /* proc_id */];
+	} req;
+	/* response */
+	struct {
+		uint16_t proc_id;
+		uint8_t error;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t) - 2 - 1]; /* 64 - header - proc_id - rc */
+	} rsp;
  };

  struct as10x_cmd_t {
-   /* header */
-   struct as10x_cmd_header_t header;
-   /* body */
-   union {
-      union TURN_ON           turn_on;
-      union TURN_OFF          turn_off;
-      union SET_TUNE          set_tune;
-      union GET_TUNE_STATUS   get_tune_status;
-      union GET_TPS           get_tps;
-      union COMMON            common;
-      union ADD_PID_FILTER    add_pid_filter;
-      union DEL_PID_FILTER    del_pid_filter;
-      union START_STREAMING   start_streaming;
-      union STOP_STREAMING    stop_streaming;
-      union GET_DEMOD_STATS   get_demod_stats;
-      union GET_IMPULSE_RESP  get_impulse_rsp;
-      union FW_CONTEXT        context;
-      union SET_REGISTER      set_register;
-      union GET_REGISTER      get_register;
-      union CFG_CHANGE_MODE   cfg_change_mode;
-      union DUMP_MEMORY       dump_memory;
-      union DUMPLOG_MEMORY    dumplog_memory;
-      union RAW_DATA          raw_data;
-   } body;
+	/* header */
+	struct as10x_cmd_header_t header;
+	/* body */
+	union {
+		union TURN_ON			turn_on;
+		union TURN_OFF			turn_off;
+		union SET_TUNE			set_tune;
+		union GET_TUNE_STATUS	get_tune_status;
+		union GET_TPS			get_tps;
+		union COMMON			common;
+		union ADD_PID_FILTER	add_pid_filter;
+		union DEL_PID_FILTER	del_pid_filter;
+		union START_STREAMING	start_streaming;
+		union STOP_STREAMING	stop_streaming;
+		union GET_DEMOD_STATS	get_demod_stats;
+		union GET_IMPULSE_RESP	get_impulse_rsp;
+		union FW_CONTEXT		context;
+		union SET_REGISTER		set_register;
+		union GET_REGISTER		get_register;
+		union CFG_CHANGE_MODE	cfg_change_mode;
+		union DUMP_MEMORY		dump_memory;
+		union DUMPLOG_MEMORY	dumplog_memory;
+		union RAW_DATA			raw_data;
+	} body;
  };

  struct as10x_token_cmd_t {
-   /* token cmd */
-   struct as10x_cmd_t c;
-   /* token response */
-   struct as10x_cmd_t r;
+	/* token cmd */
+	struct as10x_cmd_t c;
+	/* token response */
+	struct as10x_cmd_t r;
  };
  #pragma pack()


-/**************************/
-/* FUNCTION DECLARATION   */
-/**************************/
+/************************/
+/* FUNCTION DECLARATION	*/
+/************************/

  void as10x_cmd_build(struct as10x_cmd_t *pcmd, uint16_t proc_id,
-		      uint16_t cmd_len);
+		uint16_t cmd_len);
  int as10x_rsp_parse(struct as10x_cmd_t *r, uint16_t proc_id);

  #ifdef __cplusplus
@@ -500,36 +499,36 @@
  int as10x_cmd_turn_off(as10x_handle_t *phandle);

  int as10x_cmd_set_tune(as10x_handle_t *phandle,
-		       struct as10x_tune_args *ptune);
+		struct as10x_tune_args *ptune);

  int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
-			      struct as10x_tune_status *pstatus);
+		struct as10x_tune_status *pstatus);

  int as10x_cmd_get_tps(as10x_handle_t *phandle,
-		      struct as10x_tps *ptps);
+		struct as10x_tps *ptps);

-int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
-			      struct as10x_demod_stats *pdemod_stats);
+int as10x_cmd_get_demod_stats(as10x_handle_t *phandle,
+		struct as10x_demod_stats *pdemod_stats);

  int as10x_cmd_get_impulse_resp(as10x_handle_t *phandle,
-			       uint8_t *is_ready);
+		uint8_t *is_ready);

  /* as10x cmd stream */
  int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
-			     struct as10x_ts_filter *filter);
+		struct as10x_ts_filter *filter);
  int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
-			     uint16_t pid_value);
+		uint16_t pid_value);

  int as10x_cmd_start_streaming(as10x_handle_t *phandle);
  int as10x_cmd_stop_streaming(as10x_handle_t *phandle);

  /* as10x cmd cfg */
  int as10x_cmd_set_context(as10x_handle_t *phandle,
-			  uint16_t tag,
-			  uint32_t value);
+		uint16_t tag,
+		uint32_t value);
  int as10x_cmd_get_context(as10x_handle_t *phandle,
-			  uint16_t tag,
-			  uint32_t *pvalue);
+		uint16_t tag,
+		uint32_t *pvalue);

  int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode);
  int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd_stream.c linux.as102.04-tabs/drivers/staging/as102/as10x_cmd_stream.c
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd_stream.c	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_cmd_stream.c	2011-10-14 23:24:32.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -20,23 +20,23 @@
  #include<linux/kernel.h>
  #include "as102_drv.h"
  #elif defined(WIN32)
-    #if defined(DDK) /* win32 ddk implementation */
-	#include "wdm.h"
-	#include "Device.h"
-	#include "endian_mgmt.h" /* FIXME */
-    #else /* win32 sdk implementation */
-	#include<windows.h>
-	#include "types.h"
-	#include "util.h"
-	#include "as10x_handle.h"
-	#include "endian_mgmt.h"
-    #endif
+#if defined(DDK) /* win32 ddk implementation */
+#include "wdm.h"
+#include "Device.h"
+#include "endian_mgmt.h" /* FIXME */
+#else /* win32 sdk implementation */
+#include<windows.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h"
+#endif
  #else /* all other cases */
-    #include<string.h>
-    #include "types.h"
-    #include "util.h"
-    #include "as10x_handle.h"
-    #include "endian_mgmt.h" /* FIXME */
+#include<string.h>
+#include "types.h"
+#include "util.h"
+#include "as10x_handle.h"
+#include "endian_mgmt.h" /* FIXME */
  #endif /* __KERNEL__ */

  #include "as10x_cmd.h"
@@ -49,9 +49,9 @@
     \param  pfilter_handle: pointer where to store filter handle
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
-			     struct as10x_ts_filter *filter)
+		struct as10x_ts_filter *filter)
  {
  	int error;
  	struct as10x_cmd_t *pcmd, *prsp;
@@ -67,7 +67,7 @@

  	/* fill command */
  	pcmd->body.add_pid_filter.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_SETFILTER);
+			cpu_to_le16(CONTROL_PROC_SETFILTER);
  	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
  	pcmd->body.add_pid_filter.req.stream_type = filter->type;

@@ -98,7 +98,7 @@
  		filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
  	}

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -109,9 +109,9 @@
     \param  filter_handle: filter handle
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
-			     uint16_t pid_value)
+		uint16_t pid_value)
  {
  	int error;
  	struct as10x_cmd_t *pcmd, *prsp;
@@ -127,7 +127,7 @@

  	/* fill command */
  	pcmd->body.del_pid_filter.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
+			cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
  	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);

  	/* send command */
@@ -147,7 +147,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -157,7 +157,7 @@
     \param  phandle:   pointer to AS10x handle
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_start_streaming(as10x_handle_t *phandle)
  {
  	int error;
@@ -174,7 +174,7 @@

  	/* fill command */
  	pcmd->body.start_streaming.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_START_STREAMING);
+			cpu_to_le16(CONTROL_PROC_START_STREAMING);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
@@ -193,7 +193,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
@@ -203,7 +203,7 @@
     \param  phandle:   pointer to AS10x handle
     \return 0 when no error,<  0 in case of error.
     \callgraph
-*/
+ */
  int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
  {
  	int8_t error;
@@ -220,7 +220,7 @@

  	/* fill command */
  	pcmd->body.stop_streaming.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
+			cpu_to_le16(CONTROL_PROC_STOP_STREAMING);

  	/* send command */
  	if (phandle->ops->xfer_cmd) {
@@ -239,7 +239,7 @@
  	/* parse response */
  	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);

-out:
+	out:
  	LEAVE();
  	return error;
  }
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_handle.h linux.as102.04-tabs/drivers/staging/as102/as10x_handle.h
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_handle.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_handle.h	2011-10-14 22:47:14.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -24,13 +24,13 @@
  #include "as10x_cmd.h"

  /* values for "mode" field */
-#define REGMODE8         8
-#define REGMODE16        16
-#define REGMODE32        32
+#define REGMODE8		8
+#define REGMODE16		16
+#define REGMODE32		32

  struct as102_priv_ops_t {
  	int (*upload_fw_pkt) (struct as102_bus_adapter_t *bus_adap,
-			      unsigned char *buf, int buflen, int swap32);
+			unsigned char *buf, int buflen, int swap32);

  	int (*send_cmd) (struct as102_bus_adapter_t *bus_adap,
  			 unsigned char *buf, int buflen);
@@ -40,7 +40,7 @@
  			 unsigned char *recv_buf, int recv_buf_len);
  /*
  	int (*pid_filter) (struct as102_bus_adapter_t *bus_adap,
-			   int index, u16 pid, int onoff);
+			int index, u16 pid, int onoff);
  */
  	int (*start_stream) (struct as102_dev_t *dev);
  	void (*stop_stream) (struct as102_dev_t *dev);
@@ -48,11 +48,11 @@
  	int (*reset_target) (struct as102_bus_adapter_t *bus_adap);

  	int (*read_write)(struct as102_bus_adapter_t *bus_adap, uint8_t mode,
-			  uint32_t rd_addr, uint16_t rd_len,
-			  uint32_t wr_addr, uint16_t wr_len);
+			uint32_t rd_addr, uint16_t rd_len,
+			uint32_t wr_addr, uint16_t wr_len);

  	int (*as102_read_ep2) (struct as102_bus_adapter_t *bus_adap,
-			       unsigned char *recv_buf,
-			       int recv_buf_len);
+			unsigned char *recv_buf,
+			int recv_buf_len);
  };
  #endif
diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as10x_types.h linux.as102.04-tabs/drivers/staging/as102/as10x_types.h
--- linux.as102.03-typedefs/drivers/staging/as102/as10x_types.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.04-tabs/drivers/staging/as102/as10x_types.h	2011-10-14 23:33:20.000000000 +0200
@@ -9,7 +9,7 @@
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
@@ -22,176 +22,176 @@
  #include "as10x_handle.h"

  /*********************************/
-/*       MACRO DEFINITIONS       */
+/*		MACRO DEFINITIONS		 */
  /*********************************/

  /* bandwidth constant values */
-#define BW_5_MHZ           0x00
-#define BW_6_MHZ           0x01
-#define BW_7_MHZ           0x02
-#define BW_8_MHZ           0x03
+#define BW_5_MHZ			0x00
+#define BW_6_MHZ			0x01
+#define BW_7_MHZ			0x02
+#define BW_8_MHZ			0x03

  /* hierarchy priority selection values */
-#define HIER_NO_PRIORITY   0x00
-#define HIER_LOW_PRIORITY  0x01
-#define HIER_HIGH_PRIORITY 0x02
+#define HIER_NO_PRIORITY	0x00
+#define HIER_LOW_PRIORITY	0x01
+#define HIER_HIGH_PRIORITY	0x02

  /* constellation available values */
-#define CONST_QPSK         0x00
-#define CONST_QAM16        0x01
-#define CONST_QAM64        0x02
-#define CONST_UNKNOWN      0xFF
+#define CONST_QPSK			0x00
+#define CONST_QAM16			0x01
+#define CONST_QAM64			0x02
+#define CONST_UNKNOWN		0xFF

  /* hierarchy available values */
-#define HIER_NONE         0x00
-#define HIER_ALPHA_1      0x01
-#define HIER_ALPHA_2      0x02
-#define HIER_ALPHA_4      0x03
-#define HIER_UNKNOWN      0xFF
+#define HIER_NONE			0x00
+#define HIER_ALPHA_1		0x01
+#define HIER_ALPHA_2		0x02
+#define HIER_ALPHA_4		0x03
+#define HIER_UNKNOWN		0xFF

  /* interleaving available values */
-#define INTLV_NATIVE      0x00
-#define INTLV_IN_DEPTH    0x01
-#define INTLV_UNKNOWN     0xFF
+#define INTLV_NATIVE		0x00
+#define INTLV_IN_DEPTH		0x01
+#define INTLV_UNKNOWN		0xFF

  /* code rate available values */
-#define CODE_RATE_1_2     0x00
-#define CODE_RATE_2_3     0x01
-#define CODE_RATE_3_4     0x02
-#define CODE_RATE_5_6     0x03
-#define CODE_RATE_7_8     0x04
-#define CODE_RATE_UNKNOWN 0xFF
+#define CODE_RATE_1_2		0x00
+#define CODE_RATE_2_3		0x01
+#define CODE_RATE_3_4		0x02
+#define CODE_RATE_5_6		0x03
+#define CODE_RATE_7_8		0x04
+#define CODE_RATE_UNKNOWN	0xFF

  /* guard interval available values */
-#define GUARD_INT_1_32    0x00
-#define GUARD_INT_1_16    0x01
-#define GUARD_INT_1_8     0x02
-#define GUARD_INT_1_4     0x03
-#define GUARD_UNKNOWN     0xFF
+#define GUARD_INT_1_32		0x00
+#define GUARD_INT_1_16		0x01
+#define GUARD_INT_1_8		0x02
+#define GUARD_INT_1_4		0x03
+#define GUARD_UNKNOWN		0xFF

  /* transmission mode available values */
-#define TRANS_MODE_2K      0x00
-#define TRANS_MODE_8K      0x01
-#define TRANS_MODE_4K      0x02
-#define TRANS_MODE_UNKNOWN 0xFF
+#define TRANS_MODE_2K		0x00
+#define TRANS_MODE_8K		0x01
+#define TRANS_MODE_4K		0x02
+#define TRANS_MODE_UNKNOWN	0xFF

  /* DVBH signalling available values */
-#define TIMESLICING_PRESENT   0x01
-#define MPE_FEC_PRESENT       0x02
+#define TIMESLICING_PRESENT	0x01
+#define MPE_FEC_PRESENT		0x02

  /* tune state available */
-#define TUNE_STATUS_NOT_TUNED       0x00
-#define TUNE_STATUS_IDLE            0x01
-#define TUNE_STATUS_LOCKING         0x02
-#define TUNE_STATUS_SIGNAL_DVB_OK   0x03
-#define TUNE_STATUS_STREAM_DETECTED 0x04
-#define TUNE_STATUS_STREAM_TUNED    0x05
-#define TUNE_STATUS_ERROR           0xFF
+#define TUNE_STATUS_NOT_TUNED		0x00
+#define TUNE_STATUS_IDLE			0x01
+#define TUNE_STATUS_LOCKING			0x02
+#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
+#define TUNE_STATUS_STREAM_DETECTED	0x04
+#define TUNE_STATUS_STREAM_TUNED	0x05
+#define TUNE_STATUS_ERROR			0xFF

  /* available TS FID filter types */
-#define TS_PID_TYPE_TS       0
-#define TS_PID_TYPE_PSI_SI   1
-#define TS_PID_TYPE_MPE      2
+#define TS_PID_TYPE_TS		0
+#define TS_PID_TYPE_PSI_SI	1
+#define TS_PID_TYPE_MPE		2

  /* number of echos available */
-#define MAX_ECHOS   15
+#define MAX_ECHOS	15

  /* Context types */
-#define CONTEXT_LNA                   1010
-#define CONTEXT_ELNA_HYSTERESIS       4003
-#define CONTEXT_ELNA_GAIN             4004
-#define CONTEXT_MER_THRESHOLD         5005
-#define CONTEXT_MER_OFFSET            5006
-#define CONTEXT_IR_STATE              7000
-#define CONTEXT_TSOUT_MSB_FIRST       7004
-#define CONTEXT_TSOUT_FALLING_EDGE    7005
+#define CONTEXT_LNA					1010
+#define CONTEXT_ELNA_HYSTERESIS		4003
+#define CONTEXT_ELNA_GAIN			4004
+#define CONTEXT_MER_THRESHOLD		5005
+#define CONTEXT_MER_OFFSET			5006
+#define CONTEXT_IR_STATE			7000
+#define CONTEXT_TSOUT_MSB_FIRST		7004
+#define CONTEXT_TSOUT_FALLING_EDGE	7005

  /* Configuration modes */
-#define CFG_MODE_ON     0
-#define CFG_MODE_OFF    1
-#define CFG_MODE_AUTO   2
+#define CFG_MODE_ON		0
+#define CFG_MODE_OFF	1
+#define CFG_MODE_AUTO	2

  #pragma pack(1)
  struct as10x_tps {
-   uint8_t constellation;
-   uint8_t hierarchy;
-   uint8_t interleaving_mode;
-   uint8_t code_rate_HP;
-   uint8_t code_rate_LP;
-   uint8_t guard_interval;
-   uint8_t transmission_mode;
-   uint8_t DVBH_mask_HP;
-   uint8_t DVBH_mask_LP;
-   uint16_t cell_ID;
+	uint8_t constellation;
+	uint8_t hierarchy;
+	uint8_t interleaving_mode;
+	uint8_t code_rate_HP;
+	uint8_t code_rate_LP;
+	uint8_t guard_interval;
+	uint8_t transmission_mode;
+	uint8_t DVBH_mask_HP;
+	uint8_t DVBH_mask_LP;
+	uint16_t cell_ID;
  };

  struct as10x_tune_args {
-   /* frequency */
-   uint32_t freq;
-   /* bandwidth */
-   uint8_t bandwidth;
-   /* hierarchy selection */
-   uint8_t hier_select;
-   /* constellation */
-   uint8_t constellation;
-   /* hierarchy */
-   uint8_t hierarchy;
-   /* interleaving mode */
-   uint8_t interleaving_mode;
-   /* code rate */
-   uint8_t code_rate;
-   /* guard interval */
-   uint8_t guard_interval;
-   /* transmission mode */
-   uint8_t transmission_mode;
+	/* frequency */
+	uint32_t freq;
+	/* bandwidth */
+	uint8_t bandwidth;
+	/* hierarchy selection */
+	uint8_t hier_select;
+	/* constellation */
+	uint8_t constellation;
+	/* hierarchy */
+	uint8_t hierarchy;
+	/* interleaving mode */
+	uint8_t interleaving_mode;
+	/* code rate */
+	uint8_t code_rate;
+	/* guard interval */
+	uint8_t guard_interval;
+	/* transmission mode */
+	uint8_t transmission_mode;
  };

  struct as10x_tune_status {
-   /* tune status */
-   uint8_t tune_state;
-   /* signal strength */
-   int16_t signal_strength;
-   /* packet error rate 10^-4 */
-   uint16_t PER;
-   /* bit error rate 10^-4 */
-   uint16_t BER;
+	/* tune status */
+	uint8_t tune_state;
+	/* signal strength */
+	int16_t signal_strength;
+	/* packet error rate 10^-4 */
+	uint16_t PER;
+	/* bit error rate 10^-4 */
+	uint16_t BER;
  };

  struct as10x_demod_stats {
-   /* frame counter */
-   uint32_t frame_count;
-   /* Bad frame counter */
-   uint32_t bad_frame_count;
-   /* Number of wrong bytes fixed by Reed-Solomon */
-   uint32_t bytes_fixed_by_rs;
-   /* Averaged MER */
-   uint16_t mer;
-   /* statistics calculation state indicator (started or not) */
-   uint8_t has_started;
+	/* frame counter */
+	uint32_t frame_count;
+	/* Bad frame counter */
+	uint32_t bad_frame_count;
+	/* Number of wrong bytes fixed by Reed-Solomon */
+	uint32_t bytes_fixed_by_rs;
+	/* Averaged MER */
+	uint16_t mer;
+	/* statistics calculation state indicator (started or not) */
+	uint8_t has_started;
  };

  struct as10x_ts_filter {
-   uint16_t pid;  /** valid PID value 0x00 : 0x2000 */
-   uint8_t  type; /** Red TS_PID_TYPE_<N>  values */
-   uint8_t  idx;  /** index in filtering table */
+	uint16_t	pid;	/** valid PID value 0x00 : 0x2000 */
+	uint8_t		type;	/** Red TS_PID_TYPE_<N>  values */
+	uint8_t		idx;	/** index in filtering table */
  };

  struct as10x_register_value {
-   uint8_t       mode;
-   union {
-      uint8_t    value8;    /* 8 bit value */
-      uint16_t   value16;   /* 16 bit value */
-      uint32_t   value32;   /* 32 bit value */
-   }u;
+	uint8_t mode;
+	union {
+		uint8_t		value8;		/* 8 bit value */
+		uint16_t	value16;	/* 16 bit value */
+		uint32_t	value32;	/* 32 bit value */
+	}u;
  };

  #pragma pack()

  struct as10x_register_addr {
-   /* register addr */
-   uint32_t addr;
-   /* register mode access */
-   uint8_t mode;
+	/* register addr */
+	uint32_t addr;
+	/* register mode access */
+	uint8_t mode;
  };





