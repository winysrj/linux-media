Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab1FHBqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:06 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k6Oo030515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:06 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncC007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:05 -0400
Date: Tue, 7 Jun 2011 22:45:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/15] [media] DocBook/dvbproperty.xml: Document the
 terrestrial delivery systems
Message-ID: <20110607224538.08b832d9@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of repeating duplicate parameters to each delivery system,
just add a section for each specific delivery system, showing
what's applicable to each case. This helps userspace app developers
to know what DVB parameters are applicable to each delivery system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index d8a6424..4c45f3c 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1,6 +1,12 @@
 <section id="FE_GET_SET_PROPERTY">
-<title>FE_GET_PROPERTY/FE_SET_PROPERTY</title>
-
+<title><constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></title>
+<para>This section describes the DVB version 5 extention of the DVB-API, also
+called "S2API", as this API were added to provide support for DVB-S2. It was
+designed to be able to replace the old frontend API. Yet, the DISEQC and
+the capability ioctls weren't implemented yet via the new way.</para>
+<para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
+API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
+struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
 <programlisting>
 /* Reserved fields should be set to 0 */
 struct dtv_property {
@@ -149,52 +155,7 @@ the actual action is determined by the dtv_property cmd/data pairs. With one sin
 get/set up to 64 properties. The actual meaning of each property is described on the next sections.
 </para>
 
-<para>The available frontend property types are:</para>
-
-<para><link linkend="DTV-UNDEFINED">DTV_UNDEFINED</link></para>
-<para><link linkend="DTV-TUNE">DTV_TUNE</link></para>
-<para><link linkend="DTV-CLEAR">DTV_CLEAR</link></para>
-<para><link linkend="DTV-FREQUENCY">DTV_FREQUENCY</link></para>
-<para><link linkend="DTV-MODULATION">DTV_MODULATION</link></para>
-<para><link linkend="DTV-BANDWIDTH-HZ">DTV_BANDWIDTH_HZ</link></para>
-<para><link linkend="DTV-INVERSION">DTV_INVERSION</link></para>
-<para><link linkend="DTV-DISEQC-MASTER">DTV_DISEQC_MASTER</link></para>
-<para><link linkend="DTV-SYMBOL-RATE">DTV_SYMBOL_RATE</link></para>
-<para><link linkend="DTV-INNER-FEC">DTV_INNER_FEC</link></para>
-<para><link linkend="DTV-VOLTAGE">DTV_VOLTAGE</link></para>
-<para><link linkend="DTV-TONE">DTV_TONE</link></para>
-<para><link linkend="DTV-PILOT">DTV_PILOT</link></para>
-<para><link linkend="DTV-ROLLOFF">DTV_ROLLOFF</link></para>
-<para><link linkend="DTV-DISEQC-SLAVE-REPLY">DTV_DISEQC_SLAVE_REPLY</link></para>
-<para><link linkend="DTV-FE-CAPABILITY-COUNT">DTV_FE_CAPABILITY_COUNT</link></para>
-<para><link linkend="DTV-FE-CAPABILITY">DTV_FE_CAPABILITY</link></para>
-<para><link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link></para>
-<para><link linkend="DTV-ISDBT-PARTIAL-RECEPTION">DTV_ISDBT_PARTIAL_RECEPTION</link></para>
-<para><link linkend="DTV-ISDBT-SOUND-BROADCASTING">DTV_ISDBT_SOUND_BROADCASTING</link></para>
-<para><link linkend="DTV-ISDBT-SB-SUBCHANNEL-ID">DTV_ISDBT_SB_SUBCHANNEL_ID</link></para>
-<para><link linkend="DTV-ISDBT-SB-SEGMENT-IDX">DTV_ISDBT_SB_SEGMENT_IDX</link></para>
-<para><link linkend="DTV-ISDBT-SB-SEGMENT-COUNT">DTV_ISDBT_SB_SEGMENT_COUNT</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERA_FEC</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERA_MODULATION</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERA_SEGMENT_COUNT</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERA_TIME_INTERLEAVING</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERB_FEC</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERB_MODULATION</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERB_SEGMENT_COUNT</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERB_TIME_INTERLEAVING</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERC_FEC</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERC_MODULATION</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERC_SEGMENT_COUNT</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERC_TIME_INTERLEAVING</link></para>
-<para><link linkend="DTV-API-VERSION">DTV_API_VERSION</link></para>
-<para><link linkend="DTV-CODE-RATE-HP">DTV_CODE_RATE_HP</link></para>
-<para><link linkend="DTV-CODE-RATE-LP">DTV_CODE_RATE_LP</link></para>
-<para><link linkend="DTV-GUARD-INTERVAL">DTV_GUARD_INTERVAL</link></para>
-<para><link linkend="DTV-TRANSMISSION-MODE">DTV_TRANSMISSION_MODE</link></para>
-<para><link linkend="DTV-HIERARCHY">DTV_HIERARCHY</link></para>
-<para><link linkend="DTV-ISDBT-LAYER-ENABLED">DTV_ISDBT_LAYER_ENABLED</link></para>
-<para><link linkend="DTV-ISDBS-TS-ID">DTV_ISDBS_TS_ID</link></para>
-<para><link linkend="DTV-DVBT2-PLP-ID">DTV_DVBT2_PLP_ID</link></para>
+<para>The available frontend property types are shown on the next section.</para>
 </section>
 
 <section id="fe_property_parameters">
@@ -696,13 +657,53 @@ typedef enum fe_hierarchy {
 			many data types via a single multiplex. The API will soon support this
 			at which point this section will be expanded.</para>
 	</section>
-	<section id="frontend-property-dtv-types">
-	<title>Properties used by each DTV type</title>
+</section>
+	<section id="frontend-property-terrestrial-systems">
+	<title>Properties used on terrestrial delivery systems</title>
+		<section id="dvbt-params">
+			<title>DVB-T delivery system</title>
+			<para>The following parameters are valid for DVB-T:</para>
+			<itemizedlist mark='opencircle'>
+				<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CODE-RATE-HP"><constant>DTV_CODE_RATE_HP</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CODE-RATE-LP"><constant>DTV_CODE_RATE_LP</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			</itemizedlist>
+		</section>
+		<section id="dvbt2-params">
+			<title>DVB-T2 delivery system</title>
+			<para>DVB-T2support is currently in the early stages
+			of development so expect this section to grow and become
+			more detailed with time.</para>
+		<para>The following parameters are valid for DVB-T2:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CODE-RATE-HP"><constant>DTV_CODE_RATE_HP</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CODE-RATE-LP"><constant>DTV_CODE_RATE_LP</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DVBT2-PLP-ID"><constant>DTV_DVBT2_PLP_ID</constant></link></para></listitem>
+		</itemizedlist>
+		</section>
 		<section id="isdbt">
-		<title>ISDB-T frontend</title>
-		<para>This section describes shortly what are the possible parameters in the Linux
-			DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
-			demodulator:</para>
+		<title>ISDB-T delivery system</title>
 		<para>This ISDB-T/ISDB-Tsb API extension should reflect all information
 			needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
 			that some very sophisticated devices won't need certain parameters to
@@ -717,17 +718,54 @@ typedef enum fe_hierarchy {
 			Television Broadcasting" and</para>
 		<para>ARIB TR-B14 - "Operational Guidelines for Digital Terrestrial
 			Television Broadcasting".</para>
-		<para>In order to read this document one has to have some knowledge the
-			channel structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to
-			the reader that an ISDB-T channel consists of 13 segments, that it can
-			have up to 3 layer sharing those segments, and things like that.</para>
-		</section>
-		<section id="dvbt2-params">
-			<title>DVB-T2 parameters</title>
-			<para>This section covers parameters that apply only to the DVB-T2 delivery method. DVB-T2
-				support is currently in the early stages development so expect this section to grow
-				and become more detailed with time.</para>
+		<para>In order to understand the ISDB specific parameters,
+			one has to have some knowledge the channel structure in
+			ISDB-T and ISDB-Tsb. I.e. it has to be known to
+			the reader that an ISDB-T channel consists of 13 segments,
+			that it can have up to 3 layer sharing those segments,
+			and things like that.</para>
+		<para>The following parameters are valid for ISDB-T:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CODE-RATE-HP"><constant>DTV_CODE_RATE_HP</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CODE-RATE-LP"><constant>DTV_CODE_RATE_LP</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-ENABLED"><constant>DTV_ISDBT_LAYER_ENABLED</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-PARTIAL-RECEPTION"><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-SOUND-BROADCASTING"><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-SB-SUBCHANNEL-ID"><constant>DTV_ISDBT_SB_SUBCHANNEL_ID</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-SB-SEGMENT-IDX"><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-SB-SEGMENT-COUNT"><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-FEC"><constant>DTV_ISDBT_LAYERA_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-MODULATION"><constant>DTV_ISDBT_LAYERA_MODULATION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT"><constant>DTV_ISDBT_LAYERA_SEGMENT_COUNT</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERA_TIME_INTERLEAVING</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-FEC"><constant>DTV_ISDBT_LAYERB_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-MODULATION"><constant>DTV_ISDBT_LAYERB_MODULATION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT"><constant>DTV_ISDBT_LAYERB_SEGMENT_COUNT</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERB_TIME_INTERLEAVING</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-FEC"><constant>DTV_ISDBT_LAYERC_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-MODULATION"><constant>DTV_ISDBT_LAYERC_MODULATION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT"><constant>DTV_ISDBT_LAYERC_SEGMENT_COUNT</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERC_TIME_INTERLEAVING</constant></link></para></listitem>
+		</itemizedlist>
 		</section>
 	</section>
-</section>
+	<section id="frontend-property-cable-systems">
+	<title>Properties used on cable delivery systems</title>
+	<para>TODO</para>
+	</section>
+	<section id="frontend-property-satellital-systems">
+	<title>Properties used on satellital delivery systems</title>
+	<para>TODO</para>
+	</section>
 </section>
-- 
1.7.1


