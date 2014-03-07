Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4041 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaCGO0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:26:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/5] DocBook media: update STREAMON/OFF documentation.
Date: Fri,  7 Mar 2014 15:26:20 +0100
Message-Id: <1394202384-5762-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
References: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-streamon.xml          | 28 +++++++++++++++++-----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index 65dff55..df2c63d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
@@ -52,16 +52,24 @@
     <para>The <constant>VIDIOC_STREAMON</constant> and
 <constant>VIDIOC_STREAMOFF</constant> ioctl start and stop the capture
 or output process during streaming (<link linkend="mmap">memory
-mapping</link> or <link linkend="userp">user pointer</link>) I/O.</para>
+mapping</link>, <link linkend="userp">user pointer</link> or
+<link linkend="dmabuf">DMABUF</link>) I/O.</para>
 
-    <para>Specifically the capture hardware is disabled and no input
+    <para>Capture hardware is disabled and no input
 buffers are filled (if there are any empty buffers in the incoming
 queue) until <constant>VIDIOC_STREAMON</constant> has been called.
-Accordingly the output hardware is disabled, no video signal is
+Output hardware is disabled and no video signal is
 produced until <constant>VIDIOC_STREAMON</constant> has been called.
 The ioctl will succeed when at least one output buffer is in the
 incoming queue.</para>
 
+    <para>Memory-to-memory devices will not start until
+<constant>VIDIOC_STREAMON</constant> has been called for both the capture
+and output stream types.</para>
+
+    <para>If <constant>VIDIOC_STREAMON</constant> fails then any already
+queued buffers will remain queued.</para>
+
     <para>The <constant>VIDIOC_STREAMOFF</constant> ioctl, apart of
 aborting or finishing any DMA in progress, unlocks any user pointer
 buffers locked in physical memory, and it removes all buffers from the
@@ -70,14 +78,22 @@ dequeued yet will be lost, likewise all images enqueued for output but
 not transmitted yet. I/O returns to the same state as after calling
 &VIDIOC-REQBUFS; and can be restarted accordingly.</para>
 
+    <para>If buffers have been queued with &VIDIOC-QBUF; and
+<constant>VIDIOC_STREAMOFF</constant> is called without ever having
+called <constant>VIDIOC_STREAMON</constant>, then those queued buffers
+will also be removed from the incoming queue and all are returned to the
+same state as after calling &VIDIOC-REQBUFS; and can be restarted
+accordingly.</para>
+
     <para>Both ioctls take a pointer to an integer, the desired buffer or
 stream type. This is the same as &v4l2-requestbuffers;
 <structfield>type</structfield>.</para>
 
     <para>If <constant>VIDIOC_STREAMON</constant> is called when streaming
 is already in progress, or if <constant>VIDIOC_STREAMOFF</constant> is called
-when streaming is already stopped, then the ioctl does nothing and 0 is
-returned.</para>
+when streaming is already stopped, then 0 is returned. Nothing happens in the
+case of <constant>VIDIOC_STREAMON</constant>, but <constant>VIDIOC_STREAMOFF</constant>
+will return queued buffers to their starting state as mentioned above.</para>
 
     <para>Note that applications can be preempted for unknown periods right
 before or after the <constant>VIDIOC_STREAMON</constant> or
@@ -93,7 +109,7 @@ synchronize with other events.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The buffer<structfield>type</structfield> is not supported,
+	  <para>The buffer <structfield>type</structfield> is not supported,
 	  or no buffers have been allocated (memory mapping) or enqueued
 	  (output) yet.</para>
 	</listitem>
-- 
1.9.0

