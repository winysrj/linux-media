Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbFHTye (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org, Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 12/26] [media] DocBook: Add documentation for ATSC M/H properties
Date: Mon,  8 Jun 2015 16:53:56 -0300
Message-Id: <7f2a97ee8841fca092b8da7f572bdd744f2dbe79.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those data were retrieved by looking at A/153: ATSC Mobile DTV
Standard and guessing what makes more sense to each field.

Cc: Michael Ira Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 275788875655..8d57f0c9b6aa 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -741,10 +741,13 @@ typedef enum fe_delivery_system {
 	<tbody valign="top">
 	<row>
 	    <entry id="ATSCMH-RSFRAME-PRI-ONLY"><constant>ATSCMH_RSFRAME_PRI_ONLY</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Single Frame: There is only a primary RS Frame for all
+		Group Regions.</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSFRAME-PRI-SEC"><constant>ATSCMH_RSFRAME_PRI_SEC</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Dual Frame: There are two separate RS Frames: Primary RS
+		Frame for Group Region A and B and Secondary RS Frame for Group
+		Region C and D.</entry>
 	</row>
         </tbody>
     </tgroup>
@@ -752,7 +755,7 @@ typedef enum fe_delivery_system {
 		</section>
 		<section id="DTV-ATSCMH-RS-FRAME-ENSEMBLE">
 			<title><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></title>
-			<para>RS frame ensemble.</para>
+			<para>Reed Solomon(RS) frame ensemble.</para>
 			<para>Possible values are:</para>
 <table pgwide="1" frame="none" id="atscmh-rs-frame-ensemble">
     <title>enum atscmh_rs_frame_ensemble</title>
@@ -767,13 +770,13 @@ typedef enum fe_delivery_system {
 	<tbody valign="top">
 	<row>
 	    <entry id="ATSCMH-RSFRAME-ENS-PRI"><constant>ATSCMH_RSFRAME_ENS_PRI</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Primary Ensemble.</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSFRAME-ENS-SEC"><constant>AATSCMH_RSFRAME_PRI_SEC</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Secondary Ensemble.</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSFRAME-RES"><constant>AATSCMH_RSFRAME_RES</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reserved. Shouldn't be used.</entry>
 	</row>
         </tbody>
     </tgroup>
@@ -781,7 +784,7 @@ typedef enum fe_delivery_system {
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-PRI">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_PRI</constant></title>
-			<para>RS code mode (primary).</para>
+			<para>Reed Solomon (RS) code mode (primary).</para>
 			<para>Possible values are:</para>
 <table pgwide="1" frame="none" id="atscmh-rs-code-mode">
     <title>enum atscmh_rs_code_mode</title>
@@ -796,16 +799,16 @@ typedef enum fe_delivery_system {
 	<tbody valign="top">
 	<row>
 	    <entry id="ATSCMH-RSCODE-211-187"><constant>ATSCMH_RSCODE_211_187</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reed Solomon code (211,187).</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSCODE-223-187"><constant>ATSCMH_RSCODE_223_187</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reed Solomon code (223,187).</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSCODE-235-187"><constant>ATSCMH_RSCODE_235_187</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reed Solomon code (235,187).</entry>
 	</row><row>
 	    <entry id="ATSCMH-RSCODE-RES"><constant>ATSCMH_RSCODE_RES</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reserved. Shouldn't be used.</entry>
 	</row>
         </tbody>
     </tgroup>
@@ -813,7 +816,7 @@ typedef enum fe_delivery_system {
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-SEC">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_SEC</constant></title>
-			<para>RS code mode (secondary).</para>
+			<para>Reed Solomon (RS) code mode (secondary).</para>
 			<para>Possible values are the same as documented on
 			    &atscmh-rs-code-mode;:</para>
 		</section>
@@ -834,13 +837,15 @@ typedef enum fe_delivery_system {
 	<tbody valign="top">
 	<row>
 	    <entry id="ATSCMH-SCCC-BLK-SEP"><constant>ATSCMH_SCCC_BLK_SEP</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Separate SCCC: the SCCC outer code mode shall be set independently
+		for each Group Region (A, B, C, D)</entry>
 	</row><row>
 	    <entry id="ATSCMH-SCCC-BLK-COMB"><constant>ATSCMH_SCCC_BLK_COMB</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Combined SCCC: all four Regions shall have the same SCCC outer
+		code mode.</entry>
 	</row><row>
 	    <entry id="ATSCMH-SCCC-BLK-RES"><constant>ATSCMH_SCCC_BLK_RES</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>Reserved. Shouldn't be used.</entry>
 	</row>
         </tbody>
     </tgroup>
@@ -863,10 +868,10 @@ typedef enum fe_delivery_system {
 	<tbody valign="top">
 	<row>
 	    <entry id="ATSCMH-SCCC-CODE-HLF"><constant>ATSCMH_SCCC_CODE_HLF</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>The outer code rate of a SCCC Block is 1/2 rate.</entry>
 	</row><row>
 	    <entry id="ATSCMH-SCCC-CODE-QTR"><constant>ATSCMH_SCCC_CODE_QTR</constant></entry>
-	    <entry>to be documented.</entry>
+	    <entry>The outer code rate of a SCCC Block is 1/4 rate.</entry>
 	</row><row>
 	    <entry id="ATSCMH-SCCC-CODE-RES"><constant>ATSCMH_SCCC_CODE_RES</constant></entry>
 	    <entry>to be documented.</entry>
-- 
2.4.2

