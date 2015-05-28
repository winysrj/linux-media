Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbbE1Vtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 14/35] DocBook: Merge FE_SET_PROPERTY/FE_GET_PROPERTY ioctl description
Date: Thu, 28 May 2015 18:49:17 -0300
Message-Id: <8a5429faf9868e57043fe36a8ee478b14f2f4365.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having two refentries, merge them into just one,
like what's done with other similar ioctls at V4L2 side.

That makes the entry cleaner and will allow to add the associated
structures together with the refentry.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index f2f57861f0c8..f8380219afbb 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -179,7 +179,6 @@ DOCUMENTED = \
 	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
 
 DVB_DOCUMENTED = \
-	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
@@ -189,6 +188,7 @@ DVB_DOCUMENTED = \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link\s\+linkend=\".*\">\(__.*_OLD\)<\/link>,\1,g" \
+	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
 
 #
 # Media targets and dependencies
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index f9680b0302b3..28ea62067af6 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -70,7 +70,7 @@ struct dtv_properties {
 <section>
 	<title>Property types</title>
 <para>
-On <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link>/<link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link>,
+On <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY and FE_SET_PROPERTY</link>,
 the actual action is determined by the dtv_property cmd/data pairs. With one single ioctl, is possible to
 get/set up to 64 properties. The actual meaning of each property is described on the next sections.
 </para>
@@ -1223,14 +1223,14 @@ enum fe_interleaving {
 
 <refentry id="FE_GET_PROPERTY">
   <refmeta>
-    <refentrytitle>ioctl FE_GET_PROPERTY</refentrytitle>
+    <refentrytitle>ioctl FE_SET_PROPERTY, FE_GET_PROPERTY</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
-    <refname>FE_GET_PROPERTY</refname>
-    <refpurpose>Returns one or more frontend properties. This call only
- requires read-only access to the device</refpurpose>
+    <refname>FE_SET_PROPERTY and FE_GET_PROPERTY</refname>
+    <refpurpose>FE_SET_PROPERTY sets one or more frontend properties.
+	FE_GET_PROPERTY returns one or more frontend properties.</refpurpose>
   </refnamediv>
 
   <refsynopsisdiv>
@@ -1256,7 +1256,7 @@ enum fe_interleaving {
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>FE_GET_PROPERTY</para>
+	  <para>FE_SET_PROPERTY, FE_GET_PROPERTY</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -1272,68 +1272,32 @@ enum fe_interleaving {
     <title>Description</title>
 
     <para>All DVB frontend devices support the
-<constant>FE_GET_PROPERTY</constant> ioctl. It is used to get properties and
-statistics from the frontend.
+<constant>FE_SET_PROPERTY</constant> and <constant>FE_GET_PROPERTY</constant>
+ioctls. The supported properties and statistics depends on the delivery system
+and on the device:</para>
+<itemizedlist>
+<listitem>
+    <para><constant>FE_SET_PROPERTY:</constant></para>
+<itemizedlist>
+<listitem>This ioctl is used to set one or more
+	frontend properties.</listitem>
+<listitem>This is the basic command to request the frontend to tune into some
+    frequency and to start decoding the digital TV signal.</listitem>
+<listitem>This call requires read/write access to the device.</listitem>
+<listitem>At return, the values are updated to reflect the
+    actual parameters used.</listitem>
+</itemizedlist>
+</listitem>
+<listitem>
+    <para><constant>FE_GET_PROPERTY:</constant></para>
+<itemizedlist>
+<listitem>This ioctl is used to get properties and
+statistics from the frontend.</listitem>
+<listitem>No properties are changed, and statistics aren't reset.</listitem>
+<listitem>This call only requires read-only access to the device.</listitem>
+</itemizedlist>
+</listitem>
+</itemizedlist>
 &return-value-dvb;.
-</para>
-</refsect1>
-</refentry>
-
-<refentry id="FE_SET_PROPERTY">
-  <refmeta>
-    <refentrytitle>ioctl FE_SET_PROPERTY</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>FE_SET_PROPERTY</refname>
-    <refpurpose>Sets one or more frontend properties. This call
- requires read/write access to the device</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dtv-property; *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-        <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fe_fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>FE_SET_PROPERTY</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	    <para>pointer to &dtv-property;</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <para>All DVB frontend devices support the
-<constant>FE_SET_PROPERTY</constant> ioctl. It is used to sets one or more
-frontend properties. This is the basic command to request the frontend to tune
-into some frequency and to start decoding the digital TV signal.
-&return-value-dvb;.
-</para>
 </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index f4d300488d12..e2817f830312 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -42,7 +42,7 @@
 </tbody></tgroup></table>
 
 <para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
-supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
+supported via the new <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
 </para>
 
 <para>The usage of this field is deprecated, as it doesn't report all supported standards, and
@@ -59,11 +59,11 @@ the kind of hardware you are using.</para>
 union with specific per-system parameters. However, as newer delivery systems
 required more data, the structure size weren't enough to fit, and just
 extending its size would break the existing applications. So, those parameters
-were replaced by the usage of <link linkend="FE_GET_SET_PROPERTY">
+were replaced by the usage of <link linkend="FE_GET_PROPERTY">
 <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> ioctl's. The
 new API is flexible enough to add new parameters to existing delivery systems,
 and to add newer delivery systems.</para>
-<para>So, newer applications should use <link linkend="FE_GET_SET_PROPERTY">
+<para>So, newer applications should use <link linkend="FE_GET_PROPERTY">
 <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
 order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
 DVB-C2, ISDB, etc.</para>
-- 
2.4.1

