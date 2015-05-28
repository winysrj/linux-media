Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbbE1Vtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 23/35] DocBook: reformat FE_ENABLE_HIGH_LNB_VOLTAGE ioctl
Date: Thu, 28 May 2015 18:49:26 -0300
Message-Id: <d21a6bdb0008b1e2ede2f5e59c0ce8b981dc829a.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the proper format for FE_ENABLE_HIGH_LNB_VOLTAGE documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml

diff --git a/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml b/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
new file mode 100644
index 000000000000..3ee08a82cc7c
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
@@ -0,0 +1,61 @@
+<refentry id="FE_ENABLE_HIGH_LNB_VOLTAGE">
+  <refmeta>
+    <refentrytitle>ioctl FE_ENABLE_HIGH_LNB_VOLTAGE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_ENABLE_HIGH_LNB_VOLTAGE</refname>
+    <refpurpose>Select output DC level between normal LNBf voltages or higher
+	LNBf voltages.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>unsigned int <parameter>high</parameter></paramdef>
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
+	  <para>FE_ENABLE_HIGH_LNB_VOLTAGE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>high</parameter></term>
+	<listitem>
+	    <para>Valid flags:</para>
+	    <itemizedlist>
+		<listitem>0 - normal 13V and 18V.</listitem>
+		<listitem>&gt;0 - enables slightly higher voltages instead of
+		    13/18V, in order to compensate for long antena cables.</listitem>
+	    </itemizedlist>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>Select output DC level between normal LNBf voltages or higher
+	LNBf voltages between 0 (normal) or a value grater than 0 for higher
+	voltages.</para>
+&return-value-dvb;
+</refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 645f92bec767..bb2cd9ef3b03 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -689,55 +689,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_ENABLE_HIGH_LNB_VOLTAGE">
-<title>FE_ENABLE_HIGH_LNB_VOLTAGE</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>If high != 0 enables slightly higher voltages instead of 13/18V (to compensate
- for long cables). This call requires read/write permissions. Not all DVB
- adapters support this ioctl.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request =
- <link linkend="FE_ENABLE_HIGH_LNB_VOLTAGE">FE_ENABLE_HIGH_LNB_VOLTAGE</link>, int high);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
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
-<para>Equals <link linkend="FE_SET_VOLTAGE">FE_SET_VOLTAGE</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int high</para>
-</entry><entry
- align="char">
-<para>The requested bus voltage.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
+&sub-fe-enable-high-lnb-voltage;
 &sub-fe-set-frontend-tune-mode;
 
 </section>
-- 
2.4.1

