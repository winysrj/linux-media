Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbE1Vtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 32/35] DocBook: Provide a high-level description for DVB frontend
Date: Thu, 28 May 2015 18:49:35 -0300
Message-Id: <575a0cc7bafa09eb42b50d404b93a0747135400b.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just showing ioctls, let's add an introdutory text
briefly explaining the DVB frontend API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index bcee1d9fc73d..16a4648043d6 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -29,19 +29,29 @@
 specification is available at
 <ulink url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
 
-
 <section id="query-dvb-frontend-info">
 <title>Querying frontend information</title>
 
-<para>Information about the frontend can be queried with
-	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
+<para>Usually, the first thing to do when the frontend is opened is to
+    check the frontend capabilities. This is done using <link linkend="FE_GET_INFO">FE_GET_INFO</link>. This ioctl will enumerate
+    the DVB API version and other characteristics about the frontend, and
+    can be opened either in read only or read/write mode.</para>
 </section>
 
 <section id="dvb-fe-read-status">
-<title>Querying frontend status</title>
+<title>Querying frontend status and statistics</title>
 
-<para>Information about the frontend tuner locking status can be queried with
-	<link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
+<para>Once <link linkend="FE_GET_PROPERTY"><constant>FE_SET_PROPERTY</constant></link>
+    is called, the frontend will run a kernel thread that will periodically
+    check for the tuner lock status and provide statistics about the quality
+    of the signal.</para>
+<para>The information about the frontend tuner locking status can be queried
+    using <link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
+<para>Signal statistics are provided via <link linkend="FE_GET_PROPERTY"><constant>FE_GET_PROPERTY</constant></link>.
+    Please notice that several statistics require the demodulator to be fully
+    locked (e. g. with FE_HAS_LOCK bit set). See
+    <xref linkend="frontend-stat-properties">Frontend statistics indicators</xref>
+    for more details.</para>
 </section>
 
 &sub-dvbproperty;
-- 
2.4.1

