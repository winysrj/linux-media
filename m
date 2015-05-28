Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbbE1Vtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 21/35] DocBook: move FE_GET_PROPERTY to its own xml file
Date: Thu, 28 May 2015 18:49:24 -0300
Message-Id: <7319ec291e3a1027fa80468da05ecee5a0811b93.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That helps the xref logic at the Makefile to point to the
right place. Also, it becomes more organized and easier to
maintain if each ioctl have its own xml file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-get-property.xml

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 48faf5089675..12a31e628d34 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -35,6 +35,8 @@ the capability ioctls weren't implemented yet via the new way.</para>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
 
+&sub-fe-get-property;
+
 <section id="dtv-stats">
 <title>DTV stats type</title>
 <programlisting>
@@ -1247,85 +1249,3 @@ enum fe_interleaving {
 	</section>
 	</section>
 </section>
-
-<refentry id="FE_GET_PROPERTY">
-  <refmeta>
-    <refentrytitle>ioctl FE_SET_PROPERTY, FE_GET_PROPERTY</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-      <refname>FE_SET_PROPERTY</refname>
-      <refname>FE_GET_PROPERTY</refname>
-    <refpurpose>FE_SET_PROPERTY sets one or more frontend properties.
-	FE_GET_PROPERTY returns one or more frontend properties.</refpurpose>
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
-	  <para>FE_SET_PROPERTY, FE_GET_PROPERTY</para>
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
-<constant>FE_SET_PROPERTY</constant> and <constant>FE_GET_PROPERTY</constant>
-ioctls. The supported properties and statistics depends on the delivery system
-and on the device:</para>
-<itemizedlist>
-<listitem>
-    <para><constant>FE_SET_PROPERTY:</constant></para>
-<itemizedlist>
-<listitem>This ioctl is used to set one or more
-	frontend properties.</listitem>
-<listitem>This is the basic command to request the frontend to tune into some
-    frequency and to start decoding the digital TV signal.</listitem>
-<listitem>This call requires read/write access to the device.</listitem>
-<listitem>At return, the values are updated to reflect the
-    actual parameters used.</listitem>
-</itemizedlist>
-</listitem>
-<listitem>
-    <para><constant>FE_GET_PROPERTY:</constant></para>
-<itemizedlist>
-<listitem>This ioctl is used to get properties and
-statistics from the frontend.</listitem>
-<listitem>No properties are changed, and statistics aren't reset.</listitem>
-<listitem>This call only requires read-only access to the device.</listitem>
-</itemizedlist>
-</listitem>
-</itemizedlist>
-&return-value-dvb;.
-</refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
new file mode 100644
index 000000000000..b121fe5380ca
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-get-property.xml
@@ -0,0 +1,81 @@
+<refentry id="FE_GET_PROPERTY">
+  <refmeta>
+    <refentrytitle>ioctl FE_SET_PROPERTY, FE_GET_PROPERTY</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+      <refname>FE_SET_PROPERTY</refname>
+      <refname>FE_GET_PROPERTY</refname>
+    <refpurpose>FE_SET_PROPERTY sets one or more frontend properties.
+	FE_GET_PROPERTY returns one or more frontend properties.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&dtv-property; *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fe_fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_SET_PROPERTY, FE_GET_PROPERTY</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	    <para>pointer to &dtv-property;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>All DVB frontend devices support the
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
+&return-value-dvb;.
+</refsect1>
+</refentry>
-- 
2.4.1

