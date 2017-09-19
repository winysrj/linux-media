Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35703
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750972AbdISNmr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:42:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 2/6] media: dvb_frontend: cleanup ioctl handling logic
Date: Tue, 19 Sep 2017 10:42:34 -0300
Message-Id: <616ac8323cfe1041ad05e9610c87ee9c5e247811.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there are two handlers for ioctls:
 - dvb_frontend_ioctl_properties()
 - dvb_frontend_ioctl_legacy()

Despite their names, both handles non-legacy DVB ioctls.

Besides that, there's no reason why to not handle all ioctls
on a single handler function.

So, merge them into a single function (dvb_frontend_handle_ioctl)
and reorganize the ioctl's to indicate what's the current DVB
API and what's deprecated.

Despite the big diff, the handling logic for each ioctl is the
same as before.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 402 +++++++++++++++++-----------------
 1 file changed, 195 insertions(+), 207 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 725cb1c8a088..cbe697a094d2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1315,10 +1315,8 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg);
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg);
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg);
 
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    const struct dtv_frontend_properties *c,
@@ -1816,12 +1814,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
 		c->sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
@@ -1928,14 +1926,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int err;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (down_interruptible(&fepriv->sem))
@@ -1953,121 +1950,13 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
-		err = dvb_frontend_ioctl_properties(file, cmd, parg);
-	else {
-		c->state = DTV_UNDEFINED;
-		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
-	}
+	c->state = DTV_UNDEFINED;
+	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
 	return err;
 }
 
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err, i;
-
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
-
-	switch(cmd) {
-	case FE_SET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
-		kfree(tvp);
-		break;
-	}
-	case FE_GET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-		struct dtv_frontend_properties getp = fe->dtv_property_cache;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		/*
-		 * Let's use our own copy of property cache, in order to
-		 * avoid mangling with DTV zigzag logic, as drivers might
-		 * return crap, if they don't check if the data is available
-		 * before updating the properties cache.
-		 */
-		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-		}
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (copy_to_user((void __user *)tvps->props, tvp,
-				 tvps->num * sizeof(struct dtv_property))) {
-			kfree(tvp);
-			return -EFAULT;
-		}
-		kfree(tvp);
-		break;
-	}
-	default:
-		return -ENOTSUPP;
-	} /* switch */
-	return 0;
-}
-
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2205,59 +2094,102 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 }
 
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = -EOPNOTSUPP;
+	int i, err;
 
-	switch (cmd) {
-	case FE_GET_INFO: {
-		struct dvb_frontend_info* info = parg;
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
-		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
+		}
+
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
+
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
 
 		/*
-		 * Associate the 4 delivery systems supported by DVBv3
-		 * API with their DVBv5 counterpart. For the other standards,
-		 * use the closest type, assuming that it would hopefully
-		 * work with a DVBv3 application.
-		 * It should be noticed that, on multi-frontend devices with
-		 * different types (terrestrial and cable, for example),
-		 * a pure DVBv3 application won't be able to use all delivery
-		 * systems. Yet, changing the DVBv5 cache to the other delivery
-		 * system should be enough for making it work.
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
 		 */
-		switch (dvbv3_type(c->delivery_system)) {
-		case DVBV3_QPSK:
-			info->type = FE_QPSK;
-			break;
-		case DVBV3_ATSC:
-			info->type = FE_ATSC;
-			break;
-		case DVBV3_QAM:
-			info->type = FE_QAM;
-			break;
-		case DVBV3_OFDM:
-			info->type = FE_OFDM;
-			break;
-		default:
-			dev_err(fe->dvb->device,
-					"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
-					__func__, c->delivery_system);
-			fe->ops.info.type = FE_OFDM;
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, &getp, NULL);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_get(fe, &getp, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
 		}
-		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
-				 __func__, c->delivery_system, fe->ops.info.type);
 
-		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
-		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
-			info->caps |= FE_CAN_INVERSION_AUTO;
-		err = 0;
+		if (copy_to_user((void __user *)tvps->props, tvp,
+				 tvps->num * sizeof(struct dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
 		break;
 	}
 
@@ -2278,42 +2210,6 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 	}
 
-	case FE_READ_BER:
-		if (fe->ops.read_ber) {
-			if (fepriv->thread)
-				err = fe->ops.read_ber(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SIGNAL_STRENGTH:
-		if (fe->ops.read_signal_strength) {
-			if (fepriv->thread)
-				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SNR:
-		if (fe->ops.read_snr) {
-			if (fepriv->thread)
-				err = fe->ops.read_snr(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_UNCORRECTED_BLOCKS:
-		if (fe->ops.read_ucblocks) {
-			if (fepriv->thread)
-				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
 	case FE_DISEQC_RESET_OVERLOAD:
 		if (fe->ops.diseqc_reset_overload) {
 			err = fe->ops.diseqc_reset_overload(fe);
@@ -2365,6 +2261,23 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
+	case FE_DISEQC_RECV_SLAVE_REPLY:
+		if (fe->ops.diseqc_recv_slave_reply)
+			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+		break;
+
+	case FE_ENABLE_HIGH_LNB_VOLTAGE:
+		if (fe->ops.enable_high_lnb_voltage)
+			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+		break;
+
+	case FE_SET_FRONTEND_TUNE_MODE:
+		fepriv->tune_mode_flags = (unsigned long) parg;
+		err = 0;
+		break;
+
+	/* DEPRECATED dish control ioctls */
+
 	case FE_DISHNETWORK_SEND_LEGACY_CMD:
 		if (fe->ops.dishnetwork_send_legacy_command) {
 			err = fe->ops.dishnetwork_send_legacy_command(fe,
@@ -2430,15 +2343,91 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
-	case FE_DISEQC_RECV_SLAVE_REPLY:
-		if (fe->ops.diseqc_recv_slave_reply)
-			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+	/* DEPRECATED statistics ioctls */
+
+	case FE_READ_BER:
+		if (fe->ops.read_ber) {
+			if (fepriv->thread)
+				err = fe->ops.read_ber(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_SIGNAL_STRENGTH:
+		if (fe->ops.read_signal_strength) {
+			if (fepriv->thread)
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
-	case FE_ENABLE_HIGH_LNB_VOLTAGE:
-		if (fe->ops.enable_high_lnb_voltage)
-			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+	case FE_READ_SNR:
+		if (fe->ops.read_snr) {
+			if (fepriv->thread)
+				err = fe->ops.read_snr(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_UNCORRECTED_BLOCKS:
+		if (fe->ops.read_ucblocks) {
+			if (fepriv->thread)
+				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	/* DEPRECATED DVBv3 ioctls */
+
+	case FE_GET_INFO: {
+		struct dvb_frontend_info* info = parg;
+
+		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
+		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
+
+		/*
+		 * Associate the 4 delivery systems supported by DVBv3
+		 * API with their DVBv5 counterpart. For the other standards,
+		 * use the closest type, assuming that it would hopefully
+		 * work with a DVBv3 application.
+		 * It should be noticed that, on multi-frontend devices with
+		 * different types (terrestrial and cable, for example),
+		 * a pure DVBv3 application won't be able to use all delivery
+		 * systems. Yet, changing the DVBv5 cache to the other delivery
+		 * system should be enough for making it work.
+		 */
+		switch (dvbv3_type(c->delivery_system)) {
+		case DVBV3_QPSK:
+			info->type = FE_QPSK;
+			break;
+		case DVBV3_ATSC:
+			info->type = FE_ATSC;
+			break;
+		case DVBV3_QAM:
+			info->type = FE_QAM;
+			break;
+		case DVBV3_OFDM:
+			info->type = FE_OFDM;
+			break;
+		default:
+			dev_err(fe->dvb->device,
+					"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+					__func__, c->delivery_system);
+			fe->ops.info.type = FE_OFDM;
+		}
+		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
+				 __func__, c->delivery_system, fe->ops.info.type);
+
+		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
+		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
+			info->caps |= FE_CAN_INVERSION_AUTO;
+		err = 0;
 		break;
+	}
 
 	case FE_SET_FRONTEND:
 		err = dvbv3_set_delivery_system(fe);
@@ -2466,11 +2455,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		err = dtv_get_frontend(fe, &getp, parg);
 		break;
 	}
-	case FE_SET_FRONTEND_TUNE_MODE:
-		fepriv->tune_mode_flags = (unsigned long) parg;
-		err = 0;
-		break;
-	}
+
+	default:
+		return -ENOTSUPP;
+	} /* switch */
 
 	return err;
 }
-- 
2.13.5
