Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbbE2TWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 15:22:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 5/5] DocBook: Update DocBook version and fix a few legacy things
Date: Fri, 29 May 2015 16:22:08 -0300
Message-Id: <2410e2d42ade96b2ef77109b0b47bc6f39225706.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB part of the media API documentation has several
legacy things on it:
	- Examples that don't work;
	- APIs unused and deprecated;
	- places mentioning the wrong API version.

Fix them and bump the documentation version, in order to
reflect the cleanup efforts to make it more consistent with
the current status of the API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 4c15396c67e5..dc8cb558f9fd 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -28,13 +28,23 @@
 	<holder>Convergence GmbH</holder>
 </copyright>
 <copyright>
-	<year>2009-2014</year>
+	<year>2009-2015</year>
 	<holder>Mauro Carvalho Chehab</holder>
 </copyright>
 
 <revhistory>
 <!-- Put document revisions here, newest first. -->
 <revision>
+	<revnumber>2.1.0</revnumber>
+	<date>2015-05-29</date>
+	<authorinitials>mcc</authorinitials>
+	<revremark>
+		DocBook improvements and cleanups, in order to document the
+		system calls on a more standard way and provide more description
+		about the current DVB API.
+	</revremark>
+</revision>
+<revision>
 	<revnumber>2.0.4</revnumber>
 	<date>2011-05-06</date>
 	<authorinitials>mcc</authorinitials>
@@ -95,18 +105,26 @@ Added ISDB-T test originally written by Patrick Boettcher
   <chapter id="dvb_demux">
     &sub-demux;
   </chapter>
-  <chapter id="dvb_video">
-    &sub-video;
-  </chapter>
-  <chapter id="dvb_audio">
-    &sub-audio;
-  </chapter>
   <chapter id="dvb_ca">
     &sub-ca;
   </chapter>
   <chapter id="dvb_net">
     &sub-net;
   </chapter>
+  <chapter id="legacy_dvb_apis">
+  <title>DVB Deprecated APIs</title>
+  <para>The APIs described here are kept only for historical reasons. There's
+      just one driver for a very legacy hardware that uses this API. No
+      modern drivers should use it. Instead, audio and video should be using
+      the V4L2 and ALSA APIs, and the pipelines should be set using the
+      Media Controller API</para>
+    <section id="dvb_video">
+	&sub-video;
+    </section>
+    <section id="dvb_audio">
+	&sub-audio;
+    </section>
+  </chapter>
   <chapter id="dvb_kdapi">
     &sub-kdapi;
   </chapter>
diff --git a/Documentation/DocBook/media/dvb/examples.xml b/Documentation/DocBook/media/dvb/examples.xml
index f037e568eb6e..c9f68c7183cc 100644
--- a/Documentation/DocBook/media/dvb/examples.xml
+++ b/Documentation/DocBook/media/dvb/examples.xml
@@ -1,8 +1,10 @@
 <title>Examples</title>
 <para>In this section we would like to present some examples for using the DVB API.
 </para>
-<para>Maintainer note: This section is out of date. Please refer to the sample programs packaged
-with the driver distribution from <ulink url="http://linuxtv.org/hg/dvb-apps" />.
+<para>NOTE: This section is out of date, and the code below won't even
+    compile. Please refer to the
+    <ulink url="http://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>
+    for updated/recommended examples.
 </para>
 
 <section id="tuning">
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 4a34ef4783a4..1f7a35a2b365 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -205,7 +205,7 @@ a partial path like:</para>
 additional include file <emphasis
 role="bold">linux/dvb/version.h</emphasis> exists, which defines the
 constant <emphasis role="bold">DVB_API_VERSION</emphasis>. This document
-describes <emphasis role="bold">DVB_API_VERSION 5.8</emphasis>.
+describes <emphasis role="bold">DVB_API_VERSION 5.10</emphasis>.
 </para>
 
 </section>
-- 
2.4.1

