Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8677 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2DTOpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 10:45:40 -0400
Date: Fri, 20 Apr 2012 16:45:23 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv5 02/13] Documentation: media: description of DMABUF importing
 in V4L2
In-reply-to: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de
Message-id: <1334933134-4688-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds description and usage examples for importing
DMABUF file descriptor in V4L2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/io.xml             |  179 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 ++
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +++---
 5 files changed, 224 insertions(+), 22 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index bce97c5..2a2083d 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2523,6 +2523,10 @@ ioctls.</para>
         <listitem>
 	  <para>Selection API. <xref linkend="selection-api" /></para>
         </listitem>
+        <listitem>
+	  <para>Importing DMABUF file descriptors as a new IO method described
+	  in <xref linkend="dmabuf" />.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index b815929..f8fb559 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -472,6 +472,162 @@ rest should be evident.</para>
       </footnote></para>
   </section>
 
+  <section id="dmabuf">
+    <title>Streaming I/O (DMA buffer importing)</title>
+
+    <note>
+      <title>Experimental</title>
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
+<para>The DMABUF framework provides a generic mean for sharing buffers between
+ multiple devices. Device drivers that support DMABUF can export a DMA buffer
+to userspace as a file descriptor (known as the exporter role), import a DMA
+buffer from userspace using a file descriptor previously exported for a
+different or the same device (known as the importer role), or both. This
+section describes the DMABUF importer role API in V4L2.</para>
+
+<para>Input and output devices support the streaming I/O method when the
+<constant>V4L2_CAP_STREAMING</constant> flag in the
+<structfield>capabilities</structfield> field of &v4l2-capability; returned by
+the &VIDIOC-QUERYCAP; ioctl is set. Whether importing DMA buffers through
+DMABUF file descriptors is supported is determined by calling the
+&VIDIOC-REQBUFS; ioctl with the memory type set to
+<constant>V4L2_MEMORY_DMABUF</constant>.</para>
+
+    <para>This I/O method is dedicated for sharing DMA buffers between V4L and
+other APIs.  Buffers (planes) are allocated by a driver on behalf of the
+application, and exported to the application as file descriptors using an API
+specific to the allocator driver.  Only those file descriptor are exchanged,
+these files and meta-information are passed in &v4l2-buffer; (or in
+&v4l2-plane; in the multi-planar API case).  The driver must be switched into
+DMABUF I/O mode by calling the &VIDIOC-REQBUFS; with the desired buffer type.
+No buffers (planes) are allocated beforehand, consequently they are not indexed
+and cannot be queried like mapped buffers with the
+<constant>VIDIOC_QUERYBUF</constant> ioctl.</para>
+
+    <example>
+      <title>Initiating streaming I/O with DMABUF file descriptors</title>
+
+      <programlisting>
+&v4l2-requestbuffers; reqbuf;
+
+memset (&amp;reqbuf, 0, sizeof (reqbuf));
+reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+reqbuf.memory = V4L2_MEMORY_DMABUF;
+
+if (ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf) == -1) {
+	if (errno == EINVAL)
+		printf ("Video capturing or DMABUF streaming is not supported\n");
+	else
+		perror ("VIDIOC_REQBUFS");
+
+	exit (EXIT_FAILURE);
+}
+      </programlisting>
+    </example>
+
+    <para>Buffer (plane) file is passed on the fly with the &VIDIOC-QBUF;
+ioctl. In case of multiplanar buffers, every plane can be associated with a
+different DMABUF descriptor.Although buffers are commonly cycled, applications
+can pass different DMABUF descriptor at each <constant>VIDIOC_QBUF</constant>
+call.</para>
+
+    <example>
+      <title>Queueing DMABUF using single plane API</title>
+
+      <programlisting>
+int buffer_queue(int v4lfd, int index, int dmafd)
+{
+	&v4l2-buffer; buf;
+
+	memset(&amp;buf, 0, sizeof buf);
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf.memory = V4L2_MEMORY_DMABUF;
+	buf.index = index;
+	buf.m.fd = dmafd;
+
+	if (ioctl (v4lfd, &VIDIOC-QBUF;, &amp;buf) == -1) {
+		perror ("VIDIOC_QBUF");
+		return -1;
+	}
+
+	return 0;
+}
+      </programlisting>
+    </example>
+
+    <example>
+      <title>Queueing DMABUF using multi plane API</title>
+
+      <programlisting>
+int buffer_queue_mp(int v4lfd, int index, int dmafd[], int n_planes)
+{
+	&v4l2-buffer; buf;
+	&v4l2-plane; planes[VIDEO_MAX_PLANES];
+	int i;
+
+	memset(&amp;buf, 0, sizeof buf);
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	buf.memory = V4L2_MEMORY_DMABUF;
+	buf.index = index;
+	buf.m.planes = planes;
+	buf.length = n_planes;
+
+	memset(&amp;planes, 0, sizeof planes);
+
+	for (i = 0; i &lt; n_planes; ++i)
+		buf.m.planes[i].m.fd = dmafd[i];
+
+	if (ioctl (v4lfd, &VIDIOC-QBUF;, &amp;buf) == -1) {
+		perror ("VIDIOC_QBUF");
+		return -1;
+	}
+
+	return 0;
+}
+      </programlisting>
+    </example>
+
+    <para>Filled or displayed buffers are dequeued with the
+&VIDIOC-DQBUF; ioctl. The driver can unlock the buffer at any
+time between the completion of the DMA and this ioctl. The memory is
+also unlocked when &VIDIOC-STREAMOFF; is called, &VIDIOC-REQBUFS;, or
+when the device is closed.</para>
+
+    <para>For capturing applications it is customary to enqueue a
+number of empty buffers, to start capturing and enter the read loop.
+Here the application waits until a filled buffer can be dequeued, and
+re-enqueues the buffer when the data is no longer needed. Output
+applications fill and enqueue buffers, when enough buffers are stacked
+up output is started. In the write loop, when the application
+runs out of free buffers it must wait until an empty buffer can be
+dequeued and reused. Two methods exist to suspend execution of the
+application until one or more buffers can be dequeued. By default
+<constant>VIDIOC_DQBUF</constant> blocks when no buffer is in the
+outgoing queue. When the <constant>O_NONBLOCK</constant> flag was
+given to the &func-open; function, <constant>VIDIOC_DQBUF</constant>
+returns immediately with an &EAGAIN; when no buffer is available. The
+&func-select; or &func-poll; function are always available.</para>
+
+    <para>To start and stop capturing or output applications call the
+&VIDIOC-STREAMON; and &VIDIOC-STREAMOFF; ioctls. Note that
+<constant>VIDIOC_STREAMOFF</constant> removes all buffers from both queues and
+unlocks all buffers as a side effect. Since there is no notion of doing
+anything "now" on a multitasking system, if an application needs to synchronize
+with another event it should examine the &v4l2-buffer;
+<structfield>timestamp</structfield> of captured buffers, or set the field
+before enqueuing buffers for output.</para>
+
+    <para>Drivers implementing DMABUF importing I/O must support the
+<constant>VIDIOC_REQBUFS</constant>, <constant>VIDIOC_QBUF</constant>,
+<constant>VIDIOC_DQBUF</constant>, <constant>VIDIOC_STREAMON</constant> and
+<constant>VIDIOC_STREAMOFF</constant> ioctl, the <function>select()</function>
+and <function>poll()</function> function.</para>
+
+  </section>
+
   <section id="async">
     <title>Asynchronous I/O</title>
 
@@ -671,6 +827,14 @@ memory, set by the application. See <xref linkend="userp" /> for details.
 	    <structname>v4l2_buffer</structname> structure.</entry>
 	  </row>
 	  <row>
+	    <entry></entry>
+	    <entry>int</entry>
+	    <entry><structfield>fd</structfield></entry>
+	    <entry>For the single-plane API and when
+<structfield>memory</structfield> is <constant>V4L2_MEMORY_DMABUF</constant> this
+is the file descriptor associated with a DMABUF buffer.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>length</structfield></entry>
 	    <entry></entry>
@@ -746,6 +910,15 @@ should set this to 0.</entry>
 	      </entry>
 	  </row>
 	  <row>
+	    <entry></entry>
+	    <entry>int</entry>
+	    <entry><structfield>fd</structfield></entry>
+	    <entry>When the memory type in the containing &v4l2-buffer; is
+		<constant>V4L2_MEMORY_DMABUF</constant>, this is a file
+		descriptor associated with a DMABUF buffer, similar to the
+		<structfield>fd</structfield> field in &v4l2-buffer;.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>data_offset</structfield></entry>
 	    <entry></entry>
@@ -980,6 +1153,12 @@ pointer</link> I/O.</entry>
 	    <entry>3</entry>
 	    <entry>[to do]</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_MEMORY_DMABUF</constant></entry>
+	    <entry>2</entry>
+	    <entry>The buffer is used for <link linkend="dmabuf">DMA shared
+buffer</link> I/O.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 73ae8a6..adc92be 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -98,6 +98,7 @@ information.</para>
 	    <entry><structfield>memory</structfield></entry>
 	    <entry>Applications set this field to
 <constant>V4L2_MEMORY_MMAP</constant> or
+<constant>V4L2_MEMORY_DMABUF</constant> or
 <constant>V4L2_MEMORY_USERPTR</constant>.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 9caa49a..cb5f5ff 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -112,6 +112,21 @@ they cannot be swapped out to disk. Buffers remain locked until
 dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is
 called, or until the device is closed.</para>
 
+    <para>To enqueue a <link linkend="dmabuf">DMABUF</link> buffer applications
+set the <structfield>memory</structfield> field to
+<constant>V4L2_MEMORY_DMABUF</constant> and the <structfield>m.fd</structfield>
+to a file descriptor associated with a DMABUF buffer. When the multi-planar API is
+used and <structfield>m.fd</structfield> of the passed array of &v4l2-plane;
+have to be used instead. When <constant>VIDIOC_QBUF</constant> is called with a
+pointer to this structure the driver sets the
+<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
+<constant>V4L2_BUF_FLAG_MAPPED</constant> and
+<constant>V4L2_BUF_FLAG_DONE</constant> flags in the
+<structfield>flags</structfield> field, or it returns an error code.  This
+ioctl locks the buffer. Buffers remain locked until dequeued,
+until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is called, or until the
+device is closed.</para>
+
     <para>Applications call the <constant>VIDIOC_DQBUF</constant>
 ioctl to dequeue a filled (capturing) or displayed (output) buffer
 from the driver's outgoing queue. They just set the
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index 7be4b1d..e3e709b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -48,28 +48,30 @@
   <refsect1>
     <title>Description</title>
 
-    <para>This ioctl is used to initiate <link linkend="mmap">memory
-mapped</link> or <link linkend="userp">user pointer</link>
-I/O. Memory mapped buffers are located in device memory and must be
-allocated with this ioctl before they can be mapped into the
-application's address space. User buffers are allocated by
-applications themselves, and this ioctl is merely used to switch the
-driver into user pointer I/O mode and to setup some internal structures.</para>
+<para>This ioctl is used to initiate <link linkend="mmap">memory mapped</link>,
+<link linkend="userp">user pointer</link> or <link
+linkend="dmabuf">DMABUF</link> based I/O.  Memory mapped buffers are located in
+device memory and must be allocated with this ioctl before they can be mapped
+into the application's address space. User buffers are allocated by
+applications themselves, and this ioctl is merely used to switch the driver
+into user pointer I/O mode and to setup some internal structures.
+Similarly, DMABUF buffers are allocated by applications through a device
+driver, and this ioctl only configures the driver into DMABUF I/O mode without
+performing any direct allocation.</para>
 
-    <para>To allocate device buffers applications initialize all
-fields of the <structname>v4l2_requestbuffers</structname> structure.
-They set the <structfield>type</structfield> field to the respective
-stream or buffer type, the <structfield>count</structfield> field to
-the desired number of buffers, <structfield>memory</structfield>
-must be set to the requested I/O method and the <structfield>reserved</structfield> array
-must be zeroed. When the ioctl
-is called with a pointer to this structure the driver will attempt to allocate
-the requested number of buffers and it stores the actual number
-allocated in the <structfield>count</structfield> field. It can be
-smaller than the number requested, even zero, when the driver runs out
-of free memory. A larger number is also possible when the driver requires
-more buffers to function correctly. For example video output requires at least two buffers,
-one displayed and one filled by the application.</para>
+    <para>To allocate device buffers applications initialize all fields of the
+<structname>v4l2_requestbuffers</structname> structure.  They set the
+<structfield>type</structfield> field to the respective stream or buffer type,
+the <structfield>count</structfield> field to the desired number of buffers,
+<structfield>memory</structfield> must be set to the requested I/O method and
+the <structfield>reserved</structfield> array must be zeroed. When the ioctl is
+called with a pointer to this structure the driver will attempt to allocate the
+requested number of buffers and it stores the actual number allocated in the
+<structfield>count</structfield> field. It can be smaller than the number
+requested, even zero, when the driver runs out of free memory. A larger number
+is also possible when the driver requires more buffers to function correctly.
+For example video output requires at least two buffers, one displayed and one
+filled by the application.</para>
     <para>When the I/O method is not supported the ioctl
 returns an &EINVAL;.</para>
 
@@ -102,7 +104,8 @@ as the &v4l2-format; <structfield>type</structfield> field. See <xref
 	    <entry>&v4l2-memory;</entry>
 	    <entry><structfield>memory</structfield></entry>
 	    <entry>Applications set this field to
-<constant>V4L2_MEMORY_MMAP</constant> or
+<constant>V4L2_MEMORY_MMAP</constant>,
+<constant>V4L2_MEMORY_DMABUF</constant> or
 <constant>V4L2_MEMORY_USERPTR</constant>.</entry>
 	  </row>
 	  <row>
-- 
1.7.5.4

