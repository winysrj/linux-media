Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4979 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2IGN3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 12/28] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Fri,  7 Sep 2012 15:29:12 +0200
Message-Id: <86a39343d33f0f75079407d8b36202a1de4c58de.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new flag that tells userspace that the monotonic clock is used
for timestamps and update the documentation accordingly.

We decided on this new flag during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml              |   10 +++++++---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml  |    3 ++-
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |    7 +++++++
 include/linux/videodev2.h                           |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2dc39d8..b680d66 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -582,10 +582,14 @@ applications when an output stream.</entry>
 	    <entry>struct timeval</entry>
 	    <entry><structfield>timestamp</structfield></entry>
 	    <entry></entry>
-	    <entry><para>For input streams this is the
+	    <entry><para>This is either the
 system time (as returned by the <function>gettimeofday()</function>
-function) when the first data byte was captured. For output streams
-the data will not be displayed before this time, secondary to the
+function) or a monotonic timestamp (as returned by the
+<function>clock_gettime(CLOCK_MONOTONIC, &amp;ts)</function> function).
+A monotonic timestamp is used if the <constant>V4L2_CAP_MONOTONIC_TS</constant>
+capability is set, otherwise the system time is used.
+For input streams this is the timestamp when the first data byte was captured.
+For output streams the data will not be displayed before this time, secondary to the
 nominal frame rate determined by the current video standard in
 enqueued order. Applications can for example zero this field to
 display frames as soon as possible. The driver stores the time at
diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 98a856f..00757d4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -120,7 +120,8 @@
 	    <entry>struct timespec</entry>
 	    <entry><structfield>timestamp</structfield></entry>
             <entry></entry>
-	    <entry>Event timestamp.</entry>
+	    <entry>Event timestamp using the monotonic clock as returned by the
+	    <function>clock_gettime(CLOCK_MONOTONIC, &amp;ts)</function> function.</entry>
 	  </row>
 	  <row>
 	    <entry>u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index d5b1248..48aa7ac 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -319,6 +319,13 @@ linkend="async">asynchronous</link> I/O methods.</entry>
 linkend="mmap">streaming</link> I/O method.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_MONOTONIC_TS</constant></entry>
+	    <entry>0x40000000</entry>
+	    <entry>The driver uses a monotonic timestamp instead of wallclock time for the
+	    &v4l2-buffer; <structfield>timestamp</structfield> field.
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_DEVICE_CAPS</constant></entry>
 	    <entry>0x80000000</entry>
 	    <entry>The driver fills the <structfield>device_caps</structfield>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 47d58ed..00f464d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -290,6 +290,7 @@ struct v4l2_capability {
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
 
+#define V4L2_CAP_MONOTONIC_TS           0x40000000  /* uses monotonic timestamps */
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
 /*
-- 
1.7.10.4

