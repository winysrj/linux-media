Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab1EFPfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 11:35:43 -0400
Message-ID: <4DC4153D.9000902@redhat.com>
Date: Fri, 06 May 2011 12:35:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>,
	Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH]  DocBook/dvb: Improve description of the DVB API v5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/dvb/dvbapi.xml b/Documentation/DocBook/dvb/dvbapi.xml
index ad8678d..9fad86c 100644
--- a/Documentation/DocBook/dvb/dvbapi.xml
+++ b/Documentation/DocBook/dvb/dvbapi.xml
@@ -35,6 +35,14 @@
 <revhistory>
 <!-- Put document revisions here, newest first. -->
 <revision>
+	<revnumber>2.0.4</revnumber>
+	<date>2011-05-06</date>
+	<authorinitials>mcc</authorinitials>
+	<revremark>
+		Add more information about DVB APIv5, better describing the frontend GET/SET props ioctl's.
+	</revremark>
+</revision>
+<revision>
 	<revnumber>2.0.3</revnumber>
 	<date>2010-07-03</date>
 	<authorinitials>mcc</authorinitials>
diff --git a/Documentation/DocBook/dvb/dvbproperty.xml b/Documentation/DocBook/dvb/dvbproperty.xml
index 97f397e..05ce603 100644
--- a/Documentation/DocBook/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/dvb/dvbproperty.xml
@@ -1,6 +1,312 @@
-<section id="FE_GET_PROPERTY">
+<section id="FE_GET_SET_PROPERTY">
 <title>FE_GET_PROPERTY/FE_SET_PROPERTY</title>
 
+<programlisting>
+/* Reserved fields should be set to 0 */
+struct dtv_property {
+	__u32 cmd;
+	union {
+		__u32 data;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			void *reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
+#define DTV_IOCTL_MAX_MSGS 64
+
+struct dtv_properties {
+	__u32 num;
+	struct dtv_property *props;
+};
+</programlisting>
+
+<section id="FE_GET_PROPERTY">
+<title>FE_GET_PROPERTY</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns one or more frontend properties. This call only
+ requires read-only access to the device.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link>,
+ dtv_properties &#x22C6;props);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int num</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>struct dtv_property *props</para>
+</entry><entry
+ align="char">
+<para>Points to the location where the front-end property commands are stored.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>ERRORS</para>
+<informaltable><tgroup cols="2"><tbody><row>
+  <entry align="char"><para>EINVAL</para></entry>
+  <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
+ </row><row>
+  <entry align="char"><para>ENOMEM</para></entry>
+  <entry align="char"><para>Out of memory.</para></entry>
+ </row><row>
+  <entry align="char"><para>EFAULT</para></entry>
+  <entry align="char"><para>Failure while copying data from/to userspace.</para></entry>
+ </row><row>
+  <entry align="char"><para>EOPNOTSUPP</para></entry>
+  <entry align="char"><para>Property type not supported.</para></entry>
+ </row></tbody></tgroup></informaltable>
+</section>
+
+<section id="FE_SET_PROPERTY">
+<title>FE_SET_PROPERTY</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call sets one or more frontend properties. This call only
+ requires read-only access to the device.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link>,
+ dtv_properties &#x22C6;props);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int num</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>struct dtv_property *props</para>
+</entry><entry
+ align="char">
+<para>Points to the location where the front-end property commands are stored.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>ERRORS
+</para>
+<informaltable><tgroup cols="2"><tbody><row>
+  <entry align="char"><para>EINVAL</para></entry>
+  <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
+ </row><row>
+  <entry align="char"><para>ENOMEM</para></entry>
+  <entry align="char"><para>Out of memory.</para></entry>
+ </row><row>
+  <entry align="char"><para>EFAULT</para></entry>
+  <entry align="char"><para>Failure while copying data from/to userspace.</para></entry>
+ </row><row>
+  <entry align="char"><para>EOPNOTSUPP</para></entry>
+  <entry align="char"><para>Property type not supported.</para></entry>
+ </row></tbody></tgroup></informaltable>
+</section>
+
+<para>
+On <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link>/<link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link>,
+the actual action is determined by the dtv_property cmd/data pairs. With one single ioctl, is possible to
+get/set up to 64 properties. The actual meaning of each property is described on the next sections.
+</para>
+
+<para>The Available frontend property types are:</para>
+<programlisting>
+#define DTV_UNDEFINED		0
+#define DTV_TUNE		1
+#define DTV_CLEAR		2
+#define DTV_FREQUENCY		3
+#define DTV_MODULATION		4
+#define DTV_BANDWIDTH_HZ	5
+#define DTV_INVERSION		6
+#define DTV_DISEQC_MASTER	7
+#define DTV_SYMBOL_RATE		8
+#define DTV_INNER_FEC		9
+#define DTV_VOLTAGE		10
+#define DTV_TONE		11
+#define DTV_PILOT		12
+#define DTV_ROLLOFF		13
+#define DTV_DISEQC_SLAVE_REPLY	14
+#define DTV_FE_CAPABILITY_COUNT	15
+#define DTV_FE_CAPABILITY	16
+#define DTV_DELIVERY_SYSTEM	17
+#define DTV_ISDBT_PARTIAL_RECEPTION	18
+#define DTV_ISDBT_SOUND_BROADCASTING	19
+#define DTV_ISDBT_SB_SUBCHANNEL_ID	20
+#define DTV_ISDBT_SB_SEGMENT_IDX	21
+#define DTV_ISDBT_SB_SEGMENT_COUNT	22
+#define DTV_ISDBT_LAYERA_FEC			23
+#define DTV_ISDBT_LAYERA_MODULATION		24
+#define DTV_ISDBT_LAYERA_SEGMENT_COUNT		25
+#define DTV_ISDBT_LAYERA_TIME_INTERLEAVING	26
+#define DTV_ISDBT_LAYERB_FEC			27
+#define DTV_ISDBT_LAYERB_MODULATION		28
+#define DTV_ISDBT_LAYERB_SEGMENT_COUNT		29
+#define DTV_ISDBT_LAYERB_TIME_INTERLEAVING	30
+#define DTV_ISDBT_LAYERC_FEC			31
+#define DTV_ISDBT_LAYERC_MODULATION		32
+#define DTV_ISDBT_LAYERC_SEGMENT_COUNT		33
+#define DTV_ISDBT_LAYERC_TIME_INTERLEAVING	34
+#define DTV_API_VERSION		35
+#define DTV_CODE_RATE_HP	36
+#define DTV_CODE_RATE_LP	37
+#define DTV_GUARD_INTERVAL	38
+#define DTV_TRANSMISSION_MODE	39
+#define DTV_HIERARCHY		40
+#define DTV_ISDBT_LAYER_ENABLED	41
+#define DTV_ISDBS_TS_ID		42
+</programlisting>
+
+<section id="fe_property_common">
+	<title>Parameters that are common to all Digital TV standards</title>
+	<section id="DTV_FREQUENCY">
+		<title><constant>DTV_FREQUENCY</constant></title>
+
+		<para>Central frequency of the channel, in HZ.</para>
+
+		<para>Notes:</para>
+		<para>1)For ISDB-T, the channels are usually transmitted with an offset of 143kHz.
+			E.g. a valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
+			the channel which is 6MHz.</para>
+
+		<para>2)As in ISDB-Tsb the channel consists of only one or three segments the
+			frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
+			central frequency of the channel is expected.</para>
+	</section>
+
+	<section id="DTV_BANDWIDTH_HZ">
+		<title><constant>DTV_BANDWIDTH_HZ</constant></title>
+
+		<para>Bandwidth for the channel, in HZ.</para>
+
+		<para>Possible values:
+			<constant>6000000</constant>,
+			<constant>7000000</constant>,
+			<constant>8000000</constant>.
+		</para>
+
+		<para>Notes:</para>
+
+		<para>1) For ISDB-T it should be always 6000000Hz (6MHz)</para>
+		<para>2) For ISDB-Tsb it can vary depending on the number of connected segments</para>
+		<para>3) Bandwidth doesn't apply for DVB-C transmissions, as the bandwidth
+			 for DVB-C depends on the symbol rate</para>
+		<para>4) Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
+			other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
+			DTV_ISDBT_SB_SEGMENT_COUNT).</para>
+	</section>
+
+	<section id="DTV_DELIVERY_SYSTEM">
+		<title><constant>DTV_DELIVERY_SYSTEM</constant></title>
+
+		<para>Specifies the type of Delivery system</para>
+
+		<para>Possible values: </para>
+<programlisting>
+typedef enum fe_delivery_system {
+	SYS_UNDEFINED,
+	SYS_DVBC_ANNEX_AC,
+	SYS_DVBC_ANNEX_B,
+	SYS_DVBT,
+	SYS_DSS,
+	SYS_DVBS,
+	SYS_DVBS2,
+	SYS_DVBH,
+	SYS_ISDBT,
+	SYS_ISDBS,
+	SYS_ISDBC,
+	SYS_ATSC,
+	SYS_ATSCMH,
+	SYS_DMBTH,
+	SYS_CMMB,
+	SYS_DAB,
+} fe_delivery_system_t;
+</programlisting>
+
+	</section>
+
+	<section id="DTV_TRANSMISSION_MODE">
+		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
+
+		<para>Specifies the number of carriers used by the standard</para>
+
+		<para>Possible values are:</para>
+<programlisting>
+typedef enum fe_transmit_mode {
+	TRANSMISSION_MODE_2K,
+	TRANSMISSION_MODE_8K,
+	TRANSMISSION_MODE_AUTO,
+	TRANSMISSION_MODE_4K
+} fe_transmit_mode_t;
+</programlisting>
+
+		<para>Notes:</para>
+		<para>1) ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
+			'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K</para>
+
+		<para>2) If <constant>DTV_TRANSMISSION_MODE</constant> is set the <constant>TRANSMISSION_MODE_AUTO</constant> the
+			hardware will try to find the correct FFT-size (if capable) and will
+			use TMCC to fill in the missing parameters.</para>
+	</section>
+
+	<section id="DTV_GUARD_INTERVAL">
+		<title><constant>DTV_GUARD_INTERVAL</constant></title>
+
+		<para>Possible values are:</para>
+<programlisting>
+typedef enum fe_guard_interval {
+	GUARD_INTERVAL_1_32,
+	GUARD_INTERVAL_1_16,
+	GUARD_INTERVAL_1_8,
+	GUARD_INTERVAL_1_4,
+	GUARD_INTERVAL_AUTO
+} fe_guard_interval_t;
+</programlisting>
+
+		<para>Notes:</para>
+		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
+			try to find the correct guard interval (if capable) and will use TMCC to fill
+			in the missing parameters.</para>
+	</section>
+</section>
+
 <section id="isdbt">
 	<title>ISDB-T frontend</title>
 	<para>This section describes shortly what are the possible parameters in the Linux
@@ -32,73 +338,6 @@
 
 	<para>Parameters used by ISDB-T and ISDB-Tsb.</para>
 
-	<section id="isdbt-parms">
-		<title>Parameters that are common with DVB-T and ATSC</title>
-
-		<section id="isdbt-freq">
-			<title><constant>DTV_FREQUENCY</constant></title>
-
-			<para>Central frequency of the channel.</para>
-
-			<para>For ISDB-T the channels are usually transmitted with an offset of 143kHz. E.g. a
-				valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
-				the channel which is 6MHz.</para>
-
-			<para>As in ISDB-Tsb the channel consists of only one or three segments the
-				frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
-				central frequency of the channel is expected.</para>
-		</section>
-
-		<section id="isdbt-bw">
-			<title><constant>DTV_BANDWIDTH_HZ</constant> (optional)</title>
-
-			<para>Possible values:</para>
-
-			<para>For ISDB-T it should be always 6000000Hz (6MHz)</para>
-			<para>For ISDB-Tsb it can vary depending on the number of connected segments</para>
-
-			<para>Note: Hardware specific values might be given here, but standard
-				applications should not bother to set a value to this field as
-				standard demods are ignoring it anyway.</para>
-
-			<para>Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
-				other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
-				DTV_ISDBT_SB_SEGMENT_COUNT).</para>
-		</section>
-
-		<section id="isdbt-delivery-sys">
-			<title><constant>DTV_DELIVERY_SYSTEM</constant></title>
-
-			<para>Possible values: <constant>SYS_ISDBT</constant></para>
-		</section>
-
-		<section id="isdbt-tx-mode">
-			<title><constant>DTV_TRANSMISSION_MODE</constant></title>
-
-			<para>ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
-				'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K</para>
-
-			<para>Possible values: <constant>TRANSMISSION_MODE_2K</constant>, <constant>TRANSMISSION_MODE_8K</constant>,
-				<constant>TRANSMISSION_MODE_AUTO</constant>, <constant>TRANSMISSION_MODE_4K</constant></para>
-
-			<para>If <constant>DTV_TRANSMISSION_MODE</constant> is set the <constant>TRANSMISSION_MODE_AUTO</constant> the
-				hardware will try to find the correct FFT-size (if capable) and will
-				use TMCC to fill in the missing parameters.</para>
-
-			<para><constant>TRANSMISSION_MODE_4K</constant> is added at the same time as the other new parameters.</para>
-		</section>
-
-		<section id="isdbt-guard-interval">
-			<title><constant>DTV_GUARD_INTERVAL</constant></title>
-
-			<para>Possible values: <constant>GUARD_INTERVAL_1_32</constant>, <constant>GUARD_INTERVAL_1_16</constant>, <constant>GUARD_INTERVAL_1_8</constant>,
-				<constant>GUARD_INTERVAL_1_4</constant>, <constant>GUARD_INTERVAL_AUTO</constant></para>
-
-			<para>If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
-				try to find the correct guard interval (if capable) and will use TMCC to fill
-				in the missing parameters.</para>
-		</section>
-	</section>
 	<section id="isdbt-new-parms">
 		<title>ISDB-T only parameters</title>
 
