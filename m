Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 29/35] DocBook: better document FE_DISEQC_RESET_OVERLOAD
Date: Thu, 28 May 2015 18:49:32 -0300
Message-Id: <eef99691e0f7d4869ff8932cc5e0dccccac57878.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new format for the ioctl documentation and put the
struct dvb_diseqc_slave_reply together with the ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml b/Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
new file mode 100644
index 000000000000..c104df77ecd0
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
@@ -0,0 +1,51 @@
+<refentry id="FE_DISEQC_RESET_OVERLOAD">
+  <refmeta>
+    <refentrytitle>ioctl FE_DISEQC_RESET_OVERLOAD</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_DISEQC_RESET_OVERLOAD</refname>
+    <refpurpose>Restores the power to the antenna subsystem, if it was powered
+	off due to power overload.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>NULL</paramdef>
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
+	  <para>FE_DISEQC_RESET_OVERLOAD</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>If the bus has been automatically powered off due to power overload, this ioctl
+ call restores the power to the bus. The call requires read/write access to the
+ device. This call has no effect if the device is manually powered off. Not all
+ DVB adapters support this ioctl.</para>
+&return-value-dvb;
+</refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index f7bb2db07c23..86bd9ed9d7f8 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -333,50 +333,7 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 </section>
 
-
-<section id="FE_DISEQC_RESET_OVERLOAD">
-<title>FE_DISEQC_RESET_OVERLOAD</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>If the bus has been automatically powered off due to power overload, this ioctl
- call restores the power to the bus. The call requires read/write access to the
- device. This call has no effect if the device is manually powered off. Not all
- DVB adapters support this ioctl.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request =
- <link linkend="FE_DISEQC_RESET_OVERLOAD">FE_DISEQC_RESET_OVERLOAD</link>);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_DISEQC_RESET_OVERLOAD">FE_DISEQC_RESET_OVERLOAD</link> for this
- command.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
+&sub-fe-diseqc-reset-overload;
 &sub-fe-diseqc-send-master-cmd;
 &sub-fe-diseqc-recv-slave-reply;
 &sub-fe-diseqc-send-burst;
-- 
2.4.1

