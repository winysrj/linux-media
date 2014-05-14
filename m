Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18548 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaENObn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 10:31:43 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5K0050UJ0TA920@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 May 2014 23:31:41 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] v4l: Fix documentation of V4L2_PIX_FMT_H264_MVC and VP8 pixel
 formats
Date: Wed, 14 May 2014 16:31:09 +0200
Message-id: <1400077869-17573-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'Code' column in the documentation should provide the real fourcc
code that is used. Changed the documentation to provide the fourcc
defined in videodev2.h

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index ea514d6..91dcbc8 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -772,7 +772,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 	  </row>
 	  <row id="V4L2-PIX-FMT-H264-MVC">
 		<entry><constant>V4L2_PIX_FMT_H264_MVC</constant></entry>
-		<entry>'MVC'</entry>
+		<entry>'M264'</entry>
 		<entry>H264 MVC video elementary stream.</entry>
 	  </row>
 	  <row id="V4L2-PIX-FMT-H263">
@@ -812,7 +812,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 	  </row>
 	  <row id="V4L2-PIX-FMT-VP8">
 		<entry><constant>V4L2_PIX_FMT_VP8</constant></entry>
-		<entry>'VP8'</entry>
+		<entry>'VP80'</entry>
 		<entry>VP8 video elementary stream.</entry>
 	  </row>
 	</tbody>
-- 
1.7.9.5

