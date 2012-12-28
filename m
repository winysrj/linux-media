Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2L1X5N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 18:57:13 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBSNvCgc022380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 18:57:13 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
Date: Fri, 28 Dec 2012 21:56:46 -0200
Message-Id: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVBv3 quality parameters are limited on several ways:
	- Doesn't provide any way to indicate the used measure;
	- Userspace need to guess how to calculate the measure;
	- Only a limited set of stats are supported;
	- Doesn't provide QoS measure for the OFDM TPS/TMCC
	  carriers, used to detect the network parameters for
	  DVB-T/ISDB-T;
	- Can't be called in a way to require them to be filled
	  all at once (atomic reads from the hardware), with may
	  cause troubles on interpreting them on userspace;
	- On some OFDM delivery systems, the carriers can be
	  independently modulated, having different properties.
	  Currently, there's no way to report per-layer stats;
This RFC adds the header definitions meant to solve that issues.
After discussed, I'll write a patch for the DocBook and add support
for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
will also have support for those features.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/uapi/linux/dvb/frontend.h | 78 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

v3: Just update http://patchwork.linuxtv.org/patch/9578/ to current tip

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c12d452..a998b9a 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -365,7 +365,21 @@ struct dvb_frontend_event {
 #define DTV_INTERLEAVING			60
 #define DTV_LNA					61
 
-#define DTV_MAX_COMMAND				DTV_LNA
+/* Quality parameters */
+#define DTV_ENUM_QUALITY	45	/* Enumerates supported QoS parameters */
+#define DTV_QUALITY_SNR		46
+#define DTV_QUALITY_CNR		47
+#define DTV_QUALITY_EsNo	48
+#define DTV_QUALITY_EbNo	49
+#define DTV_QUALITY_RELATIVE	50
+#define DTV_ERROR_BER		51
+#define DTV_ERROR_PER		52
+#define DTV_ERROR_PARAMS	53	/* Error count at TMCC or TPS carrier */
+#define DTV_FE_STRENGTH		54
+#define DTV_FE_SIGNAL		55
+#define DTV_FE_UNC		56
+
+#define DTV_MAX_COMMAND		DTV_FE_UNC
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -452,12 +466,74 @@ struct dtv_cmds_h {
 	__u32	reserved:30;	/* Align */
 };
 
+/**
+ * Scale types for the quality parameters.
+ * @FE_SCALE_DECIBEL: The scale is measured in dB, typically
+ *		  used on signal measures.
+ * @FE_SCALE_LINEAR: The scale is linear.
+ *		     typically used on error QoS parameters.
+ * @FE_SCALE_RELATIVE: The scale is relative.
+ */
+enum fecap_scale_params {
+	FE_SCALE_DECIBEL,
+	FE_SCALE_LINEAR,
+	FE_SCALE_RELATIVE
+};
+
+/**
+ * struct dtv_status - Used for reading a DTV status property
+ *
+ * @value:	value of the measure. Should range from 0 to 0xffff;
+ * @scale:	Filled with enum fecap_scale_params - the scale
+ *		in usage for that parameter
+ * @min:	minimum value. Not used if the scale is relative.
+ *		For non-relative measures, define the measure
+ *		associated with dtv_status.value == 0.
+ * @max:	maximum value. Not used if the scale is	relative.
+ *		For non-relative measures, define the measure
+ *		associated with dtv_status.value == 0xffff.
+ *
+ * At userspace, min/max values should be used to calculate the
+ * absolute value of that measure, if fecap_scale_params is not
+ * FE_SCALE_RELATIVE, using the following formula:
+ *	 measure = min + (value * (max - min) / 0xffff)
+ *
+ * For error count measures, typically, min = 0, and max = 0xffff,
+ * and the measure represent the number of errors detected.
+ *
+ * Up to 4 status groups can be provided. This is for the
+ * OFDM standards where the carriers can be grouped into
+ * independent layers, each with its own modulation. When
+ * such layers are used (for example, on ISDB-T), the status
+ * should be filled with:
+ *	stat.status[0] = global statistics;
+ *	stat.status[1] = layer A statistics;
+ *	stat.status[2] = layer B statistics;
+ *	stat.status[3] = layer C statistics.
+ * and stat.len should be filled with the latest filled status + 1.
+ * If the frontend doesn't provide a global statistics,
+ * stat.has_global should be 0.
+ * Delivery systems that don't use it, should just set stat.len and
+ * stat.has_global with 1, and fill just stat.status[0].
+ */
+struct dtv_status {
+	__u16 value;
+	__u16 scale;
+	__s16 min;
+	__s16 max;
+} __attribute__ ((packed));
+
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
 	union {
 		__u32 data;
 		struct {
+			__u8 len;
+			__u8 has_global;
+			struct dtv_status status[4];
+		} stat;
+		struct {
 			__u8 data[32];
 			__u32 len;
 			__u32 reserved1[3];
-- 
1.7.11.7

