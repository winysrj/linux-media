Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward6.mail.yandex.net ([77.88.60.125]:57949 "EHLO
	forward6.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2IMO1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 10:27:22 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] DocBook: Multistream support
MIME-Version: 1.0
Message-Id: <1023401347545788@web17e.yandex.ru>
Date: Thu, 13 Sep 2012 17:16:28 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Multistream support for DVBAPI. If my english bad - please fix it somebody :)

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index d188be9..c7c14be 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -793,15 +793,16 @@ typedef enum fe_hierarchy {
  } fe_hierarchy_t;
 	</programlisting>
 	</section>
-	<section id="DTV-ISDBS-TS-ID">
-	<title><constant>DTV_ISDBS_TS_ID</constant></title>
-	<para>Currently unused.</para>
+	<section id="DTV-STREAM-ID">
+	<title><constant>DTV_STREAM_ID</constant></title>
+	<para>DVB-S2/T2, ISDB-S supports transmission several streams via a single carrier.
+		Depend from standards can be used for many purposes. This property enable
+		substream filtering. For DVB-S2/T2 valid substream id from 0 to 255, for ISDB from 1 to 65535.
+		Anoter id values disable filtering (better use special define NO_STREAM_ID_FILTER).</para>
 	</section>
-	<section id="DTV-DVBT2-PLP-ID">
-		<title><constant>DTV_DVBT2_PLP_ID</constant></title>
-		<para>DVB-T2 supports Physical Layer Pipes (PLP) to allow transmission of
-			many data types via a single multiplex. The API will soon support this
-			at which point this section will be expanded.</para>
+	<section id="DTV-DVBT2-PLP-ID-LEGACY">
+		<title><constant>DTV_DVBT2_PLP_ID_LEGACY</constant></title>
+		<para>Obsolete, replaced with DTV_STREAM_ID.</para>
 	</section>
 	<section id="DTV-ENUM-DELSYS">
 		<title><constant>DTV_ENUM_DELSYS</constant></title>
@@ -869,7 +870,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-DVBT2-PLP-ID"><constant>DTV_DVBT2_PLP_ID</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 		</itemizedlist>
 		</section>
 		<section id="isdbt">
@@ -1048,6 +1049,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-PILOT"><constant>DTV_PILOT</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="turbo-params">
@@ -1070,7 +1072,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-ISDBS-TS-ID"><constant>DTV_ISDBS_TS_ID</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-STREAM-ID"><constant>DTV_STREAM_ID</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	</section>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 950bdfb..426c252 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -101,6 +101,7 @@ a specific frontend type.</para>
 	FE_CAN_8VSB                   = 0x200000,
 	FE_CAN_16VSB                  = 0x400000,
 	FE_HAS_EXTENDED_CAPS          = 0x800000,
+	FE_CAN_MULTISTREAM            = 0x4000000,
 	FE_CAN_TURBO_FEC              = 0x8000000,
 	FE_CAN_2G_MODULATION          = 0x10000000,
 	FE_NEEDS_BENDING              = 0x20000000,
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 170064a..2048b53 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -205,7 +205,7 @@ a partial path like:</para>
 additional include file <emphasis
 role="tt">linux/dvb/version.h</emphasis> exists, which defines the
 constant <emphasis role="tt">DVB_API_VERSION</emphasis>. This document
-describes <emphasis role="tt">DVB_API_VERSION 5.4</emphasis>.
+describes <emphasis role="tt">DVB_API_VERSION 5.8</emphasis>.
 </para>
 
 </section>
