Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbbE1Vtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 28/35] DocBook: better document FE_DISEQC_SEND_MASTER_CMD
Date: Thu, 28 May 2015 18:49:31 -0300
Message-Id: <3f697f011b97508de8b53f8d56fc44f6f726834c.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new format for the ioctl documentation and put the
struct dvb_diseqc_slave_reply together with the ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
new file mode 100644
index 000000000000..d4d6cd8dfc6c
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
@@ -0,0 +1,72 @@
+<refentry id="FE_DISEQC_SEND_MASTER_CMD">
+  <refmeta>
+    <refentrytitle>ioctl FE_DISEQC_SEND_MASTER_CMD</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_DISEQC_SEND_MASTER_CMD</refname>
+    <refpurpose>Sends a DiSEqC command</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&dvb-diseqc-master-cmd; *<parameter>argp</parameter></paramdef>
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
+	  <para>FE_DISEQC_SEND_MASTER_CMD</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	    <para>pointer to &dvb-diseqc-master-cmd;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>Sends a DiSEqC command to the antenna subsystem.</para>
+&return-value-dvb;
+
+<table pgwide="1" frame="none" id="dvb-diseqc-master-cmd">
+    <title>struct <structname>dvb_diseqc_master_cmd</structname></title>
+    <tgroup cols="3">
+    &cs-str;
+    <tbody valign="top">
+	<row>
+	<entry>uint8_t</entry>
+	<entry>msg[6]</entry>
+	<entry>DiSEqC message (framing, address, command, data[3])</entry>
+	</row><row>
+	<entry>uint8_t</entry>
+	<entry>msg_len</entry>
+	<entry>Length of the DiSEqC message. Valid values are 3 to 6</entry>
+	</row>
+    </tbody>
+    </tgroup>
+</table>
+
+</refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index cba6c355637c..f7bb2db07c23 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -50,18 +50,6 @@ specification is available at
 
 &sub-dvbproperty;
 
-<section id="dvb-diseqc-master-cmd">
-<title>diseqc master command</title>
-
-<para>A message sent from the frontend to DiSEqC capable equipment.</para>
-<programlisting>
-	struct dvb_diseqc_master_cmd {
-	uint8_t msg [6]; /&#x22C6;  { framing, address, command, data[3] } &#x22C6;/
-	uint8_t msg_len; /&#x22C6;  valid values are 3...6  &#x22C6;/
-	};
-</programlisting>
-</section>
-
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -389,56 +377,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_DISEQC_SEND_MASTER_CMD">
-<title>FE_DISEQC_SEND_MASTER_CMD</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call is used to send a a DiSEqC command.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request =
- <link linkend="FE_DISEQC_SEND_MASTER_CMD">FE_DISEQC_SEND_MASTER_CMD</link>, struct
- dvb_diseqc_master_cmd &#x22C6;cmd);</para>
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
-<para>Equals <link linkend="FE_DISEQC_SEND_MASTER_CMD">FE_DISEQC_SEND_MASTER_CMD</link> for this
- command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_diseqc_master_cmd
- *cmd</para>
-</entry><entry
- align="char">
-<para>Pointer to the command to be transmitted.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
+&sub-fe-diseqc-send-master-cmd;
 &sub-fe-diseqc-recv-slave-reply;
 &sub-fe-diseqc-send-burst;
 &sub-fe-set-tone;
-- 
2.4.1

