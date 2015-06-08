Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 08/26] [media] DocBook: Better document DTMB time interleaving
Date: Mon,  8 Jun 2015 16:53:52 -0300
Message-Id: <a1c2c681e86953471925aa57f0a6f80e920f92f9.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DTMB time interleaving was not properly documented. Add
a documentation for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 816d5ac56164..33f2313aca07 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1068,15 +1068,37 @@ typedef enum atscmh_sccc_code_mode {
 	</section>
 	<section id="DTV-INTERLEAVING">
 	<title><constant>DTV_INTERLEAVING</constant></title>
-	<para id="fe-interleaving">Interleaving mode</para>
-	<programlisting>
-enum fe_interleaving {
-	INTERLEAVING_NONE,
-	INTERLEAVING_AUTO,
-	INTERLEAVING_240,
-	INTERLEAVING_720,
-};
-	</programlisting>
+
+<para>Time interleaving to be used. Currently, used only on DTMB.</para>
+
+<table pgwide="1" frame="none" id="fe-interleaving">
+    <title>enum fe_interleaving</title>
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
+	    <entry id="INTERLEAVING-NONE"><constant>INTERLEAVING_NONE</constant></entry>
+	    <entry>No interleaving.</entry>
+	</row><row>
+	    <entry id="INTERLEAVING-AUTO"><constant>INTERLEAVING_AUTO</constant></entry>
+	    <entry>Auto-detect interleaving.</entry>
+	</row><row>
+	    <entry id="INTERLEAVING-240"><constant>INTERLEAVING_240</constant></entry>
+	    <entry>Interleaving of 240 symbols.</entry>
+	</row><row>
+	    <entry id="INTERLEAVING-720"><constant>INTERLEAVING_720</constant></entry>
+	    <entry>Interleaving of 720 symbols.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+
 	</section>
 	<section id="DTV-LNA">
 	<title><constant>DTV_LNA</constant></title>
-- 
2.4.2

