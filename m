Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37749 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaGUWlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 18:41:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: Fix ARGB32 fourcc value in the documentation
Date: Tue, 22 Jul 2014 00:41:22 +0200
Message-Id: <1405982482-11456-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ARGB32 pixel format's fourcc value is defined to 'BA24' in the
videodev2.h header, but documented as 'AX24'. Fix the documentation.

Reported-by: Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 32feac9..4209542 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -489,7 +489,7 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	  </row>
 	  <row id="V4L2-PIX-FMT-ARGB32">
 	    <entry><constant>V4L2_PIX_FMT_ARGB32</constant></entry>
-	    <entry>'AX24'</entry>
+	    <entry>'BA24'</entry>
 	    <entry></entry>
 	    <entry>a<subscript>7</subscript></entry>
 	    <entry>a<subscript>6</subscript></entry>
-- 
Regards,

Laurent Pinchart

