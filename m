Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1716 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2ISOic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/6] DocBook: various updates w.r.t. v4l2_buffer and multiplanar.
Date: Wed, 19 Sep 2012 16:37:40 +0200
Message-Id: <499780c9daeee902db65382be3bdf481d205e99c.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
References: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify the behavior of v4l2_buffer in the multiplanar case,
including fixing a false statement: you can't set m.planes to NULL
when calling DQBUF.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml              |    6 ++++--
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml     |    3 +--
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml |   11 +++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 1885cc0..c6d39fe 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -677,8 +677,10 @@ memory, set by the application. See <xref linkend="userp" /> for details.
 	    <entry><structfield>length</structfield></entry>
 	    <entry></entry>
 	    <entry>Size of the buffer (not the payload) in bytes for the
-	    single-planar API. For the multi-planar API should contain the
-	    number of elements in the <structfield>planes</structfield> array.
+	    single-planar API. For the multi-planar API the application sets
+	    this to the number of elements in the <structfield>planes</structfield>
+	    array. The driver will fill in the actual number of valid elements in
+	    that array.
 	    </entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 6a821a6..2d37abe 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -121,8 +121,7 @@ remaining fields or returns an error code. The driver may also set
 field. It indicates a non-critical (recoverable) streaming error. In such case
 the application may continue as normal, but should be aware that data in the
 dequeued buffer might be corrupted. When using the multi-planar API, the
-planes array does not have to be passed; the <structfield>m.planes</structfield>
-member must be set to NULL in that case.</para>
+planes array must be passed in as well.</para>
 
     <para>By default <constant>VIDIOC_DQBUF</constant> blocks when no
 buffer is in the outgoing queue. When the
diff --git a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
index 6e414d7..a597155 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
@@ -48,8 +48,8 @@
   <refsect1>
     <title>Description</title>
 
-    <para>This ioctl is part of the <link linkend="mmap">memory
-mapping</link> I/O method. It can be used to query the status of a
+    <para>This ioctl is part of the <link linkend="mmap">streaming
+</link> I/O method. It can be used to query the status of a
 buffer at any time after buffers have been allocated with the
 &VIDIOC-REQBUFS; ioctl.</para>
 
@@ -71,6 +71,7 @@ the structure.</para>
 
     <para>In the <structfield>flags</structfield> field the
 <constant>V4L2_BUF_FLAG_MAPPED</constant>,
+<constant>V4L2_BUF_FLAG_PREPARED</constant>,
 <constant>V4L2_BUF_FLAG_QUEUED</constant> and
 <constant>V4L2_BUF_FLAG_DONE</constant> flags will be valid. The
 <structfield>memory</structfield> field will be set to the current
@@ -79,8 +80,10 @@ contains the offset of the buffer from the start of the device memory,
 the <structfield>length</structfield> field its size. For the multi-planar API,
 fields <structfield>m.mem_offset</structfield> and
 <structfield>length</structfield> in the <structfield>m.planes</structfield>
-array elements will be used instead. The driver may or may not set the remaining
-fields and flags, they are meaningless in this context.</para>
+array elements will be used instead and the <structfield>length</structfield>
+field of &v4l2-buffer; is set to the number of filled-in array elements.
+The driver may or may not set the remaining fields and flags, they are
+meaningless in this context.</para>
 
     <para>The <structname>v4l2_buffer</structname> structure is
     specified in <xref linkend="buffer" />.</para>
-- 
1.7.10.4

