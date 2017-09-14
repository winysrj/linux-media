Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26750 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdINJ7o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 05:59:44 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170914095942epoutp02c1a5ffacb06586ed0936b99df35fbf07~kMgdQWFr-2723227232epoutp02h
        for <linux-media@vger.kernel.org>; Thu, 14 Sep 2017 09:59:42 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: mchehab@kernel.org, max.kellermann@gmail.com,
        sakari.ailus@linux.intel.com, mingo@kernel.org,
        hans.verkuil@cisco.com, yamada.masahiro@socionext.com,
        shuah@kernel.org
Cc: satendra.t@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, taeyoung0432.lee@samsung.com,
        jackee.lee@samsung.com, hemanshu.s@samsung.com,
        p.awasthi@samsung.com, siddharth.s@samsung.com,
        madhur.verma@samsung.com
Subject: [RFC] [DVB][FRONTEND] Added a new ioctl for optimizing frontend
 property set operation
Date: Thu, 14 Sep 2017 05:59:27 -0400
Message-Id: <1505383167-2836-1-git-send-email-satendra.t@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20170914095941epcas5p3520a04d543890249b4952fea48747276@epcas5p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-For setting one frontend property , one FE_SET_PROPERTY ioctl is called
-Since, size of struct dtv_property is 72 bytes, this ioctl requires
---allocating 72 bytes of memory in user space
---allocating 72 bytes of memory in kernel space
---copying 72 bytes of data from user space to kernel space
-However, for all the properties, only 8 out of 72 bytes are used
 for setting the property
-Four bytes are needed for specifying property type and another 4 for
 property value
-Moreover, there are 2 properties DTV_CLEAR and DTV_TUNE which use
 only 4 bytes for property name
---They don't use property value
-Therefore, we have defined new short variant/forms/version of currently
 used structures for such 8 byte properties.
-This results in 89% (8*100/72) of memory saving in user and kernel space
 each.
-This also results in faster copy (8 bytes as compared to 72 bytes) from
 user to kernel space
-We have added new ioctl FE_SET_PROPERTY_SHORT which utilizes above
 mentioned new property structures
-This ioctl can co-exist with present ioctl FE_SET_PROPERTY
-If the apps wish to use shorter forms they can use
 proposed FE_SET_PROPERTY_SHORT, rest of them can continue to use
 current versions FE_SET_PROPERTY
-We are currently not validating incoming properties in
 function dtv_property_short_process_set because most of
 the frontend drivers in linux source are not using the
 method ops.set_property. Just two drivers are using it
 drivers/media/dvb-frontends/stv0288.c
 driver/media/usb/dvb-usb/friio-fe.c
 -Moreover, stv0288 driver implemments blank function
 for set_property.
-If needed in future, we can define a new
 ops.set_property_short method to support
 struct dtv_property_short.
Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 228 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/dvb/frontend.h     |  24 ++++
 2 files changed, 248 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e3fff8f..e183025 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1914,6 +1914,192 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
+/**
+ * dtv_property_short_process_set
+ * @fe: Pointer to struct dvb_frontend
+ * @tvp: Pointer to struct dtv_property_short
+ * @file: Pointer to struct file
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
+				    struct dtv_property_short *tvp,
+				    struct file *file)
+{
+	int r = 0;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	/* Currently, We do not allow the frontend to validate incoming
+	 * properties, currently, just 2 drivers are using
+	 * ops.set_property method , If required, we can define new
+	 * ops.set_property_short method for this purpose
+	 */
+	switch (tvp->cmd) {
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
+		c->state = tvp->cmd;
+		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
+				__func__);
+
+		r = dtv_set_frontend(fe);
+		break;
+	case DTV_FREQUENCY:
+		c->frequency = tvp->data;
+		break;
+	case DTV_MODULATION:
+		c->modulation = tvp->data;
+		break;
+	case DTV_BANDWIDTH_HZ:
+		c->bandwidth_hz = tvp->data;
+		break;
+	case DTV_INVERSION:
+		c->inversion = tvp->data;
+		break;
+	case DTV_SYMBOL_RATE:
+		c->symbol_rate = tvp->data;
+		break;
+	case DTV_INNER_FEC:
+		c->fec_inner = tvp->data;
+		break;
+	case DTV_PILOT:
+		c->pilot = tvp->data;
+		break;
+	case DTV_ROLLOFF:
+		c->rolloff = tvp->data;
+		break;
+	case DTV_DELIVERY_SYSTEM:
+		r = dvbv5_set_delivery_system(fe, tvp->data);
+		break;
+	case DTV_VOLTAGE:
+		c->voltage = tvp->data;
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+			(void *)c->voltage);
+		break;
+	case DTV_TONE:
+		c->sectone = tvp->data;
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+			(void *)c->sectone);
+		break;
+	case DTV_CODE_RATE_HP:
+		c->code_rate_HP = tvp->data;
+		break;
+	case DTV_CODE_RATE_LP:
+		c->code_rate_LP = tvp->data;
+		break;
+	case DTV_GUARD_INTERVAL:
+		c->guard_interval = tvp->data;
+		break;
+	case DTV_TRANSMISSION_MODE:
+		c->transmission_mode = tvp->data;
+		break;
+	case DTV_HIERARCHY:
+		c->hierarchy = tvp->data;
+		break;
+	case DTV_INTERLEAVING:
+		c->interleaving = tvp->data;
+		break;
+
+	/* ISDB-T Support here */
+	case DTV_ISDBT_PARTIAL_RECEPTION:
+		c->isdbt_partial_reception = tvp->data;
+		break;
+	case DTV_ISDBT_SOUND_BROADCASTING:
+		c->isdbt_sb_mode = tvp->data;
+		break;
+	case DTV_ISDBT_SB_SUBCHANNEL_ID:
+		c->isdbt_sb_subchannel = tvp->data;
+		break;
+	case DTV_ISDBT_SB_SEGMENT_IDX:
+		c->isdbt_sb_segment_idx = tvp->data;
+		break;
+	case DTV_ISDBT_SB_SEGMENT_COUNT:
+		c->isdbt_sb_segment_count = tvp->data;
+		break;
+	case DTV_ISDBT_LAYER_ENABLED:
+		c->isdbt_layer_enabled = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERA_FEC:
+		c->layer[0].fec = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERA_MODULATION:
+		c->layer[0].modulation = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
+		c->layer[0].segment_count = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
+		c->layer[0].interleaving = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERB_FEC:
+		c->layer[1].fec = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERB_MODULATION:
+		c->layer[1].modulation = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
+		c->layer[1].segment_count = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
+		c->layer[1].interleaving = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERC_FEC:
+		c->layer[2].fec = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERC_MODULATION:
+		c->layer[2].modulation = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
+		c->layer[2].segment_count = tvp->data;
+		break;
+	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
+		c->layer[2].interleaving = tvp->data;
+		break;
+
+	/* Multistream support */
+	case DTV_STREAM_ID:
+	case DTV_DVBT2_PLP_ID_LEGACY:
+		c->stream_id = tvp->data;
+		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_PARADE_ID:
+		fe->dtv_property_cache.atscmh_parade_id = tvp->data;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->data;
+		break;
+
+	case DTV_LNA:
+		c->lna = tvp->data;
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
@@ -1939,7 +2125,8 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
+	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
+		|| (cmd == FE_SET_PROPERTY_SHORT))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		c->state = DTV_UNDEFINED;
@@ -2026,9 +2213,42 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			err = -EFAULT;
 			goto out;
 		}
-
-	} else
-		err = -EOPNOTSUPP;
+	/* New ioctl for optimizing property set
+	 */
+	} else if (cmd == FE_SET_PROPERTY_SHORT) {
+		struct dtv_property_short *tvp_short = NULL;
+		struct dtv_properties_short *tvps_short = parg;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", \
+		__func__, tvps_short->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", \
+		__func__, tvps_short->props);
+		if ((!tvps_short->num) ||
+		(tvps_short->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+		tvp_short = memdup_user(tvps_short->props,
+		tvps_short->num * sizeof(*tvp_short));
+		if (IS_ERR(tvp_short))
+			return PTR_ERR(tvp_short);
+		for (i = 0; i < tvps_short->num; i++) {
+			err = dtv_property_short_process_set(fe, tvp_short + i,\
+				file);
+			if (err < 0) {
+				kfree(tvp_short);
+				return err;
+			}
+			/* Since we are returning when error occurs
+			 * There is no need to store the result as it
+			 * would have been >=0 in case we didn't return
+			 * (tvp + i)->result = err;
+			 */
+		}
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache\
+		is full, tuning\n", __func__);
+		kfree(tvp_short);
+		} else
+			err = -EOPNOTSUPP;
 
 out:
 	kfree(tvp);
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
