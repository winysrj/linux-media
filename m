Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.hs-offenburg.de ([141.79.128.11]:50614 "EHLO
	mx.hs-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaGGOgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 10:36:11 -0400
Received: from [141.79.36.106] (vpn36-106.rz.hs-offenburg.de [141.79.36.106])
	by mx.hs-offenburg.de (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id s67EFfpN001088
	for <linux-media@vger.kernel.org>; Mon, 7 Jul 2014 16:15:42 +0200
Message-ID: <53BAAB84.7040807@hs-offenburg.de>
Date: Mon, 07 Jul 2014 16:15:32 +0200
From: Andreas Weber <andreas.weber@hs-offenburg.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] DocBook media: fix number of bits filled with zeros for SRGBB12
Content-Type: multipart/mixed;
 boundary="------------050900070108030501070406"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050900070108030501070406
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit



--------------050900070108030501070406
Content-Type: text/x-diff;
 name="0001-DocBook-media-fix-number-of-bits-filled-with-zeros-f.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-DocBook-media-fix-number-of-bits-filled-with-zeros-f.pa";
 filename*1="tch"

>From 4e0d586d6ff8019032d1c6771428ee25c4bbb755 Mon Sep 17 00:00:00 2001
From: Andreas Weber <andy.weber.aw@gmail.com>
Date: Mon, 7 Jul 2014 16:00:05 +0200
Subject: [PATCH] DocBook media: fix number of bits filled with zeros for
 SRGBB12

Signed-off-by: Andreas Weber <andy.weber.aw@gmail.com>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
index 9ba4fb6..96947f1 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
@@ -18,7 +18,7 @@
 	<title>Description</title>
 
 	<para>The following four pixel formats are raw sRGB / Bayer formats with
-12 bits per colour. Each colour component is stored in a 16-bit word, with 6
+12 bits per colour. Each colour component is stored in a 16-bit word, with 4
 unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
 and n/2 blue or red samples, with alternating red and blue rows. Bytes are
 stored in memory in little endian order. They are conventionally described
-- 
2.0.0


--------------050900070108030501070406--
