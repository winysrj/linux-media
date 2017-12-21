Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36264 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753095AbdLUQSV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:21 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 08/11] media: dvb uAPI docs: document mmap-related ioctls
Date: Thu, 21 Dec 2017 14:18:07 -0200
Message-Id: <1fd218b1af7423707b3bfcd59239bd26e16d7c93.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

5 new ioctls were added to the DVB demux API, in order to
handle memory maped I/O. Add documentation for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-expbuf.rst   | 90 +++++++++++++++++++++++++++
 Documentation/media/uapi/dvb/dmx-qbuf.rst     | 85 +++++++++++++++++++++++++
 Documentation/media/uapi/dvb/dmx-querybuf.rst | 65 +++++++++++++++++++
 Documentation/media/uapi/dvb/dmx-reqbufs.rst  | 76 ++++++++++++++++++++++
 Documentation/media/uapi/dvb/dmx_fcalls.rst   |  4 ++
 5 files changed, 320 insertions(+)
 create mode 100644 Documentation/media/uapi/dvb/dmx-expbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-qbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-querybuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-reqbufs.rst

diff --git a/Documentation/media/uapi/dvb/dmx-expbuf.rst b/Documentation/media/uapi/dvb/dmx-expbuf.rst
new file mode 100644
index 000000000000..51df34c6fb59
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-expbuf.rst
@@ -0,0 +1,90 @@
+.. _DMX_EXPBUF:
+
+****************
+ioctl DMX_EXPBUF
+****************
+
+Name
+====
+
+DMX_EXPBUF - Export a buffer as a DMABUF file descriptor.
+
+.. warning:: this API is still experimental
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, DMX_EXPBUF, struct dmx_exportbuffer *argp )
+    :name: DMX_EXPBUF
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <dmx_fopen>`.
+
+``argp``
+    Pointer to struct :c:type:`dmx_exportbuffer`.
+
+
+Description
+===========
+
+This ioctl is an extension to the memory mapping I/O method.
+It can be used to export a buffer as a DMABUF file at any time after
+buffers have been allocated with the :ref:`DMX_REQBUFS` ioctl.
+
+The ``reserved`` array must be zeroed before calling it.
+
+To export a buffer, applications fill struct :c:type:`dmx_exportbuffer`.
+Applications must set the ``index`` field. Valid index numbers
+range from zero to the number of buffers allocated with :ref:`DMX_REQBUFS`
+(struct :c:type:`dmx_requestbuffers` ``count``) minus one.
+Additional flags may be posted in the ``flags`` field. Refer to a manual
+for open() for details. Currently only O_CLOEXEC, O_RDONLY, O_WRONLY,
+and O_RDWR are supported.
+All other fields must be set to zero. In the
+case of multi-planar API, every plane is exported separately using
+multiple :ref:`DMX_EXPBUF` calls.
+
+After calling :ref:`DMX_EXPBUF` the ``fd`` field will be set by a
+driver, on success. This is a DMABUF file descriptor. The application may
+pass it to other DMABUF-aware devices. It is recommended to close a DMABUF
+file when it is no longer used to allow the associated memory to be reclaimed.
+
+
+Examples
+========
+
+
+.. code-block:: c
+
+    int buffer_export(int v4lfd, enum dmx_buf_type bt, int index, int *dmafd)
+    {
+	struct dmx_exportbuffer expbuf;
+
+	memset(&expbuf, 0, sizeof(expbuf));
+	expbuf.type = bt;
+	expbuf.index = index;
+	if (ioctl(v4lfd, DMX_EXPBUF, &expbuf) == -1) {
+	    perror("DMX_EXPBUF");
+	    return -1;
+	}
+
+	*dmafd = expbuf.fd;
+
+	return 0;
+    }
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EINVAL
+    A queue is not in MMAP mode or DMABUF exporting is not supported or
+    ``flags`` or ``index`` fields are invalid.
diff --git a/Documentation/media/uapi/dvb/dmx-qbuf.rst b/Documentation/media/uapi/dvb/dmx-qbuf.rst
new file mode 100644
index 000000000000..b20b8153d48d
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-qbuf.rst
@@ -0,0 +1,85 @@
+.. _DMX_QBUF:
+
+*************************
+ioctl DMX_QBUF, DMX_DQBUF
+*************************
+
+Name
+====
+
+DMX_QBUF - DMX_DQBUF - Exchange a buffer with the driver
+
+.. warning:: this API is still experimental
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, DMX_QBUF, struct dmx_buffer *argp )
+    :name: DMX_QBUF
+
+.. c:function:: int ioctl( int fd, DMX_DQBUF, struct dmx_buffer *argp )
+    :name: DMX_DQBUF
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <dmx_fopen>`.
+
+``argp``
+    Pointer to struct :c:type:`dmx_buffer`.
+
+
+Description
+===========
+
+Applications call the ``DMX_QBUF`` ioctl to enqueue an empty
+(capturing) or filled (output) buffer in the driver's incoming queue.
+The semantics depend on the selected I/O method.
+
+To enqueue a buffer applications set the ``index`` field. Valid index
+numbers range from zero to the number of buffers allocated with
+:ref:`DMX_REQBUFS` (struct :c:type:`dmx_requestbuffers` ``count``) minus
+one. The contents of the struct :c:type:`dmx_buffer` returned
+by a :ref:`DMX_QUERYBUF` ioctl will do as well.
+
+The and ``reserved`` field must be set to 0.
+
+When ``DMX_QBUF`` is called with a pointer to this structure, it locks the
+memory pages of the buffer in physical memory, so they cannot be swapped
+out to disk. Buffers remain locked until dequeued, until the
+the device is closed.
+
+Applications call the ``DMX_DQBUF`` ioctl to dequeue a filled
+(capturing) buffer from the driver's outgoing queue. They just set the ``reserved`` field array to zero. When ``DMX_DQBUF`` is called with a
+pointer to this structure, the driver fills the remaining fields or
+returns an error code.
+
+By default ``DMX_DQBUF`` blocks when no buffer is in the outgoing
+queue. When the ``O_NONBLOCK`` flag was given to the
+:ref:`open() <dmx_fopen>` function, ``DMX_DQBUF`` returns
+immediately with an ``EAGAIN`` error code when no buffer is available.
+
+The struct :c:type:`dmx_buffer` structure is specified in
+:ref:`buffer`.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EAGAIN
+    Non-blocking I/O has been selected using ``O_NONBLOCK`` and no
+    buffer was in the outgoing queue.
+
+EINVAL
+    The ``index`` is out of bounds, or no buffers have been allocated yet.
+
+EIO
+    ``DMX_DQBUF`` failed due to an internal error. Can also indicate
+    temporary problems like signal loss or CRC errors.
diff --git a/Documentation/media/uapi/dvb/dmx-querybuf.rst b/Documentation/media/uapi/dvb/dmx-querybuf.rst
new file mode 100644
index 000000000000..46a50f191b10
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-querybuf.rst
@@ -0,0 +1,65 @@
+.. _DMX_QUERYBUF:
+
+******************
+ioctl DMX_QUERYBUF
+******************
+
+Name
+====
+
+DMX_QUERYBUF - Query the status of a buffer
+
+.. warning:: this API is still experimental
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, DMX_QUERYBUF, struct dvb_buffer *argp )
+    :name: DMX_QUERYBUF
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <dmx_fopen>`.
+
+``argp``
+    Pointer to struct :c:type:`dvb_buffer`.
+
+
+Description
+===========
+
+This ioctl is part of the mmap streaming I/O method. It can
+be used to query the status of a buffer at any time after buffers have
+been allocated with the :ref:`DMX_REQBUFS` ioctl.
+
+The ``reserved`` array must be zeroed before calling it.
+
+Applications set the ``index`` field. Valid index numbers range from zero
+to the number of buffers allocated with :ref:`DMX_REQBUFS`
+(struct :c:type:`dvb_requestbuffers` ``count``) minus one.
+
+After calling :ref:`DMX_QUERYBUF` with a pointer to this structure,
+drivers return an error code or fill the rest of the structure.
+
+On success, the ``offset`` will contain the offset of the buffer from the
+start of the device memory, the ``length`` field its size, and the
+``bytesused`` the number of bytes occupied by data in the buffer (payload).
+
+Return Value
+============
+
+On success 0 is returned, the ``offset`` will contain the offset of the
+buffer from the start of the device memory, the ``length`` field its size,
+and the ``bytesused`` the number of bytes occupied by data in the buffer
+(payload).
+
+On error it returns -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EINVAL
+    The ``index`` is out of bounds.
diff --git a/Documentation/media/uapi/dvb/dmx-reqbufs.rst b/Documentation/media/uapi/dvb/dmx-reqbufs.rst
new file mode 100644
index 000000000000..0749623d9d83
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-reqbufs.rst
@@ -0,0 +1,76 @@
+.. _DMX_REQBUFS:
+
+*****************
+ioctl DMX_REQBUFS
+*****************
+
+Name
+====
+
+DMX_REQBUFS - Initiate Memory Mapping and/or DMA buffer I/O
+
+.. warning:: this API is still experimental
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, DMX_REQBUFS, struct dmx_requestbuffers *argp )
+    :name: DMX_REQBUFS
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <dmx_fopen>`.
+
+``argp``
+    Pointer to struct :c:type:`dmx_requestbuffers`.
+
+Description
+===========
+
+This ioctl is used to initiate a memory mapped or DMABUF based demux I/O.
+
+Memory mapped buffers are located in device memory and must be allocated
+with this ioctl before they can be mapped into the application's address
+space. User buffers are allocated by applications themselves, and this
+ioctl is merely used to switch the driver into user pointer I/O mode and
+to setup some internal structures. Similarly, DMABUF buffers are
+allocated by applications through a device driver, and this ioctl only
+configures the driver into DMABUF I/O mode without performing any direct
+allocation.
+
+The ``reserved`` array must be zeroed before calling it.
+
+To allocate device buffers applications initialize all fields of the
+struct :c:type:`dmx_requestbuffers` structure. They set the  ``count`` field
+to the desired number of buffers,  and ``size`` to the size of each
+buffer.
+
+When the ioctl is called with a pointer to this structure, the driver will
+attempt to allocate the requested number of buffers and it stores the actual
+number allocated in the ``count`` field. The ``count`` can be smaller than the number requested, even zero, when the driver runs out of free memory. A larger
+number is also possible when the driver requires more buffers to
+function correctly. The actual allocated buffer size can is returned
+at ``size``, and can be smaller than what's requested.
+
+When this I/O method is not supported, the ioctl returns an ``EOPNOTSUPP``
+error code.
+
+Applications can call :ref:`DMX_REQBUFS` again to change the number of
+buffers, however this cannot succeed when any buffers are still mapped.
+A ``count`` value of zero frees all buffers, after aborting or finishing
+any DMA in progress.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EOPNOTSUPP
+    The  the requested I/O method is not supported.
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index db19df6dbf70..4c391cf2554f 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -24,3 +24,7 @@ Demux Function Calls
     dmx-get-pes-pids
     dmx-add-pid
     dmx-remove-pid
+    dmx-reqbufs
+    dmx-querybuf
+    dmx-expbuf
+    dmx-qbuf
-- 
2.14.3
