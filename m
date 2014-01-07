Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4775 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaAGNHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] DocBook media: update copyright years and Introduction.
Date: Tue,  7 Jan 2014 14:06:53 +0100
Message-Id: <1389100017-42855-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/dvbapi.xml |  2 +-
 Documentation/DocBook/media/v4l/v4l2.xml   |  1 +
 Documentation/DocBook/media_api.tmpl       | 13 +++++++------
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 49f46e8..4c15396 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -28,7 +28,7 @@
 	<holder>Convergence GmbH</holder>
 </copyright>
 <copyright>
-	<year>2009-2012</year>
+	<year>2009-2014</year>
 	<holder>Mauro Carvalho Chehab</holder>
 </copyright>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 53f5306..520b2a1 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -125,6 +125,7 @@ Remote Controller chapter.</contrib>
       <year>2011</year>
       <year>2012</year>
       <year>2013</year>
+      <year>2014</year>
       <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
 Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
 	Pawel Osciak</holder>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index df6db3a..ba1d704 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -37,7 +37,7 @@
 <title>LINUX MEDIA INFRASTRUCTURE API</title>
 
 <copyright>
-	<year>2009-2012</year>
+	<year>2009-2014</year>
 	<holder>LinuxTV Developers</holder>
 </copyright>
 
@@ -58,12 +58,13 @@ Foundation. A copy of the license is included in the chapter entitled
 	<title>Introduction</title>
 
 	<para>This document covers the Linux Kernel to Userspace API's used by
-		video and radio straming devices, including video cameras,
+		video and radio streaming devices, including video cameras,
 		analog and digital TV receiver cards, AM/FM receiver cards,
-		streaming capture devices.</para>
+		streaming capture and output devices, codec devices and remote
+		controllers.</para>
 	<para>It is divided into four parts.</para>
-	<para>The first part covers radio, capture,
-		cameras and analog TV devices.</para>
+	<para>The first part covers radio, video capture and output,
+		cameras, analog TV devices and codecs.</para>
 	<para>The second part covers the
 		API used for digital TV and Internet reception via one of the
 		several digital tv standards. While it is called as DVB API,
@@ -96,7 +97,7 @@ Foundation. A copy of the license is included in the chapter entitled
 </author>
 </authorgroup>
 <copyright>
-	<year>2009-2012</year>
+	<year>2009-2014</year>
 	<holder>Mauro Carvalho Chehab</holder>
 </copyright>
 
-- 
1.8.5.2

