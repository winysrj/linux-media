Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49116 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753178AbdLUQSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:25 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 07/11] media: dvb uAPI docs: document demux mmap/munmap syscalls
Date: Thu, 21 Dec 2017 14:18:06 -0200
Message-Id: <be86ad467ecc921a76a18bbc0513d1593cdd9c2f.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new dmx mmap interface, those two syscalls are now
handled by the subsystem. Document them.

This patch is based on the V4L2 text for those ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-mmap.rst   | 116 ++++++++++++++++++++++++++++
 Documentation/media/uapi/dvb/dmx-munmap.rst |  54 +++++++++++++
 Documentation/media/uapi/dvb/dmx_fcalls.rst |   2 +
 3 files changed, 172 insertions(+)
 create mode 100644 Documentation/media/uapi/dvb/dmx-mmap.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-munmap.rst

diff --git a/Documentation/media/uapi/dvb/dmx-mmap.rst b/Documentation/media/uapi/dvb/dmx-mmap.rst
new file mode 100644
index 000000000000..15d107348b9f
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-mmap.rst
@@ -0,0 +1,116 @@
+.. _dmx-mmap:
+
+*****************
+Digital TV mmap()
+*****************
+
+Name
+====
+
+dmx-mmap - Map device memory into application address space
+
+.. warning:: this API is still experimental
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <unistd.h>
+    #include <sys/mman.h>
+
+
+.. c:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
+    :name: dmx-mmap
+
+Arguments
+=========
+
+``start``
+    Map the buffer to this address in the application's address space.
+    When the ``MAP_FIXED`` flag is specified, ``start`` must be a
+    multiple of the pagesize and mmap will fail when the specified
+    address cannot be used. Use of this option is discouraged;
+    applications should just specify a ``NULL`` pointer here.
+
+``length``
+    Length of the memory area to map. This must be a multiple of the
+    DVB packet length (188, on most drivers).
+
+``prot``
+    The ``prot`` argument describes the desired memory protection.
+    Regardless of the device type and the direction of data exchange it
+    should be set to ``PROT_READ`` | ``PROT_WRITE``, permitting read
+    and write access to image buffers. Drivers should support at least
+    this combination of flags.
+
+``flags``
+    The ``flags`` parameter specifies the type of the mapped object,
+    mapping options and whether modifications made to the mapped copy of
+    the page are private to the process or are to be shared with other
+    references.
+
+    ``MAP_FIXED`` requests that the driver selects no other address than
+    the one specified. If the specified address cannot be used,
+    :ref:`mmap() <dmx-mmap>` will fail. If ``MAP_FIXED`` is specified,
+    ``start`` must be a multiple of the pagesize. Use of this option is
+    discouraged.
+
+    One of the ``MAP_SHARED`` or ``MAP_PRIVATE`` flags must be set.
+    ``MAP_SHARED`` allows applications to share the mapped memory with
+    other (e. g. child-) processes.
+
+    .. note::
+
+       The Linux Digital TV applications should not set the
+       ``MAP_PRIVATE``, ``MAP_DENYWRITE``, ``MAP_EXECUTABLE`` or ``MAP_ANON``
+       flags.
+
+``fd``
+    File descriptor returned by :ref:`open() <dmx_fopen>`.
+
+``offset``
+    Offset of the buffer in device memory, as returned by
+    :ref:`DMX_QUERYBUF` ioctl.
+
+
+Description
+===========
+
+The :ref:`mmap() <dmx-mmap>` function asks to map ``length`` bytes starting at
+``offset`` in the memory of the device specified by ``fd`` into the
+application address space, preferably at address ``start``. This latter
+address is a hint only, and is usually specified as 0.
+
+Suitable length and offset parameters are queried with the
+:ref:`DMX_QUERYBUF` ioctl. Buffers must be allocated with the
+:ref:`DMX_REQBUFS` ioctl before they can be queried.
+
+To unmap buffers the :ref:`munmap() <dmx-munmap>` function is used.
+
+
+Return Value
+============
+
+On success :ref:`mmap() <dmx-mmap>` returns a pointer to the mapped buffer. On
+error ``MAP_FAILED`` (-1) is returned, and the ``errno`` variable is set
+appropriately. Possible error codes are:
+
+EBADF
+    ``fd`` is not a valid file descriptor.
+
+EACCES
+    ``fd`` is not open for reading and writing.
+
+EINVAL
+    The ``start`` or ``length`` or ``offset`` are not suitable. (E. g.
+    they are too large, or not aligned on a ``PAGESIZE`` boundary.)
+
+    The ``flags`` or ``prot`` value is not supported.
+
+    No buffers have been allocated with the
+    :ref:`DMX_REQBUFS` ioctl.
+
+ENOMEM
+    Not enough physical or virtual memory was available to complete the
+    request.
diff --git a/Documentation/media/uapi/dvb/dmx-munmap.rst b/Documentation/media/uapi/dvb/dmx-munmap.rst
new file mode 100644
index 000000000000..d77218732bb6
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx-munmap.rst
@@ -0,0 +1,54 @@
+.. _dmx-munmap:
+
+************
+DVB munmap()
+************
+
+Name
+====
+
+dmx-munmap - Unmap device memory
+
+.. warning:: This API is still experimental.
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <unistd.h>
+    #include <sys/mman.h>
+
+
+.. c:function:: int munmap( void *start, size_t length )
+    :name: dmx-munmap
+
+Arguments
+=========
+
+``start``
+    Address of the mapped buffer as returned by the
+    :ref:`mmap() <dmx-mmap>` function.
+
+``length``
+    Length of the mapped buffer. This must be the same value as given to
+    :ref:`mmap() <dmx-mmap>`.
+
+
+Description
+===========
+
+Unmaps a previously with the :ref:`mmap() <dmx-mmap>` function mapped
+buffer and frees it, if possible.
+
+
+Return Value
+============
+
+On success :ref:`munmap() <dmx-munmap>` returns 0, on failure -1 and the
+``errno`` variable is set appropriately:
+
+EINVAL
+    The ``start`` or ``length`` is incorrect, or no buffers have been
+    mapped yet.
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index a17289143220..db19df6dbf70 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -13,6 +13,8 @@ Demux Function Calls
     dmx-fclose
     dmx-fread
     dmx-fwrite
+    dmx-mmap
+    dmx-munmap
     dmx-start
     dmx-stop
     dmx-set-filter
-- 
2.14.3
