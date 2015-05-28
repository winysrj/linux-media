Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 27/35] DocBook: better document FE_DISEQC_RECV_SLAVE_REPLY
Date: Thu, 28 May 2015 18:49:30 -0300
Message-Id: <13d8dd5c0aeb5f3ccc4fd395e6365039691e1928.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new format for the ioctl documentation and put the
struct dvb_diseqc_slave_reply together with the ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml b/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
new file mode 100644
index 000000000000..de68b5b57476
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
@@ -0,0 +1,78 @@
+<refentry id="FE_DISEQC_RECV_SLAVE_REPLY">
+  <refmeta>
+    <refentrytitle>ioctl FE_DISEQC_RECV_SLAVE_REPLY</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_DISEQC_RECV_SLAVE_REPLY</refname>
+    <refpurpose>Receives reply from a DiSEqC 2.0 command</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&dvb-diseqc-slave-reply; *<parameter>argp</parameter></paramdef>
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
+	  <para>FE_DISEQC_RECV_SLAVE_REPLY</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	    <para>pointer to &dvb-diseqc-slave-reply;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>Receives reply from a DiSEqC 2.0 command.</para>
+&return-value-dvb;
+
+<table pgwide="1" frame="none" id="dvb-diseqc-slave-reply">
+    <title>struct <structname>dvb_diseqc_slave_reply</structname></title>
+    <tgroup cols="3">
+    &cs-str;
+    <tbody valign="top">
+	<row>
+	<entry>uint8_t</entry>
+	<entry>msg[4]</entry>
+	<entry>DiSEqC message (framing, data[3])</entry>
+	</row><row>
+	<entry>uint8_t</entry>
+	<entry>msg_len</entry>
+	<entry>Length of the DiSEqC message. Valid values are 0 to 4,
+	    where 0 means no msg</entry>
+	</row><row>
+	<entry>int</entry>
+	<entry>timeout</entry>
+	<entry>Return from ioctl after timeout ms with errorcode when no
+	    message was received</entry>
+	</row>
+    </tbody>
+    </tgroup>
+</table>
+
+</refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 17050152a48a..cba6c355637c 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -62,19 +62,6 @@ specification is available at
 </programlisting>
 </section>
 
-<section role="subsection" id="dvb-diseqc-slave-reply">
-<title>diseqc slave reply</title>
-
-<para>A reply to the frontend from DiSEqC 2.0 capable equipment.</para>
-<programlisting>
-	struct dvb_diseqc_slave_reply {
-	uint8_t msg [4]; /&#x22C6;  { framing, data [3] } &#x22C6;/
-	uint8_t msg_len; /&#x22C6;  valid values are 0...4, 0 means no msg  &#x22C6;/
-	int     timeout; /&#x22C6;  return from ioctl after timeout ms with &#x22C6;/
-	};                       /&#x22C6;  errorcode when no message was received  &#x22C6;/
-</programlisting>
-</section>
-
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -452,56 +439,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_DISEQC_RECV_SLAVE_REPLY">
-<title>FE_DISEQC_RECV_SLAVE_REPLY</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call is used to receive reply to a DiSEqC 2.0 command.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request =
- <link linkend="FE_DISEQC_RECV_SLAVE_REPLY">FE_DISEQC_RECV_SLAVE_REPLY</link>, struct
- dvb_diseqc_slave_reply &#x22C6;reply);</para>
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
-<para>Equals <link linkend="FE_DISEQC_RECV_SLAVE_REPLY">FE_DISEQC_RECV_SLAVE_REPLY</link> for this
- command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_diseqc_slave_reply
- *reply</para>
-</entry><entry
- align="char">
-<para>Pointer to the command to be received.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-&return-value-dvb;
-</section>
-
+&sub-fe-diseqc-recv-slave-reply;
 &sub-fe-diseqc-send-burst;
 &sub-fe-set-tone;
 &sub-fe-set-voltage;
-- 
2.4.1

