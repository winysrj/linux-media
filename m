Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 10/35] DocBook: improve documentation for FE_READ_STATUS
Date: Thu, 28 May 2015 18:49:13 -0300
Message-Id: <f2898351cdcaa3ed6a69375b61f6fb5e5db127d0.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the ioctl and enum fe_status to a separate xml file and
put it into a better format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/frontend_read_status.xml

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 86346189e8fb..28acf5a1e9ff 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -33,12 +33,21 @@ specification is available at
 <section id="query-dvb-frontend-info">
 <title>Querying frontend information</title>
 
-<para>Information about the frontend ca be queried with
+<para>Information about the frontend can be queried with
 	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
 </section>
 
 &sub-frontend_get_info;
 
+<section id="dvb-fe-read-status">
+<title>Querying frontend status</title>
+
+<para>Information about the frontend tuner locking status can be queried with
+	<link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
+</section>
+
+&sub-frontend_read_status;
+
 <section id="dvb-diseqc-master-cmd">
 <title>diseqc master command</title>
 
@@ -109,51 +118,6 @@ spec.</para>
 <para></para>
 </section>
 
-<section id="fe-status-t">
-<title>frontend status</title>
-<para>Several functions of the frontend device use the fe_status data type defined
-by</para>
-<programlisting>
-typedef enum fe_status {
-	FE_HAS_SIGNAL		= 0x01,
-	FE_HAS_CARRIER		= 0x02,
-	FE_HAS_VITERBI		= 0x04,
-	FE_HAS_SYNC		= 0x08,
-	FE_HAS_LOCK		= 0x10,
-	FE_TIMEDOUT		= 0x20,
-	FE_REINIT		= 0x40,
-} fe_status_t;
-</programlisting>
-<para>to indicate the current state and/or state changes of the frontend hardware:
-</para>
-
-<informaltable><tgroup cols="2"><tbody>
-<row>
-<entry align="char">FE_HAS_SIGNAL</entry>
-<entry align="char">The frontend has found something above the noise level</entry>
-</row><row>
-<entry align="char">FE_HAS_CARRIER</entry>
-<entry align="char">The frontend has found a DVB signal</entry>
-</row><row>
-<entry align="char">FE_HAS_VITERBI</entry>
-<entry align="char">The frontend FEC inner coding (Viterbi, LDPC or other inner code) is stable</entry>
-</row><row>
-<entry align="char">FE_HAS_SYNC</entry>
-<entry align="char">Synchronization bytes was found</entry>
-</row><row>
-<entry align="char">FE_HAS_LOCK</entry>
-<entry align="char">The DVB were locked and everything is working</entry>
-</row><row>
-<entry align="char">FE_TIMEDOUT</entry>
-<entry align="char">no lock within the last about 2 seconds</entry>
-</row><row>
-<entry align="char">FE_REINIT</entry>
-<entry align="char">The frontend was reinitialized, application is
-recommended to reset DiSEqC, tone and parameters</entry>
-</row>
-</tbody></tgroup></informaltable>
-</section>
-
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -437,69 +401,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="FE_READ_STATUS">
-<title>FE_READ_STATUS</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns status information about the front-end. This call only
- requires read-only access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_READ_STATUS">FE_READ_STATUS</link>,
- fe_status_t &#x22C6;status);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-
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
-<para>Equals <link linkend="FE_READ_STATUS">FE_READ_STATUS</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct fe_status_t
- *status</para>
-</entry><entry
- align="char">
-<para>Points to the location where the front-end status word is
- to be stored.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURN VALUE</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>status points to invalid address.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-</section>
-
 
 <section id="FE_DISEQC_RESET_OVERLOAD">
 <title>FE_DISEQC_RESET_OVERLOAD</title>
diff --git a/Documentation/DocBook/media/dvb/frontend_read_status.xml b/Documentation/DocBook/media/dvb/frontend_read_status.xml
new file mode 100644
index 000000000000..f2d08b6e2422
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/frontend_read_status.xml
@@ -0,0 +1,103 @@
+<refentry id="FE_READ_STATUS">
+  <refmeta>
+    <refentrytitle>ioctl FE_READ_STATUS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_READ_STATUS</refname>
+    <refpurpose>Returns status information about the front-end. This call only
+ requires read-only access to the device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&fe-status; *<parameter>argp</parameter></paramdef>
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
+	  <para>FE_READ_STATUS</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	    <para>pointer to &fe-status;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>All DVB frontend devices support the
+<constant>FE_READ_STATUS</constant> ioctl. It is used to check about the
+locking status of the frontend after being tuned. The ioctl takes a
+pointer to a 16-bits number where the status will be written.
+&return-value-dvb;.
+</para>
+</refsect1>
+
+<section id="fe-status-t">
+<title>enum fe_status</title>
+
+<para>The enum fe_status is used to indicate the current state
+    and/or state changes of the frontend hardware.</para>
+
+<table pgwide="1" frame="none" id="fe-status">
+    <title>enum fe_status</title>
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
+	    <entry align="char">FE_HAS_SIGNAL</entry>
+	    <entry align="char">The frontend has found something above the noise level</entry>
+	</row><row>
+	    <entry align="char">FE_HAS_CARRIER</entry>
+	    <entry align="char">The frontend has found a DVB signal</entry>
+	</row><row>
+	    <entry align="char">FE_HAS_VITERBI</entry>
+	    <entry align="char">The frontend FEC inner coding (Viterbi, LDPC or other inner code) is stable</entry>
+	</row><row>
+	    <entry align="char">FE_HAS_SYNC</entry>
+	    <entry align="char">Synchronization bytes was found</entry>
+	</row><row>
+	    <entry align="char">FE_HAS_LOCK</entry>
+	    <entry align="char">The DVB were locked and everything is working</entry>
+	</row><row>
+	    <entry align="char">FE_TIMEDOUT</entry>
+	    <entry align="char">no lock within the last about 2 seconds</entry>
+	</row><row>
+	    <entry align="char">FE_REINIT</entry>
+	    <entry align="char">The frontend was reinitialized, application is
+	    recommended to reset DiSEqC, tone and parameters</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+</refentry>
-- 
2.4.1

