Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58064 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3KZOPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 09:15:32 -0500
Received: by mail-ie0-f173.google.com with SMTP id to1so9411134ieb.32
        for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 06:15:31 -0800 (PST)
From: Mauro Dreissig <mukadr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
	Mauro Dreissig <mukadr@gmail.com>
Subject: [PATCH 2/2] staging: as102: Remove ENTER/LEAVE debugging macros
Date: Tue, 26 Nov 2013 09:15:21 -0500
Message-Id: <1385475321-4245-3-git-send-email-mukadr@gmail.com>
In-Reply-To: <1385475321-4245-1-git-send-email-mukadr@gmail.com>
References: <1385475321-4245-1-git-send-email-mukadr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Too much noise, also does not cover every possible code paths.

Signed-off-by: Mauro Dreissig <mukadr@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/as102/as102_drv.c        | 10 ----------
 drivers/staging/media/as102/as102_drv.h        |  8 --------
 drivers/staging/media/as102/as102_fe.c         | 26 --------------------------
 drivers/staging/media/as102/as102_fw.c         |  6 ------
 drivers/staging/media/as102/as102_usb_drv.c    | 25 -------------------------
 drivers/staging/media/as102/as10x_cmd.c        | 21 ---------------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    |  9 ---------
 drivers/staging/media/as102/as10x_cmd_stream.c | 12 ------------
 8 files changed, 117 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index ac92eaf..62218db 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -112,8 +112,6 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 	struct as10x_bus_adapter_t *bus_adap = &dev->bus_adap;
 	int ret = -EFAULT;
 
-	ENTER();
-
 	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
 		dprintk(debug, "mutex_lock_interruptible(lock) failed !\n");
 		return -EBUSY;
@@ -141,8 +139,6 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 	}
 
 	mutex_unlock(&dev->bus_adap.lock);
-
-	LEAVE();
 	return ret;
 }
 
@@ -152,8 +148,6 @@ static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct as102_dev_t *as102_dev = demux->priv;
 
-	ENTER();
-
 	if (mutex_lock_interruptible(&as102_dev->sem))
 		return -ERESTARTSYS;
 
@@ -165,7 +159,6 @@ static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 		ret = as102_start_stream(as102_dev);
 
 	mutex_unlock(&as102_dev->sem);
-	LEAVE();
 	return ret;
 }
 
@@ -174,8 +167,6 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct as102_dev_t *as102_dev = demux->priv;
 
-	ENTER();
-
 	if (mutex_lock_interruptible(&as102_dev->sem))
 		return -ERESTARTSYS;
 
@@ -187,7 +178,6 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 				 dvbdmxfeed->pid, 0);
 
 	mutex_unlock(&as102_dev->sem);
-	LEAVE();
 	return 0;
 }
 
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index b0e5a23..a06837d 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -38,14 +38,6 @@ extern int elna_enable;
 		printk(args);	\
 	} } while (0)
 
-#ifdef TRACE
-#define ENTER()	pr_debug(">> enter %s\n", __func__)
-#define LEAVE()	pr_debug("<< leave %s\n", __func__)
-#else
-#define ENTER()
-#define LEAVE()
-#endif
-
 #define AS102_DEVICE_MAJOR	192
 
 #define AS102_USB_BUF_SIZE	512
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 9ce8c9d..72b2c48 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -34,8 +34,6 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 	struct as102_dev_t *dev;
 	struct as10x_tune_args tune_args = { 0 };
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
@@ -52,7 +50,6 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 
 	mutex_unlock(&dev->bus_adap.lock);
 
-	LEAVE();
 	return (ret < 0) ? -EINVAL : 0;
 }
 
@@ -63,8 +60,6 @@ static int as102_fe_get_frontend(struct dvb_frontend *fe)
 	struct as102_dev_t *dev;
 	struct as10x_tps tps = { 0 };
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -EINVAL;
@@ -80,13 +75,11 @@ static int as102_fe_get_frontend(struct dvb_frontend *fe)
 
 	mutex_unlock(&dev->bus_adap.lock);
 
-	LEAVE();
 	return (ret < 0) ? -EINVAL : 0;
 }
 
 static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
 			struct dvb_frontend_tune_settings *settings) {
-	ENTER();
 
 #if 0
 	dprintk(debug, "step_size    = %d\n", settings->step_size);
@@ -97,7 +90,6 @@ static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
 
 	settings->min_delay_ms = 1000;
 
-	LEAVE();
 	return 0;
 }
 
@@ -108,8 +100,6 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct as102_dev_t *dev;
 	struct as10x_tune_status tstate = { 0 };
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
@@ -168,7 +158,6 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 out:
 	mutex_unlock(&dev->bus_adap.lock);
-	LEAVE();
 	return ret;
 }
 
@@ -183,15 +172,12 @@ static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct as102_dev_t *dev;
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
 
 	*snr = dev->demod_stats.mer;
 
-	LEAVE();
 	return 0;
 }
 
@@ -199,15 +185,12 @@ static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct as102_dev_t *dev;
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
 
 	*ber = dev->ber;
 
-	LEAVE();
 	return 0;
 }
 
@@ -216,15 +199,12 @@ static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
 {
 	struct as102_dev_t *dev;
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
 
 	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
 
-	LEAVE();
 	return 0;
 }
 
@@ -232,8 +212,6 @@ static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct as102_dev_t *dev;
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
@@ -243,7 +221,6 @@ static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	else
 		*ucblocks = 0;
 
-	LEAVE();
 	return 0;
 }
 
@@ -252,8 +229,6 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 	struct as102_dev_t *dev;
 	int ret;
 
-	ENTER();
-
 	dev = (struct as102_dev_t *) fe->tuner_priv;
 	if (dev == NULL)
 		return -ENODEV;
@@ -272,7 +247,6 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 
 	mutex_unlock(&dev->bus_adap.lock);
 
-	LEAVE();
 	return ret;
 }
 
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index 9e7c6d7..f33f752 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -109,8 +109,6 @@ static int as102_firmware_upload(struct as10x_bus_adapter_t *bus_adap,
 	int total_read_bytes = 0, errno = 0;
 	unsigned char addr_has_changed = 0;
 
-	ENTER();
-
 	for (total_read_bytes = 0; total_read_bytes < firmware->size; ) {
 		int read_bytes = 0, data_len = 0;
 
@@ -158,7 +156,6 @@ static int as102_firmware_upload(struct as10x_bus_adapter_t *bus_adap,
 		}
 	}
 error:
-	LEAVE();
 	return (errno == 0) ? total_read_bytes : errno;
 }
 
@@ -170,8 +167,6 @@ int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 	const char *fw1, *fw2;
 	struct usb_device *dev = bus_adap->usb_dev;
 
-	ENTER();
-
 	/* select fw file to upload */
 	if (dual_tuner) {
 		fw1 = as102_dt_fw1;
@@ -233,6 +228,5 @@ error:
 	kfree(cmd_buf);
 	release_firmware(firmware);
 
-	LEAVE();
 	return errno;
 }
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 0eaced3..8759553 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -92,7 +92,6 @@ static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
 			      unsigned char *recv_buf, int recv_buf_len)
 {
 	int ret = 0;
-	ENTER();
 
 	if (send_buf != NULL) {
 		ret = usb_control_msg(bus_adap->usb_dev,
@@ -140,7 +139,6 @@ static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
 #endif
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -240,8 +238,6 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
 {
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < MAX_STREAM_URB; i++)
 		usb_free_urb(dev->stream_urb[i]);
 
@@ -249,15 +245,12 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
 			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 			dev->stream,
 			dev->dma_addr);
-	LEAVE();
 }
 
 static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 {
 	int i, ret = 0;
 
-	ENTER();
-
 	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
 				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 				       GFP_KERNEL,
@@ -287,7 +280,6 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 		dev->stream_urb[i] = urb;
 	}
-	LEAVE();
 	return ret;
 }
 
@@ -318,23 +310,17 @@ static void as102_usb_release(struct kref *kref)
 {
 	struct as102_dev_t *as102_dev;
 
-	ENTER();
-
 	as102_dev = container_of(kref, struct as102_dev_t, kref);
 	if (as102_dev != NULL) {
 		usb_put_dev(as102_dev->bus_adap.usb_dev);
 		kfree(as102_dev);
 	}
-
-	LEAVE();
 }
 
 static void as102_usb_disconnect(struct usb_interface *intf)
 {
 	struct as102_dev_t *as102_dev;
 
-	ENTER();
-
 	/* extract as102_dev_t from usb_device private data */
 	as102_dev = usb_get_intfdata(intf);
 
@@ -353,8 +339,6 @@ static void as102_usb_disconnect(struct usb_interface *intf)
 	kref_put(&as102_dev->kref, as102_usb_release);
 
 	pr_info("%s: device has been disconnected\n", DRIVER_NAME);
-
-	LEAVE();
 }
 
 static int as102_usb_probe(struct usb_interface *intf,
@@ -364,8 +348,6 @@ static int as102_usb_probe(struct usb_interface *intf,
 	struct as102_dev_t *as102_dev;
 	int i;
 
-	ENTER();
-
 	/* This should never actually happen */
 	if (ARRAY_SIZE(as102_usb_id_table) !=
 	    (sizeof(as102_device_names) / sizeof(const char *))) {
@@ -424,7 +406,6 @@ static int as102_usb_probe(struct usb_interface *intf,
 	/* register dvb layer */
 	ret = as102_dvb_register(as102_dev);
 
-	LEAVE();
 	return ret;
 
 failed:
@@ -439,8 +420,6 @@ static int as102_open(struct inode *inode, struct file *file)
 	struct usb_interface *intf = NULL;
 	struct as102_dev_t *dev = NULL;
 
-	ENTER();
-
 	/* read minor from inode */
 	minor = iminor(inode);
 
@@ -467,7 +446,6 @@ static int as102_open(struct inode *inode, struct file *file)
 	kref_get(&dev->kref);
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -476,15 +454,12 @@ static int as102_release(struct inode *inode, struct file *file)
 	int ret = 0;
 	struct as102_dev_t *dev = NULL;
 
-	ENTER();
-
 	dev = file->private_data;
 	if (dev != NULL) {
 		/* decrement the count on our device */
 		kref_put(&dev->kref, as102_usb_release);
 	}
 
-	LEAVE();
 	return ret;
 }
 
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index a73df10..9e49f15 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -34,8 +34,6 @@ int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -63,7 +61,6 @@ int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -78,8 +75,6 @@ int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -106,7 +101,6 @@ int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -123,8 +117,6 @@ int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *preq, *prsp;
 
-	ENTER();
-
 	preq = adap->cmd;
 	prsp = adap->rsp;
 
@@ -164,7 +156,6 @@ int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -181,8 +172,6 @@ int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t  *preq, *prsp;
 
-	ENTER();
-
 	preq = adap->cmd;
 	prsp = adap->rsp;
 
@@ -220,7 +209,6 @@ int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -236,8 +224,6 @@ int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -281,7 +267,6 @@ int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -298,8 +283,6 @@ int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -343,7 +326,6 @@ int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 		prsp->body.get_demod_stats.rsp.stats.has_started;
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -361,8 +343,6 @@ int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -397,7 +377,6 @@ int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
 
 out:
-	LEAVE();
 	return error;
 }
 
diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index 4a2bbd7..b1e300d 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -40,8 +40,6 @@ int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 	int  error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -81,7 +79,6 @@ int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 	}
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -99,8 +96,6 @@ int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -136,7 +131,6 @@ int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -156,8 +150,6 @@ int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -188,7 +180,6 @@ int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index 6d000f6..1088ca1 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -34,8 +34,6 @@ int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -77,7 +75,6 @@ int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
 	}
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -94,8 +91,6 @@ int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -126,7 +121,6 @@ int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -141,8 +135,6 @@ int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap)
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -172,7 +164,6 @@ int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap)
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
 
@@ -187,8 +178,6 @@ int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap)
 	int8_t error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
-	ENTER();
-
 	pcmd = adap->cmd;
 	prsp = adap->rsp;
 
@@ -218,6 +207,5 @@ int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap)
 	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
 
 out:
-	LEAVE();
 	return error;
 }
-- 
1.8.5.rc3

