Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422659AbbE2TWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 15:22:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 1/5] DocBook: improve documentation of the properties structs
Date: Fri, 29 May 2015 16:22:04 -0300
Message-Id: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the tytle of the struct documentation to reflect
the name of the structures, and use links to do cross-ref.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index ae9bc1e089cc..b91210d646cf 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -36,7 +36,7 @@ API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
 
 <section id="dtv-stats">
-<title>DTV stats type</title>
+<title>struct <structname>dtv_stats</structname></title>
 <programlisting>
 struct dtv_stats {
 	__u8 scale;	/* enum fecap_scale_params type */
@@ -48,19 +48,19 @@ struct dtv_stats {
 </programlisting>
 </section>
 <section id="dtv-fe-stats">
-<title>DTV stats type</title>
+<title>struct <structname>dtv_fe_stats</structname></title>
 <programlisting>
 #define MAX_DTV_STATS   4
 
 struct dtv_fe_stats {
 	__u8 len;
-	struct dtv_stats stat[MAX_DTV_STATS];
+	&dtv-stats; stat[MAX_DTV_STATS];
 } __packed;
 </programlisting>
 </section>
 
 <section id="dtv-property">
-<title>DTV property type</title>
+<title>struct <structname>dtv_property</structname></title>
 <programlisting>
 /* Reserved fields should be set to 0 */
 
@@ -69,7 +69,7 @@ struct dtv_property {
 	__u32 reserved[3];
 	union {
 		__u32 data;
-		struct dtv_fe_stats st;
+		&dtv-fe-stats; st;
 		struct {
 			__u8 data[32];
 			__u32 len;
@@ -85,11 +85,11 @@ struct dtv_property {
 </programlisting>
 </section>
 <section id="dtv-properties">
-<title>DTV properties type</title>
+<title>struct <structname>dtv_properties</structname></title>
 <programlisting>
 struct dtv_properties {
 	__u32 num;
-	struct dtv_property *props;
+	&dtv-property; *props;
 };
 </programlisting>
 </section>
diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
index b121fe5380ca..456ed92133f1 100644
--- a/Documentation/DocBook/media/dvb/fe-get-property.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-property.xml
@@ -17,7 +17,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dtv-property; *<parameter>argp</parameter></paramdef>
+	<paramdef>&dtv-properties; *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -40,7 +40,7 @@
       <varlistentry>
 	<term><parameter>argp</parameter></term>
 	<listitem>
-	    <para>pointer to &dtv-property;</para>
+	    <para>pointer to &dtv-properties;</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
2.4.1

