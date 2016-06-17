Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57404 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbcFQRiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 13:38:07 -0400
Received: from axis700.grange ([81.173.224.105]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0M7Hao-1bZb8H2xWw-00x0F9 for
 <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 19:38:03 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 0BBAD13EC5
	for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 19:38:01 +0200 (CEST)
Date: Fri, 17 Jun 2016 19:38:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix the Z16 format definition
Message-ID: <Pine.LNX.4.64.1606171937060.12351@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A copy paste error created that format with the same one-line
description as Y8I and Y12I, whereas Z16 is quite different from them
both.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/DocBook/media/v4l/pixfmt-z16.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
index 3d87e4b..1d9cb16 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-z16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
@@ -5,7 +5,7 @@
   </refmeta>
   <refnamediv>
     <refname><constant>V4L2_PIX_FMT_Z16</constant></refname>
-    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
+    <refpurpose>16-bit depth data with distance values at each pixel</refpurpose>
   </refnamediv>
   <refsect1>
     <title>Description</title>
-- 
1.9.3

