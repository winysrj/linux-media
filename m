Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63338 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3GKJUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:20:50 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPR00DANLY4RZT0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Jul 2013 18:20:48 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] DocBook: Fix typo in V4L2_CID_JPEG_COMPRESSION_QUALITY
 reference
Date: Thu, 11 Jul 2013 11:20:15 +0200
Message-id: <1373534415-16115-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the erroneous V4L2_CID_JPEG_IMAGE_QUALITY control name
with V4L2_CID_JPEG_COMPRESSION_QUALITY.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
index 4874849..098ff48 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
@@ -92,8 +92,8 @@ to add them.</para>
 	    <entry>int</entry>
 	    <entry><structfield>quality</structfield></entry>
 	    <entry>Deprecated. If <link linkend="jpeg-quality-control"><constant>
-	    V4L2_CID_JPEG_IMAGE_QUALITY</constant></link> control is exposed by
-	    a driver applications should use it instead and ignore this field.
+	    V4L2_CID_JPEG_COMPRESSION_QUALITY</constant></link> control is exposed
+	    by a driver applications should use it instead and ignore this field.
 	    </entry>
 	  </row>
 	  <row>
-- 
1.7.9.5

