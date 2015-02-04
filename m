Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45382 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965653AbbBDNOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 08:14:52 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/5] [media] videodev2: Add V4L2_BUF_FLAG_LAST
Date: Wed,  4 Feb 2015 14:14:33 +0100
Message-Id: <1423055677-13161-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
References: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

This v4l2_buffer flag can be used by drivers to mark a capture buffer
as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
command was issued.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Added documentation
---
 Documentation/DocBook/media/v4l/io.xml | 10 ++++++++++
 include/uapi/linux/videodev2.h         |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 1c17f80..f3b8bc0 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1129,6 +1129,16 @@ in this buffer has not been created by the CPU but by some DMA-capable unit,
 in which case caches have not been used.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
+	    <entry>0x00100000</entry>
+	    <entry>Last buffer produced by the hardware. mem2mem codec drivers
+set this flag on the capture queue for the last buffer when the
+<link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. After the
+queue is drained, the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will
+not block anymore, but return an &EPIPE;.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
 	    <entry>0x0000e000</entry>
 	    <entry>Mask for timestamp types below. To test the
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..c642c10 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -809,6 +809,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+/* mem2mem encoder/decoder */
+#define V4L2_BUF_FLAG_LAST			0x00100000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.1.4

