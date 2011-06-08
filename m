Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1FHBqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:12 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581kChR006771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:12 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncG007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:12 -0400
Date: Tue, 7 Jun 2011 22:45:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/15] [media] DocBook/dvbproperty.xml: Add Satellite
 standards
Message-ID: <20110607224541.30f37ec4@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 9cbb289..a9863a3 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -688,8 +688,8 @@ typedef enum fe_hierarchy {
 		</section>
 		<section id="dvbt2-params">
 			<title>DVB-T2 delivery system</title>
-			<para>DVB-T2support is currently in the early stages
-			of development so expect this section to grow and become
+			<para>DVB-T2 support is currently in the early stages
+			of development, so expect that this section maygrow and become
 			more detailed with time.</para>
 		<para>The following parameters are valid for DVB-T2:</para>
 		<itemizedlist mark='opencircle'>
@@ -781,6 +781,7 @@ typedef enum fe_hierarchy {
 		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
+	<title>Properties used on cable delivery systems</title>
 	<section id="dvbc-params">
 		<title>DVB-C delivery system</title>
 		<para>The DVB-C Annex-A/C is the widely used cable standard. Transmission uses QAM modulation.</para>
@@ -811,11 +812,66 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
-	<title>Properties used on cable delivery systems</title>
-	<para>TODO</para>
 	</section>
 	<section id="frontend-property-satellital-systems">
 	<title>Properties used on satellital delivery systems</title>
-	<para>TODO</para>
+	<section id="dvbs-params">
+		<title>DVB-S delivery system</title>
+		<para>The following parameters are valid for DVB-S:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+		</itemizedlist>
+		<para>Future implementations might add those two missing parameters:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-DISEQC-MASTER"><constant>DTV_DISEQC_MASTER</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DISEQC-SLAVE-REPLY"><constant>DTV_DISEQC_SLAVE_REPLY</constant></link></para></listitem>
+		</itemizedlist>
+	</section>
+	<section id="dvbs2-params">
+		<title>DVB-S2 delivery system</title>
+		<para>The following parameters are valid for DVB-S2:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TONE"><constant>DTV_TONE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-PILOT"><constant>DTV_PILOT</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
+		</itemizedlist>
+		<para>Future implementations might add those two missing parameters:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-DISEQC-MASTER"><constant>DTV_DISEQC_MASTER</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DISEQC-SLAVE-REPLY"><constant>DTV_DISEQC_SLAVE_REPLY</constant></link></para></listitem>
+		</itemizedlist>
+	</section>
+	<section id="isdbs-params">
+		<title>ISDB-S delivery system</title>
+		<para>The following parameters are valid for ISDB-S:</para>
+		<itemizedlist mark='opencircle'>
+			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ISDBS-TS-ID"><constant>DTV_ISDBS_TS_ID</constant></link></para></listitem>
+		</itemizedlist>
+	</section>
 	</section>
 </section>
-- 
1.7.1

