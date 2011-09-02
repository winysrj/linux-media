Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60873 "EHLO
	retiisi.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756351Ab1IBWfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 18:35:00 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: Remove experimental note from ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS
Date: Sat,  3 Sep 2011 01:28:28 +0300
Message-Id: <1315002508-11651-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_ENUM_FRAMESIZES and VIDIOC_FRAME_INTERVALS have existed for quite
some time, are widely supported by various drivers and are being used by
applications. Thus they no longer can be considered experimental.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml         |    4 ----
 .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |    7 -------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index ce1004a..a6261c1 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2458,10 +2458,6 @@ and may change in the future.</para>
 &VIDIOC-QUERYCAP; ioctl, <xref linkend="device-capabilities" />.</para>
         </listitem>
         <listitem>
-	  <para>&VIDIOC-ENUM-FRAMESIZES; and
-&VIDIOC-ENUM-FRAMEINTERVALS; ioctls.</para>
-        </listitem>
-        <listitem>
 	  <para>&VIDIOC-G-ENC-INDEX; ioctl.</para>
         </listitem>
         <listitem>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
index f77a13f..a78454b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
@@ -50,13 +50,6 @@ and pixel format and receives a frame width and height.</para>
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-
-      <para>This is an <link linkend="experimental">experimental</link>
-interface and may change in the future.</para>
-    </note>
-
     <para>This ioctl allows applications to enumerate all frame sizes
 (&ie; width and height in pixels) that the device supports for the
 given pixel format.</para>
-- 
1.7.2.5

