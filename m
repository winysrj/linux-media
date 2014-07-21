Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37158 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGUUjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 16:39:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: Clarify RGB666 pixel format definition
Date: Mon, 21 Jul 2014 22:39:10 +0200
Message-Id: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RGB666 pixel format doesn't include an alpha channel. Document it as
such.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml          | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 32feac9..c47692a 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -330,20 +330,12 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry></entry>
 	    <entry>r<subscript>1</subscript></entry>
 	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
 	  </row>
 	  <row id="V4L2-PIX-FMT-BGR24">
 	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
-- 
Regards,

Laurent Pinchart

