Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1LRAhK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:37:10 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0bAO5026148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:37:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/7] [media] Update documentation to reflect DVB-C Annex A/C support
Date: Sat, 17 Dec 2011 22:36:56 -0200
Message-Id: <1324168621-21506-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324168621-21506-2-git-send-email-mchehab@redhat.com>
References: <1324168621-21506-1-git-send-email-mchehab@redhat.com>
 <1324168621-21506-2-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |   11 +++++------
 Documentation/DocBook/media/dvb/frontend.xml    |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index b812e31..ffee1fb 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -311,8 +311,6 @@ typedef enum fe_rolloff {
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
-	ROLLOFF_15, /* DVB-C Annex A */
-	ROLLOFF_13, /* DVB-C Annex C */
 } fe_rolloff_t;
 		</programlisting>
 		</section>
@@ -336,9 +334,10 @@ typedef enum fe_rolloff {
 		<title>fe_delivery_system type</title>
 		<para>Possible values: </para>
 <programlisting>
+
 typedef enum fe_delivery_system {
 	SYS_UNDEFINED,
-	SYS_DVBC_ANNEX_AC,
+	SYS_DVBC_ANNEX_A,
 	SYS_DVBC_ANNEX_B,
 	SYS_DVBT,
 	SYS_DSS,
@@ -355,6 +354,7 @@ typedef enum fe_delivery_system {
 	SYS_DAB,
 	SYS_DVBT2,
 	SYS_TURBO,
+	SYS_DVBC_ANNEX_C,
 } fe_delivery_system_t;
 </programlisting>
 		</section>
@@ -781,7 +781,8 @@ typedef enum fe_hierarchy {
 	<title>Properties used on cable delivery systems</title>
 	<section id="dvbc-params">
 		<title>DVB-C delivery system</title>
-		<para>The DVB-C Annex-A/C is the widely used cable standard. Transmission uses QAM modulation.</para>
+		<para>The DVB-C Annex-A is the widely used cable standard. Transmission uses QAM modulation.</para>
+		<para>The DVB-C Annex-C is optimized for 6MHz, and is used in Japan. It supports a subset of the Annex A modulation types, and a roll-off of 0.13, instead of 0.15</para>
 		<para>The following parameters are valid for DVB-C Annex A/C:</para>
 		<itemizedlist mark='opencircle'>
 			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
@@ -792,10 +793,8 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 		</itemizedlist>
-		<para>The Rolloff of 0.15 (ROLLOFF_15) is assumed, as ITU-T J.83 Annex A is more common. For Annex C, rolloff should be 0.13 (ROLLOFF_13). All other values are invalid.</para>
 	</section>
 	<section id="dvbc-annex-b-params">
 		<title>DVB-C Annex B delivery system</title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 61407ea..28d7ea5 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -45,8 +45,8 @@ transmission. The fontend types are given by fe_type_t type, defined as:</para>
   </row>
   <row>
      <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
-     <entry>For DVB-C annex A/C standard</entry>
-     <entry><constant>SYS_DVBC_ANNEX_AC</constant></entry>
+     <entry>For DVB-C annex A standard</entry>
+     <entry><constant>SYS_DVBC_ANNEX_A</constant></entry>
   </row>
   <row>
      <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
-- 
1.7.8

