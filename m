Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63396 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3AXMfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 07:35:25 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH400LUAQZ0YVP0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 21:35:24 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH4006Z9QYLQC80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 21:35:24 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, verkuil@xs4all.nl, m.szyprowski@samsung.com,
	pawel@osciak.com, Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/3 v2] v4l: Define video buffer flag for the COPY timestamp
 type
Date: Thu, 24 Jan 2013 13:35:05 +0100
Message-id: <1359030907-9883-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
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

