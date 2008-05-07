Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1Jtohg-0006uF-7D
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 20:49:27 +0200
Message-ID: <4821F9A9.6030304@ncircle.nullnet.fi>
Date: Wed, 07 May 2008 21:49:13 +0300
From: Tomi Orava <tomimo@ncircle.nullnet.fi>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
References: <43276.192.168.9.10.1192357983.squirrel@ncircle.nullnet.fi>
	<20071018181040.GA6960@dose.home.local>
	<20071018182940.GA7317@dose.home.local>
	<20071018201418.GA16574@dose.home.local>
	<47075.192.168.9.10.1193248379.squirrel@ncircle.nullnet.fi>
	<472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr>
In-Reply-To: <481F66B0.4090302@free.fr>
Content-Type: multipart/mixed; boundary="------------030409000502030207030802"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of Terratec
 Cinergy T2 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030409000502030207030802
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Hi,

>>> Well, I see some issues after taking a closer look at your driver:
>>> 1- checkpatch.pl raises errors: 90 errors, 53 warnings, 995 lines checked
>>> 2- there is a compilation error (I applied the patch on the latest
>>> v4l-dvb tree):
>>> cinergyT2-core.c: In function 'cinergyt2_usb_probe':
>>> cinergyT2-core.c:138: error: too few arguments to function
>>> 'dvb_usb_device_init'
>>> 3- you should replace the existing driver, not proposing a different
>>> driver. I mean, patch directly
>>> linux/drivers/media/dvb/cinergyT2/cinergyT2.c.

I did some cleanups pointed by the checkpach.pl script.
However, I did not replace the original Cinergy T2 driver
as I think that this new driver should be located in the
very same directory as the rest of the usb-dvb drivers.

The current patch is against the v4l-dvb tree.

Regards,
Tomi Orava

--------------030409000502030207030802
Content-Type: text/x-patch;
 name="CinergyT2-V7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="CinergyT2-V7.patch"

diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Tue May 06 11:09:01 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Wed May 07 22:34:53 2008 +0300
@@ -241,3 +241,11 @@ config DVB_USB_AF9005_REMOTE
 	  Say Y here to support the default remote control decoding for the
 	  Afatech AF9005 based receiver.
 
+config 	DVB_USB_CINERGY_T2
+	tristate "Alternative driver for Terratec CinergyT2/qanu USB2 DVB-T receiver"
+	depends on DVB_USB
+	help
+	  Support for "TerraTec CinergyT2" USB2.0 Highspeed DVB Receivers
+
+	  Say Y if you own such a device and want to use it.
+
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/Makefile
--- a/linux/drivers/media/dvb/dvb-usb/Makefile	Tue May 06 11:09:01 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/Makefile	Wed May 07 22:34:53 2008 +0300
@@ -61,6 +61,10 @@ dvb-usb-af9005-remote-objs = af9005-remo
 dvb-usb-af9005-remote-objs = af9005-remote.o
 obj-$(CONFIG_DVB_USB_AF9005_REMOTE) += dvb-usb-af9005-remote.o
 
+dvb-usb-cinergyT2-objs = cinergyT2-core.o cinergyT2-fe.o cinergyT2-remote.o
+obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
+
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 # due to tuner-xc3028
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c	Wed May 07 22:34:53 2008 +0300
@@ -0,0 +1,235 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *		    Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "cinergyT2.h"
+
+
+/* debug */
+int dvb_usb_cinergyt2_debug;
+int disable_remote;
+
+module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
+		"(or-able)).");
+
+module_param_named(disable_remote, disable_remote, int, 0644);
+MODULE_PARM_DESC(disable_remote, "Disable remote controller support (int)");
+
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+
+/* We are missing a release hook with usb_device data */
+struct dvb_usb_device *cinergyt2_usb_device;
+
+static struct dvb_usb_device_properties cinergyt2_properties;
+
+
+/* slightly modified version of dvb_usb_generic_rw -function */
+
+int cinergyt2_cmd(struct dvb_usb_device *d, char *wbuf, int wlen,
+			char *rbuf, int rlen, int delay_ms)
+{
+	int actlen, ret = -ENOMEM;
+
+	if (d->props.generic_bulk_ctrl_endpoint == 0) {
+		err("endpoint for generic control not specified.");
+		return -EINVAL;
+	}
+
+	if (wbuf == NULL || wlen == 0)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&d->usb_mutex);
+	if (ret)
+		return ret;
+
+	deb_xfer(">>> ");
+	debug_dump(wbuf, wlen, deb_xfer);
+
+	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
+				d->props.generic_bulk_ctrl_endpoint),
+				wbuf, wlen, &actlen, 2000);
+
+	if (ret)
+		deb_rc("bulk message failed: %d (%d/%d)", ret, wlen, actlen);
+	else
+		ret = actlen != wlen ? -1 : 0;
+
+	/* an answer is expected, and no error before */
+	if (!ret && rbuf && rlen) {
+		if (delay_ms)
+			msleep(delay_ms);
+
+		ret = usb_bulk_msg(d->udev, usb_rcvbulkpipe(d->udev,
+					d->props.generic_bulk_ctrl_endpoint),
+					rbuf, rlen, &actlen, 2000);
+		if (ret)
+			deb_rc("recv bulk message failed: %d", ret);
+		else {
+			deb_xfer("<<< ");
+			debug_dump(rbuf, actlen, deb_xfer);
+			ret = actlen;
+		}
+	}
+	mutex_unlock(&d->usb_mutex);
+	return ret;
+}
+
+static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int enable)
+{
+	char buf [] = { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0 };
+	char result[64];
+	return cinergyt2_cmd(adap->dev, buf, sizeof(buf), result,
+				sizeof(result), 0);
+}
+
+static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
+{
+	char buf[] = { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
+	char state[3];
+	return cinergyt2_cmd(d, buf, sizeof(buf), state, sizeof(state), 0);
+}
+
+static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	char query[] = { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
+	char state[3];
+	int ret;
+
+	adap->fe = cinergyt2_fe_attach(adap->dev);
+
+	ret = cinergyt2_cmd(adap->dev, query, sizeof(query), state,
+				sizeof(state), 0);
+	if (ret < 0) {
+		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
+			"state info\n");
+	}
+
+	/* Copy this pointer as we are gonna need it in the release phase */
+	cinergyt2_usb_device = adap->dev;
+
+	ret = cinergyt2_remote_init(adap->dev);
+	if (ret)
+		err("could not initialize remote control.");
+
+	return 0;
+}
+
+static int cinergyt2_usb_probe(struct usb_interface *intf,
+				const struct usb_device_id *id)
+{
+	return dvb_usb_device_init(intf, &cinergyt2_properties,
+					THIS_MODULE, NULL, adapter_nr);
+}
+
+
+static struct usb_device_id cinergyt2_usb_table [] = {
+	{ USB_DEVICE(USB_VID_TERRATEC, 0x0038) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(usb, cinergyt2_usb_table);
+
+static struct dvb_usb_device_properties cinergyt2_properties = {
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.streaming_ctrl   = cinergyt2_streaming_ctrl,
+			.frontend_attach  = cinergyt2_frontend_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 5,
+				.endpoint = 0x02,
+				.u = {
+					.bulk = {
+						.buffersize = 512,
+					}
+				}
+			},
+		}
+	},
+
+	.power_ctrl       = cinergyt2_power_ctrl,
+
+	.rc_interval      = 50,
+	.rc_key_map       = 0,
+	.rc_key_map_size  = 0,
+	.rc_query         = 0,
+
+	.generic_bulk_ctrl_endpoint = 1,
+
+	.num_device_descs = 1,
+	.devices = {
+		{ .name = "TerraTec/qanu USB2.0 Highspeed DVB-T Receiver",
+		  .cold_ids = {NULL},
+		  .warm_ids = { &cinergyt2_usb_table[0], NULL },
+		},
+		{ NULL },
+	}
+};
+
+
+static struct usb_driver cinergyt2_driver = {
+#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2, 6, 15)
+	.owner	= THIS_MODULE,
+#endif
+	.name		= "cinergyT2",
+	.probe		= cinergyt2_usb_probe,
+	.disconnect	= dvb_usb_device_exit,
+	.id_table	= cinergyt2_usb_table
+};
+
+static int __init cinergyt2_usb_init(void)
+{
+	int err;
+
+	err = usb_register(&cinergyt2_driver);
+	if (err) {
+		err("usb_register() failed! (err %i)\n", err);
+		return err;
+	}
+	return 0;
+}
+
+static void __exit cinergyt2_usb_exit(void)
+{
+	cinergyt2_remote_exit(cinergyt2_usb_device);
+	usb_deregister(&cinergyt2_driver);
+}
+
+module_init(cinergyt2_usb_init);
+module_exit(cinergyt2_usb_exit);
+
+MODULE_DESCRIPTION("Terratec Cinergy T2 DVB-T driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomi Orava");
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	Wed May 07 22:34:53 2008 +0300
@@ -0,0 +1,351 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *                  Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "cinergyT2.h"
+
+
+/**
+ *  convert linux-dvb frontend parameter set into TPS.
+ *  See ETSI ETS-300744, section 4.6.2, table 9 for details.
+ *
+ *  This function is probably reusable and may better get placed in a support
+ *  library.
+ *
+ *  We replace errornous fields by default TPS fields (the ones with value 0).
+ */
+
+static uint16_t compute_tps(struct dvb_frontend_parameters *p)
+{
+	struct dvb_ofdm_parameters *op = &p->u.ofdm;
+	uint16_t tps = 0;
+
+	switch (op->code_rate_HP) {
+	case FEC_2_3:
+		tps |= (1 << 7);
+		break;
+	case FEC_3_4:
+		tps |= (2 << 7);
+		break;
+	case FEC_5_6:
+		tps |= (3 << 7);
+		break;
+	case FEC_7_8:
+		tps |= (4 << 7);
+		break;
+	case FEC_1_2:
+	case FEC_AUTO:
+	default:
+		/* tps |= (0 << 7) */;
+	}
+
+	switch (op->code_rate_LP) {
+	case FEC_2_3:
+		tps |= (1 << 4);
+		break;
+	case FEC_3_4:
+		tps |= (2 << 4);
+		break;
+	case FEC_5_6:
+		tps |= (3 << 4);
+		break;
+	case FEC_7_8:
+		tps |= (4 << 4);
+		break;
+	case FEC_1_2:
+	case FEC_AUTO:
+	default:
+		/* tps |= (0 << 4) */;
+	}
+
+	switch (op->constellation) {
+	case QAM_16:
+		tps |= (1 << 13);
+		break;
+	case QAM_64:
+		tps |= (2 << 13);
+		break;
+	case QPSK:
+	default:
+		/* tps |= (0 << 13) */;
+	}
+
+	switch (op->transmission_mode) {
+	case TRANSMISSION_MODE_8K:
+		tps |= (1 << 0);
+		break;
+	case TRANSMISSION_MODE_2K:
+	default:
+		/* tps |= (0 << 0) */;
+	}
+
+	switch (op->guard_interval) {
+	case GUARD_INTERVAL_1_16:
+		tps |= (1 << 2);
+		break;
+	case GUARD_INTERVAL_1_8:
+		tps |= (2 << 2);
+		break;
+	case GUARD_INTERVAL_1_4:
+		tps |= (3 << 2);
+		break;
+	case GUARD_INTERVAL_1_32:
+	default:
+		/* tps |= (0 << 2) */;
+	}
+
+	switch (op->hierarchy_information) {
+	case HIERARCHY_1:
+		tps |= (1 << 10);
+		break;
+	case HIERARCHY_2:
+		tps |= (2 << 10);
+		break;
+	case HIERARCHY_4:
+		tps |= (3 << 10);
+		break;
+	case HIERARCHY_NONE:
+	default:
+		/* tps |= (0 << 10) */;
+	}
+
+	return tps;
+}
+
+struct cinergyt2_fe_state {
+	struct dvb_frontend fe;
+	struct dvb_usb_device *d;
+};
+
+static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
+					fe_status_t *status)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_get_status_msg result;
+	u8 cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret = cinergyt2_cmd(state->d, cmd, sizeof(cmd), (u8 *)&result,
+			sizeof(result), 0);
+	if (ret < 0)
+		return ret;
+
+	*status = 0;
+
+	if (0xffff - le16_to_cpu(result.gain) > 30)
+		*status |= FE_HAS_SIGNAL;
+	if (result.lock_bits & (1 << 6))
+		*status |= FE_HAS_LOCK;
+	if (result.lock_bits & (1 << 5))
+		*status |= FE_HAS_SYNC;
+	if (result.lock_bits & (1 << 4))
+		*status |= FE_HAS_CARRIER;
+	if (result.lock_bits & (1 << 1))
+		*status |= FE_HAS_VITERBI;
+
+	if ((*status & (FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC)) !=
+			(FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC))
+		*status &= ~FE_HAS_LOCK;
+
+	return 0;
+}
+
+static int cinergyt2_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret = cinergyt2_cmd(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0)
+		return ret;
+
+	*ber = le32_to_cpu(status.viterbi_error_rate);
+	return 0;
+}
+
+static int cinergyt2_fe_read_unc_blocks(struct dvb_frontend *fe, u32 *unc)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	u8 cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret = cinergyt2_cmd(state->d, cmd, sizeof(cmd), (u8 *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_unc_blocks() Failed! (Error=%d)\n",
+			ret);
+		return ret;
+	}
+	*unc = le32_to_cpu(status.uncorrected_block_count);
+	return 0;
+}
+
+static int cinergyt2_fe_read_signal_strength(struct dvb_frontend *fe,
+						u16 *strength)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret = cinergyt2_cmd(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_signal_strength() Failed!"
+			" (Error=%d)\n", ret);
+		return ret;
+	}
+	*strength = (0xffff - le16_to_cpu(status.gain));
+	return 0;
+}
+
+static int cinergyt2_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret = cinergyt2_cmd(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_snr() Failed! (Error=%d)\n", ret);
+		return ret;
+	}
+	*snr = (status.snr << 8) | status.snr;
+	return 0;
+}
+
+static int cinergyt2_fe_init(struct dvb_frontend *fe)
+{
+	return 0;
+}
+
+static int cinergyt2_fe_sleep(struct dvb_frontend *fe)
+{
+	deb_info("cinergyt2_fe_sleep() Called\n");
+	return 0;
+}
+
+static int cinergyt2_fe_get_tune_settings(struct dvb_frontend *fe,
+				struct dvb_frontend_tune_settings *tune)
+{
+	tune->min_delay_ms = 800;
+	return 0;
+}
+
+static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *fep)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	struct dvbt_set_parameters_msg param;
+	char result[2];
+	int err;
+
+	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
+	param.tps = cpu_to_le16(compute_tps(fep));
+	param.freq = cpu_to_le32(fep->frequency / 1000);
+	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+
+	err = cinergyt2_cmd(state->d,
+			(char *)&param, sizeof(param),
+			result, sizeof(result), 0);
+	if (err < 0)
+		err("cinergyt2_fe_set_frontend() Failed! err=%d\n", err);
+
+	return (err < 0) ? err : 0;
+}
+
+static int cinergyt2_fe_get_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *fep)
+{
+	return 0;
+}
+
+static void cinergyt2_fe_release(struct dvb_frontend *fe)
+{
+	struct cinergyt2_fe_state *state = fe->demodulator_priv;
+	if (state != NULL)
+		kfree(state);
+}
+
+static struct dvb_frontend_ops cinergyt2_fe_ops;
+
+struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
+{
+	struct cinergyt2_fe_state *s = kzalloc(sizeof(
+					struct cinergyt2_fe_state), GFP_KERNEL);
+	if (s == NULL)
+		return NULL;
+
+	s->d = d;
+	memcpy(&s->fe.ops, &cinergyt2_fe_ops, sizeof(struct dvb_frontend_ops));
+	s->fe.demodulator_priv = s;
+	return &s->fe;
+}
+
+
+static struct dvb_frontend_ops cinergyt2_fe_ops = {
+	.info = {
+		.name			= DRIVER_NAME,
+		.type			= FE_OFDM,
+		.frequency_min		= 174000000,
+		.frequency_max		= 862000000,
+		.frequency_stepsize	= 166667,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2
+			| FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8
+			| FE_CAN_FEC_AUTO | FE_CAN_QPSK
+			| FE_CAN_QAM_16 | FE_CAN_QAM_64
+			| FE_CAN_QAM_AUTO
+			| FE_CAN_TRANSMISSION_MODE_AUTO
+			| FE_CAN_GUARD_INTERVAL_AUTO
+			| FE_CAN_HIERARCHY_AUTO
+			| FE_CAN_RECOVER
+			| FE_CAN_MUTE_TS
+	},
+
+	.release		= cinergyt2_fe_release,
+
+	.init			= cinergyt2_fe_init,
+	.sleep			= cinergyt2_fe_sleep,
+
+	.set_frontend		= cinergyt2_fe_set_frontend,
+	.get_frontend		= cinergyt2_fe_get_frontend,
+	.get_tune_settings	= cinergyt2_fe_get_tune_settings,
+
+	.read_status		= cinergyt2_fe_read_status,
+	.read_ber		= cinergyt2_fe_read_ber,
+	.read_signal_strength	= cinergyt2_fe_read_signal_strength,
+	.read_snr		= cinergyt2_fe_read_snr,
+	.read_ucblocks		= cinergyt2_fe_read_unc_blocks,
+};
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2-remote.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-remote.c	Wed May 07 22:34:53 2008 +0300
@@ -0,0 +1,336 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *		    Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "cinergyT2.h"
+
+enum {
+	CINERGYT2_RC_EVENT_TYPE_NONE = 0x00,
+	CINERGYT2_RC_EVENT_TYPE_NEC  = 0x01,
+	CINERGYT2_RC_EVENT_TYPE_RC5  = 0x02
+};
+
+/**
+ * struct dvb_usb_rc_key - a remote control key and its input-event
+ * @custom: the vendor/custom part of the key
+ * @data: the actual key part
+ * @event: the input event assigned to key identified by custom and data
+ */
+struct cinergyt2_rc_key {
+	u32 custom;
+	u32 data;
+	u32 event;
+};
+
+
+struct cinergyt2_rc_event {
+	char custom;
+	uint32_t data;
+} __attribute__((packed));
+
+
+extern int disable_remote;
+
+struct cinergyt2_rc_key cinergyt2_rc_keys[] = {
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xfe01eb04, 	KEY_POWER },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xfd02eb04, 	KEY_1 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xfc03eb04, 	KEY_2 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xfb04eb04, 	KEY_3 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xfa05eb04, 	KEY_4 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf906eb04, 	KEY_5 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf807eb04, 	KEY_6 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf708eb04, 	KEY_7 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf609eb04, 	KEY_8 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf50aeb04, 	KEY_9 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf30ceb04, 	KEY_0 },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf40beb04, 	KEY_VIDEO },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf20deb04, 	KEY_REFRESH },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf10eeb04, 	KEY_SELECT },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xf00feb04, 	KEY_EPG },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xef10eb04, 	KEY_UP },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xeb14eb04, 	KEY_DOWN },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xee11eb04, 	KEY_LEFT },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xec13eb04, 	KEY_RIGHT },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xed12eb04, 	KEY_OK },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xea15eb04, 	KEY_TEXT },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe916eb04, 	KEY_INFO },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe817eb04, 	KEY_RED },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe718eb04, 	KEY_GREEN },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe619eb04, 	KEY_YELLOW },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe51aeb04, 	KEY_BLUE },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe31ceb04, 	KEY_VOLUMEUP },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe11eeb04, 	KEY_VOLUMEDOWN },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe21deb04, 	KEY_MUTE },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe41beb04, 	KEY_CHANNELUP },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xe01feb04, 	KEY_CHANNELDOWN },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xbf40eb04, 	KEY_PAUSE },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xb34ceb04, 	KEY_PLAY },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xa758eb04, 	KEY_RECORD },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xab54eb04, 	KEY_PREVIOUS },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xb748eb04, 	KEY_STOP },
+	{ CINERGYT2_RC_EVENT_TYPE_NEC, 	0xa35ceb04, 	KEY_NEXT }
+};
+
+int cinergyt2_rc_keys_size = ARRAY_SIZE(cinergyt2_rc_keys);
+
+
+static int cinergyt2_decode_rc_key(struct dvb_usb_device *dev, int type,
+					int data, u32 *event, int *state)
+{
+	int i, key, found;
+
+	*state = REMOTE_NO_KEY_PRESSED;
+	key = le32_to_cpu(data);
+
+	/* info("cinergyt2_decode_rc_key() type=%d, key=0x%x \
+	* 		(converted=0x%x)\n", type, data, key);
+	*/
+
+	switch (type) {
+	case CINERGYT2_RC_EVENT_TYPE_NEC:
+		if (key == ~0) {
+			/* Stop key repeat */
+			*state = REMOTE_NO_KEY_PRESSED;
+			break;
+		}
+		found = 0;
+
+		for (i = 0; i < cinergyt2_rc_keys_size; i++) {
+			if (cinergyt2_rc_keys[i].data == key) {
+				*event = cinergyt2_rc_keys[i].event;
+				*state = REMOTE_KEY_PRESSED;
+				found = 1;
+				/* deb_info("Remote key pressed! key = %d\n",
+				* 		i);
+				*/
+				break;
+			}
+		}
+		if (found == 0)
+			err("cinergyT2: Unknown remote control key detected!"
+				"key=0x%x (raw=0x%x)\n", key, data);
+		break;
+
+	case CINERGYT2_RC_EVENT_TYPE_RC5:
+	case CINERGYT2_RC_EVENT_TYPE_NONE:
+	default:
+		info("Unhandled remote key detected! type=0x%x\n", type);
+		break;
+	}
+	return 0;
+}
+
+static int cinergyt2_rc_process(struct dvb_usb_device *dev)
+{
+	char buf[1] = { CINERGYT2_EP1_GET_RC_EVENTS };
+	struct cinergyt2_rc_event rc_events[12];
+	int len, i, state;
+	u32 event;
+	/* struct cinergyt2_device_state *st = dev->priv; */
+
+	len = cinergyt2_cmd(dev, buf, sizeof(buf),
+				(char *)rc_events, sizeof(rc_events), 0);
+	if (len < 0) {
+		/* printk(KERN_INFO "Failed to read RC event data!\n"); */
+		return 0;
+	}
+
+	if (len == 0)
+		return 0;
+
+	state = REMOTE_NO_KEY_PRESSED;
+
+	for (i = 0; i < (len / sizeof(rc_events[0])); i++) {
+		/* deb_info("[%d/%d] rc_events[%d].data = %x (converted=%x),
+		* 		type=%x\n",
+		*		i, len / sizeof(rc_events[0]),
+		*		i, rc_events[i].data,
+		*		le32_to_cpu(rc_events[i].data),
+		*		rc_events[i].custom);
+		 */
+
+		cinergyt2_decode_rc_key(dev, rc_events[i].custom,
+					rc_events[i].data, &event, &state);
+		switch (state) {
+		case REMOTE_NO_KEY_PRESSED:
+			break;
+
+		case REMOTE_KEY_PRESSED:
+			/* deb_rc("key pressed\n"); */
+			dev->last_event = event;
+			input_event(dev->rc_input_dev, EV_KEY,
+					event, 1);
+			input_event(dev->rc_input_dev, EV_KEY,
+					dev->last_event, 0);
+			input_sync(dev->rc_input_dev);
+			break;
+
+		case REMOTE_KEY_REPEAT:
+			/* deb_rc("key repeated\n"); */
+			input_event(dev->rc_input_dev, EV_KEY,
+					event, 1);
+			input_event(dev->rc_input_dev, EV_KEY,
+					dev->last_event, 0);
+			input_sync(dev->rc_input_dev);
+			break;
+		default:
+			break;
+		}
+
+	}
+	return 0;
+}
+
+/*
+ * Code copied from dvb-usb-remote.c and modified for Cinergy T2
+ */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+static void cinergyt2_read_remote_control(void *data)
+#else
+static void cinergyt2_read_remote_control(struct work_struct *work)
+#endif
+{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+	struct dvb_usb_device *d = data;
+#else
+	struct dvb_usb_device *d =
+		container_of(work, struct dvb_usb_device,
+				rc_query_work.work);
+#endif
+
+	/* TODO: need a lock here.
+	* We can simply skip checking for the remote control
+	*  if we're busy.
+	*/
+
+	/* when the parameter has been set to 1 via sysfs while
+	* the driver was running
+	*/
+
+	if (disable_remote)
+		return;
+
+	if (cinergyt2_rc_process(d))
+		err("error while querying for an remote control event.");
+
+	schedule_delayed_work(&d->rc_query_work,
+				msecs_to_jiffies(d->props.rc_interval));
+}
+
+
+
+int cinergyt2_remote_init(struct dvb_usb_device *d)
+{
+	struct input_dev *input_dev;
+	int i;
+	int err;
+
+	if (disable_remote) {
+		err("Remote controller support disabled!\n");
+		return 0;
+	}
+
+	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
+	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		err("Failed to allocate new input device!\n");
+		return -ENOMEM;
+	}
+
+	input_dev->evbit[0] = BIT(EV_KEY);
+	input_dev->name = "IR-receiver inside an USB DVB receiver";
+	input_dev->phys = d->rc_phys;
+	usb_to_input_id(d->udev, &input_dev->id);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	input_dev->dev.parent = &d->udev->dev;
+#else
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 15)
+	input_dev->cdev.dev = &d->udev->dev;
+#endif
+#endif
+
+	/* set the bits for the keys */
+	deb_rc("key map size: %d\n", cinergyt2_rc_keys_size);
+	for (i = 0; i < cinergyt2_rc_keys_size; i++) {
+		deb_rc("setting bit for event %d item %d\n",
+			cinergyt2_rc_keys[i].event, i);
+		set_bit(cinergyt2_rc_keys[i].event, input_dev->keybit);
+	}
+
+	/* Start the remote-control polling. */
+	if (d->props.rc_interval < 40)
+		d->props.rc_interval = 100; /* default */
+
+	/* setting these two values to non-zero,
+	 * we have to manage key repeats */
+
+	input_dev->rep[REP_PERIOD] = d->props.rc_interval;
+	input_dev->rep[REP_DELAY]  = d->props.rc_interval + 150;
+
+	err = input_register_device(input_dev);
+	if (err) {
+		input_free_device(input_dev);
+		err("Failed to register new input device!\n");
+		return err;
+	}
+
+	d->rc_input_dev = input_dev;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+	INIT_WORK(&d->rc_query_work, cinergyt2_read_remote_control, d);
+#else
+	INIT_DELAYED_WORK(&d->rc_query_work, cinergyt2_read_remote_control);
+#endif
+
+	info("schedule remote query interval to %d msecs.",
+		d->props.rc_interval);
+
+	schedule_delayed_work(&d->rc_query_work,
+				msecs_to_jiffies(d->props.rc_interval));
+
+	d->state |= DVB_USB_STATE_REMOTE;
+
+	return 0;
+}
+EXPORT_SYMBOL(cinergyt2_remote_init);
+
+
+int cinergyt2_remote_exit(struct dvb_usb_device *d)
+{
+	if (d->state & DVB_USB_STATE_REMOTE) {
+		cancel_rearming_delayed_work(&d->rc_query_work);
+		flush_scheduled_work();
+		input_unregister_device(d->rc_input_dev);
+	}
+	d->state &= ~DVB_USB_STATE_REMOTE;
+	return 0;
+}
+EXPORT_SYMBOL(cinergyt2_remote_exit);
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2.h	Wed May 07 22:34:53 2008 +0300
@@ -0,0 +1,101 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *                  Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,  or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not,  write to the Free Software
+ * Foundation,  Inc.,  675 Mass Ave,  Cambridge,  MA 02139,  USA.
+ *
+ */
+
+#ifndef _DVB_USB_CINERGYT2_H_
+#define _DVB_USB_CINERGYT2_H_
+
+#include <linux/usb/input.h>
+
+#define DVB_USB_LOG_PREFIX "cinergyT2"
+#include "dvb-usb.h"
+
+#define DRIVER_NAME "TerraTec/qanu USB2.0 Highspeed DVB-T Receiver"
+
+extern int disable_remote;
+extern int dvb_usb_cinergyt2_debug;
+
+#define deb_info(args...)  dprintk(dvb_usb_cinergyt2_debug,  0x001, args)
+#define deb_xfer(args...)  dprintk(dvb_usb_cinergyt2_debug,  0x002, args)
+#define deb_pll(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x004, args)
+#define deb_ts(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x008, args)
+#define deb_err(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x010, args)
+#define deb_rc(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x020, args)
+#define deb_fw(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x040, args)
+#define deb_mem(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x080, args)
+#define deb_uxfer(args...) dprintk(dvb_usb_cinergyt2_debug,  0x100, args)
+
+
+
+enum cinergyt2_ep1_cmd {
+	CINERGYT2_EP1_PID_TABLE_RESET		= 0x01,
+	CINERGYT2_EP1_PID_SETUP			= 0x02,
+	CINERGYT2_EP1_CONTROL_STREAM_TRANSFER	= 0x03,
+	CINERGYT2_EP1_SET_TUNER_PARAMETERS	= 0x04,
+	CINERGYT2_EP1_GET_TUNER_STATUS		= 0x05,
+	CINERGYT2_EP1_START_SCAN		= 0x06,
+	CINERGYT2_EP1_CONTINUE_SCAN		= 0x07,
+	CINERGYT2_EP1_GET_RC_EVENTS		= 0x08,
+	CINERGYT2_EP1_SLEEP_MODE		= 0x09,
+	CINERGYT2_EP1_GET_FIRMWARE_VERSION	= 0x0A
+};
+
+
+struct dvbt_get_status_msg {
+	uint32_t freq;
+	uint8_t bandwidth;
+	uint16_t tps;
+	uint8_t flags;
+	uint16_t gain;
+	uint8_t snr;
+	uint32_t viterbi_error_rate;
+	uint32_t rs_error_rate;
+	uint32_t uncorrected_block_count;
+	uint8_t lock_bits;
+	uint8_t prev_lock_bits;
+} __attribute__((packed));
+
+
+struct dvbt_set_parameters_msg {
+	uint8_t cmd;
+	uint32_t freq;
+	uint8_t bandwidth;
+	uint16_t tps;
+	uint8_t flags;
+} __attribute__((packed));
+
+
+extern struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d);
+extern int cinergyt2_cmd(struct dvb_usb_device *d,  char *wbuf,  int wlen,
+			char *rbuf,  int rlen,  int delay_ms);
+
+extern int cinergyt2_remote_init(struct dvb_usb_device *d);
+extern int cinergyt2_remote_exit(struct dvb_usb_device *d);
+
+#endif /* _DVB_USB_CINERGYT2_H_ */
+

--------------030409000502030207030802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030409000502030207030802--
