Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 31/35] DocBook: fix FE_READ_STATUS argument description
Date: Thu, 28 May 2015 18:49:34 -0300
Message-Id: <85a8983df42cccf9932d2251928f48c258c75fa7.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What's written there about the arguments for this ioctl
is bogus: it doesn't return an enum (or a typedef)
for enum fe_status. Instead, it returns a bitmask with the
values defined by enum fe_status.

Also, the size of the integer returned is not 16 bits, but,
instead, sizeof(fe_status_t), e. g. sizeof(enum), with is
arch-dependent.

This should of course be fixed, but this should be done on
a separate patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-read-status.xml b/Documentation/DocBook/media/dvb/fe-read-status.xml
index 9c1810ae920d..bbd0b5bb6b12 100644
--- a/Documentation/DocBook/media/dvb/fe-read-status.xml
+++ b/Documentation/DocBook/media/dvb/fe-read-status.xml
@@ -16,7 +16,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&fe-status; *<parameter>argp</parameter></paramdef>
+	<paramdef>unsigned int *<parameter>status</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -37,9 +37,10 @@
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><parameter>argp</parameter></term>
+	<term><parameter>status</parameter></term>
 	<listitem>
-	    <para>pointer to &fe-status;</para>
+	    <para>pointer to a bitmask integer filled with the values defined by
+		&fe-status;.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
@@ -51,16 +52,19 @@
     <para>All DVB frontend devices support the
 <constant>FE_READ_STATUS</constant> ioctl. It is used to check about the
 locking status of the frontend after being tuned. The ioctl takes a
-pointer to a 16-bits number where the status will be written.
-&return-value-dvb;.
+pointer to an integer where the status will be written.
 </para>
+<para>NOTE: the size of status is actually sizeof(enum fe_status), with varies
+    according with the architecture. This needs to be fixed in the future.</para>
+&return-value-dvb;
 </refsect1>
 
 <section id="fe-status-t">
-<title>enum fe_status</title>
+<title>int fe_status</title>
 
-<para>The enum fe_status is used to indicate the current state
-    and/or state changes of the frontend hardware.</para>
+<para>The fe_status parameter is used to indicate the current state
+    and/or state changes of the frontend hardware. It is produced using
+    the &fe-status; values on a bitmask</para>
 
 <table pgwide="1" frame="none" id="fe-status">
     <title>enum fe_status</title>
-- 
2.4.1

