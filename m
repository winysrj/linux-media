Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FHBpy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:54 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581js5a028944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:54 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc4007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:53 -0400
Date: Tue, 7 Jun 2011 22:45:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/15] [media] DocBook/frontend.xml: Link DVB S2API
 parameters
Message-ID: <20110607224531.56b2744a@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Associate the frontend.h DVB S2API parmeters to the corresponding
documentation at the spec.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 34afc54..3036070 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -124,7 +124,9 @@ DVB_DOCUMENTED = \
 	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
+	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
+	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 #	-e "s,\(\s\+\)\(FE_[A-Z0-9_]\+\)\([\s\=\,]*\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
 #
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index b5365f6..3a1ecb2 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -199,7 +199,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 
 <section id="fe_property_common">
 	<title>Parameters that are common to all Digital TV standards</title>
-	<section id="DTV_FREQUENCY">
+	<section id="DTV-FREQUENCY">
 		<title><constant>DTV_FREQUENCY</constant></title>
 
 		<para>Central frequency of the channel, in HZ.</para>
@@ -214,7 +214,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 			central frequency of the channel is expected.</para>
 	</section>
 
-	<section id="DTV_BANDWIDTH_HZ">
+	<section id="DTV-BANDWIDTH-HZ">
 		<title><constant>DTV_BANDWIDTH_HZ</constant></title>
 
 		<para>Bandwidth for the channel, in HZ.</para>
@@ -241,7 +241,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 		<para>6) In addition, DVB-T2 supports 1.172, 5 and 10MHz.</para>
 	</section>
 
-	<section id="DTV_DELIVERY_SYSTEM">
+	<section id="DTV-DELIVERY-SYSTEM">
 		<title><constant>DTV_DELIVERY_SYSTEM</constant></title>
 
 		<para>Specifies the type of Delivery system</para>
@@ -271,7 +271,7 @@ typedef enum fe_delivery_system {
 
 	</section>
 
-	<section id="DTV_TRANSMISSION_MODE">
+	<section id="DTV-TRANSMISSION-MODE">
 		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
 
 		<para>Specifies the number of carriers used by the standard</para>
@@ -300,7 +300,7 @@ typedef enum fe_transmit_mode {
 		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
 	</section>
 
-	<section id="DTV_GUARD_INTERVAL">
+	<section id="DTV-GUARD-INTERVAL">
 		<title><constant>DTV_GUARD_INTERVAL</constant></title>
 
 		<para>Possible values are:</para>
@@ -359,10 +359,10 @@ typedef enum fe_guard_interval {
 	<section id="isdbt-new-parms">
 		<title>ISDB-T only parameters</title>
 
-		<section id="isdbt-part-rec">
+		<section id="DTV-ISDBT-PARTIAL-RECEPTION">
 			<title><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></title>
 
-			<para><constant>If DTV_ISDBT_SOUND_BROADCASTING</constant> is '0' this bit-field represents whether
+			<para>If <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '0' this bit-field represents whether
 				the channel is in partial reception mode or not.</para>
 
 			<para>If '1' <constant>DTV_ISDBT_LAYERA_*</constant> values are assigned to the center segment and
@@ -375,7 +375,7 @@ typedef enum fe_guard_interval {
 			<para>Possible values: 0, 1, -1 (AUTO)</para>
 		</section>
 
-		<section id="isdbt-sound-bcast">
+		<section id="DTV-ISDBT-SOUND-BROADCASTING">
 			<title><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></title>
 
 			<para>This field represents whether the other DTV_ISDBT_*-parameters are
@@ -385,7 +385,7 @@ typedef enum fe_guard_interval {
 			<para>Possible values: 0, 1, -1 (AUTO)</para>
 		</section>
 
-		<section id="isdbt-sb-ch-id">
+		<section id="DTV-ISDBT-SB-SUBCHANNEL-ID">
 			<title><constant>DTV_ISDBT_SB_SUBCHANNEL_ID</constant></title>
 
 			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
@@ -418,7 +418,7 @@ typedef enum fe_guard_interval {
 			<para>Possible values: 0 .. 41, -1 (AUTO)</para>
 		</section>
 
-		<section id="isdbt-sb-seg-idx">
+		<section id="DTV-ISDBT-SB-SEGMENT-IDX">
 
 			<title><constant>DTV_ISDBT_SB_SEGMENT_IDX</constant></title>
 
@@ -433,7 +433,7 @@ typedef enum fe_guard_interval {
 			<para>Note: This value cannot be determined by an automatic channel search.</para>
 		</section>
 
-		<section id="isdbt-sb-seg-cnt">
+		<section id="DTV-ISDBT-SB-SEGMENT-COUNT">
 			<title><constant>DTV_ISDBT_SB_SEGMENT_COUNT</constant></title>
 
 			<para>This field only applies if <constant>DTV_ISDBT_SOUND_BROADCASTING</constant> is '1'.</para>
@@ -457,7 +457,7 @@ typedef enum fe_guard_interval {
 				available segments. The total number of segments over all layers has
 				to 13 in ISDB-T.</para>
 
-			<section id="isdbt-layer-ena">
+			<section id="DTV-ISDBT-LAYER-ENABLED">
 				<title><constant>DTV_ISDBT_LAYER_ENABLED</constant></title>
 
 				<para>Hierarchical reception in ISDB-T is achieved by enabling or disabling
@@ -482,13 +482,13 @@ typedef enum fe_guard_interval {
 				<para><constant>DTV_ISDBT_LAYER_ENABLED[31:3]</constant> unused</para>
 			</section>
 
-			<section id="isdbt-layer-fec">
+			<section id="DTV-ISDBT-LAYER-FEC">
 				<title><constant>DTV_ISDBT_LAYER*_FEC</constant></title>
 
 				<para>Possible values: <constant>FEC_AUTO</constant>, <constant>FEC_1_2</constant>, <constant>FEC_2_3</constant>, <constant>FEC_3_4</constant>, <constant>FEC_5_6</constant>, <constant>FEC_7_8</constant></para>
 			</section>
 
-			<section id="isdbt-layer-mod">
+			<section id="DTV-ISDBT-LAYER-MODULATION">
 				<title><constant>DTV_ISDBT_LAYER*_MODULATION</constant></title>
 
 				<para>Possible values: <constant>QAM_AUTO</constant>, QP<constant>SK, QAM_16</constant>, <constant>QAM_64</constant>, <constant>DQPSK</constant></para>
@@ -497,7 +497,7 @@ typedef enum fe_guard_interval {
 					and <constant>DTV_ISDBT_PARTIAL_RECEPTION</constant>=0 layer has to be <constant>DQPSK</constant>.</para>
 			</section>
 
-			<section id="isdbt-layer-seg-cnt">
+			<section id="DTV-ISDBT-LAYER-SEGMENT-COUNT">
 				<title><constant>DTV_ISDBT_LAYER*_SEGMENT_COUNT</constant></title>
 
 				<para>Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)</para>
@@ -560,7 +560,7 @@ typedef enum fe_guard_interval {
 
 			</section>
 
-			<section id="isdbt_layer_t_interl">
+			<section id="DTV-ISDBT-LAYER-TIME-INTERLEAVING">
 				<title><constant>DTV_ISDBT_LAYER*_TIME_INTERLEAVING</constant></title>
 
 				<para>Possible values: 0, 1, 2, 3, -1 (AUTO)</para>
@@ -578,7 +578,7 @@ typedef enum fe_guard_interval {
 			support is currently in the early stages development so expect this section to grow
 			and become more detailed with time.</para>
 
-		<section id="dvbt2-plp-id">
+		<section id="DTV-DVBT2-PLP-ID">
 			<title><constant>DTV_DVBT2_PLP_ID</constant></title>
 
 			<para>DVB-T2 supports Physical Layer Pipes (PLP) to allow transmission of
-- 
1.7.1


