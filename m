Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbbE1Vtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 13/35] DocBook: fix xref to the FE open() function
Date: Thu, 28 May 2015 18:49:16 -0300
Message-Id: <18a58bf7f413c18420e10c91db779630114278cf.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of going to the V4L2 open(), use the xref to the
proper place at the frontend ioctls that were already
reformatted.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 272d2e5c7488..f9680b0302b3 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1250,7 +1250,7 @@ enum fe_interleaving {
       <varlistentry>
 	<term><parameter>fd</parameter></term>
 	<listitem>
-	  <para>&fd;</para>
+	  <para>&fe_fd;</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -1308,7 +1308,7 @@ statistics from the frontend.
       <varlistentry>
 	<term><parameter>fd</parameter></term>
 	<listitem>
-	  <para>&fd;</para>
+	  <para>&fe_fd;</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/Documentation/DocBook/media/dvb/frontend_get_info.xml b/Documentation/DocBook/media/dvb/frontend_get_info.xml
index d569e386fb15..b98a9a5e74d3 100644
--- a/Documentation/DocBook/media/dvb/frontend_get_info.xml
+++ b/Documentation/DocBook/media/dvb/frontend_get_info.xml
@@ -27,7 +27,7 @@
       <varlistentry>
 	<term><parameter>fd</parameter></term>
 	<listitem>
-	  <para>&fd;</para>
+	  <para>&fe_fd;</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/Documentation/DocBook/media/dvb/frontend_read_status.xml b/Documentation/DocBook/media/dvb/frontend_read_status.xml
index f2d08b6e2422..9c1810ae920d 100644
--- a/Documentation/DocBook/media/dvb/frontend_read_status.xml
+++ b/Documentation/DocBook/media/dvb/frontend_read_status.xml
@@ -27,7 +27,7 @@
       <varlistentry>
 	<term><parameter>fd</parameter></term>
 	<listitem>
-	  <para>&fd;</para>
+	  <para>&fe_fd;</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index d15c9c61e730..1e194514841c 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -7,6 +7,7 @@
 <!ENTITY eg                     "e.&nbsp;g.">
 <!ENTITY ie                     "i.&nbsp;e.">
 <!ENTITY fd                     "File descriptor returned by <link linkend='func-open'><function>open()</function></link>.">
+<!ENTITY fe_fd                  "File descriptor returned by <link linkend='frontend_f_open'><function>open()</function></link>.">
 <!ENTITY i2c                    "I<superscript>2</superscript>C">
 <!ENTITY return-value		"<title>Return Value</title><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately. The generic error codes are described at the <link linkend='gen-errors'>Generic Error Codes</link> chapter.</para>">
 <!ENTITY return-value-dvb	"<para>RETURN VALUE</para><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately. The generic error codes are described at the <link linkend='gen-errors'>Generic Error Codes</link> chapter.</para>">
-- 
2.4.1

