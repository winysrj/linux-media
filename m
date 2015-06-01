Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbFAJNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 05:13:05 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] DocBook: some fixes for DVB FE open()
Date: Mon,  1 Jun 2015 06:12:52 -0300
Message-Id: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The changeset dc9ef7d11207 change the open() ioctl documentation to
match the V4L2 open(). However, some cut-and-pasted stuff doesn't
match what actually happens at the DVB core.

So, fix the documentation entry to be more accurate with the DVB
frontend open() specifics.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index c7fa3d8bff5c..9d8e95cd9694 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -61,7 +61,7 @@ specification is available at
 
 <refentry id="frontend_f_open">
   <refmeta>
-    <refentrytitle>open()</refentrytitle>
+    <refentrytitle>DVB frontend open()</refentrytitle>
     &manvol;
   </refmeta>
 
@@ -94,20 +94,19 @@ specification is available at
       <varlistentry>
 	<term><parameter>flags</parameter></term>
 	<listitem>
-	  <para>Open flags. Access mode must be
-<constant>O_RDWR</constant>. This is just a technicality, input devices
-still support only reading and output devices only writing.</para>
-	  <para>When the <constant>O_NONBLOCK</constant> flag is
-given, the read() function will return the &EAGAIN; when no data is available,
-otherwise these functions block until data becomes
-available. Other flags have no effect.</para>
+	  <para>Open flags. Access can either be
+              <constant>O_RDWR</constant> or <constant>O_RDONLY</constant>.</para>
+          <para>Multiple opens are allowed with <constant>O_RDONLY</constant>. In this mode, only query and read ioctls are allowed.</para>
+          <para>Only one open is allowed in <constant>O_RDWR</constant>. In this mode, all ioctls are allowed.</para>
+	  <para>When the <constant>O_NONBLOCK</constant> flag is given, the system calls may return &EAGAIN; when no data is available or when the device driver is temporarily busy.</para>
+         <para>Other flags have no effect.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
   <refsect1>
     <title>Description</title>
-<para>This system call opens a named frontend device (/dev/dvb/adapter0/frontend0)
+    <para>This system call opens a named frontend device (<constant>/dev/dvb/adapter?/frontend?</constant>)
  for subsequent use. Usually the first thing to do after a successful open is to
  find out the frontend type with <link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
 <para>The device can be opened in read-only mode, which only allows monitoring of
@@ -145,8 +144,7 @@ device.</para>
       <varlistentry>
 	<term><errorcode>EBUSY</errorcode></term>
 	<listitem>
-	  <para>The driver does not support multiple opens and the
-device is already in use.</para>
+	  <para>The the device driver is already in use.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -177,13 +175,19 @@ files open.</para>
 system has been reached.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENODEV</errorcode></term>
+	<listitem>
+	  <para>The device got removed.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
 
 <refentry id="frontend_f_close">
   <refmeta>
-    <refentrytitle>close()</refentrytitle>
+    <refentrytitle>DVB frontend close()</refentrytitle>
     &manvol;
   </refmeta>
 
-- 
2.4.1

