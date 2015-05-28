Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbbE1Vtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 12/35] DocBook: rewrite FE_GET_PROPERTY/FE_SET_PROPERTY to use the std way
Date: Thu, 28 May 2015 18:49:15 -0300
Message-Id: <271e9ddefa5f4ab45b26dd653dcdd9d03a163099.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the standard way of documenting ioctls for FE_GET_PROPERTY
and FE_SET_PROPERTY.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 7ddab2ba9b40..272d2e5c7488 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -7,6 +7,7 @@ the capability ioctls weren't implemented yet via the new way.</para>
 <para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
+
 <section id="dtv-stats">
 <title>DTV stats type</title>
 <programlisting>
@@ -66,102 +67,6 @@ struct dtv_properties {
 </programlisting>
 </section>
 
-<section id="FE_GET_PROPERTY">
-<title>FE_GET_PROPERTY</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns one or more frontend properties. This call only
- requires read-only access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link>,
- dtv_properties &#x22C6;props);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int num</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct dtv_property *props</para>
-</entry><entry
- align="char">
-<para>Points to the location where the front-end property commands are stored.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-&return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row>
-  <entry align="char"><para>EOPNOTSUPP</para></entry>
-  <entry align="char"><para>Property type not supported.</para></entry>
- </row></tbody></tgroup></informaltable>
-</section>
-
-<section id="FE_SET_PROPERTY">
-<title>FE_SET_PROPERTY</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call sets one or more frontend properties. This call
- requires read/write access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link>,
- dtv_properties &#x22C6;props);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int num</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct dtv_property *props</para>
-</entry><entry
- align="char">
-<para>Points to the location where the front-end property commands are stored.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-&return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row>
-  <entry align="char"><para>EOPNOTSUPP</para></entry>
-  <entry align="char"><para>Property type not supported.</para></entry>
- </row></tbody></tgroup></informaltable>
-</section>
-
 <section>
 	<title>Property types</title>
 <para>
@@ -1315,3 +1220,120 @@ enum fe_interleaving {
 	</section>
 	</section>
 </section>
+
+<refentry id="FE_GET_PROPERTY">
+  <refmeta>
+    <refentrytitle>ioctl FE_GET_PROPERTY</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_GET_PROPERTY</refname>
+    <refpurpose>Returns one or more frontend properties. This call only
+ requires read-only access to the device</refpurpose>
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
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_GET_PROPERTY</para>
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
+<constant>FE_GET_PROPERTY</constant> ioctl. It is used to get properties and
+statistics from the frontend.
+&return-value-dvb;.
+</para>
+</refsect1>
+</refentry>
+
+<refentry id="FE_SET_PROPERTY">
+  <refmeta>
+    <refentrytitle>ioctl FE_SET_PROPERTY</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_SET_PROPERTY</refname>
+    <refpurpose>Sets one or more frontend properties. This call
+ requires read/write access to the device</refpurpose>
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
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_SET_PROPERTY</para>
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
+<constant>FE_SET_PROPERTY</constant> ioctl. It is used to sets one or more
+frontend properties. This is the basic command to request the frontend to tune
+into some frequency and to start decoding the digital TV signal.
+&return-value-dvb;.
+</para>
+</refsect1>
+</refentry>
-- 
2.4.1

