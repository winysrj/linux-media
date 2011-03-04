Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37634 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759388Ab1CDL0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 06:26:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Fri, 04 Mar 2011 12:26:22 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: =?UTF-8?q?=5BPATCH/RFC=20v7=205/5=5D=20v4l=3A=20Documentation=20for=20the=20codec=20interface?=
In-reply-to: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1299237982-31687-6-git-send-email-k.debski@samsung.com>
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds documentation for the codec interface of V4L2.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/v4l/dev-codec.xml |  169 ++++++++++++++++++++++++++++---
 1 files changed, 155 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/v4l/dev-codec.xml b/Documentation/DocBook/v4l/dev-codec.xml
index 6e156dc..73ecee8 100644
--- a/Documentation/DocBook/v4l/dev-codec.xml
+++ b/Documentation/DocBook/v4l/dev-codec.xml
@@ -1,21 +1,162 @@
-  <title>Codec Interface</title>
+	<title>Codec Interface</title>
 
-  <note>
-    <title>Suspended</title>
+	<para>
+A V4L2 codec can compress, decompress, transform, or otherwise convert
+video data from one format into another format, in memory. Applications
+can send and receive the data in two ways. First method utilizes
+&func-write; and &func-read; calls to exchange the data. The second
+uses streaming I/O to interact with the driver.
+	</para>
 
-    <para>This interface has been be suspended from the V4L2 API
-implemented in Linux 2.6 until we have more experience with codec
-device interfaces.</para>
-  </note>
+	<para>
+Codec devices belong to the group of memory-to-memory devices – memory
+buffer containing a frame in one format is converted and stored in another
+buffer in the memory. The format of capture and output buffers is
+determined by the pixel formats passed in the &VIDIOC-S-FMT; call.
+	</para>
 
-  <para>A V4L2 codec can compress, decompress, transform, or otherwise
-convert video data from one format into another format, in memory.
-Applications send data to be converted to the driver through a
-&func-write; call, and receive the converted data through a
-&func-read; call. For efficiency a driver may also support streaming
-I/O.</para>
+	<para>
+Many advanced video codecs – such as H264 and MPEG4 require that decoded buffers
+are kept as reference for other frames. This requirement may result in a use
+case where a few output buffers have to be processed before the first capture
+buffer is returned. In addition the buffers may be dequeued in an arbitrary
+order.
+	</para>
 
-  <para>[to do]</para>
+	<para>
+The codec hardware may enable to tweak decoding parameters and will require the
+application to set encoding parameters. Hence the <constant>
+V4L2_CTRL_CLASS_CODEC control</constant> class has been introduced.
+	</para>
+
+	<para>
+The standard V4L2 naming of buffers is kept – output means input of the device,
+capture on the other hand means the device’s output.
+	</para>
+
+<section>
+	<title>Querying Capabilities</title>
+
+	<para>
+Devices that support the codec interface set the
+<costant>V4L2_CAP_VIDEO_M2M</constant> flag of the capabilities field of the
+v4l2_capability struct returned by the &VIDIOC-QUERYCAP; ioctl. At least one of
+the read/write or streaming I/O methods must be supported.
+	</para>
+</section>
+
+<section>
+	<title>Multiple Instance Capabilities</title>
+
+	<para>
+Codecs as memory to memory devices can support multiple instances.
+Drivers for devices with such capabilities should store configuration context
+for every open file descriptor. This means that configuration is kept only until
+the descriptor is closed and it is not possible to configure the device with one
+application and perform streaming with another. If the device is capable of
+handling only one stream at a time it can use a single context.
+	</para>
+</section>
+
+<section>
+	<title>Image Format Negotiation</title>
+
+	<para>
+In case of decoding a video stream, the header may need to be parsed before the
+stream decoding can take place. Usually only after the header is processed the
+dimensions of the decoded image and the minimum number of buffers is known. This
+requires that the output part of the interface has to be able to process the
+header before allocating the buffers for capture. &VIDIOC-G-FMT; can be used by
+the application to get the parameters of the capture buffers. If necessary the
+&VIDIOC-S-FMT; call can be used to change those parameters, but it is up to the
+driver to validate and correct those values. In addition it is necessary to
+negotiate the number of capture buffers. In many cases the application may need
+to allocate N more buffers than the minimum required by the codec. It can be
+useful in case the device has a minimum number of buffers that have to be queued
+in hardware to operate and if the application needs to keep N buffers dequeued
+for processing. This cannot be easily done with &VIDIOC-REQBUFS; alone. To
+address this issue the V4L2_CID_CODEC_MIN_REQ_ BUFS_CAP control has been
+introduced and can be read to determine the minimum buffer count for the
+capture queue. The application can use this number to calculate the number of
+buffers passed to the REQBUFS call. The V4L2_CID_CODEC_MIN_REQ_ BUFS_OUT
+control can also be used if the minimum number of buffers is determined for the
+output queue, for example in case of encoding.
+	</para>
+
+	<para>
+When encoding &VIDIOC-S-FMT; has to be done on both capture and output.
+&VIDIOC-S-FMT; on capture will determine the video codec to be used and encoding
+parameters should be configured by setting appropriate controls. &VIDIOC-S-FMT;
+on output will be used to determine the input image parameters.
+	</para>
+</section>
+
+<section>
+	<title>Processing</title>
+
+	<para>
+In case of streaming I/O the processing is done by queueing and dequeueing
+buffers on both the capture and output queue. In case of decoding it may be
+necessary to parse the header before the parameters of the video are determined.
+In such case the size and number of capture buffers is unknown, hence only the
+output part of the device is initialized. The application should extract the
+header from the stream and queue it as the first buffer on the output queue.
+After the header is parsed by the hardware the capture part of the codec can be
+initialized. In case of encoding both capture and output parts have to be
+initialized before stream on is called.
+	</para>
+
+	<para>
+When streamoff is called then the buffers that were in that queue are discarded.
+This can be used to support compressed stream seeking – after streamoff on
+capture and output all the frames are discarded. Then buffers from new position
+in the stream are queued on the output queue and empty buffers are queued on the
+capture queue. When stream on is called afterwards processing is resumed from
+the new position in the stream.
+	</para>
+
+	<para>
+Marking end-of-stream is necessary, because a number of buffers may be kept
+queued in the hardware for the purpose of acting as reference frames. After
+reaching end of compressed stream it is necessary to mark end-of-stream with a
+buffer which bytesused is set to 0 on the output side. After all remaining
+buffers are dequeued on the capture side, a buffer with bytesused set to 0 is
+dequeued.
+	</para>
+</section>
+
+<section>
+	<title>Resolution change</title>
+
+	<para>
+The resolution and the minimum number of buffers of the decoded picture can be
+changed during streaming. This feature is widely used in digital TV broadcasts.
+If the hardware is able to support such feature it is necessary that the driver
+notifies the application about such event. It might be necessary for the
+application to reallocate the buffers. Such notification is similar to the
+end-of-stream notification – if resolution or the number of necessary buffers is
+changed then the remaining capture buffers are dequeued and then one buffer with
+bytesused set to 0 is returned to the application. At this time the application
+should reallocate and queue the capture buffers. To do this it is necessary to
+call streamoff on the capture, unmap the buffers, free the memory by calling
+reqbufs with count set to 0. Now the application can read the new resolution by
+running &VIDIOC-G-FMT; and the minimum number of buffers by reading the
+V4L2_CID_CODEC_MIN_REQ_BUFS_CAP control. After allocating, mmaping and queueing the
+buffers the hardware will continue processing.
+	</para>
+</section>
+
+<section>
+	<title>Supplemental features</title>
+
+	<para>
+Hardware and format constraints may influence the size of the capture buffer.
+For example the hardware may need the image buffer to be aligned to 128x32
+size.  To read the actual video frame size the application should use the
+&VIDIOC-G-CROP; call for decoding and use &VIDIOC-S-CROP; call in case of
+encoding.
+	</para>
+</section>
 
   <!--
 Local Variables:
-- 
1.6.3.3
