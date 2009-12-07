Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935582AbZLGVAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 16:00:39 -0500
Message-ID: <4B1D6CFA.2020602@infradead.org>
Date: Mon, 07 Dec 2009 19:00:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>	 <4B02FDA4.5030508@infradead.org>	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>	 <200911201237.31537.julian@jusst.de>	 <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>	 <4B07290B.4060307@jusst.de>	 <a3ef07920912041202u78f4d12av8d7a49f5f91b3d56@mail.gmail.com> <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com>
In-Reply-To: <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky wrote:
> On Fri, Dec 4, 2009 at 3:02 PM, VDR User <user.vdr@gmail.com> wrote:
>> No activity in this thread for 2 weeks now.  Has there been any progress?

> I have stated that I like Manu's proposal, but I would prefer that the
> get_property (s2api) interface were used, because it totally provides
> an interface that is sufficient for this feature.

I've ported Manu's proposal to S2API way of handling it. It is just compiled
only. I haven't test it yet on a real driver.

Comments?

---

Add support for frontend statistics via S2API

The current DVB V3 API to handle statistics has two issues:
	- Retrieving several values can't be done atomically;
	- There's no indication about scale information.

This patch solves those two issues by adding a group of S2API
that handles the needed statistics operations. It basically ports the
proposal of Manu Abraham <abraham.manu@gmail.com> To S2API.

As the original patch, both of the above issues were addressed.

In order to demonstrate the changes on an existing driver for the new API, I've
implemented it at the cx24123 driver.

There are some advantages of using this approach over using the static structs
of the original proposal:
	- userspace can select an arbitrary number of parameters on his get request;
	- the latency to retrieve just one parameter is lower than retrieving
several parameters. On the cx24123 example, if user wants just signal strength,
the latency is the same as reading one register via i2c bus. If using the original
proposal, the latency would be 6 times worse, since you would need to get 3 properties
at the same time;
	- the latency for reading all 3 parameters at the same time is equal to
the latency of the original proposal;
	- if newer statistics parameters will be needed in the future, it is just
a matter of adding additional S2API command/value pairs;
	- the DVB V3 calls can be easily implemented as a call to the new get_stats ops,
without adding extra latency time.

Thanks to Manu Abraham <abraham.manu@gmail.com> for his initial proposal.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -975,6 +975,16 @@ static struct dtv_cmds_h dtv_cmds[] = {
 	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
 	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
 	_DTV_CMD(DTV_HIERARCHY, 0, 0),
+
+	/* Statistics API */
+	_DTV_CMD(DTV_FE_QUALITY, 0, 0),
+	_DTV_CMD(DTV_FE_QUALITY_UNIT, 0, 0),
+	_DTV_CMD(DTV_FE_STRENGTH, 0, 0),
+	_DTV_CMD(DTV_FE_STRENGTH_UNIT, 0, 0),
+	_DTV_CMD(DTV_FE_ERROR, 0, 0),
+	_DTV_CMD(DTV_FE_ERROR_UNIT, 0, 0),
+	_DTV_CMD(DTV_FE_SIGNAL, 0, 0),
+	_DTV_CMD(DTV_FE_SIGNAL_UNIT, 0, 0),
 };
 
 static void dtv_property_dump(struct dtv_property *tvp)
@@ -1203,16 +1213,59 @@ static int dvb_frontend_ioctl_legacy(str
 static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 			unsigned int cmd, void *parg);
 
+static int dtv_property_prepare_get_stats(struct dvb_frontend *fe,
+				    struct dtv_property *tvp,
+				    struct inode *inode, struct file *file)
+{
+	switch (tvp->cmd) {
+	case DTV_FE_QUALITY:
+		fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY;
+		break;
+	case DTV_FE_QUALITY_UNIT:
+		fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY_UNIT;
+		break;
+	case DTV_FE_STRENGTH:
+		fe->dtv_property_cache.need_stats |= FE_NEED_STRENGTH;
+		break;
+	case DTV_FE_STRENGTH_UNIT:
+		fe->dtv_property_cache.need_stats |= FE_NEED_STRENGTH_UNIT;
+		break;
+	case DTV_FE_ERROR:
+		fe->dtv_property_cache.need_stats |= FE_NEED_ERROR;
+		break;
+	case DTV_FE_ERROR_UNIT:
+		fe->dtv_property_cache.need_stats |= FE_NEED_ERROR_UNIT;
+		break;
+	case DTV_FE_SIGNAL:
+		fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL;
+		break;
+	case DTV_FE_SIGNAL_UNIT:
+		fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL_UNIT;
+		break;
+	case DTV_FE_UNC:
+		fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL;
+		break;
+	case DTV_FE_UNC_UNIT:
+		fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL_UNIT;
+		break;
+	default:
+		return 1;
+	};
+
+	return 0;
+}
+
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
-				    struct inode *inode, struct file *file)
+				    struct inode *inode, struct file *file,
+				    int need_get_ops)
 {
 	int r = 0;
 
 	dtv_property_dump(tvp);
 
 	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.get_property)
+	if (fe->ops.get_property && need_get_ops)
 		r = fe->ops.get_property(fe, tvp);
 
 	if (r < 0)
@@ -1329,6 +1382,38 @@ static int dtv_property_process_get(stru
 	case DTV_ISDBS_TS_ID:
 		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
 		break;
+
+	/* Quality measures */
+	case DTV_FE_QUALITY:
+		tvp->u.data = fe->dtv_property_cache.quality;
+		break;
+	case DTV_FE_QUALITY_UNIT:
+		tvp->u.data = fe->dtv_property_cache.quality_unit;
+		break;
+	case DTV_FE_STRENGTH:
+		tvp->u.data = fe->dtv_property_cache.strength;
+		break;
+	case DTV_FE_STRENGTH_UNIT:
+		tvp->u.data = fe->dtv_property_cache.strength_unit;
+		break;
+	case DTV_FE_ERROR:
+		tvp->u.data = fe->dtv_property_cache.error;
+		break;
+	case DTV_FE_ERROR_UNIT:
+		tvp->u.data = fe->dtv_property_cache.error_unit;
+		break;
+	case DTV_FE_SIGNAL:
+		tvp->u.data = fe->dtv_property_cache.signal;
+		break;
+	case DTV_FE_SIGNAL_UNIT:
+		tvp->u.data = fe->dtv_property_cache.signal_unit;
+		break;
+	case DTV_FE_UNC:
+		tvp->u.data = fe->dtv_property_cache.signal;
+		break;
+	case DTV_FE_UNC_UNIT:
+		tvp->u.data = fe->dtv_property_cache.signal_unit;
+		break;
 	default:
 		r = -1;
 	}
@@ -1527,7 +1612,7 @@ static int dvb_frontend_ioctl_properties
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	int err = 0;
+	int err = 0, need_get_ops;
 
 	struct dtv_properties *tvps = NULL;
 	struct dtv_property *tvp = NULL;
@@ -1591,8 +1676,29 @@ static int dvb_frontend_ioctl_properties
 			goto out;
 		}
 
+		/*
+		* Do all get operations at once, instead of handling them
+		* individually
+		*/
+		need_get_ops = 0;
+		fe->dtv_property_cache.need_stats = 0;
+		for (i = 0; i < tvps->num; i++)
+			need_get_ops += dtv_property_prepare_get_stats(fe,
+							 tvp + i, inode, file);
+
+		if (!fe->dtv_property_cache.need_stats) {
+			need_get_ops++;
+		} else {
+			if (fe->ops.get_stats) {
+				err = fe->ops.get_stats(fe);
+				if (err < 0)
+					return err;
+			}
+		}
+
 		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, inode, file);
+			(tvp + i)->result = dtv_property_process_get(fe,
+					tvp + i, inode, file, need_get_ops);
 			err |= (tvp + i)->result;
 		}
 
diff --git a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -304,6 +304,7 @@ struct dvb_frontend_ops {
 
 	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
+	int (*get_stats)(struct dvb_frontend* fe);
 };
 
 #define MAX_EVENT 8
@@ -358,6 +359,32 @@ struct dtv_frontend_properties {
 
 	/* ISDB-T specifics */
 	u32			isdbs_ts_id;
+
+	/* Statistics group */
+
+#define FE_NEED_QUALITY		(1 << 0)
+#define FE_NEED_QUALITY_UNIT	(1 << 1)
+#define FE_NEED_STRENGTH	(1 << 2)
+#define FE_NEED_STRENGTH_UNIT	(1 << 3)
+#define FE_NEED_ERROR		(1 << 4)
+#define FE_NEED_ERROR_UNIT	(1 << 5)
+#define FE_NEED_UNC		(1 << 6)
+#define FE_NEED_UNC_UNIT	(1 << 7)
+#define FE_NEED_SIGNAL		(1 << 6)
+#define FE_NEED_SIGNAL_UNIT	(1 << 7)
+	int			need_stats;
+
+	u32			quality;
+	u32			strength;
+	u32			error;
+	u32			unc;
+	u32			signal;
+
+	enum fecap_quality_params	quality_unit;
+	enum fecap_scale_params		strength_unit;
+	enum fecap_error_params		error_unit;
+	enum fecap_unc_params		unc_unit;
+	enum fecap_scale_params		signal_unit;
 };
 
 struct dvb_frontend {
diff --git a/linux/drivers/media/dvb/frontends/cx24123.c b/linux/drivers/media/dvb/frontends/cx24123.c
--- a/linux/drivers/media/dvb/frontends/cx24123.c
+++ b/linux/drivers/media/dvb/frontends/cx24123.c
@@ -890,6 +890,66 @@ static int cx24123_read_status(struct dv
 	return 0;
 }
 
+static int cx24123_get_stats(struct dvb_frontend* fe)
+{
+	struct cx24123_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *prop = &fe->dtv_property_cache;
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH) {
+		/* larger = better */
+		prop->strength = cx24123_readreg(state, 0x3b) << 8;
+			dprintk("Signal strength = %d\n", prop->strength);
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH;
+	}
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH_UNIT) {
+		/* larger = better */
+		prop->strength_unit = FE_SCALE_UNKNOWN;
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH_UNIT;
+	}
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR) {
+		/* The true bit error rate is this value divided by
+		the window size (set as 256 * 255) */
+		prop->error = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
+			       (cx24123_readreg(state, 0x1d) << 8 |
+			       cx24123_readreg(state, 0x1e));
+
+		dprintk("BER = %d\n", prop->error);
+
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR;
+	}
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR_UNIT) {
+		/* larger = better */
+		prop->strength_unit = FE_ERROR_BER;
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR_UNIT;
+	}
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY) {
+		/* Inverted raw Es/N0 count, totally bogus but better than the
+		   BER threshold. */
+		prop->quality = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
+					  (u16)cx24123_readreg(state, 0x19));
+
+		dprintk("read S/N index = %d\n", prop->quality);
+
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY;
+	}
+
+	if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY_UNIT) {
+		/* larger = better */
+		prop->strength_unit = FE_QUALITY_EsNo;
+		fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY_UNIT;
+	}
+
+	/* Check if userspace requested a parameter that we can't handle*/
+	if (fe->dtv_property_cache.need_stats)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Configured to return the measurement of errors in blocks,
  * because no UCBLOCKS value is available, so this value doubles up
@@ -897,43 +957,30 @@ static int cx24123_read_status(struct dv
  */
 static int cx24123_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct cx24123_state *state = fe->demodulator_priv;
+	fe->dtv_property_cache.need_stats = FE_NEED_ERROR;
+	cx24123_get_stats(fe);
 
-	/* The true bit error rate is this value divided by
-	   the window size (set as 256 * 255) */
-	*ber = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
-		(cx24123_readreg(state, 0x1d) << 8 |
-		 cx24123_readreg(state, 0x1e));
-
-	dprintk("BER = %d\n", *ber);
-
+	*ber = fe->dtv_property_cache.error;
 	return 0;
 }
 
 static int cx24123_read_signal_strength(struct dvb_frontend *fe,
 	u16 *signal_strength)
 {
-	struct cx24123_state *state = fe->demodulator_priv;
-
-	/* larger = better */
-	*signal_strength = cx24123_readreg(state, 0x3b) << 8;
-
-	dprintk("Signal strength = %d\n", *signal_strength);
-
+	fe->dtv_property_cache.need_stats = FE_NEED_STRENGTH;
+	cx24123_get_stats(fe);
+	*signal_strength = fe->dtv_property_cache.strength;
 	return 0;
 }
 
+
 static int cx24123_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct cx24123_state *state = fe->demodulator_priv;
-
 	/* Inverted raw Es/N0 count, totally bogus but better than the
-	   BER threshold. */
-	*snr = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
-			 (u16)cx24123_readreg(state, 0x19));
-
-	dprintk("read S/N index = %d\n", *snr);
-
+		BER threshold. */
+	fe->dtv_property_cache.need_stats = FE_NEED_QUALITY;
+	cx24123_get_stats(fe);
+	*snr = fe->dtv_property_cache.quality;
 	return 0;
 }
 
@@ -1174,6 +1221,7 @@ static struct dvb_frontend_ops cx24123_o
 	.set_voltage = cx24123_set_voltage,
 	.tune = cx24123_tune,
 	.get_frontend_algo = cx24123_get_algo,
+	.get_stats = cx24123_get_stats,
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Conexant " \
diff --git a/linux/include/linux/dvb/frontend.h b/linux/include/linux/dvb/frontend.h
--- a/linux/include/linux/dvb/frontend.h
+++ b/linux/include/linux/dvb/frontend.h
@@ -304,7 +304,19 @@ struct dvb_frontend_event {
 
 #define DTV_ISDBS_TS_ID		42
 
-#define DTV_MAX_COMMAND				DTV_ISDBS_TS_ID
+/* Quality parameters */
+#define DTV_FE_QUALITY		43
+#define DTV_FE_QUALITY_UNIT	44
+#define DTV_FE_STRENGTH		45
+#define DTV_FE_STRENGTH_UNIT	46
+#define DTV_FE_ERROR		47
+#define DTV_FE_ERROR_UNIT	48
+#define DTV_FE_SIGNAL		49
+#define DTV_FE_SIGNAL_UNIT	50
+#define DTV_FE_UNC		51
+#define DTV_FE_UNC_UNIT		52
+
+#define DTV_MAX_COMMAND				DTV_FE_UNC_UNIT
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -338,6 +350,46 @@ typedef enum fe_delivery_system {
 	SYS_DAB,
 } fe_delivery_system_t;
 
+/* Frontend General Statistics
+ * General parameters
+ * FE_*_UNKNOWN:
+ *	Parameter is unknown to the frontend and doesn't really
+ *	make any sense for an application.
+ *
+ * FE_*_RELATIVE:
+ *	Parameter is relative on the basis of a ceil - floor basis
+ *	Format is based on empirical test to determine
+ *	the floor and ceiling values. This format is exactly the
+ *	same format as the existing statistics implementation.
+ */
+
+enum fecap_quality_params {
+	FE_QUALITY_UNKNOWN		= 0,
+	FE_QUALITY_SNR			= (1 <<  0),
+	FE_QUALITY_CNR			= (1 <<  1),
+	FE_QUALITY_EsNo			= (1 <<  2),
+	FE_QUALITY_EbNo			= (1 <<  3),
+	FE_QUALITY_RELATIVE		= (1 << 31),
+};
+
+enum fecap_scale_params {
+	FE_SCALE_UNKNOWN		= 0,
+	FE_SCALE_dB			= (1 <<  0),
+	FE_SCALE_RELATIVE		= (1 << 31),
+};
+
+enum fecap_error_params {
+	FE_ERROR_UNKNOWN		= 0,
+	FE_ERROR_BER			= (1 <<  0),
+	FE_ERROR_PER			= (1 <<  1),
+	FE_ERROR_RELATIVE		= (1 << 31),
+};
+
+enum fecap_unc_params {
+	FE_UNC_UNKNOWN			= 0,
+	FE_UNC_RELATIVE			= (1 << 31),
+};
+
 struct dtv_cmds_h {
 	char	*name;		/* A display name for debugging purposes */
 
