Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1FHBqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:04 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k3aI006735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:04 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncA007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:02 -0400
Date: Tue, 7 Jun 2011 22:45:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/15] [media] DocBook/dvbproperty.xml: Reorganize the
 parameters
Message-ID: <20110607224536.5721fc57@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Put the parameters at the sequencial order as they appear inside
the frontend.h header.

TODO: fix the per-standard section, to reflect the parameters
that should actually be used for each transmission system type.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 01f3933..d8a6424 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -197,8 +197,8 @@ get/set up to 64 properties. The actual meaning of each property is described on
 <para><link linkend="DTV-DVBT2-PLP-ID">DTV_DVBT2_PLP_ID</link></para>
 </section>
 
-<section id="fe_property_common">
-	<title>Parameters that are common to all Digital TV standards</title>
+<section id="fe_property_parameters">
+	<title>Digital TV property parameters</title>
 	<section id="DTV-UNDEFINED">
 	<title><constant>DTV_UNDEFINED</constant></title>
 	<para>Used internally. A GET/SET operation for it won't change or return anything.</para>
@@ -211,6 +211,20 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	<title><constant>DTV_CLEAR</constant></title>
 	<para>Reset a cache of data specific to the frontend here. This does not effect hardware.</para>
 	</section>
+	<section id="DTV-FREQUENCY">
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
 	<section id="DTV-MODULATION">
 	<title><constant>DTV_MODULATION</constant></title>
 <para>Specifies the frontend modulation type for cable and satellite types. The modulation can be one of the types bellow:</para>
@@ -232,6 +246,32 @@ get/set up to 64 properties. The actual meaning of each property is described on
  } fe_modulation_t;
 </programlisting>
 	</section>
+	<section id="DTV-BANDWIDTH-HZ">
+		<title><constant>DTV_BANDWIDTH_HZ</constant></title>
+
+		<para>Bandwidth for the channel, in HZ.</para>
+
+		<para>Possible values:
+			<constant>1712000</constant>,
+			<constant>5000000</constant>,
+			<constant>6000000</constant>,
+			<constant>7000000</constant>,
+			<constant>8000000</constant>,
+			<constant>10000000</constant>.
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
+		<para>5) DVB-T supports 6, 7 and 8MHz.</para>
+		<para>6) In addition, DVB-T2 supports 1.172, 5 and 10MHz.</para>
+	</section>
 	<section id="DTV-INVERSION">
 	<title><constant>DTV_INVERSION</constant></title>
 	<para>The Inversion field can take one of these values:
@@ -338,116 +378,11 @@ typedef enum fe_rolloff {
 	<title><constant>DTV_FE_CAPABILITY</constant></title>
 	<para>Currently not implemented.</para>
 	</section>
-	<section id="DTV-API-VERSION">
-	<title><constant>DTV_API_VERSION</constant></title>
-	<para>Returns the major/minor version of the DVB API</para>
-	</section>
-	<section id="DTV-CODE-RATE-HP">
-	<title><constant>DTV_CODE_RATE_HP</constant></title>
-	<para>Used on terrestrial transmissions. The acceptable values are:
-	</para>
-	<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-} fe_code_rate_t;
-	</programlisting>
-	</section>
-	<section id="DTV-CODE-RATE-LP">
-	<title><constant>DTV_CODE_RATE_LP</constant></title>
-	<para>Used on terrestrial transmissions. The acceptable values are:
-	</para>
-	<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-} fe_code_rate_t;
-	</programlisting>
-	</section>
-	<section id="DTV-HIERARCHY">
-	<title><constant>DTV_HIERARCHY</constant></title>
-	<para>Frontend hierarchy</para>
-	<programlisting>
-typedef enum fe_hierarchy {
-	 HIERARCHY_NONE,
-	 HIERARCHY_1,
-	 HIERARCHY_2,
-	 HIERARCHY_4,
-	 HIERARCHY_AUTO
- } fe_hierarchy_t;
-	</programlisting>
-	</section>
-	<section id="DTV-ISDBS-TS-ID">
-	<title><constant>DTV_ISDBS_TS_ID</constant></title>
-	<para>Currently unused.</para>
-	</section>
-	<section id="DTV-FREQUENCY">
-		<title><constant>DTV_FREQUENCY</constant></title>
-
-		<para>Central frequency of the channel, in HZ.</para>
-
-		<para>Notes:</para>
-		<para>1)For ISDB-T, the channels are usually transmitted with an offset of 143kHz.
-			E.g. a valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
-			the channel which is 6MHz.</para>
-
-		<para>2)As in ISDB-Tsb the channel consists of only one or three segments the
-			frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
-			central frequency of the channel is expected.</para>
-	</section>
-
-	<section id="DTV-BANDWIDTH-HZ">
-		<title><constant>DTV_BANDWIDTH_HZ</constant></title>
-
-		<para>Bandwidth for the channel, in HZ.</para>
-
-		<para>Possible values:
-			<constant>1712000</constant>,
-			<constant>5000000</constant>,
-			<constant>6000000</constant>,
-			<constant>7000000</constant>,
-			<constant>8000000</constant>,
-			<constant>10000000</constant>.
-		</para>
-
-		<para>Notes:</para>
-
-		<para>1) For ISDB-T it should be always 6000000Hz (6MHz)</para>
-		<para>2) For ISDB-Tsb it can vary depending on the number of connected segments</para>
-		<para>3) Bandwidth doesn't apply for DVB-C transmissions, as the bandwidth
-			 for DVB-C depends on the symbol rate</para>
-		<para>4) Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
-			other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
-			DTV_ISDBT_SB_SEGMENT_COUNT).</para>
-		<para>5) DVB-T supports 6, 7 and 8MHz.</para>
-		<para>6) In addition, DVB-T2 supports 1.172, 5 and 10MHz.</para>
-	</section>
-
 	<section id="DTV-DELIVERY-SYSTEM">
 		<title><constant>DTV_DELIVERY_SYSTEM</constant></title>
-
 		<para>Specifies the type of Delivery system</para>
-
+		<section id="fe-delivery-system-t">
+		<title>fe_delivery_system type</title>
 		<para>Possible values: </para>
 <programlisting>
 typedef enum fe_delivery_system {
@@ -470,9 +405,247 @@ typedef enum fe_delivery_system {
 	SYS_DVBT2,
 } fe_delivery_system_t;
 </programlisting>
+		</section>
+	</section>
+	<section id="DTV-ISDBT-PARTIAL-RECEPTION">
+		<title><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></title>
+
+		<para>If <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '0' this bit-field represents whether
+			the channel is in partial reception mode or not.</para>
+
+		<para>If '1' <constant>DTV_ISDBT_LAYERA_*</constant> values are assigned to the center segment and
+			<constant>DTV_ISDBT_LAYERA_SEGMENT_COUNT</constant> has to be '1'.</para>
+
+		<para>If in addition <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'
+			<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> represents whether this ISDB-Tsb channel
+			is consisting of one segment and layer or three segments and two layers.</para>
+
+		<para>Possible values: 0, 1, -1 (AUTO)</para>
+	</section>
+	<section id="DTV-ISDBT-SOUND-BROADCASTING">
+		<title><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></title>
+
+		<para>This field represents whether the other DTV_ISDBT_*-parameters are
+			referring to an ISDB-T and an ISDB-Tsb channel. (See also
+			<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>).</para>
+
+		<para>Possible values: 0, 1, -1 (AUTO)</para>
+	</section>
+	<section id="DTV-ISDBT-SB-SUBCHANNEL-ID">
+		<title><constant>DTV_ISDBT_SB_SUBCHANNEL_ID</constant></title>
+
+		<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+
+		<para>(Note of the author: This might not be the correct description of the
+			<constant>SUBCHANNEL-ID</constant> in all details, but it is my understanding of the technical
+			background needed to program a device)</para>
+
+		<para>An ISDB-Tsb channel (1 or 3 segments) can be broadcasted alone or in a
+			set of connected ISDB-Tsb channels. In this set of channels every
+			channel can be received independently. The number of connected
+			ISDB-Tsb segment can vary, e.g. depending on the frequency spectrum
+			bandwidth available.</para>
 
+		<para>Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
+			broadcaster has several possibilities to put those channels in the
+			air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
+			segments from position 1-8 to 5-13 or anything in between.</para>
+
+		<para>The underlying layer of segments are subchannels: each segment is
+			consisting of several subchannels with a predefined IDs. A sub-channel
+			is used to help the demodulator to synchronize on the channel.</para>
+
+		<para>An ISDB-T channel is always centered over all sub-channels. As for
+			the example above, in ISDB-Tsb it is no longer as simple as that.</para>
+
+		<para><constant>The DTV_ISDBT_SB_SUBCHANNEL_ID</constant> parameter is used to give the
+			sub-channel ID of the segment to be demodulated.</para>
+
+		<para>Possible values: 0 .. 41, -1 (AUTO)</para>
+	</section>
+	<section id="DTV-ISDBT-SB-SEGMENT-IDX">
+		<title><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant></title>
+		<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+		<para><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant> gives the index of the segment to be
+			demodulated for an ISDB-Tsb channel where several of them are
+			transmitted in the connected manner.</para>
+		<para>Possible values: 0 .. <constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> - 1</para>
+		<para>Note: This value cannot be determined by an automatic channel search.</para>
+	</section>
+	<section id="DTV-ISDBT-SB-SEGMENT-COUNT">
+		<title><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant></title>
+		<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
+		<para><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> gives the total count of connected ISDB-Tsb
+			channels.</para>
+		<para>Possible values: 1 .. 13</para>
+		<para>Note: This value cannot be determined by an automatic channel search.</para>
 	</section>
+	<section id="isdb-hierq-layers">
+		<title>Hierarchical layers</title>
+		<para>ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
+			ISDB-T hierarchical layers can be decoded simultaneously. For that
+			reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.</para>
+		<para>ISDB-T has 3 hierarchical layers which each can use a part of the
+			available segments. The total number of segments over all layers has
+			to 13 in ISDB-T.</para>
+		<section id="DTV-ISDBT-LAYER-ENABLED">
+			<title><constant>DTV_ISDBT_LAYER_ENABLED</constant></title>
+			<para>Hierarchical reception in ISDB-T is achieved by enabling or disabling
+				layers in the decoding process. Setting all bits of
+				<constant>DTV_ISDBT_LAYER_ENABLED</constant> to '1' forces all layers (if applicable) to be
+				demodulated. This is the default.</para>
+			<para>If the channel is in the partial reception mode
+				(<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> = 1) the central segment can be decoded
+				independently of the other 12 segments. In that mode layer A has to
+				have a <constant>SEGMENT_COUNT</constant> of 1.</para>
+			<para>In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb
+				according to <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>. <constant>SEGMENT_COUNT</constant> must be filled
+				accordingly.</para>
+			<para>Possible values: 0x1, 0x2, 0x4 (|-able)</para>
+			<para><constant>DTV_ISDBT_LAYER_ENABLED[0:0]</constant> - layer A</para>
+			<para><constant>DTV_ISDBT_LAYER_ENABLED[1:1]</constant> - layer B</para>
+			<para><constant>DTV_ISDBT_LAYER_ENABLED[2:2]</constant> - layer C</para>
+			<para><constant>DTV_ISDBT_LAYER_ENABLED[31:3]</constant> unused</para>
+		</section>
+		<section id="DTV-ISDBT-LAYER-FEC">
+			<title><constant>DTV_ISDBT_LAYER*_FEC</constant></title>
+			<para>Possible values: <constant>FEC_AUTO</constant>, <constant>FEC_1_2</constant>, <constant>FEC_2_3</constant>, <constant>FEC_3_4</constant>, <constant>FEC_5_6</constant>, <constant>FEC_7_8</constant></para>
+		</section>
+		<section id="DTV-ISDBT-LAYER-MODULATION">
+			<title><constant>DTV_ISDBT_LAYER*_MODULATION</constant></title>
+			<para>Possible values: <constant>QAM_AUTO</constant>, QP<constant>SK, QAM_16</constant>, <constant>QAM_64</constant>, <constant>DQPSK</constant></para>
+			<para>Note: If layer C is <constant>DQPSK</constant> layer B has to be <constant>DQPSK</constant>. If layer B is <constant>DQPSK</constant>
+				and <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>=0 layer has to be <constant>DQPSK</constant>.</para>
+		</section>
+		<section id="DTV-ISDBT-LAYER-SEGMENT-COUNT">
+			<title><constant>DTV_ISDBT_LAYER*_SEGMENT_COUNT</constant></title>
+			<para>Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)</para>
+			<para>Note: Truth table for <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> and
+				<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> and <constant>LAYER</constant>*_SEGMENT_COUNT</para>
+			<informaltable id="isdbt-layer_seg-cnt-table">
+				<tgroup cols="6">
+					<tbody>
+						<row>
+							<entry>PR</entry>
+							<entry>SB</entry>
+							<entry>Layer A width</entry>
+							<entry>Layer B width</entry>
+							<entry>Layer C width</entry>
+							<entry>total width</entry>
+						</row>
+						<row>
+							<entry>0</entry>
+							<entry>0</entry>
+							<entry>1 .. 13</entry>
+							<entry>1 .. 13</entry>
+							<entry>1 .. 13</entry>
+							<entry>13</entry>
+						</row>
+						<row>
+							<entry>1</entry>
+							<entry>0</entry>
+							<entry>1</entry>
+							<entry>1 .. 13</entry>
+							<entry>1 .. 13</entry>
+							<entry>13</entry>
+						</row>
+						<row>
+							<entry>0</entry>
+							<entry>1</entry>
+							<entry>1</entry>
+							<entry>0</entry>
+							<entry>0</entry>
+							<entry>1</entry>
+						</row>
+						<row>
+							<entry>1</entry>
+							<entry>1</entry>
+							<entry>1</entry>
+							<entry>2</entry>
+							<entry>0</entry>
+							<entry>13</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</informaltable>
+		</section>
+		<section id="DTV-ISDBT-LAYER-TIME-INTERLEAVING">
+			<title><constant>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</constant></title>
+			<para>Possible values: 0, 1, 2, 3, -1 (AUTO)</para>
+			<para>Note: The real inter-leaver depth-names depend on the mode (fft-size); the values
+				here are referring to what can be found in the TMCC-structure -
+				independent of the mode.</para>
+		</section>
+	</section>
+	<section id="DTV-API-VERSION">
+	<title><constant>DTV_API_VERSION</constant></title>
+	<para>Returns the major/minor version of the DVB API</para>
+	</section>
+	<section id="DTV-CODE-RATE-HP">
+	<title><constant>DTV_CODE_RATE_HP</constant></title>
+	<para>Used on terrestrial transmissions. The acceptable values are:
+	</para>
+	<programlisting>
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+	</programlisting>
+	</section>
+	<section id="DTV-CODE-RATE-LP">
+	<title><constant>DTV_CODE_RATE_LP</constant></title>
+	<para>Used on terrestrial transmissions. The acceptable values are:
+	</para>
+	<programlisting>
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+	</programlisting>
+	</section>
+	<section id="DTV-GUARD-INTERVAL">
+		<title><constant>DTV_GUARD_INTERVAL</constant></title>
+
+		<para>Possible values are:</para>
+<programlisting>
+typedef enum fe_guard_interval {
+	GUARD_INTERVAL_1_32,
+	GUARD_INTERVAL_1_16,
+	GUARD_INTERVAL_1_8,
+	GUARD_INTERVAL_1_4,
+	GUARD_INTERVAL_AUTO,
+	GUARD_INTERVAL_1_128,
+	GUARD_INTERVAL_19_128,
+	GUARD_INTERVAL_19_256,
+} fe_guard_interval_t;
+</programlisting>
 
+		<para>Notes:</para>
+		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
+			try to find the correct guard interval (if capable) and will use TMCC to fill
+			in the missing parameters.</para>
+		<para>2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at present</para>
+	</section>
 	<section id="DTV-TRANSMISSION-MODE">
 		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
 
@@ -490,7 +663,6 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_32K,
 } fe_transmit_mode_t;
 </programlisting>
-
 		<para>Notes:</para>
 		<para>1) ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
 			'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K</para>
@@ -501,291 +673,60 @@ typedef enum fe_transmit_mode {
 		<para>3) DVB-T specifies 2K and 8K as valid sizes.</para>
 		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
 	</section>
-
-	<section id="DTV-GUARD-INTERVAL">
-		<title><constant>DTV_GUARD_INTERVAL</constant></title>
-
-		<para>Possible values are:</para>
-<programlisting>
-typedef enum fe_guard_interval {
-	GUARD_INTERVAL_1_32,
-	GUARD_INTERVAL_1_16,
-	GUARD_INTERVAL_1_8,
-	GUARD_INTERVAL_1_4,
-	GUARD_INTERVAL_AUTO,
-	GUARD_INTERVAL_1_128,
-	GUARD_INTERVAL_19_128,
-	GUARD_INTERVAL_19_256,
-} fe_guard_interval_t;
-</programlisting>
-
-		<para>Notes:</para>
-		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
-			try to find the correct guard interval (if capable) and will use TMCC to fill
-			in the missing parameters.</para>
-		<para>2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at present</para>
+	<section id="DTV-HIERARCHY">
+	<title><constant>DTV_HIERARCHY</constant></title>
+	<para>Frontend hierarchy</para>
+	<programlisting>
+typedef enum fe_hierarchy {
+	 HIERARCHY_NONE,
+	 HIERARCHY_1,
+	 HIERARCHY_2,
+	 HIERARCHY_4,
+	 HIERARCHY_AUTO
+ } fe_hierarchy_t;
+	</programlisting>
 	</section>
-</section>
-
-<section id="isdbt">
-	<title>ISDB-T frontend</title>
-	<para>This section describes shortly what are the possible parameters in the Linux
-		DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
-		demodulator:</para>
-
-	<para>This ISDB-T/ISDB-Tsb API extension should reflect all information
-		needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
-		that some very sophisticated devices won't need certain parameters to
-		tune.</para>
-
-	<para>The information given here should help application writers to know how
-		to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.</para>
-
-	<para>The details given here about ISDB-T and ISDB-Tsb are just enough to
-		basically show the dependencies between the needed parameter values,
-		but surely some information is left out. For more detailed information
-		see the following documents:</para>
-
-	<para>ARIB STD-B31 - "Transmission System for Digital Terrestrial
-		Television Broadcasting" and</para>
-	<para>ARIB TR-B14 - "Operational Guidelines for Digital Terrestrial
-		Television Broadcasting".</para>
-
-	<para>In order to read this document one has to have some knowledge the
-		channel structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to
-		the reader that an ISDB-T channel consists of 13 segments, that it can
-		have up to 3 layer sharing those segments, and things like that.</para>
-
-	<para>Parameters used by ISDB-T and ISDB-Tsb.</para>
-
-	<section id="isdbt-new-parms">
-		<title>ISDB-T only parameters</title>
-
-		<section id="DTV-ISDBT-PARTIAL-RECEPTION">
-			<title><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></title>
-
-			<para>If <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '0' this bit-field represents whether
-				the channel is in partial reception mode or not.</para>
-
-			<para>If '1' <constant>DTV_ISDBT_LAYERA_*</constant> values are assigned to the center segment and
-				<constant>DTV_ISDBT_LAYERA_SEGMENT_COUNT</constant> has to be '1'.</para>
-
-			<para>If in addition <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'
-				<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> represents whether this ISDB-Tsb channel
-				is consisting of one segment and layer or three segments and two layers.</para>
-
-			<para>Possible values: 0, 1, -1 (AUTO)</para>
-		</section>
-
-		<section id="DTV-ISDBT-SOUND-BROADCASTING">
-			<title><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></title>
-
-			<para>This field represents whether the other DTV_ISDBT_*-parameters are
-				referring to an ISDB-T and an ISDB-Tsb channel. (See also
-				<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>).</para>
-
-			<para>Possible values: 0, 1, -1 (AUTO)</para>
-		</section>
-
-		<section id="DTV-ISDBT-SB-SUBCHANNEL-ID">
-			<title><constant>DTV_ISDBT_SB_SUBCHANNEL_ID</constant></title>
-
-			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
-
-			<para>(Note of the author: This might not be the correct description of the
-				<constant>SUBCHANNEL-ID</constant> in all details, but it is my understanding of the technical
-				background needed to program a device)</para>
-
-			<para>An ISDB-Tsb channel (1 or 3 segments) can be broadcasted alone or in a
-				set of connected ISDB-Tsb channels. In this set of channels every
-				channel can be received independently. The number of connected
-				ISDB-Tsb segment can vary, e.g. depending on the frequency spectrum
-				bandwidth available.</para>
-
-			<para>Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
-				broadcaster has several possibilities to put those channels in the
-				air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
-				segments from position 1-8 to 5-13 or anything in between.</para>
-
-			<para>The underlying layer of segments are subchannels: each segment is
-				consisting of several subchannels with a predefined IDs. A sub-channel
-				is used to help the demodulator to synchronize on the channel.</para>
-
-			<para>An ISDB-T channel is always centered over all sub-channels. As for
-				the example above, in ISDB-Tsb it is no longer as simple as that.</para>
-
-			<para><constant>The DTV_ISDBT_SB_SUBCHANNEL_ID</constant> parameter is used to give the
-				sub-channel ID of the segment to be demodulated.</para>
-
-			<para>Possible values: 0 .. 41, -1 (AUTO)</para>
-		</section>
-
-		<section id="DTV-ISDBT-SB-SEGMENT-IDX">
-
-			<title><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant></title>
-
-			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
-
-			<para><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant> gives the index of the segment to be
-				demodulated for an ISDB-Tsb channel where several of them are
-				transmitted in the connected manner.</para>
-
-			<para>Possible values: 0 .. <constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> - 1</para>
-
-			<para>Note: This value cannot be determined by an automatic channel search.</para>
-		</section>
-
-		<section id="DTV-ISDBT-SB-SEGMENT-COUNT">
-			<title><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant></title>
-
-			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
-
-			<para><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant> gives the total count of connected ISDB-Tsb
-				channels.</para>
-
-			<para>Possible values: 1 .. 13</para>
-
-			<para>Note: This value cannot be determined by an automatic channel search.</para>
-		</section>
-
-		<section id="isdb-hierq-layers">
-			<title>Hierarchical layers</title>
-
-			<para>ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
-				ISDB-T hierarchical layers can be decoded simultaneously. For that
-				reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.</para>
-
-			<para>ISDB-T has 3 hierarchical layers which each can use a part of the
-				available segments. The total number of segments over all layers has
-				to 13 in ISDB-T.</para>
-
-			<section id="DTV-ISDBT-LAYER-ENABLED">
-				<title><constant>DTV_ISDBT_LAYER_ENABLED</constant></title>
-
-				<para>Hierarchical reception in ISDB-T is achieved by enabling or disabling
-					layers in the decoding process. Setting all bits of
-					<constant>DTV_ISDBT_LAYER_ENABLED</constant> to '1' forces all layers (if applicable) to be
-					demodulated. This is the default.</para>
-
-				<para>If the channel is in the partial reception mode
-					(<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> = 1) the central segment can be decoded
-					independently of the other 12 segments. In that mode layer A has to
-					have a <constant>SEGMENT_COUNT</constant> of 1.</para>
-
-				<para>In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb
-					according to <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>. <constant>SEGMENT_COUNT</constant> must be filled
-					accordingly.</para>
-
-				<para>Possible values: 0x1, 0x2, 0x4 (|-able)</para>
-
-				<para><constant>DTV_ISDBT_LAYER_ENABLED[0:0]</constant> - layer A</para>
-				<para><constant>DTV_ISDBT_LAYER_ENABLED[1:1]</constant> - layer B</para>
-				<para><constant>DTV_ISDBT_LAYER_ENABLED[2:2]</constant> - layer C</para>
-				<para><constant>DTV_ISDBT_LAYER_ENABLED[31:3]</constant> unused</para>
-			</section>
-
-			<section id="DTV-ISDBT-LAYER-FEC">
-				<title><constant>DTV_ISDBT_LAYER*_FEC</constant></title>
-
-				<para>Possible values: <constant>FEC_AUTO</constant>, <constant>FEC_1_2</constant>, <constant>FEC_2_3</constant>, <constant>FEC_3_4</constant>, <constant>FEC_5_6</constant>, <constant>FEC_7_8</constant></para>
-			</section>
-
-			<section id="DTV-ISDBT-LAYER-MODULATION">
-				<title><constant>DTV_ISDBT_LAYER*_MODULATION</constant></title>
-
-				<para>Possible values: <constant>QAM_AUTO</constant>, QP<constant>SK, QAM_16</constant>, <constant>QAM_64</constant>, <constant>DQPSK</constant></para>
-
-				<para>Note: If layer C is <constant>DQPSK</constant> layer B has to be <constant>DQPSK</constant>. If layer B is <constant>DQPSK</constant>
-					and <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>=0 layer has to be <constant>DQPSK</constant>.</para>
-			</section>
-
-			<section id="DTV-ISDBT-LAYER-SEGMENT-COUNT">
-				<title><constant>DTV_ISDBT_LAYER*_SEGMENT_COUNT</constant></title>
-
-				<para>Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)</para>
-
-				<para>Note: Truth table for <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> and
-					<constant>DTV_ISDBT_PARTIAL_RECEPTION</constant> and <constant>LAYER</constant>*_SEGMENT_COUNT</para>
-
-				<informaltable id="isdbt-layer_seg-cnt-table">
-					<tgroup cols="6">
-
-						<tbody>
-							<row>
-								<entry>PR</entry>
-								<entry>SB</entry>
-								<entry>Layer A width</entry>
-								<entry>Layer B width</entry>
-								<entry>Layer C width</entry>
-								<entry>total width</entry>
-							</row>
-
-							<row>
-								<entry>0</entry>
-								<entry>0</entry>
-								<entry>1 .. 13</entry>
-								<entry>1 .. 13</entry>
-								<entry>1 .. 13</entry>
-								<entry>13</entry>
-							</row>
-
-							<row>
-								<entry>1</entry>
-								<entry>0</entry>
-								<entry>1</entry>
-								<entry>1 .. 13</entry>
-								<entry>1 .. 13</entry>
-								<entry>13</entry>
-							</row>
-
-							<row>
-								<entry>0</entry>
-								<entry>1</entry>
-								<entry>1</entry>
-								<entry>0</entry>
-								<entry>0</entry>
-								<entry>1</entry>
-							</row>
-
-							<row>
-								<entry>1</entry>
-								<entry>1</entry>
-								<entry>1</entry>
-								<entry>2</entry>
-								<entry>0</entry>
-								<entry>13</entry>
-							</row>
-						</tbody>
-
-					</tgroup>
-				</informaltable>
-
-			</section>
-
-			<section id="DTV-ISDBT-LAYER-TIME-INTERLEAVING">
-				<title><constant>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</constant></title>
-
-				<para>Possible values: 0, 1, 2, 3, -1 (AUTO)</para>
-
-				<para>Note: The real inter-leaver depth-names depend on the mode (fft-size); the values
-					here are referring to what can be found in the TMCC-structure -
-					independent of the mode.</para>
-			</section>
-		</section>
+	<section id="DTV-ISDBS-TS-ID">
+	<title><constant>DTV_ISDBS_TS_ID</constant></title>
+	<para>Currently unused.</para>
 	</section>
-	<section id="dvbt2-params">
-		<title>DVB-T2 parameters</title>
-
-		<para>This section covers parameters that apply only to the DVB-T2 delivery method. DVB-T2
-			support is currently in the early stages development so expect this section to grow
-			and become more detailed with time.</para>
-
-		<section id="DTV-DVBT2-PLP-ID">
-			<title><constant>DTV_DVBT2_PLP_ID</constant></title>
-
-			<para>DVB-T2 supports Physical Layer Pipes (PLP) to allow transmission of
-				many data types via a single multiplex. The API will soon support this
-				at which point this section will be expanded.</para>
+	<section id="DTV-DVBT2-PLP-ID">
+		<title><constant>DTV_DVBT2_PLP_ID</constant></title>
+		<para>DVB-T2 supports Physical Layer Pipes (PLP) to allow transmission of
+			many data types via a single multiplex. The API will soon support this
+			at which point this section will be expanded.</para>
+	</section>
+	<section id="frontend-property-dtv-types">
+	<title>Properties used by each DTV type</title>
+		<section id="isdbt">
+		<title>ISDB-T frontend</title>
+		<para>This section describes shortly what are the possible parameters in the Linux
+			DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
+			demodulator:</para>
+		<para>This ISDB-T/ISDB-Tsb API extension should reflect all information
+			needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
+			that some very sophisticated devices won't need certain parameters to
+			tune.</para>
+		<para>The information given here should help application writers to know how
+			to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.</para>
+		<para>The details given here about ISDB-T and ISDB-Tsb are just enough to
+			basically show the dependencies between the needed parameter values,
+			but surely some information is left out. For more detailed information
+			see the following documents:</para>
+		<para>ARIB STD-B31 - "Transmission System for Digital Terrestrial
+			Television Broadcasting" and</para>
+		<para>ARIB TR-B14 - "Operational Guidelines for Digital Terrestrial
+			Television Broadcasting".</para>
+		<para>In order to read this document one has to have some knowledge the
+			channel structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to
+			the reader that an ISDB-T channel consists of 13 segments, that it can
+			have up to 3 layer sharing those segments, and things like that.</para>
+		</section>
+		<section id="dvbt2-params">
+			<title>DVB-T2 parameters</title>
+			<para>This section covers parameters that apply only to the DVB-T2 delivery method. DVB-T2
+				support is currently in the early stages development so expect this section to grow
+				and become more detailed with time.</para>
 		</section>
 	</section>
 </section>
-- 
1.7.1


