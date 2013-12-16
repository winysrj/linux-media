Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:20411 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab3LPIRG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 03:17:06 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 2/2] [media] Documentation/DocBook/media/v4l: fix typo, s/packet/packed/
Date: Mon, 16 Dec 2013 09:16:46 +0100
Message-Id: <1387181806-17021-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1387181806-17021-1-git-send-email-ospite@studenti.unina.it>
References: <1387181806-17021-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change "packet" to "packed" where the doc is talking about packed data
formats.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index bbe30cd..be21be3 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -89,7 +89,7 @@
       <constant>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</constant>.
       </para>
 
-      <para>The following tables list existing packet RGB formats.</para>
+      <para>The following tables list existing packed RGB formats.</para>
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
 	<title>RGB formats</title>
@@ -615,7 +615,7 @@
 	</mediaobject>
       </figure>
 
-      <para>The following table lists existing packet Bayer formats. The data
+      <para>The following table lists existing packed Bayer formats. The data
       organization is given as an example for the first pixel only.</para>
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-bayer">
@@ -1178,7 +1178,7 @@
       U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
       </para>
 
-	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> lists existing packet YUV
+	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> lists existing packed YUV
 	formats and describes the organization of each pixel data in each sample.
 	When a format pattern is split across multiple samples each of the samples
 	in the pattern is described.</para>
-- 
1.8.5.1

