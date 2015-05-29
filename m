Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbbE2B3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 21:29:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 3/8] DocBook: improve documentation for DVB spectral inversion
Date: Thu, 28 May 2015 22:28:52 -0300
Message-Id: <52d67c92016544f4489e8ad8ae6d175b5d22dfc4.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format it as a table and provide more details.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index d9861b54f8c8..41085537acfc 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -238,19 +238,45 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</section>
 	<section id="DTV-INVERSION">
 	<title><constant>DTV_INVERSION</constant></title>
-	<para>The Inversion field can take one of these values:
-	</para>
-	<programlisting>
-	typedef enum fe_spectral_inversion {
-		INVERSION_OFF,
-		INVERSION_ON,
-		INVERSION_AUTO
-	} fe_spectral_inversion_t;
-	</programlisting>
-	<para>It indicates if spectral inversion should be presumed or not. In the automatic setting
-	(<constant>INVERSION_AUTO</constant>) the hardware will try to figure out the correct setting by
-	itself.
-	</para>
+
+	<para>Specifies if the frontend should do spectral inversion or not.</para>
+
+<section id="fe-spectral-inversion-t">
+<title>enum fe_modulation: Frontend spectral inversion</title>
+
+<para>This parameter indicates if spectral inversion should be presumed or not.
+    In the automatic setting (<constant>INVERSION_AUTO</constant>) the hardware
+    will try to figure out the correct setting by itself. If the hardware
+    doesn't support, the DVB core will try to lock at the carrier first with
+    inversion off. If it fails, it will try to enable inversion.
+</para>
+
+<table pgwide="1" frame="none" id="fe-spectral-inversion">
+    <title>enum fe_modulation</title>
+    <tgroup cols="2">
+	&cs-def;
+	<thead>
+	<row>
+	    <entry>ID</entry>
+	    <entry>Description</entry>
+	</row>
+	</thead>
+	<tbody valign="top">
+	<row>
+	    <entry>INVERSION_OFF</entry>
+	    <entry>Don't do spectral band inversion.</entry>
+	</row><row>
+	    <entry>INVERSION_ON</entry>
+	    <entry>Do spectral band inversion.</entry>
+	</row><row>
+	    <entry>INVERSION_AUTO</entry>
+	    <entry>Autodetect spectral band inversion.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
 	</section>
 	<section id="DTV-DISEQC-MASTER">
 	<title><constant>DTV_DISEQC_MASTER</constant></title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 07c1284e88c8..77dd88ceeedd 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -56,23 +56,6 @@ specification is available at
 
 &sub-dvbproperty;
 
-<section id="fe-spectral-inversion-t">
-<title>frontend spectral inversion</title>
-<para>The Inversion field can take one of these values:
-</para>
-<programlisting>
-typedef enum fe_spectral_inversion {
-	INVERSION_OFF,
-	INVERSION_ON,
-	INVERSION_AUTO
-} fe_spectral_inversion_t;
-</programlisting>
-<para>It indicates if spectral inversion should be presumed or not. In the automatic setting
-(<constant>INVERSION_AUTO</constant>) the hardware will try to figure out the correct setting by
-itself.
-</para>
-</section>
-
 <section id="fe-code-rate-t">
 <title>frontend code rate</title>
 <para>The possible values for the <constant>fec_inner</constant> field used on
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index 7d5823858df0..fe1117e91f51 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -82,7 +82,7 @@ DVB-C2, ISDB, etc.</para>
 struct dvb_frontend_parameters {
 	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
 				/&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
-	fe_spectral_inversion_t inversion;
+	&fe-spectral-inversion-t; inversion;
 	union {
 		struct dvb_qpsk_parameters qpsk;
 		struct dvb_qam_parameters  qam;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index d4b1718046ae..223905563676 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -154,12 +154,13 @@ enum fe_status {
 
 typedef enum fe_status fe_status_t;
 
-typedef enum fe_spectral_inversion {
+enum fe_spectral_inversion {
 	INVERSION_OFF,
 	INVERSION_ON,
 	INVERSION_AUTO
-} fe_spectral_inversion_t;
+};
 
+typedef enum fe_spectral_inversion fe_spectral_inversion_t;
 
 typedef enum fe_code_rate {
 	FEC_NONE = 0,
-- 
2.4.1

