Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51743 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbEaM7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 08:59:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] DocBook media: rewrite frontend open/close
Date: Sun, 31 May 2015 14:59:12 +0200
Message-Id: <1433077152-18200-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

To fix the last xmllint errors the open and close function reference
description was rewritten based on the v4l2 open and close functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/frontend.xml | 281 +++++++++++++++------------
 1 file changed, 159 insertions(+), 122 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index ab42d8c..c7fa3d8 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -59,11 +59,54 @@ specification is available at
 <section id="frontend_fcalls">
 <title>Frontend Function Calls</title>
 
-<section id="frontend_f_open">
-<title>open()</title>
-<para>DESCRIPTION</para>
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
+<refentry id="frontend_f_open">
+  <refmeta>
+    <refentrytitle>open()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>fe-open</refname>
+    <refpurpose>Open a frontend device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;fcntl.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>open</function></funcdef>
+	<paramdef>const char *<parameter>device_name</parameter></paramdef>
+	<paramdef>int <parameter>flags</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>device_name</parameter></term>
+	<listitem>
+	  <para>Device to be opened.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>flags</parameter></term>
+	<listitem>
+	  <para>Open flags. Access mode must be
+<constant>O_RDWR</constant>. This is just a technicality, input devices
+still support only reading and output devices only writing.</para>
+	  <para>When the <constant>O_NONBLOCK</constant> flag is
+given, the read() function will return the &EAGAIN; when no data is available,
+otherwise these functions block until data becomes
+available. Other flags have no effect.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+  <refsect1>
+    <title>Description</title>
 <para>This system call opens a named frontend device (/dev/dvb/adapter0/frontend0)
  for subsequent use. Usually the first thing to do after a successful open is to
  find out the frontend type with <link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
@@ -82,127 +125,121 @@ specification is available at
  for use in the specified mode. This implies that the corresponding hardware is
  powered up, and that other front-ends may have been powered down to make
  that possible.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int open(const char &#x22C6;deviceName, int flags);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>const char
- *deviceName</para>
-</entry><entry
- align="char">
-<para>Name of specific video device.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int flags</para>
-</entry><entry
- align="char">
-<para>A bit-wise OR of the following flags:</para>
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
-<para>O_RDONLY read-only access</para>
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
-<para>O_RDWR read/write access</para>
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
-<para>O_NONBLOCK open in non-blocking mode</para>
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
-<para>(blocking mode is the default)</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>RETURN VALUE</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>ENODEV</para>
-</entry><entry
- align="char">
-<para>Device driver not loaded/available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EBUSY</para>
-</entry><entry
- align="char">
-<para>Device or resource busy.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-</section>
+  </refsect1>
 
-<section id="frontend_f_close">
-<title>close()</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
+  <refsect1>
+    <title>Return Value</title>
+
+    <para>On success <function>open</function> returns the new file
+descriptor. On error -1 is returned, and the <varname>errno</varname>
+variable is set appropriately. Possible error codes are:</para>
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EACCES</errorcode></term>
+	<listitem>
+	  <para>The caller has no permission to access the
+device.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>The driver does not support multiple opens and the
+device is already in use.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENXIO</errorcode></term>
+	<listitem>
+	  <para>No device corresponding to this device special file
+exists.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOMEM</errorcode></term>
+	<listitem>
+	  <para>Not enough kernel memory was available to complete the
+request.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EMFILE</errorcode></term>
+	<listitem>
+	  <para>The  process  already  has  the  maximum number of
+files open.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENFILE</errorcode></term>
+	<listitem>
+	  <para>The limit on the total number of files open on the
+system has been reached.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
+
+<refentry id="frontend_f_close">
+  <refmeta>
+    <refentrytitle>close()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>fe-close</refname>
+    <refpurpose>Close a frontend device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;unistd.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>close</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
 <para>This system call closes a previously opened front-end device. After closing
  a front-end device, its corresponding hardware might be powered down
  automatically.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int close(int fd);</para>
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
- </row></tbody></tgroup></informaltable>
-<para>RETURN VALUE</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-</section>
+</refsect1>
+  <refsect1>
+    <title>Return Value</title>
+
+    <para>The function returns <returnvalue>0</returnvalue> on
+success, <returnvalue>-1</returnvalue> on failure and the
+<varname>errno</varname> is set appropriately. Possible error
+codes:</para>
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EBADF</errorcode></term>
+	<listitem>
+	  <para><parameter>fd</parameter> is not a valid open file
+descriptor.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
 
 &sub-fe-get-info;
 &sub-fe-read-status;
-- 
2.1.4

