Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 25/41] Documentation: mmap.rst: Add ioctl cross references
Date: Mon,  4 Jul 2016 22:31:00 -0300
Message-Id: <f14c85b48fbb40786aa9b755aaba690dcd595beb.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of ioctls mentioned there that aren't cross-referenced.

Convert the const to cross references. That makes it visually
better, and improves navigation along the document.

While here, remove bad whitespaces.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/mmap.rst | 195 +++++++++++++++---------------
 1 file changed, 98 insertions(+), 97 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 976bd2cf247b..2171b18c1aab 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -58,8 +58,8 @@ possible with the :ref:`munmap() <func-munmap>` function.
 
     struct v4l2_requestbuffers reqbuf;
     struct {
-        void *start;
-        size_t length;
+	void *start;
+	size_t length;
     } *buffers;
     unsigned int i;
 
@@ -69,57 +69,57 @@ possible with the :ref:`munmap() <func-munmap>` function.
     reqbuf.count = 20;
 
     if (-1 == ioctl (fd, VIDIOC_REQBUFS, &reqbuf)) {
-        if (errno == EINVAL)
-            printf("Video capturing or mmap-streaming is not supported\\n");
-        else
-            perror("VIDIOC_REQBUFS");
+	if (errno == EINVAL)
+	    printf("Video capturing or mmap-streaming is not supported\\n");
+	else
+	    perror("VIDIOC_REQBUFS");
 
-        exit(EXIT_FAILURE);
+	exit(EXIT_FAILURE);
     }
 
     /* We want at least five buffers. */
 
     if (reqbuf.count < 5) {
-        /* You may need to free the buffers here. */
-        printf("Not enough buffer memory\\n");
-        exit(EXIT_FAILURE);
+	/* You may need to free the buffers here. */
+	printf("Not enough buffer memory\\n");
+	exit(EXIT_FAILURE);
     }
 
     buffers = calloc(reqbuf.count, sizeof(*buffers));
     assert(buffers != NULL);
 
     for (i = 0; i < reqbuf.count; i++) {
-        struct v4l2_buffer buffer;
+	struct v4l2_buffer buffer;
 
-        memset(&buffer, 0, sizeof(buffer));
-        buffer.type = reqbuf.type;
-        buffer.memory = V4L2_MEMORY_MMAP;
-        buffer.index = i;
+	memset(&buffer, 0, sizeof(buffer));
+	buffer.type = reqbuf.type;
+	buffer.memory = V4L2_MEMORY_MMAP;
+	buffer.index = i;
 
-        if (-1 == ioctl (fd, VIDIOC_QUERYBUF, &buffer)) {
-            perror("VIDIOC_QUERYBUF");
-            exit(EXIT_FAILURE);
-        }
+	if (-1 == ioctl (fd, VIDIOC_QUERYBUF, &buffer)) {
+	    perror("VIDIOC_QUERYBUF");
+	    exit(EXIT_FAILURE);
+	}
 
-        buffers[i].length = buffer.length; /* remember for munmap() */
+	buffers[i].length = buffer.length; /* remember for munmap() */
 
-        buffers[i].start = mmap(NULL, buffer.length,
-                    PROT_READ | PROT_WRITE, /* recommended */
-                    MAP_SHARED,             /* recommended */
-                    fd, buffer.m.offset);
+	buffers[i].start = mmap(NULL, buffer.length,
+		    PROT_READ | PROT_WRITE, /* recommended */
+		    MAP_SHARED,             /* recommended */
+		    fd, buffer.m.offset);
 
-        if (MAP_FAILED == buffers[i].start) {
-            /* If you do not exit here you should unmap() and free()
-               the buffers mapped so far. */
-            perror("mmap");
-            exit(EXIT_FAILURE);
-        }
+	if (MAP_FAILED == buffers[i].start) {
+	    /* If you do not exit here you should unmap() and free()
+	       the buffers mapped so far. */
+	    perror("mmap");
+	    exit(EXIT_FAILURE);
+	}
     }
 
     /* Cleanup. */
 
     for (i = 0; i < reqbuf.count; i++)
-        munmap(buffers[i].start, buffers[i].length);
+	munmap(buffers[i].start, buffers[i].length);
 
 
 .. code-block:: c
@@ -130,8 +130,8 @@ possible with the :ref:`munmap() <func-munmap>` function.
     #define FMT_NUM_PLANES = 3
 
     struct {
-        void *start[FMT_NUM_PLANES];
-        size_t length[FMT_NUM_PLANES];
+	void *start[FMT_NUM_PLANES];
+	size_t length[FMT_NUM_PLANES];
     } *buffers;
     unsigned int i, j;
 
@@ -141,66 +141,66 @@ possible with the :ref:`munmap() <func-munmap>` function.
     reqbuf.count = 20;
 
     if (ioctl(fd, VIDIOC_REQBUFS, &reqbuf) < 0) {
-        if (errno == EINVAL)
-            printf("Video capturing or mmap-streaming is not supported\\n");
-        else
-            perror("VIDIOC_REQBUFS");
+	if (errno == EINVAL)
+	    printf("Video capturing or mmap-streaming is not supported\\n");
+	else
+	    perror("VIDIOC_REQBUFS");
 
-        exit(EXIT_FAILURE);
+	exit(EXIT_FAILURE);
     }
 
     /* We want at least five buffers. */
 
     if (reqbuf.count < 5) {
-        /* You may need to free the buffers here. */
-        printf("Not enough buffer memory\\n");
-        exit(EXIT_FAILURE);
+	/* You may need to free the buffers here. */
+	printf("Not enough buffer memory\\n");
+	exit(EXIT_FAILURE);
     }
 
     buffers = calloc(reqbuf.count, sizeof(*buffers));
     assert(buffers != NULL);
 
     for (i = 0; i < reqbuf.count; i++) {
-        struct v4l2_buffer buffer;
-        struct v4l2_plane planes[FMT_NUM_PLANES];
+	struct v4l2_buffer buffer;
+	struct v4l2_plane planes[FMT_NUM_PLANES];
 
-        memset(&buffer, 0, sizeof(buffer));
-        buffer.type = reqbuf.type;
-        buffer.memory = V4L2_MEMORY_MMAP;
-        buffer.index = i;
-        /* length in struct v4l2_buffer in multi-planar API stores the size
-         * of planes array. */
-        buffer.length = FMT_NUM_PLANES;
-        buffer.m.planes = planes;
+	memset(&buffer, 0, sizeof(buffer));
+	buffer.type = reqbuf.type;
+	buffer.memory = V4L2_MEMORY_MMAP;
+	buffer.index = i;
+	/* length in struct v4l2_buffer in multi-planar API stores the size
+	 * of planes array. */
+	buffer.length = FMT_NUM_PLANES;
+	buffer.m.planes = planes;
 
-        if (ioctl(fd, VIDIOC_QUERYBUF, &buffer) < 0) {
-            perror("VIDIOC_QUERYBUF");
-            exit(EXIT_FAILURE);
-        }
+	if (ioctl(fd, VIDIOC_QUERYBUF, &buffer) < 0) {
+	    perror("VIDIOC_QUERYBUF");
+	    exit(EXIT_FAILURE);
+	}
 
-        /* Every plane has to be mapped separately */
-        for (j = 0; j < FMT_NUM_PLANES; j++) {
-            buffers[i].length[j] = buffer.m.planes[j].length; /* remember for munmap() */
+	/* Every plane has to be mapped separately */
+	for (j = 0; j < FMT_NUM_PLANES; j++) {
+	    buffers[i].length[j] = buffer.m.planes[j].length; /* remember for munmap() */
 
-            buffers[i].start[j] = mmap(NULL, buffer.m.planes[j].length,
-                     PROT_READ | PROT_WRITE, /* recommended */
-                     MAP_SHARED,             /* recommended */
-                     fd, buffer.m.planes[j].m.offset);
+	    buffers[i].start[j] = mmap(NULL, buffer.m.planes[j].length,
+		     PROT_READ | PROT_WRITE, /* recommended */
+		     MAP_SHARED,             /* recommended */
+		     fd, buffer.m.planes[j].m.offset);
 
-            if (MAP_FAILED == buffers[i].start[j]) {
-                /* If you do not exit here you should unmap() and free()
-                   the buffers and planes mapped so far. */
-                perror("mmap");
-                exit(EXIT_FAILURE);
-            }
-        }
+	    if (MAP_FAILED == buffers[i].start[j]) {
+		/* If you do not exit here you should unmap() and free()
+		   the buffers and planes mapped so far. */
+		perror("mmap");
+		exit(EXIT_FAILURE);
+	    }
+	}
     }
 
     /* Cleanup. */
 
     for (i = 0; i < reqbuf.count; i++)
-        for (j = 0; j < FMT_NUM_PLANES; j++)
-            munmap(buffers[i].start[j], buffers[i].length[j]);
+	for (j = 0; j < FMT_NUM_PLANES; j++)
+	    munmap(buffers[i].start[j], buffers[i].length[j]);
 
 Conceptually streaming drivers maintain two buffer queues, an incoming
 and an outgoing queue. They separate the synchronous capture or output
@@ -224,37 +224,38 @@ mapped buffers, then to start capturing and enter the read loop. Here
 the application waits until a filled buffer can be dequeued, and
 re-enqueues the buffer when the data is no longer needed. Output
 applications fill and enqueue buffers, when enough buffers are stacked
-up the output is started with ``VIDIOC_STREAMON``. In the write loop,
-when the application runs out of free buffers, it must wait until an
-empty buffer can be dequeued and reused.
+up the output is started with :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`.
+In the write loop, when the application runs out of free buffers, it
+must wait until an empty buffer can be dequeued and reused.
 
-To enqueue and dequeue a buffer applications use the
-:ref:`VIDIOC_QBUF` and
-:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The status of a buffer being
-mapped, enqueued, full or empty can be determined at any time using the
-:ref:`VIDIOC_QUERYBUF` ioctl. Two methods exist to
-suspend execution of the application until one or more buffers can be
-dequeued. By default ``VIDIOC_DQBUF`` blocks when no buffer is in the
-outgoing queue. When the ``O_NONBLOCK`` flag was given to the
-:ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an ``EAGAIN`` error code when no buffer is available. The
-:ref:`select() <func-select>` or :ref:`poll() <func-poll>` functions
-are always available.
+To enqueue and dequeue a buffer applications use the :ref:`VIDIOC_QBUF`
+and :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The status of a buffer
+being mapped, enqueued, full or empty can be determined at any time
+using the :ref:`VIDIOC_QUERYBUF` ioctl. Two methods exist to suspend
+execution of the application until one or more buffers can be dequeued.
+By default :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` blocks when no buffer is
+in the outgoing queue. When the ``O_NONBLOCK`` flag was given to the
+:ref:`open() <func-open>` function, :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
+returns immediately with an ``EAGAIN`` error code when no buffer is
+available. The :ref:`select() <func-select>` or :ref:`poll()
+<func-poll>` functions are always available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON` and
-:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
-``VIDIOC_STREAMOFF`` removes all buffers from both queues as a side
-effect. Since there is no notion of doing anything "now" on a
-multitasking system, if an application needs to synchronize with another
-event it should examine the struct :ref:`v4l2_buffer <v4l2-buffer>`
-``timestamp`` of captured or outputted buffers.
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and :ref:`VIDIOC_STREAMOFF
+<VIDIOC_STREAMON>` ioctl. Note :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
+removes all buffers from both queues as a side effect. Since there is
+no notion of doing anything "now" on a multitasking system, if an
+application needs to synchronize with another event it should examine
+the struct ::ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured
+or outputted buffers.
 
 Drivers implementing memory mapping I/O must support the
-``VIDIOC_REQBUFS``, ``VIDIOC_QUERYBUF``, ``VIDIOC_QBUF``,
-``VIDIOC_DQBUF``, ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl,
-the :ref:`mmap() <func-mmap>`, :ref:`munmap() <func-munmap>`, :ref:`select() <func-select>` and
-:ref:`poll() <func-poll>` function. [3]_
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QUERYBUF
+<VIDIOC_QUERYBUF>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_DQBUF
+<VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
+and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the :ref:`mmap()
+<func-mmap>`, :ref:`munmap() <func-munmap>`, :ref:`select()
+<func-select>` and :ref:`poll() <func-poll>` function. [3]_
 
 [capture example]
 
-- 
2.7.4

