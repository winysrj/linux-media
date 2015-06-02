Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbFBTww (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 15:52:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Masanari Iida <standby24x7@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: [PATCH 3/5] [media] Docbook: typo fix: use note(d)  instead of notice(d)
Date: Tue,  2 Jun 2015 16:52:41 -0300
Message-Id: <b2fc3b01c066c742ff1a1a9c79305fd93dbfc3ba.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't want to announce anything, but to add a note ;)
So:
	notice  -> note
	notided -> noted

While here, fix another typo at media_api.tmpl:
	with -> which

Reported-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 5dfde521e9fe..746b4e2ae346 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -193,7 +193,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 
 <para>Most of the digital TV standards currently offers more than one possible
     modulation (sometimes called as "constellation" on some standards). This
-    enum contains the values used by the Kernel. Please notice that not all
+    enum contains the values used by the Kernel. Please note that not all
     modulations are supported by a given standard.</para>
 
 <table pgwide="1" frame="none" id="fe-modulation">
@@ -1098,7 +1098,7 @@ enum fe_interleaving {
 	<para>For most delivery systems, <constant>dtv_property.stat.len</constant>
 	      will be 1 if the stats is supported, and the properties will
 	      return a single value for each parameter.</para>
-	<para>It should be noticed, however, that new OFDM delivery systems
+	<para>It should be noted, however, that new OFDM delivery systems
 	      like ISDB can use different modulation types for each group of
 	      carriers. On such standards, up to 3 groups of statistics can be
 	      provided, and <constant>dtv_property.stat.len</constant> is updated
@@ -1162,7 +1162,7 @@ enum fe_interleaving {
 		<title><constant>DTV_STAT_PRE_TOTAL_BIT_COUNT</constant></title>
 		<para>Measures the amount of bits received before the inner code block, during the same period as
 		<link linkend="DTV-STAT-PRE-ERROR-BIT-COUNT"><constant>DTV_STAT_PRE_ERROR_BIT_COUNT</constant></link> measurement was taken.</para>
-		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
+		<para>It should be noted that this measurement can be smaller than the total amount of bits on the transport stream,
 		      as the frontend may need to manually restart the measurement, losing some data between each measurement interval.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
@@ -1191,7 +1191,7 @@ enum fe_interleaving {
 		<title><constant>DTV_STAT_POST_TOTAL_BIT_COUNT</constant></title>
 		<para>Measures the amount of bits received after the inner coding, during the same period as
 		<link linkend="DTV-STAT-POST-ERROR-BIT-COUNT"><constant>DTV_STAT_POST_ERROR_BIT_COUNT</constant></link> measurement was taken.</para>
-		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
+		<para>It should be noted that this measurement can be smaller than the total amount of bits on the transport stream,
 		      as the frontend may need to manually restart the measurement, losing some data between each measurement interval.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 9d8e95cd9694..dc6a1134478d 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -48,7 +48,7 @@ specification is available at
 <para>The information about the frontend tuner locking status can be queried
     using <link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
 <para>Signal statistics are provided via <link linkend="FE_GET_PROPERTY"><constant>FE_GET_PROPERTY</constant></link>.
-    Please notice that several statistics require the demodulator to be fully
+    Please note that several statistics require the demodulator to be fully
     locked (e. g. with FE_HAS_LOCK bit set). See
     <link linkend="frontend-stat-properties">Frontend statistics indicators</link>
     for more details.</para>
diff --git a/Documentation/DocBook/media/v4l/remote_controllers.xml b/Documentation/DocBook/media/v4l/remote_controllers.xml
index 5124a6c4daa8..b86844e80257 100644
--- a/Documentation/DocBook/media/v4l/remote_controllers.xml
+++ b/Documentation/DocBook/media/v4l/remote_controllers.xml
@@ -284,7 +284,7 @@ different IR's. Due to that, V4L2 API now specifies a standard for mapping Media
 </tgroup>
 </table>
 
-<para>It should be noticed that, sometimes, there some fundamental missing keys at some cheaper IR's. Due to that, it is recommended to:</para>
+<para>It should be noted that, sometimes, there some fundamental missing keys at some cheaper IR's. Due to that, it is recommended to:</para>
 
 <table pgwide="1" frame="none" id="rc_keymap_notes">
 <title>Notes</title>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 2e7d7692821e..f3f5fe5b64c9 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -87,8 +87,8 @@
 		<xref linkend="fe-delivery-system-t" />.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
-	<para>It should also be noticed that a media device may also have audio
-	      components, like mixers, PCM capture, PCM playback, etc, with
+	<para>It should also be noted that a media device may also have audio
+	      components, like mixers, PCM capture, PCM playback, etc, which
 	      are controlled via ALSA API.</para>
 	<para>For additional information and for the latest development code,
 		see: <ulink url="http://linuxtv.org">http://linuxtv.org</ulink>.</para>
-- 
2.4.1

