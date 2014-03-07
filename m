Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4326 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaCGO0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:26:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/5] DocBook media: clarify v4l2_buffer/plane fields.
Date: Fri,  7 Mar 2014 15:26:22 +0100
Message-Id: <1394202384-5762-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
References: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Be more specific as to who has to fill in each field/flag: the driver
or the application.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml | 54 ++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 49e48be..0a5d8c6 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -676,10 +676,11 @@ plane structures.</para>
 	    <entry>__u32</entry>
 	    <entry><structfield>index</structfield></entry>
 	    <entry></entry>
-	    <entry>Number of the buffer, set by the application. This
-field is only used for <link linkend="mmap">memory mapping</link> I/O
-and can range from zero to the number of buffers allocated
-with the &VIDIOC-REQBUFS; ioctl (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.</entry>
+	    <entry>Number of the buffer, set by the application except
+when calling &VIDIOC-DQBUF;, then it is set by the driver.
+This field can range from zero to the number of buffers allocated
+with the &VIDIOC-REQBUFS; ioctl (&v4l2-requestbuffers; <structfield>count</structfield>),
+plus any buffers allocated with &VIDIOC-CREATE-BUFS; minus one.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -698,7 +699,7 @@ linkend="v4l2-buf-type" /></entry>
 buffer. It depends on the negotiated data format and may change with
 each buffer for compressed variable size data like JPEG images.
 Drivers must set this field when <structfield>type</structfield>
-refers to an input stream, applications when an output stream.</entry>
+refers to an input stream, applications when it refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -715,7 +716,7 @@ linkend="buffer-flags" />.</entry>
 buffer, see <xref linkend="v4l2-field" />. This field is not used when
 the buffer contains VBI data. Drivers must set it when
 <structfield>type</structfield> refers to an input stream,
-applications when an output stream.</entry>
+applications when it refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry>struct timeval</entry>
@@ -729,7 +730,9 @@ applications when an output stream.</entry>
 	    stores the time at which the last data byte was actually sent out
 	    in the  <structfield>timestamp</structfield> field. This permits
 	    applications to monitor the drift between the video and system
-	    clock.</para></entry>
+	    clock. For output streams that use <constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant>
+	    the application has to fill in the timestamp which will be copied
+	    by the driver to the capture stream.</para></entry>
 	  </row>
 	  <row>
 	    <entry>&v4l2-timecode;</entry>
@@ -822,7 +825,8 @@ is the file descriptor associated with a DMABUF buffer.</entry>
 	    <entry><structfield>length</structfield></entry>
 	    <entry></entry>
 	    <entry>Size of the buffer (not the payload) in bytes for the
-	    single-planar API. For the multi-planar API the application sets
+	    single-planar API. This is set by the driver based on the calls to
+	    &VIDIOC-REQBUFS; and/or &VIDIOC-CREATE-BUFS;. For the multi-planar API the application sets
 	    this to the number of elements in the <structfield>planes</structfield>
 	    array. The driver will fill in the actual number of valid elements in
 	    that array.
@@ -856,13 +860,15 @@ should set this to 0.</entry>
 	    <entry><structfield>bytesused</structfield></entry>
 	    <entry></entry>
 	    <entry>The number of bytes occupied by data in the plane
-	    (its payload).</entry>
+	      (its payload). Drivers must set this field when <structfield>type</structfield>
+	      refers to an input stream, applications when it refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>length</structfield></entry>
 	    <entry></entry>
-	    <entry>Size in bytes of the plane (not its payload).</entry>
+	    <entry>Size in bytes of the plane (not its payload). This is set by the driver
+	    based on the calls to &VIDIOC-REQBUFS; and/or &VIDIOC-CREATE-BUFS;.</entry>
 	  </row>
 	  <row>
 	    <entry>union</entry>
@@ -901,7 +907,9 @@ should set this to 0.</entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>data_offset</structfield></entry>
 	    <entry></entry>
-	    <entry>Offset in bytes to video data in the plane, if applicable.
+	    <entry>Offset in bytes to video data in the plane.
+	      Drivers must set this field when <structfield>type</structfield>
+	      refers to an input stream, applications when it refers to an output stream.
 	    </entry>
 	  </row>
 	  <row>
@@ -1031,7 +1039,7 @@ buffer cannot be on both queues at the same time, the
 <constant>V4L2_BUF_FLAG_QUEUED</constant> and
 <constant>V4L2_BUF_FLAG_DONE</constant> flag are mutually exclusive.
 They can be both cleared however, then the buffer is in "dequeued"
-state, in the application domain to say so.</entry>
+state, in the application domain so to say.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_ERROR</constant></entry>
@@ -1049,27 +1057,35 @@ state, in the application domain to say so.</entry>
 	  <entry>Drivers set or clear this flag when calling the
 <constant>VIDIOC_DQBUF</constant> ioctl. It may be set by video
 capture devices when the buffer contains a compressed image which is a
-key frame (or field), &ie; can be decompressed on its own.</entry>
+key frame (or field), &ie; can be decompressed on its own. Also know as
+an I-frame.  Applications can set this bit when <structfield>type</structfield>
+refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_PFRAME</constant></entry>
 	    <entry>0x00000010</entry>
 	    <entry>Similar to <constant>V4L2_BUF_FLAG_KEYFRAME</constant>
 this flags predicted frames or fields which contain only differences to a
-previous key frame.</entry>
+previous key frame. Applications can set this bit when <structfield>type</structfield>
+refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_BFRAME</constant></entry>
 	    <entry>0x00000020</entry>
-	    <entry>Similar to <constant>V4L2_BUF_FLAG_PFRAME</constant>
-	this is a bidirectional predicted frame or field. [ooc tbd]</entry>
+	    <entry>Similar to <constant>V4L2_BUF_FLAG_KEYFRAME</constant>
+this flags a bi-directional predicted frame or field which contains only
+the differences between the current frame and both the preceding and following
+key frames to specify its content. Applications can set this bit when
+<structfield>type</structfield> refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMECODE</constant></entry>
 	    <entry>0x00000100</entry>
 	    <entry>The <structfield>timecode</structfield> field is valid.
 Drivers set or clear this flag when the <constant>VIDIOC_DQBUF</constant>
-ioctl is called.</entry>
+ioctl is called.  Applications can set this bit and the corresponding
+<structfield>timecode</structfield> structure when <structfield>type</structfield>
+refers to an output stream.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_PREPARED</constant></entry>
@@ -1141,7 +1157,9 @@ in which case caches have not been used.</entry>
 	    the frame. Logical 'and' operation between the
 	    <structfield>flags</structfield> field and
 	    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> produces the
-	    value of the timestamp source.</entry>
+	    value of the timestamp source. Applications must set the timestamp
+	    source when <structfield>type</structfield> refers to an output stream
+	    and <constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant> is set.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
-- 
1.9.0

