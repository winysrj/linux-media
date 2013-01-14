Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3ANJhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 04:37:09 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGM00E39018K3J0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jan 2013 18:36:44 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGM0003F00DON80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jan 2013 18:36:44 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, s.nawrocki@samsung.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/3] v4l: Define video buffer flag for the COPY timestamp type
Date: Mon, 14 Jan 2013 10:36:02 +0100
Message-id: <1358156164-11382-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define video buffer flag for the COPY timestamp. In this case the timestamp
value is copied from the OUTPUT to the corresponding CAPTURE buffer.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/io.xml |    6 ++++++
 include/uapi/linux/videodev2.h         |    1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 73f202f..fdd1822 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1145,6 +1145,12 @@ in which case caches have not been used.</entry>
 	    same clock outside V4L2, use
 	    <function>clock_gettime(2)</function> .</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
+	    <entry>0x4000</entry>
+	    <entry>The CAPTURE buffer timestamp has been taken from the
+	    corresponding OUTPUT buffer.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 72e9921..d5a59af 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -697,6 +697,7 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
 #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
 #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
+#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
1.7.9.5

