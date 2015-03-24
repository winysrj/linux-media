Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39358 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbbCXRq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:46:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 1/4] [media] videodev2: Add V4L2_BUF_FLAG_LAST
Date: Tue, 24 Mar 2015 18:46:51 +0100
Message-Id: <1427219214-5368-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

This v4l2_buffer flag can be used by drivers to mark a capture buffer
as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
command was issued.
The DocBook is updated to mention mem2mem codecs and the mem2mem draining flow
signals in the VIDIOC_DECODER_CMD V4L2_DEC_CMD_STOP and VIDIOC_ENCODER_CMD
V4L2_ENC_CMD_STOP documentation.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
 - Added DocBook update mentioning V4L2_BUF_FLAG_LAST in the encoder/decoder
   stop command documentation.
---
 Documentation/DocBook/media/v4l/io.xml                 | 10 ++++++++++
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml |  6 +++++-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |  5 ++++-
 include/trace/events/v4l2.h                            |  3 ++-
 include/uapi/linux/videodev2.h                         |  2 ++
 5 files changed, 23 insertions(+), 3 deletions(-)

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
diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
index 9215627..cbb7135 100644
--- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -197,7 +197,11 @@ be muted when playing back at a non-standard speed.
 this command does nothing. This command has two flags:
 if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
 set the picture to black after it stopped decoding. Otherwise the last image will
-repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
+repeat. mem2mem decoders will stop producing new frames altogether. They will send
+a <constant>V4L2_EVENT_EOS</constant> event after the last frame was decoded and
+will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag when there will
+be no new buffers produced to dequeue.
+If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
 stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
 will keep decoding until timestamp >= pts or until the last of the pending data from
 its internal buffers was decoded.
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index 0619ca5..e9cf601 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -129,7 +129,10 @@ this command.</entry>
 encoding will continue until the end of the current <wordasword>Group
 Of Pictures</wordasword>, otherwise encoding will stop immediately.
 When the encoder is already stopped, this command does
-nothing.</entry>
+nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
+after the last frame was encoded and will set the
+<constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the capture queue when
+there will be no new buffers produced to dequeue</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_ENC_CMD_PAUSE</constant></entry>
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index b9bb1f2..32c33aa 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -58,7 +58,8 @@
 		{ V4L2_BUF_FLAG_TIMESTAMP_MASK,	     "TIMESTAMP_MASK" },      \
 		{ V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN,   "TIMESTAMP_UNKNOWN" },   \
 		{ V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC, "TIMESTAMP_MONOTONIC" }, \
-		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" })
+		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" },      \
+		{ V4L2_BUF_FLAG_LAST,                "LAST" })
 
 #define show_timecode_flags(flags)					  \
 	__print_flags(flags, "|",					  \
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

