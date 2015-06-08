Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbbFHTyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org, Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 11/26] [media] DocBook: add placeholders for ATSC M/H properties
Date: Mon,  8 Jun 2015 16:53:55 -0300
Message-Id: <e40328e03e4404f3de0b07fc0d389a0d6dbce2df.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ATSC M/H specific properties are not properly documented.
This became crearer when converting the existing data into
tables and adding cross references.

For now, just add placeholders, as a further investigation
about the meaning of each parameter is required.

Cc: Michael Ira Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 7e5147e6c2f2..275788875655 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -726,114 +726,172 @@ typedef enum fe_delivery_system {
 		</section>
 		<section id="DTV-ATSCMH-RS-FRAME-MODE">
 			<title><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></title>
-			<para>RS frame mode.</para>
+			<para>Reed Solomon (RS) frame mode.</para>
 			<para>Possible values are:</para>
-		  <para id="atscmh-rs-frame-mode">
-<programlisting>
-typedef enum atscmh_rs_frame_mode {
-	ATSCMH_RSFRAME_PRI_ONLY  = 0,
-	ATSCMH_RSFRAME_PRI_SEC   = 1,
-} atscmh_rs_frame_mode_t;
-</programlisting>
-		  </para>
+<table pgwide="1" frame="none" id="atscmh-rs-frame-mode">
+    <title>enum atscmh_rs_frame_mode</title>
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
+	    <entry id="ATSCMH-RSFRAME-PRI-ONLY"><constant>ATSCMH_RSFRAME_PRI_ONLY</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSFRAME-PRI-SEC"><constant>ATSCMH_RSFRAME_PRI_SEC</constant></entry>
+	    <entry>to be documented.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 		<section id="DTV-ATSCMH-RS-FRAME-ENSEMBLE">
 			<title><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></title>
 			<para>RS frame ensemble.</para>
 			<para>Possible values are:</para>
-		  <para id="atscmh-rs-frame-ensemble">
-<programlisting>
-typedef enum atscmh_rs_frame_ensemble {
-	ATSCMH_RSFRAME_ENS_PRI   = 0,
-	ATSCMH_RSFRAME_ENS_SEC   = 1,
-} atscmh_rs_frame_ensemble_t;
-</programlisting>
-		  </para>
+<table pgwide="1" frame="none" id="atscmh-rs-frame-ensemble">
+    <title>enum atscmh_rs_frame_ensemble</title>
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
+	    <entry id="ATSCMH-RSFRAME-ENS-PRI"><constant>ATSCMH_RSFRAME_ENS_PRI</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSFRAME-ENS-SEC"><constant>AATSCMH_RSFRAME_PRI_SEC</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSFRAME-RES"><constant>AATSCMH_RSFRAME_RES</constant></entry>
+	    <entry>to be documented.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-PRI">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_PRI</constant></title>
 			<para>RS code mode (primary).</para>
 			<para>Possible values are:</para>
-		  <para id="atscmh-rs-code-mode">
-<programlisting>
-typedef enum atscmh_rs_code_mode {
-	ATSCMH_RSCODE_211_187    = 0,
-	ATSCMH_RSCODE_223_187    = 1,
-	ATSCMH_RSCODE_235_187    = 2,
-} atscmh_rs_code_mode_t;
-</programlisting>
-		  </para>
+<table pgwide="1" frame="none" id="atscmh-rs-code-mode">
+    <title>enum atscmh_rs_code_mode</title>
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
+	    <entry id="ATSCMH-RSCODE-211-187"><constant>ATSCMH_RSCODE_211_187</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSCODE-223-187"><constant>ATSCMH_RSCODE_223_187</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSCODE-235-187"><constant>ATSCMH_RSCODE_235_187</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-RSCODE-RES"><constant>ATSCMH_RSCODE_RES</constant></entry>
+	    <entry>to be documented.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-SEC">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_SEC</constant></title>
 			<para>RS code mode (secondary).</para>
-			<para>Possible values are:</para>
-<programlisting>
-typedef enum atscmh_rs_code_mode {
-	ATSCMH_RSCODE_211_187    = 0,
-	ATSCMH_RSCODE_223_187    = 1,
-	ATSCMH_RSCODE_235_187    = 2,
-} atscmh_rs_code_mode_t;
-</programlisting>
+			<para>Possible values are the same as documented on
+			    &atscmh-rs-code-mode;:</para>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-BLOCK-MODE">
 			<title><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></title>
 			<para>Series Concatenated Convolutional Code Block Mode.</para>
 			<para>Possible values are:</para>
-		  <para id="atscmh-sccc-block-mode">
-<programlisting>
-typedef enum atscmh_sccc_block_mode {
-	ATSCMH_SCCC_BLK_SEP      = 0,
-	ATSCMH_SCCC_BLK_COMB     = 1,
-} atscmh_sccc_block_mode_t;
-</programlisting>
-		  </para>
+<table pgwide="1" frame="none" id="atscmh-sccc-block-mode">
+    <title>enum atscmh_scc_block_mode</title>
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
+	    <entry id="ATSCMH-SCCC-BLK-SEP"><constant>ATSCMH_SCCC_BLK_SEP</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-SCCC-BLK-COMB"><constant>ATSCMH_SCCC_BLK_COMB</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-SCCC-BLK-RES"><constant>ATSCMH_SCCC_BLK_RES</constant></entry>
+	    <entry>to be documented.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-A">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></title>
 			<para>Series Concatenated Convolutional Code Rate.</para>
 			<para>Possible values are:</para>
-		  <para id="atscmh-sccc-code-mode">
-<programlisting>
-typedef enum atscmh_sccc_code_mode {
-	ATSCMH_SCCC_CODE_HLF     = 0,
-	ATSCMH_SCCC_CODE_QTR     = 1,
-} atscmh_sccc_code_mode_t;
-</programlisting>
-		  </para>
+<table pgwide="1" frame="none" id="atscmh-sccc-code-mode">
+    <title>enum atscmh_sccc_code_mode</title>
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
+	    <entry id="ATSCMH-SCCC-CODE-HLF"><constant>ATSCMH_SCCC_CODE_HLF</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-SCCC-CODE-QTR"><constant>ATSCMH_SCCC_CODE_QTR</constant></entry>
+	    <entry>to be documented.</entry>
+	</row><row>
+	    <entry id="ATSCMH-SCCC-CODE-RES"><constant>ATSCMH_SCCC_CODE_RES</constant></entry>
+	    <entry>to be documented.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-B">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></title>
 			<para>Series Concatenated Convolutional Code Rate.</para>
-			<para>Possible values are:</para>
-<programlisting>
-typedef enum atscmh_sccc_code_mode {
-	ATSCMH_SCCC_CODE_HLF     = 0,
-	ATSCMH_SCCC_CODE_QTR     = 1,
-} atscmh_sccc_code_mode_t;
-</programlisting>
+			<para>Possible values are the same as documented on
+			    &atscmh-sccc-code-mode;.</para>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-C">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></title>
 			<para>Series Concatenated Convolutional Code Rate.</para>
-			<para>Possible values are:</para>
-<programlisting>
-typedef enum atscmh_sccc_code_mode {
-	ATSCMH_SCCC_CODE_HLF     = 0,
-	ATSCMH_SCCC_CODE_QTR     = 1,
-} atscmh_sccc_code_mode_t;
-</programlisting>
+			<para>Possible values are the same as documented on
+			    &atscmh-sccc-code-mode;.</para>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-D">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></title>
 			<para>Series Concatenated Convolutional Code Rate.</para>
-			<para>Possible values are:</para>
-<programlisting>
-typedef enum atscmh_sccc_code_mode {
-	ATSCMH_SCCC_CODE_HLF     = 0,
-	ATSCMH_SCCC_CODE_QTR     = 1,
-} atscmh_sccc_code_mode_t;
-</programlisting>
+			<para>Possible values are the same as documented on
+			    &atscmh-sccc-code-mode;.</para>
 		</section>
 	</section>
 	<section id="DTV-API-VERSION">
-- 
2.4.2

