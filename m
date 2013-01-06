Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab3AFQxU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 11:53:20 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r06GrKZW029127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 6 Jan 2013 11:53:20 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv6] dvb: Add DVBv5 stats properties for Quality of Service
Date: Sun,  6 Jan 2013 14:52:47 -0200
Message-Id: <1357491167-4502-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVBv3 quality parameters are limited on several ways:

        - Doesn't provide any way to indicate the used measure,
	  so userspace need to guess how to calculate the measure;

        - Only a limited set of stats are supported;

        - Can't be called in a way to require them to be filled
          all at once (atomic reads from the hardware), with may
          cause troubles on interpreting them on userspace;

        - On some OFDM delivery systems, the carriers can be
          independently modulated, having different properties.
          Currently, there's no way to report per-layer stats.

To address the above issues, adding a new DVBv5-based stats
API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v6: Add DocBook documentation.

TODO:
	- Add methods at the core to periodically collect, store
	  the statistics and reset the counters;
	- Add a driver implementation.
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 105 +++++++++++++++++++++++-
 include/uapi/linux/dvb/frontend.h               |  67 ++++++++++++++-
 2 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 957e3ac..5413775 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -7,16 +7,29 @@ the capability ioctls weren't implemented yet via the new way.</para>
 <para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
+<section id="dtv-stats">
+<title>DTV stats type</title>
+<programlisting>
+struct dtv_stats {
+        __u16 value;
+        __u8 scale;
+} __attribute__ ((packed));
+</programlisting>
+</section>
 <section id="dtv-property">
 <title>DTV property type</title>
 <programlisting>
 /* Reserved fields should be set to 0 */
+
 struct dtv_property {
 	__u32 cmd;
 	union {
 		__u32 data;
 		struct {
-			__u8 data[32];
+			union {
+				__u8 data[32];
+				__u16 data[16];
+			}
 			__u32 len;
 			__u32 reserved1[3];
 			void *reserved2;
@@ -850,6 +863,86 @@ enum fe_interleaving {
 	<para>use the special macro LNA_AUTO to set LNA auto</para>
 	</section>
 </section>
+
+	<section id="frontend-qos-properties">
+	<title>Frontend Quality of Service/Statistics indicators</title>
+	<para>Except for <link linkend="DTV-QOS-ENUM"><constant>DTV_QOS_ENUM</constant></link>,
+	the values are returned via <constant>dtv_property.stat</constant>.</para>
+	<para>For most delivery systems, this will return a single value for each parameter.</para>
+	<para>It should be noticed, however, that new OFDM delivery systems 
+	like ISDB can use different modulation types for each group of carriers.
+	On such standards, up to 8 groups of statistics can be provided, one
+	for each carrier group (called "layer" on ISDB).
+	In order to be consistent with other delivery systems, the first
+	value at <link linkend="dtv-stats"><constant>dtv_property.stat.dtv_stats</constant></link> array refers to
+	a global indicator, if any. The other elements of the array represent
+	each layer, starting from layer A(index 1), layer B (index 2) and so on</para>
+	<para>The number of filled elements are stored at <constant>dtv_property.stat.len</constant>.</para>
+	<para>Each element of the <constant>dtv_property.stat.dtv_stats</constant> array consists on two elements:</para>
+	<itemizedlist mark='opencircle'>
+		<listitem><para><constant>value</constant> - Value of the measure</para></listitem>
+		<listitem><para><constant>scale</constant> - Scale for the value. It can be:</para>
+			<section id = "fecap-scale-params">
+			<itemizedlist mark='bullet'>
+				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - If it is not possible to collect a given parameter (could be a transitory or permanent condition)</para></listitem>
+				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 0.1 dB</para></listitem>
+				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
+			</itemizedlist>
+			</section>
+		</listitem>
+	</itemizedlist>
+	<section id="DTV-QOS-ENUM">
+		<title><constant>DTV_QOS_ENUM</constant></title>
+		<para>A frontend needs to advertise the statistics it provides. This property allows to enumerate all
+			<link linkend="frontend-qos-properties">DTV QoS statistics</link> that are
+			supported by a given frontend.</para>
+
+		<para><constant>dtv_property.len</constant> indicates the number of supported
+		<link linkend="frontend-qos-properties">DTV QoS statistics</link>.</para>
+		<para><constant>dtv_property.data16</constant> is an 16 bits array of the supported properties.</para>
+	</section>
+	<section id="DTV-QOS-TUNER-SIGNAL">
+		<title><constant>DTV_QOS_TUNER_SIGNAL</constant></title>
+		<para>Indicates the signal strength level at the analog part of the tuner.</para>
+	</section>
+	<section id="DTV-QOS-CNR">
+		<title><constant>DTV_QOS_CNR</constant></title>
+		<para>Indicates the signal to noise relation for the main carrier.</para>
+
+	</section>
+	<section id="DTV-QOS-BIT-ERROR-COUNT">
+		<title><constant>DTV_QOS_BIT_ERROR_COUNT</constant></title>
+		<para>Measures the number of bit errors since the last counter reset.</para>
+		<para>In order to get the bit error rate, it should be divided by
+		<link linkend="DTV-QOS-BIT-ERROR-COUNT-TIME"><constant>DTV_QOS_BIT_ERROR_COUNT_TIME</constant></link>, if
+		available. Otherwise, it should be divided by the time lapsed since the previous call for
+		<link linkend="DTV-QOS-BIT-ERROR-COUNT"><constant>DTV_QOS_BIT_ERROR_COUNT</constant></link>.</para>
+	</section>
+	<section id="DTV-QOS-BIT-ERROR-COUNT-TIME">
+		<title><constant>DTV_QOS_BIT_ERROR_COUNT_TIME</constant></title>
+		<para>measures the time since the last <link linkend="DTV-QOS-BIT-ERROR-COUNT"><constant>DTV_QOS_BIT_ERROR_COUNT</constant></link> reset.</para>
+		<para>It might not be available on certain frontends, even when
+		<link linkend="DTV-QOS-BIT-ERROR-COUNT"><constant>DTV_QOS_BIT_ERROR_COUNT</constant></link>
+		is provided, due to the lack of frontend's documentation when the driver was developed.</para>
+	</section>
+	<section id="DTV-QOS-ERROR-BLOCK-COUNT">
+		<title><constant>DTV_QOS_ERROR_BLOCK_COUNT</constant></title>
+		<para>Measures the number of block errors since the last counter reset.</para>
+		<para>In order to get the bit error rate, it should be divided by
+		<link linkend="DTV-QOS-ERROR-BLOCK-COUNT-TIME"><constant>DTV_QOS_ERROR_BLOCK_COUNT_TIME</constant></link>, if
+		available. Otherwise, it should be divided by the time lapsed since the previous call for
+		<link linkend="DTV-QOS-ERROR-BLOCK-COUNT"><constant>DTV_QOS_ERROR_BLOCK_COUNT</constant></link>.</para>
+
+	</section>
+	<section id="DTV-QOS-ERROR-BLOCK-COUNT-TIME">
+		<title><constant>DTV_QOS_ERROR_BLOCK_COUNT_TIME</constant></title>
+		<para>measures the time since the last <link linkend="DTV-QOS-ERROR-BLOCK-COUNT"><constant>DTV_QOS_ERROR_BLOCK_COUNT</constant></link> reset.</para>
+		<para>It might not be available on certain frontends, even when
+		<link linkend="DTV-QOS-ERROR-BLOCK-COUNT"><constant>DTV_QOS_BIT_ERROR_BLOCK_COUNT</constant></link>
+		is provided, due to the lack of frontend's documentation when the driver was developed.</para>
+	</section>
+	</section>
+
 	<section id="frontend-property-terrestrial-systems">
 	<title>Properties used on terrestrial delivery systems</title>
 		<section id="dvbt-params">
@@ -871,6 +964,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="dvbt2-params">
 			<title>DVB-T2 delivery system</title>
@@ -895,6 +989,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="isdbt">
 		<title>ISDB-T delivery system</title>
@@ -948,6 +1043,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT"><constant>DTV_ISDBT_LAYERC_SEGMENT_COUNT</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERC_TIME_INTERLEAVING</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="atsc-params">
 			<title>ATSC delivery system</title>
@@ -961,6 +1057,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="atscmh-params">
 			<title>ATSC-MH delivery system</title>
@@ -988,6 +1085,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE-MODE-C"><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE-MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="dtmb-params">
 			<title>DTMB delivery system</title>
@@ -1007,6 +1105,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-INTERLEAVING"><constant>DTV_INTERLEAVING</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
@@ -1028,6 +1127,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	<section id="dvbc-annex-b-params">
 		<title>DVB-C Annex B delivery system</title>
@@ -1043,6 +1143,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	</section>
 	<section id="frontend-property-satellital-systems">
@@ -1062,6 +1163,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-TONE"><constant>DTV_TONE</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 		<para>Future implementations might add those two missing parameters:</para>
 		<itemizedlist mark='opencircle'>
 			<listitem><para><link linkend="DTV-DISEQC-MASTER"><constant>DTV_DISEQC_MASTER</constant></link></para></listitem>
@@ -1077,6 +1179,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-qos-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	<section id="turbo-params">
 		<title>Turbo code delivery system</title>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c12d452..843dbcd 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -365,7 +365,16 @@ struct dvb_frontend_event {
 #define DTV_INTERLEAVING			60
 #define DTV_LNA					61
 
-#define DTV_MAX_COMMAND				DTV_LNA
+/* Quality parameters */
+#define DTV_QOS_ENUM			62
+#define DTV_QOS_TUNER_SIGNAL		63
+#define DTV_QOS_CNR			64
+#define DTV_QOS_BIT_ERROR_COUNT		65
+#define DTV_QOS_BIT_ERROR_COUNT_TIME	66
+#define DTV_QOS_ERROR_BLOCK_COUNT	67
+#define DTV_QOS_ERROR_BLOCK_COUNT_TIME	68
+
+#define DTV_MAX_COMMAND		DTV_ERROR_BLOCK_COUNT_TIME
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -452,13 +461,67 @@ struct dtv_cmds_h {
 	__u32	reserved:30;	/* Align */
 };
 
+/**
+ * Scale types for the quality parameters.
+ * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
+ *			    could indicate a temporary or a permanent
+ *			    condition.
+ * @FE_SCALE_DECIBEL: The scale is measured in 0.1 dB steps, typically
+ *		  used on signal measures.
+ * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
+ *			ranging from 0 (0%) to 0xffff (100%).
+ */
+enum fecap_scale_params {
+	FE_SCALE_NOT_AVAILABLE,
+	FE_SCALE_DECIBEL,
+	FE_SCALE_RELATIVE
+};
+
+/**
+ * struct dtv_stats - Used for reading a DTV status property
+ *
+ * @value:	value of the measure. Should range from 0 to 0xffff;
+ * @scale:	Filled with enum fecap_scale_params - the scale
+ *		in usage for that parameter
+ *
+ * For most delivery systems, this will return a single value for each
+ * parameter.
+ * It should be noticed, however, that new OFDM delivery systems like
+ * ISDB can use different modulation types for each group of carriers.
+ * On such standards, up to 8 groups of statistics can be provided, one
+ * for each carrier group (called "layer" on ISDB).
+ * In order to be consistent with other delivery systems, the first
+ * value refers to the entire set of carriers ("global").
+ * dtv_status:scale should use the value FE_SCALE_NOT_AVAILABLE when
+ * the value for the entire group of carriers or from one specific layer
+ * is not provided by the hardware.
+ * In other words, for ISDB, those values should be filled like:
+ *	stat.status[0] = global statistics;
+ *	stat.scale[0] = FE_SCALE_NOT_AVAILABLE (if not available);
+ *	stat.status[1] = layer A statistics;
+ *	stat.status[2] = layer B statistics;
+ *	stat.status[3] = layer C statistics.
+ * and stat.len should be filled with the latest filled status + 1.
+ */
+struct dtv_stats {
+	__u16 value;
+	__u8 scale;
+} __attribute__ ((packed));
+
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
 	union {
 		__u32 data;
 		struct {
-			__u8 data[32];
+			__u8 len;
+			struct dtv_stats status[4];
+		} stat;
+		struct {
+			union {
+				__u8 data[32];
+				__u16 data16[16];
+			}
 			__u32 len;
 			__u32 reserved1[3];
 			void *reserved2;
-- 
1.7.11.7

