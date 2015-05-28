Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbbE1Vto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 22/35] DocBook: reformat FE_SET_FRONTEND_TUNE_MODE ioctl
Date: Thu, 28 May 2015 18:49:25 -0300
Message-Id: <b0ac361917cb97f04ba179680e788660f2b54165.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the proper format for FE_SET_FRONTEND_TUNE_MODE documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml

diff --git a/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml b/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
new file mode 100644
index 000000000000..30bc99dc4c1c
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
@@ -0,0 +1,64 @@
+<refentry id="FE_SET_FRONTEND_TUNE_MODE">
+  <refmeta>
+    <refentrytitle>ioctl FE_SET_FRONTEND_TUNE_MODE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_SET_FRONTEND_TUNE_MODE</refname>
+    <refpurpose>Allow setting tuner mode flags to the frontend.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>unsigned int <parameter>flags</parameter></paramdef>
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
+	  <para>FE_SET_FRONTEND_TUNE_MODE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>flags</parameter></term>
+	<listitem>
+	    <para>Valid flags:</para>
+	    <itemizedlist>
+		<listitem>0 - normal tune mode</listitem>
+		<listitem>FE_TUNE_MODE_ONESHOT - When set, this flag will
+		    disable any zigzagging or other "normal" tuning behaviour.
+		    Additionally, there will be no automatic monitoring of the
+		    lock status, and hence no frontend events will be
+		    generated. If a frontend device is closed, this flag will
+		    be automatically turned off when the device is reopened
+		    read-write.</listitem>
+	    </itemizedlist>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>Allow setting tuner mode flags to the frontend, between 0 (normal)
+	or FE_TUNE_MODE_ONESHOT mode</para>
+&return-value-dvb;
+</refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 079f631cc848..645f92bec767 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -738,37 +738,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_SET_FRONTEND_TUNE_MODE">
-<title>FE_SET_FRONTEND_TUNE_MODE</title>
-<para>DESCRIPTION</para>
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
-<para>Allow setting tuner mode flags to the frontend.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS</para>
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
-<para>int ioctl(int fd, int request =
-<link linkend="FE_SET_FRONTEND_TUNE_MODE">FE_SET_FRONTEND_TUNE_MODE</link>, unsigned int flags);</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS</para>
-<informaltable><tgroup cols="2"><tbody><row>
-<entry align="char">
-	<para>unsigned int flags</para>
-</entry>
-<entry align="char">
-<para>
-FE_TUNE_MODE_ONESHOT When set, this flag will disable any zigzagging or other "normal" tuning behaviour. Additionally, there will be no automatic monitoring of the lock status, and hence no frontend events will be generated. If a frontend device is closed, this flag will be automatically turned off when the device is reopened read-write.
-</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
+&sub-fe-set-frontend-tune-mode;
 
 </section>
 
-- 
2.4.1

