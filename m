Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab3AVQpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:45:00 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MGj0aB015027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:45:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REVIEW PATCHv12 1/6] [media] dvb: Add DVBv5 statistics properties
Date: Tue, 22 Jan 2013 14:44:15 -0200
Message-Id: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVBv3 statistics parameters are limited on several ways:
        - Doesn't provide any way to indicate the used measure,
	  so userspace need to guess how to calculate the measure;
        - Only a limited set of stats are supported;
        - Can't be called in a way to require them to be filled
          all at once (atomic reads from the hardware), with may
          cause troubles on interpreting them on userspace;
        - On some OFDM delivery systems, the carriers can be
          independently modulated, having different properties.
          Currently, there's no way to report per-layer stats.
To address the above issues, adding a new DVBv5-based stats API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
v12: minor changes:
- documentation improvement;

- don't use __packed at the userspace api, as otherwise userspace compilation
  breaks;

- fold version increment patch.

 Documentation/DocBook/media/dvb/dvbapi.xml      |   2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml | 149 ++++++++++++++++++++++++
 include/uapi/linux/dvb/frontend.h               |  77 +++++++++++-
 include/uapi/linux/dvb/version.h                |   2 +-
 4 files changed, 227 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 757488b..0197bcc 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -84,7 +84,7 @@ Added ISDB-T test originally written by Patrick Boettcher
 
 
 <title>LINUX DVB API</title>
-<subtitle>Version 5.8</subtitle>
+<subtitle>Version 5.10</subtitle>
 <!-- ADD THE CHAPTERS HERE -->
   <chapter id="dvb_introdution">
     &sub-intro;
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 957e3ac..3f9f451 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -7,14 +7,41 @@ the capability ioctls weren't implemented yet via the new way.</para>
 <para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
+<section id="dtv-stats">
+<title>DTV stats type</title>
+<programlisting>
+struct dtv_stats {
+	__u8 scale;	/* enum fecap_scale_params type */
+	union {
+		__u64 uvalue;	/* for counters and relative scales */
+		__s64 svalue;	/* for 1/1000 dB measures */
+	};
+} __packed;
+</programlisting>
+</section>
+<section id="dtv-fe-stats">
+<title>DTV stats type</title>
+<programlisting>
+#define MAX_DTV_STATS   4
+
+struct dtv_fe_stats {
+	__u8 len;
+	struct dtv_stats stat[MAX_DTV_STATS];
+} __packed;
+</programlisting>
+</section>
+
 <section id="dtv-property">
 <title>DTV property type</title>
 <programlisting>
 /* Reserved fields should be set to 0 */
+
 struct dtv_property {
 	__u32 cmd;
+	__u32 reserved[3];
 	union {
 		__u32 data;
+		struct dtv_fe_stats st;
 		struct {
 			__u8 data[32];
 			__u32 len;
@@ -850,6 +877,118 @@ enum fe_interleaving {
 	<para>use the special macro LNA_AUTO to set LNA auto</para>
 	</section>
 </section>
+
+	<section id="frontend-stat-properties">
+	<title>Frontend statistics indicators</title>
+	<para>The values are returned via <constant>dtv_property.stat</constant>.
+	      If the property is supported, <constant>dtv_property.stat.len</constant> is bigger than zero.</para>
+	<para>For most delivery systems, <constant>dtv_property.stat.len</constant>
+	      will be 1 if the stats is supported, and the properties will
+	      return a single value for each parameter.</para>
+	<para>It should be noticed, however, that new OFDM delivery systems
+	      like ISDB can use different modulation types for each group of
+	      carriers. On such standards, up to 3 groups of statistics can be
+	      provided, and <constant>dtv_property.stat.len</constant> is updated
+	      to reflect the "global" metrics, plus one metric per each carrier
+	      group (called "layer" on ISDB).</para>
+	<para>So, in order to be consistent with other delivery systems, the first
+	      value at <link linkend="dtv-stats"><constant>dtv_property.stat.dtv_stats</constant></link>
+	      array refers to the global metric. The other elements of the array
+	      represent each layer, starting from layer A(index 1),
+	      layer B (index 2) and so on.</para>
+	<para>The number of filled elements are stored at <constant>dtv_property.stat.len</constant>.</para>
+	<para>Each element of the <constant>dtv_property.stat.dtv_stats</constant> array consists on two elements:</para>
+	<itemizedlist mark='opencircle'>
+		<listitem><para><constant>svalue</constant> or <constant>uvalue</constant>, where
+			<constant>svalue</constant> is for signed values of the measure (dB measures)
+			and <constant>uvalue</constant> is for unsigned values (counters, relative scale)</para></listitem>
+		<listitem><para><constant>scale</constant> - Scale for the value. It can be:</para>
+			<section id = "fecap-scale-params">
+			<itemizedlist mark='bullet'>
+				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)</para></listitem>
+				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 1/1000 dB</para></listitem>
+				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
+				<listitem><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
+			</itemizedlist>
+			</section>
+		</listitem>
+	</itemizedlist>
+	<section id="DTV-STAT-SIGNAL-STRENGTH">
+		<title><constant>DTV_STAT_SIGNAL_STRENGTH</constant></title>
+		<para>Indicates the signal strength level at the analog part of the tuner or of the demod.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_DECIBEL</constant> - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.</listitem>
+			<listitem><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for power (actually, 0 to 65535).</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-CNR">
+		<title><constant>DTV_STAT_CNR</constant></title>
+		<para>Indicates the Signal to Noise ratio for the main carrier.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_DECIBEL</constant> - Signal/Noise ratio is in 0.0001 dB units.</listitem>
+			<listitem><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0 to 65535).</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-BIT-ERROR-COUNT">
+		<title><constant>DTV_STAT_BIT_ERROR_COUNT</constant></title>
+		<para>Measures the number of bit errors before Viterbi.</para>
+		<para>This measure is taken during the same interval as <constant>DTV_STAT_TOTAL_BITS_COUNT</constant>.</para>
+		<para>In order to get the BER (Bit Error Rate) measurement, it should be divided by
+		<link linkend="DTV-STAT-TOTAL-BITS-COUNT"><constant>DTV_STAT_TOTAL_BITS_COUNT</constant></link>.</para>
+		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
+		      The frontend may reset it when a channel/transponder is tuned.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted before Viterbi.</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-TOTAL-BITS-COUNT">
+		<title><constant>DTV_STAT_TOTAL_BITS_COUNT</constant></title>
+		<para>Measures the amount of bits received before the Viterbi block, during the same period as
+		<link linkend="DTV-STAT-BIT-ERROR-COUNT"><constant>DTV_STAT_BIT_ERROR_COUNT</constant></link> measurement was taken.</para>
+		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
+		      as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.</para>
+		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
+		      The frontend may reset it when a channel/transponder is tuned.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
+				 <link linkend="DTV-STAT-BIT-ERROR-COUNT"><constant>DTV_STAT_BIT_ERROR_COUNT</constant></link>.</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-ERROR-BLOCK-COUNT">
+		<title><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></title>
+		<para>Measures the number of block errors.</para>
+		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
+		      The frontend may reset it when a channel/transponder is tuned.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error blocks counted after Red Salomon.</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-TOTAL-BLOCKS-COUNT">
+		<title><constant>DTV-STAT_TOTAL_BLOCKS_COUNT</constant></title>
+		<para>Measures the total number of blocks received during the same period as
+		<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link> measurement was taken.</para>
+		<para>It can be used to calculate the PER indicator, by dividing
+		<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link>
+		by <link linkend="DTV-STAT-TOTAL-BLOCKS-COUNT"><constant>DTV-STAT-TOTAL-BLOCKS-COUNT</constant></link>.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of blocks counted while measuring
+			<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link>.</listitem>
+		</itemizedlist>
+	</section>
+	</section>
+
 	<section id="frontend-property-terrestrial-systems">
 	<title>Properties used on terrestrial delivery systems</title>
 		<section id="dvbt-params">
@@ -871,6 +1010,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="dvbt2-params">
 			<title>DVB-T2 delivery system</title>
@@ -895,6 +1035,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="isdbt">
 		<title>ISDB-T delivery system</title>
@@ -948,6 +1089,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT"><constant>DTV_ISDBT_LAYERC_SEGMENT_COUNT</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERC_TIME_INTERLEAVING</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="atsc-params">
 			<title>ATSC delivery system</title>
@@ -961,6 +1103,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="atscmh-params">
 			<title>ATSC-MH delivery system</title>
@@ -988,6 +1131,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE-MODE-C"><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE-MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 		<section id="dtmb-params">
 			<title>DTMB delivery system</title>
@@ -1007,6 +1151,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-INTERLEAVING"><constant>DTV_INTERLEAVING</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
+			<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
@@ -1028,6 +1173,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	<section id="dvbc-annex-b-params">
 		<title>DVB-C Annex B delivery system</title>
@@ -1043,6 +1189,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	</section>
 	<section id="frontend-property-satellital-systems">
@@ -1062,6 +1209,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-TONE"><constant>DTV_TONE</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 		<para>Future implementations might add those two missing parameters:</para>
 		<itemizedlist mark='opencircle'>
 			<listitem><para><link linkend="DTV-DISEQC-MASTER"><constant>DTV_DISEQC_MASTER</constant></link></para></listitem>
@@ -1077,6 +1225,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 		</itemizedlist>
+		<para>In addition, the <link linkend="frontend-stat-properties">DTV QoS statistics</link> are also valid.</para>
 	</section>
 	<section id="turbo-params">
 		<title>Turbo code delivery system</title>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c12d452..0cd62bd 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -365,7 +365,15 @@ struct dvb_frontend_event {
 #define DTV_INTERLEAVING			60
 #define DTV_LNA					61
 
-#define DTV_MAX_COMMAND				DTV_LNA
+/* Quality parameters */
+#define DTV_STAT_SIGNAL_STRENGTH	62
+#define DTV_STAT_CNR			63
+#define DTV_STAT_BIT_ERROR_COUNT	64
+#define DTV_STAT_TOTAL_BITS_COUNT	65
+#define DTV_STAT_ERROR_BLOCK_COUNT	66
+#define DTV_STAT_TOTAL_BLOCKS_COUNT	67
+
+#define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCKS_COUNT
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -452,11 +460,78 @@ struct dtv_cmds_h {
 	__u32	reserved:30;	/* Align */
 };
 
+/**
+ * Scale types for the quality parameters.
+ * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
+ *			    could indicate a temporary or a permanent
+ *			    condition.
+ * @FE_SCALE_DECIBEL: The scale is measured in 0.0001 dB steps, typically
+ *		  used on signal measures.
+ * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
+ *			ranging from 0 (0%) to 0xffff (100%).
+ * @FE_SCALE_COUNTER: The scale counts the occurrence of an event, like
+ *			bit error, block error, lapsed time.
+ */
+enum fecap_scale_params {
+	FE_SCALE_NOT_AVAILABLE = 0,
+	FE_SCALE_DECIBEL,
+	FE_SCALE_RELATIVE,
+	FE_SCALE_COUNTER
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
+ * st.len should be filled with the latest filled status + 1.
+ *
+ * In other words, for ISDB, those values should be filled like:
+ *	u.st.stat.svalue[0] = global statistics;
+ *	u.st.stat.scale[0] = FE_SCALE_DECIBELS;
+ *	u.st.stat.value[1] = layer A statistics;
+ *	u.st.stat.scale[1] = FE_SCALE_NOT_AVAILABLE (if not available);
+ *	u.st.stat.svalue[2] = layer B statistics;
+ *	u.st.stat.scale[2] = FE_SCALE_DECIBELS;
+ *	u.st.stat.svalue[3] = layer C statistics;
+ *	u.st.stat.scale[3] = FE_SCALE_DECIBELS;
+ *	u.st.len = 4;
+ */
+struct dtv_stats {
+	__u8 scale;	/* enum fecap_scale_params type */
+	union {
+		__u64 uvalue;	/* for counters and relative scales */
+		__s64 svalue;	/* for 0.0001 dB measures */
+	};
+} __attribute__ ((packed));
+
+
+#define MAX_DTV_STATS   4
+
+struct dtv_fe_stats {
+	__u8 len;
+	struct dtv_stats stat[MAX_DTV_STATS];
+} __attribute__ ((packed));
+
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
 	union {
 		__u32 data;
+		struct dtv_fe_stats st;
 		struct {
 			__u8 data[32];
 			__u32 len;
diff --git a/include/uapi/linux/dvb/version.h b/include/uapi/linux/dvb/version.h
index 827cce7..e53e2ad 100644
--- a/include/uapi/linux/dvb/version.h
+++ b/include/uapi/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 9
+#define DVB_API_VERSION_MINOR 10
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.11.7

