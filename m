Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49216 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdIOFvp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 01:51:45 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20170915055143epoutp037f28ddd9f064aada10d933a99ad4291f~kcxORXegL1408414084epoutp03v
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 05:51:43 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: mchehab@kernel.org, max.kellermann@gmail.com,
        sakari.ailus@linux.intel.com, mingo@kernel.org,
        hans.verkuil@cisco.com, yamada.masahiro@socionext.com,
        shuah@kernel.org
Cc: satendra.t@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, taeyoung0432.lee@samsung.com,
        jackee.lee@samsung.com, hemanshu.s@samsung.com,
        madhur.verma@samsung.com
Subject: [PATCH v1] [DVB][FRONTEND] Added a new ioctl for optimizing
 frontend property set operation
Date: Fri, 15 Sep 2017 01:50:29 -0400
Message-Id: <1505454629-10240-1-git-send-email-satendra.t@samsung.com>
In-Reply-To: <20170914175059.722ac4f3@vento.lan>
Content-Type: text/plain; charset="utf-8"
References: <20170914175059.722ac4f3@vento.lan>
        <CGME20170915055142epcas5p457cd31640e1af9195733f30c2072eafc@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello  Mr Chehab,
Thanks for reviewing the patch.
I have modified the patch as per your comments.
Please check if it looks fine now.

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 212 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/dvb/frontend.h     |  24 ++++
 2 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e3fff8f..bc35a86 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1914,6 +1914,188 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
+/**
+ * dtv_property_short_process_set
+ * @fe: Pointer to struct dvb_frontend
+ * @file: Pointer to struct file
+ * @cmd: Property name
+ * @data: Property value
+ *
+ * helper function for dvb_frontend_ioctl_properties,
+ * which can be used to set dtv property using ioctl
+ * cmd FE_SET_PROPERTY_SHORT.
+ * It assigns property value to corresponding member of
+ * property-cache structure
+ * This func is a variant of the func dtv_property_process_set
+ * Returns:
+ * Zero on success, negative errno on failure.
+ */
+static int dtv_property_short_process_set(struct dvb_frontend *fe,
+					struct file *file,
+					u32 cmd, u32 data)
+{
+	int r = 0;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	switch (cmd) {
+	case DTV_CLEAR:
+		/*
+		 * Reset a cache of data specific to the frontend here. This
+		 * does not effect hardware.
+		 */
+		dvb_frontend_clear_cache(fe);
+		break;
+	case DTV_TUNE:
+		/* interpret the cache of data, build either a traditional
+		 * frontend tune request so we can pass validation in the
+		 * FE_SET_FRONTEND  ioctl.
+		 */
+		c->state = cmd;
+		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
+				__func__);
+
+		r = dtv_set_frontend(fe);
+		break;
+	case DTV_FREQUENCY:
+		c->frequency = data;
+		break;
+	case DTV_MODULATION:
+		c->modulation = data;
+		break;
+	case DTV_BANDWIDTH_HZ:
+		c->bandwidth_hz = data;
+		break;
+	case DTV_INVERSION:
+		c->inversion = data;
+		break;
+	case DTV_SYMBOL_RATE:
+		c->symbol_rate = data;
+		break;
+	case DTV_INNER_FEC:
+		c->fec_inner = data;
+		break;
+	case DTV_PILOT:
+		c->pilot = data;
+		break;
+	case DTV_ROLLOFF:
+		c->rolloff = data;
+		break;
+	case DTV_DELIVERY_SYSTEM:
+		r = dvbv5_set_delivery_system(fe, data);
+		break;
+	case DTV_VOLTAGE:
+		c->voltage = data;
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+			(void *)c->voltage);
+		break;
+	case DTV_TONE:
+		c->sectone = data;
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+			(void *)c->sectone);
+		break;
+	case DTV_CODE_RATE_HP:
+		c->code_rate_HP = data;
+		break;
+	case DTV_CODE_RATE_LP:
+		c->code_rate_LP = data;
+		break;
+	case DTV_GUARD_INTERVAL:
+		c->guard_interval = data;
+		break;
+	case DTV_TRANSMISSION_MODE:
+		c->transmission_mode = data;
+		break;
+	case DTV_HIERARCHY:
+		c->hierarchy = data;
+		break;
+	case DTV_INTERLEAVING:
+		c->interleaving = data;
+		break;
+
+	/* ISDB-T Support here */
+	case DTV_ISDBT_PARTIAL_RECEPTION:
+		c->isdbt_partial_reception = data;
+		break;
+	case DTV_ISDBT_SOUND_BROADCASTING:
+		c->isdbt_sb_mode = data;
+		break;
+	case DTV_ISDBT_SB_SUBCHANNEL_ID:
+		c->isdbt_sb_subchannel = data;
+		break;
+	case DTV_ISDBT_SB_SEGMENT_IDX:
+		c->isdbt_sb_segment_idx = data;
+		break;
+	case DTV_ISDBT_SB_SEGMENT_COUNT:
+		c->isdbt_sb_segment_count = data;
+		break;
+	case DTV_ISDBT_LAYER_ENABLED:
+		c->isdbt_layer_enabled = data;
+		break;
+	case DTV_ISDBT_LAYERA_FEC:
+		c->layer[0].fec = data;
+		break;
+	case DTV_ISDBT_LAYERA_MODULATION:
+		c->layer[0].modulation = data;
+		break;
+	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
+		c->layer[0].segment_count = data;
+		break;
+	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
+		c->layer[0].interleaving = data;
+		break;
+	case DTV_ISDBT_LAYERB_FEC:
+		c->layer[1].fec = data;
+		break;
+	case DTV_ISDBT_LAYERB_MODULATION:
+		c->layer[1].modulation = data;
+		break;
+	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
+		c->layer[1].segment_count = data;
+		break;
+	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
+		c->layer[1].interleaving = data;
+		break;
+	case DTV_ISDBT_LAYERC_FEC:
+		c->layer[2].fec = data;
+		break;
+	case DTV_ISDBT_LAYERC_MODULATION:
+		c->layer[2].modulation = data;
+		break;
+	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
+		c->layer[2].segment_count = data;
+		break;
+	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
+		c->layer[2].interleaving = data;
+		break;
+
+	/* Multistream support */
+	case DTV_STREAM_ID:
+	case DTV_DVBT2_PLP_ID_LEGACY:
+		c->stream_id = data;
+		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_PARADE_ID:
+		fe->dtv_property_cache.atscmh_parade_id = data;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
+		break;
+
+	case DTV_LNA:
+		c->lna = data;
+		if (fe->ops.set_lna)
+			r = fe->ops.set_lna(fe);
+		if (r < 0)
+			c->lna = LNA_AUTO;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return r;
+}
+
 static int dvb_frontend_ioctl(struct file *file,
 			unsigned int cmd, void *parg)
 {
@@ -1939,7 +2121,8 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
+	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
+		|| (cmd == FE_SET_PROPERTY_SHORT))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		c->state = DTV_UNDEFINED;
@@ -2026,7 +2209,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			err = -EFAULT;
 			goto out;
 		}
-
+	/* New ioctl for optimizing property set
+	 */
+	} else if (cmd == FE_SET_PROPERTY_SHORT) {
+		struct dtv_property_short *tvp_short = NULL;
+		struct dtv_properties_short *tvps_short = parg;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps_short->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps_short->props);
+		if ((!tvps_short->num) ||
+		(tvps_short->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+		tvp_short = memdup_user(tvps_short->props,
+		tvps_short->num * sizeof(*tvp_short));
+		if (IS_ERR(tvp_short))
+			return PTR_ERR(tvp_short);
+		for (i = 0; i < tvps_short->num; i++) {
+			err = dtv_property_short_process_set(fe, file,
+			(tvp_short + i)->cmd, (tvp_short + i)->data);
+			if (err < 0) {
+				kfree(tvp_short);
+				return err;
+			}
+		}
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
+		kfree(tvp_short);
 	} else
 		err = -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 00a20cd..aa82179 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -476,6 +476,17 @@ struct dtv_property {
 	int result;
 } __attribute__ ((packed));
 
+/**
+ * @struct dtv_property_short
+ * A shorter version of struct dtv_property
+ * @cmd: Property type
+ * @data: Property value
+ */
+struct dtv_property_short {
+	__u32 cmd;
+	__u32 data;
+};
+
 /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
 #define DTV_IOCTL_MAX_MSGS 64
 
@@ -484,6 +495,18 @@ struct dtv_properties {
 	struct dtv_property *props;
 };
 
+/**
+ * @struct dtv_properties_short
+ * A variant of struct dtv_properties
+ * to support struct dtv_property_short
+ * @num: Number of properties
+ * @props: Pointer to struct dtv_property_short
+ */
+struct dtv_properties_short {
+	__u32 num;
+	struct dtv_property_short *props;
+};
+
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
 
 /*
@@ -565,6 +588,7 @@ struct dvb_frontend_event {
 
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
 #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
+#define FE_SET_PROPERTY_SHORT	   _IOW('o', 84, struct dtv_properties_short)
 
 /**
  * When set, this flag will disable any zigzagging or other "normal" tuning
-- 
2.7.4
