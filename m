Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19538 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdIOKTL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 06:19:11 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20170915101909epoutp031fcba8c4298f361ed99834a4954218b7~kgauISH_80794207942epoutp03D
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 10:19:09 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: mchehab@kernel.org, max.kellermann@gmail.com,
        sakari.ailus@linux.intel.com, mingo@kernel.org,
        hans.verkuil@cisco.com, yamada.masahiro@socionext.com,
        shuah@kernel.org
Cc: satendra.t@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, taeyoung0432.lee@samsung.com,
        jackee.lee@samsung.com, hemanshu.s@samsung.com,
        madhur.verma@samsung.com
Subject: [PATCH v2] [DVB][FRONTEND] Added a new ioctl for optimizing
 frontend property set operation
Date: Fri, 15 Sep 2017 06:18:20 -0400
Message-Id: <1505470700-22979-1-git-send-email-satendra.t@samsung.com>
In-Reply-To: <20170915054921.3782cdf2@vento.lan>
Content-Type: text/plain; charset="utf-8"
References: <20170915054921.3782cdf2@vento.lan>
        <CGME20170915101907epcas5p39a5f9ffa4c02a757d911ce58cd890fea@epcas5p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello  Mr Chehab,
Thanks for the comments.
I have modified dtv_property_process_set and
also added documentation.
Please let me know if any further modifications required.

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 .../media/uapi/dvb/fe-set-property-short.rst       |  60 +++++++++
 Documentation/media/uapi/dvb/frontend_fcalls.rst   |   1 +
 drivers/media/dvb-core/dvb_frontend.c              | 143 +++++++++++++--------
 include/uapi/linux/dvb/frontend.h                  |  24 ++++
 4 files changed, 173 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/media/uapi/dvb/fe-set-property-short.rst

diff --git a/Documentation/media/uapi/dvb/fe-set-property-short.rst b/Documentation/media/uapi/dvb/fe-set-property-short.rst
new file mode 100644
index 0000000..7da1e8d
--- /dev/null
+++ b/Documentation/media/uapi/dvb/fe-set-property-short.rst
@@ -0,0 +1,60 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _FE_SET_PROPERTY_SHORT:
+
+**************************************
+ioctl FE_SET_PROPERTY_SHORT
+**************************************
+
+Name
+====
+
+FE_SET_PROPERTY_SHORT  sets one or more frontend properties.
+
+
+Synopsis
+========
+
+
+.. c:function:: int ioctl( int fd, FE_SET_PROPERTY_SHORT, struct dtv_properties_short *argp )
+    :name: FE_SET_PROPERTY_SHORT
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <frontend_f_open>`.
+
+``argp``
+    pointer to struct :c:type:`dtv_properties_short`,
+	which is a shorter variant of struct dtv_properties.
+
+
+Description
+===========
+
+All DVB frontend devices support the ``FE_SET_PROPERTY_SHORT`` ioctl.
+This ioctl is a shorter variant of ioctl FE_SET_PROPERTY.
+The supported properties and statistics depend on the delivery system
+and on the device:
+
+-  ``FE_SET_PROPERTY_SHORT:``
+
+   -  This ioctl is used to set one or more frontend properties.
+
+   -  This is the basic command to request the frontend to tune into
+      some frequency and to start decoding the digital TV signal.
+
+   -  This call requires read/write access to the device.
+
+   -  At return, the values are updated to reflect the actual parameters
+      used.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/frontend_fcalls.rst b/Documentation/media/uapi/dvb/frontend_fcalls.rst
index b03f9ca..a1246c6 100644
--- a/Documentation/media/uapi/dvb/frontend_fcalls.rst
+++ b/Documentation/media/uapi/dvb/frontend_fcalls.rst
@@ -14,6 +14,7 @@ Frontend Function Calls
     fe-get-info
     fe-read-status
     fe-get-property
+    fe-set-property-short
     fe-diseqc-reset-overload
     fe-diseqc-send-master-cmd
     fe-diseqc-recv-slave-reply
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e3fff8f..6616474 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1738,23 +1738,28 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	return emulate_delivery_system(fe, delsys);
 }
 
+/**
+ * dtv_property_process_set
+ * @fe: Pointer to struct dvb_frontend
+ * @file: Pointer to struct file
+ * @cmd: Property name
+ * @data: Property value
+ *
+ * helper function for dvb_frontend_ioctl_properties,
+ * which can be used to set a single dtv property
+ * It assigns property value to corresponding member of
+ * property-cache structure
+ * Returns:
+ * Zero on success, negative errno on failure.
+ */
 static int dtv_property_process_set(struct dvb_frontend *fe,
-				    struct dtv_property *tvp,
-				    struct file *file)
+					struct file *file,
+					u32 cmd, u32 data)
 {
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property) {
-		r = fe->ops.set_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
-	dtv_property_dump(fe, true, tvp);
-
-	switch(tvp->cmd) {
+	switch (cmd) {
 	case DTV_CLEAR:
 		/*
 		 * Reset a cache of data specific to the frontend here. This does
@@ -1767,140 +1772,140 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
 		 * ioctl.
 		 */
-		c->state = tvp->cmd;
+		c->state = cmd;
 		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
 				__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
 	case DTV_FREQUENCY:
-		c->frequency = tvp->u.data;
+		c->frequency = data;
 		break;
 	case DTV_MODULATION:
-		c->modulation = tvp->u.data;
+		c->modulation = data;
 		break;
 	case DTV_BANDWIDTH_HZ:
-		c->bandwidth_hz = tvp->u.data;
+		c->bandwidth_hz = data;
 		break;
 	case DTV_INVERSION:
-		c->inversion = tvp->u.data;
+		c->inversion = data;
 		break;
 	case DTV_SYMBOL_RATE:
-		c->symbol_rate = tvp->u.data;
+		c->symbol_rate = data;
 		break;
 	case DTV_INNER_FEC:
-		c->fec_inner = tvp->u.data;
+		c->fec_inner = data;
 		break;
 	case DTV_PILOT:
-		c->pilot = tvp->u.data;
+		c->pilot = data;
 		break;
 	case DTV_ROLLOFF:
-		c->rolloff = tvp->u.data;
+		c->rolloff = data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		r = dvbv5_set_delivery_system(fe, tvp->u.data);
+		r = dvbv5_set_delivery_system(fe, data);
 		break;
 	case DTV_VOLTAGE:
-		c->voltage = tvp->u.data;
+		c->voltage = data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
-		c->sectone = tvp->u.data;
+		c->sectone = data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
-		c->code_rate_HP = tvp->u.data;
+		c->code_rate_HP = data;
 		break;
 	case DTV_CODE_RATE_LP:
-		c->code_rate_LP = tvp->u.data;
+		c->code_rate_LP = data;
 		break;
 	case DTV_GUARD_INTERVAL:
-		c->guard_interval = tvp->u.data;
+		c->guard_interval = data;
 		break;
 	case DTV_TRANSMISSION_MODE:
-		c->transmission_mode = tvp->u.data;
+		c->transmission_mode = data;
 		break;
 	case DTV_HIERARCHY:
-		c->hierarchy = tvp->u.data;
+		c->hierarchy = data;
 		break;
 	case DTV_INTERLEAVING:
-		c->interleaving = tvp->u.data;
+		c->interleaving = data;
 		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
-		c->isdbt_partial_reception = tvp->u.data;
+		c->isdbt_partial_reception = data;
 		break;
 	case DTV_ISDBT_SOUND_BROADCASTING:
-		c->isdbt_sb_mode = tvp->u.data;
+		c->isdbt_sb_mode = data;
 		break;
 	case DTV_ISDBT_SB_SUBCHANNEL_ID:
-		c->isdbt_sb_subchannel = tvp->u.data;
+		c->isdbt_sb_subchannel = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_IDX:
-		c->isdbt_sb_segment_idx = tvp->u.data;
+		c->isdbt_sb_segment_idx = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_COUNT:
-		c->isdbt_sb_segment_count = tvp->u.data;
+		c->isdbt_sb_segment_count = data;
 		break;
 	case DTV_ISDBT_LAYER_ENABLED:
-		c->isdbt_layer_enabled = tvp->u.data;
+		c->isdbt_layer_enabled = data;
 		break;
 	case DTV_ISDBT_LAYERA_FEC:
-		c->layer[0].fec = tvp->u.data;
+		c->layer[0].fec = data;
 		break;
 	case DTV_ISDBT_LAYERA_MODULATION:
-		c->layer[0].modulation = tvp->u.data;
+		c->layer[0].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
-		c->layer[0].segment_count = tvp->u.data;
+		c->layer[0].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
-		c->layer[0].interleaving = tvp->u.data;
+		c->layer[0].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERB_FEC:
-		c->layer[1].fec = tvp->u.data;
+		c->layer[1].fec = data;
 		break;
 	case DTV_ISDBT_LAYERB_MODULATION:
-		c->layer[1].modulation = tvp->u.data;
+		c->layer[1].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
-		c->layer[1].segment_count = tvp->u.data;
+		c->layer[1].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
-		c->layer[1].interleaving = tvp->u.data;
+		c->layer[1].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERC_FEC:
-		c->layer[2].fec = tvp->u.data;
+		c->layer[2].fec = data;
 		break;
 	case DTV_ISDBT_LAYERC_MODULATION:
-		c->layer[2].modulation = tvp->u.data;
+		c->layer[2].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
-		c->layer[2].segment_count = tvp->u.data;
+		c->layer[2].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
-		c->layer[2].interleaving = tvp->u.data;
+		c->layer[2].interleaving = data;
 		break;
 
 	/* Multistream support */
 	case DTV_STREAM_ID:
 	case DTV_DVBT2_PLP_ID_LEGACY:
-		c->stream_id = tvp->u.data;
+		c->stream_id = data;
 		break;
 
 	/* ATSC-MH */
 	case DTV_ATSCMH_PARADE_ID:
-		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
+		fe->dtv_property_cache.atscmh_parade_id = data;
 		break;
 	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
-		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
 		break;
 
 	case DTV_LNA:
-		c->lna = tvp->u.data;
+		c->lna = data;
 		if (fe->ops.set_lna)
 			r = fe->ops.set_lna(fe);
 		if (r < 0)
@@ -1914,6 +1919,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
+
 static int dvb_frontend_ioctl(struct file *file,
 			unsigned int cmd, void *parg)
 {
@@ -1939,7 +1945,8 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
+	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
+		|| (cmd == FE_SET_PROPERTY_SHORT))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		c->state = DTV_UNDEFINED;
@@ -1979,7 +1986,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			return PTR_ERR(tvp);
 
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
+			err = dtv_property_process_set(fe, file,
+			(tvp + i)->cmd, (tvp + i)->u.data);
 			if (err < 0)
 				goto out;
 			(tvp + i)->result = err;
@@ -2026,7 +2034,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
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
+			err = dtv_property_process_set(fe, file,
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
