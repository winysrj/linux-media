Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbEDKvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:51:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 1/5] [media] DocBook media: document codec draining flow
Date: Mon,  4 May 2015 12:51:04 +0200
Message-Id: <1430736668-28582-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
References: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the interaction between VIDIOC_DECODER_CMD V4L2_DEC_CMD_STOP and
VIDIOC_ENCODER_CMD V4L2_ENC_CMD_STOP to start the draining, the V4L2_EVENT_EOS
event signalling all capture buffers are finished and ready to be dequeud,
the new V4L2_BUF_FLAG_LAST buffer flag indicating the last buffer being dequeued
from the capture queue, and the poll and VIDIOC_DQBUF ioctl return values once
the queue is drained.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v5:
 - Drop "mem2mem" from subject.
 - Mention possibly empty last buffer in the documentation.
---
 Documentation/DocBook/media/v4l/io.xml                 | 12 ++++++++++++
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml | 12 +++++++++++-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml | 10 +++++++++-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml        |  8 ++++++++
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 1c17f80..cff2ffd 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1129,6 +1129,18 @@ in this buffer has not been created by the CPU but by some DMA-capable unit,
 in which case caches have not been used.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
+	    <entry>0x00100000</entry>
+	    <entry>Last buffer produced by the hardware. mem2mem codec drivers
+set this flag on the capture queue for the last buffer when the
+<link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. Due to hardware
+limitations, the last buffer may be empty. In this case the driver will set the
+<structfield>bytesused</structfield> field to 0, regardless of the format. Any
+Any subsequent call to the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl
+will not block anymore, but return an &EPIPE;.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
 	    <entry>0x0000e000</entry>
 	    <entry>Mask for timestamp types below. To test the
diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
index 9215627..73eb5cf 100644
--- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -197,7 +197,17 @@ be muted when playing back at a non-standard speed.
 this command does nothing. This command has two flags:
 if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
 set the picture to black after it stopped decoding. Otherwise the last image will
-repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
+repeat. mem2mem decoders will stop producing new frames altogether. They will send
+a <constant>V4L2_EVENT_EOS</constant> event when the last frame has been decoded
+and all frames are ready to be dequeued and will set the
+<constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last buffer of the
+capture queue to indicate there will be no new buffers produced to dequeue. This
+buffer may be empty, indicated by the driver setting the
+<structfield>bytesused</structfield> field to 0. Once the
+<constant>V4L2_BUF_FLAG_LAST</constant> flag was set, the
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
+but return an &EPIPE;.
+If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
 stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
 will keep decoding until timestamp >= pts or until the last of the pending data from
 its internal buffers was decoded.
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index 0619ca5..fc1d462 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -129,7 +129,15 @@ this command.</entry>
 encoding will continue until the end of the current <wordasword>Group
 Of Pictures</wordasword>, otherwise encoding will stop immediately.
 When the encoder is already stopped, this command does
-nothing.</entry>
+nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
+when the last frame has been decoded and all frames are ready to be dequeued and
+will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last
+buffer of the capture queue to indicate there will be no new buffers produced to
+dequeue. This buffer may be empty, indicated by the driver setting the
+<structfield>bytesused</structfield> field to 0. Once the
+<constant>V4L2_BUF_FLAG_LAST</constant> flag was set, the
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
+but return an &EPIPE;.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_ENC_CMD_PAUSE</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 3504a7f..6cfc53b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -186,6 +186,14 @@ In that case the application should be able to safely reuse the buffer and
 continue streaming.
 	</para>
 	</listitem>
+	<term><errorcode>EPIPE</errorcode></term>
+	<listitem>
+	  <para><constant>VIDIOC_DQBUF</constant> returns this on an empty
+capture queue for mem2mem codecs if a buffer with the
+<constant>V4L2_BUF_FLAG_LAST</constant> was already dequeued and no new buffers
+are expected to become available.
+	</para>
+	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
-- 
2.1.4

