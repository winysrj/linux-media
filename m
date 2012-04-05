Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30891 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2DEOAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2000A43EWFSC70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:15 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M20009QTEWUP5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:31 +0100 (BST)
Date: Thu, 05 Apr 2012 15:59:59 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 02/11] Documentation: media: description of DMABUF importing in
 V4L2
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-3-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds description and usage examples for importing
DMABUF file descriptor in V4L2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/io.xml             |  177 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 ++
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    8 +-
 5 files changed, 203 insertions(+), 2 deletions(-)

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
index b815929..2a32363 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -472,6 +472,160 @@ rest should be evident.</para>
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
+<para>The DMABUF framework was introduced to provide a generic mean for sharing
+buffers between multiple HW devices. Some device drivers provide an API that
+may be capable to export a DMA buffer as a DMABUF file descriptor. The other
+device drivers may be configured to use such a buffer. They implements an API
+for importing of DMABUF. This section describes the support of DMABUF importing
+in V4L2.</para>
+
+    <para>Input and output devices support this I/O method when the
+<constant>V4L2_CAP_STREAMING</constant> flag in the
+<structfield>capabilities</structfield> field of &v4l2-capability; returned by
+the &VIDIOC-QUERYCAP; ioctl is set. If the particular importing buffer via
+DMABUF file descriptors method is supported must be determined by calling the
+&VIDIOC-REQBUFS; ioctl.</para>
+
+    <para>This I/O method is dedicated for sharing DMA buffers between V4L and
+other APIs. Buffers (planes) are allocated by the application itself using
+a client API. The buffers must be exported as DMABUF file descriptor.  Only those
+file descriptor are exchanged, these files and meta-information are passed in
+&v4l2-buffer; (or in &v4l2-plane; in the multi-planar API case).  The driver
+must be switched into DMABUF I/O mode by calling the &VIDIOC-REQBUFS; with the
+desired buffer type. No buffers (planes) are allocated beforehand, consequently
+they are not indexed and cannot be queried like mapped buffers with the
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
+		printf ("Video capturing or user pointer streaming is not supported\n");
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
+&VIDIOC-DQBUF; ioctl. The driver can unpin the buffer at any
+time between the completion of the DMA and this ioctl. The memory is
+also unpinned when &VIDIOC-STREAMOFF; is called, &VIDIOC-REQBUFS;, or
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
+&VIDIOC-STREAMON; and &VIDIOC-STREAMOFF; ioctl. Note
+<constant>VIDIOC_STREAMOFF</constant> removes all buffers from both queues and
+unlocks/unpins all buffers as a side effect. Since there is no notion of doing
+anything "now" on a multitasking system, if an application needs to synchronize
+with another event it should examine the &v4l2-buffer;
+<structfield>timestamp</structfield> of captured buffers, or set the field
+before enqueuing buffers for output.</para>
+
+    <para>Drivers implementing user pointer I/O must support the
+<constant>VIDIOC_REQBUFS</constant>, <constant>VIDIOC_QBUF</constant>,
+<constant>VIDIOC_DQBUF</constant>, <constant>VIDIOC_STREAMON</constant> and
+<constant>VIDIOC_STREAMOFF</constant> ioctl, the <function>select()</function>
+and <function>poll()</function> function.</para>
+
+  </section>
+
   <section id="async">
     <title>Asynchronous I/O</title>
 
@@ -671,6 +825,14 @@ memory, set by the application. See <xref linkend="userp" /> for details.
 	    <structname>v4l2_buffer</structname> structure.</entry>
 	  </row>
 	  <row>
+	    <entry></entry>
+	    <entry>int</entry>
+	    <entry><structfield>fd</structfield></entry>
+	    <entry>For the single-planar API and when
+<structfield>memory</structfield> is <constant>V4L2_MEMORY_DMABUF</constant> this
+is the file descriptor associated with a DMABUF buffer.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>length</structfield></entry>
 	    <entry></entry>
@@ -746,6 +908,15 @@ should set this to 0.</entry>
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
@@ -980,6 +1151,12 @@ pointer</link> I/O.</entry>
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
index 9caa49a..d4f212f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -112,6 +112,21 @@ they cannot be swapped out to disk. Buffers remain locked until
 dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is
 called, or until the device is closed.</para>
 
+    <para>To enqueue a <link linkend="dmabuf">DMABUF</link> buffer applications
+set the <structfield>memory</structfield> field to
+<constant>V4L2_MEMORY_DMABUF</constant>, the <structfield>m.fd</structfield>
+field to the file descriptor to a DMABUF buffer. When the multi-planar API is
+used, <structfield>m.fd</structfield> of the passed array of &v4l2-plane; have
+to be used instead. When <constant>VIDIOC_QBUF</constant> is called with a
+pointer to this structure the driver sets the
+<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
+<constant>V4L2_BUF_FLAG_MAPPED</constant> and
+<constant>V4L2_BUF_FLAG_DONE</constant> flags in the
+<structfield>flags</structfield> field, or it returns an error code.  This
+ioctl may pin and lock the buffer. Buffers remain locked/pinned until dequeued,
+until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is called, or until the
+device is closed.</para>
+
     <para>Applications call the <constant>VIDIOC_DQBUF</constant>
 ioctl to dequeue a filled (capturing) or displayed (output) buffer
 from the driver's outgoing queue. They just set the
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index 7be4b1d..d758622 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -50,11 +50,14 @@
 
     <para>This ioctl is used to initiate <link linkend="mmap">memory
 mapped</link> or <link linkend="userp">user pointer</link>
-I/O. Memory mapped buffers are located in device memory and must be
+I/O or <link linkend="dmabuf">DMABUF file descriptors</link>.
+Memory mapped buffers are located in device memory and must be
 allocated with this ioctl before they can be mapped into the
 application's address space. User buffers are allocated by
 applications themselves, and this ioctl is merely used to switch the
-driver into user pointer I/O mode and to setup some internal structures.</para>
+driver into user pointer I/O mode and to setup some internal structures.
+A DMABUF file descriptor is a generic carrier for HW allocated buffers
+dedicated to share them between multimedia APIs.</para>
 
     <para>To allocate device buffers applications initialize all
 fields of the <structname>v4l2_requestbuffers</structname> structure.
@@ -103,6 +106,7 @@ as the &v4l2-format; <structfield>type</structfield> field. See <xref
 	    <entry><structfield>memory</structfield></entry>
 	    <entry>Applications set this field to
 <constant>V4L2_MEMORY_MMAP</constant> or
+<constant>V4L2_MEMORY_DMABUF</constant> or
 <constant>V4L2_MEMORY_USERPTR</constant>.</entry>
 	  </row>
 	  <row>
-- 
1.7.5.4

