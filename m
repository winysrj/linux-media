Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 07/11] [media] v4l2-fh.rst: add cross references and markups
Date: Fri, 22 Jul 2016 12:03:03 -0300
Message-Id: <394f2200a97339881f9413ebfdea789ad8d9ce1e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add cross-references with the kernel-doc functions/structs
and improve the markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-fh.rst | 111 ++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 55 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index f39374262d3f..a212698d5725 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -1,27 +1,35 @@
 V4L2 File handlers
 ------------------
 
-struct v4l2_fh provides a way to easily keep file handle specific data
-that is used by the V4L2 framework. New drivers must use struct v4l2_fh
-since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY).
+struct :c:type:`v4l2_fh` provides a way to easily keep file handle specific
+data that is used by the V4L2 framework.
 
-The users of v4l2_fh (in the V4L2 framework, not the driver) know
-whether a driver uses v4l2_fh as its file->private_data pointer by
-testing the V4L2_FL_USES_V4L2_FH bit in video_device->flags. This bit is
-set whenever v4l2_fh_init() is called.
+.. attention::
+	New drivers must use struct :c:type:`v4l2_fh`
+	since it is also used to implement priority handling
+	(:ref:`VIDIOC_G_PRIORITY`).
 
-struct v4l2_fh is allocated as a part of the driver's own file handle
-structure and file->private_data is set to it in the driver's open
+The users of :c:type:`v4l2_fh` (in the V4L2 framework, not the driver) know
+whether a driver uses :c:type:`v4l2_fh` as its ``file->private_data`` pointer
+by testing the ``V4L2_FL_USES_V4L2_FH`` bit in :c:type:`video_device`->flags.
+This bit is set whenever :cpp:func:`v4l2_fh_init` is called.
+
+struct :c:type:`v4l2_fh` is allocated as a part of the driver's own file handle
+structure and ``file->private_data`` is set to it in the driver's ``open()``
 function by the driver.
 
-In many cases the struct v4l2_fh will be embedded in a larger structure.
-In that case you should call v4l2_fh_init+v4l2_fh_add in open() and
-v4l2_fh_del+v4l2_fh_exit in release().
+In many cases the struct :c:type:`v4l2_fh` will be embedded in a larger
+structure. In that case you should call:
+
+#) :cpp:func:`v4l2_fh_init` and :cpp:func:`v4l2_fh_add` in ``open()``
+#) :cpp:func:`v4l2_fh_del` and :cpp:func:`v4l2_fh_exit` in ``release()``
 
 Drivers can extract their own file handle structure by using the container_of
-macro. Example:
+macro.
 
-.. code-block:: none
+Example:
+
+.. code-block:: c
 
 	struct my_fh {
 		int blah;
@@ -63,73 +71,66 @@ macro. Example:
 		return 0;
 	}
 
-Below is a short description of the v4l2_fh functions used:
+Below is a short description of the :c:type:`v4l2_fh` functions used:
 
-.. code-block:: none
+:cpp:func:`v4l2_fh_init <v4l2_fh_init>`
+(:c:type:`fh <v4l2_fh>`, :c:type:`vdev <video_device>`)
 
-	void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 
-  Initialise the file handle. This *MUST* be performed in the driver's
-  v4l2_file_operations->open() handler.
+- Initialise the file handle. This **MUST** be performed in the driver's
+  :c:type:`v4l2_file_operations`->open() handler.
 
-.. code-block:: none
 
-	void v4l2_fh_add(struct v4l2_fh *fh)
+:cpp:func:`v4l2_fh_add <v4l2_fh_add>`
+(:c:type:`fh <v4l2_fh>`)
 
-  Add a v4l2_fh to video_device file handle list. Must be called once the
-  file handle is completely initialized.
+- Add a :c:type:`v4l2_fh` to :c:type:`video_device` file handle list.
+  Must be called once the file handle is completely initialized.
 
-.. code-block:: none
+:cpp:func:`v4l2_fh_del <v4l2_fh_del>`
+(:c:type:`fh <v4l2_fh>`)
 
-	void v4l2_fh_del(struct v4l2_fh *fh)
-
-  Unassociate the file handle from video_device(). The file handle
+- Unassociate the file handle from :c:type:`video_device`. The file handle
   exit function may now be called.
 
-.. code-block:: none
+:cpp:func:`v4l2_fh_exit <v4l2_fh_exit>`
+(:c:type:`fh <v4l2_fh>`)
 
-	void v4l2_fh_exit(struct v4l2_fh *fh)
-
-  Uninitialise the file handle. After uninitialisation the v4l2_fh
+- Uninitialise the file handle. After uninitialisation the :c:type:`v4l2_fh`
   memory can be freed.
 
 
-If struct v4l2_fh is not embedded, then you can use these helper functions:
+If struct :c:type:`v4l2_fh` is not embedded, then you can use these helper functions:
 
-.. code-block:: none
+:cpp:func:`v4l2_fh_open <v4l2_fh_open>`
+(struct file \*filp)
 
-	int v4l2_fh_open(struct file *filp)
+- This allocates a struct :c:type:`v4l2_fh`, initializes it and adds it to
+  the struct :c:type:`video_device` associated with the file struct.
 
-  This allocates a struct v4l2_fh, initializes it and adds it to the struct
-  video_device associated with the file struct.
+:cpp:func:`v4l2_fh_release <v4l2_fh_release>`
+(struct file \*filp)
 
-.. code-block:: none
-
-	int v4l2_fh_release(struct file *filp)
-
-  This deletes it from the struct video_device associated with the file
-  struct, uninitialised the v4l2_fh and frees it.
-
-These two functions can be plugged into the v4l2_file_operation's open() and
-release() ops.
+- This deletes it from the struct :c:type:`video_device` associated with the
+  file struct, uninitialised the :c:type:`v4l2_fh` and frees it.
 
+These two functions can be plugged into the v4l2_file_operation's ``open()``
+and ``release()`` ops.
 
 Several drivers need to do something when the first file handle is opened and
 when the last file handle closes. Two helper functions were added to check
-whether the v4l2_fh struct is the only open filehandle of the associated
-device node:
+whether the :c:type:`v4l2_fh` struct is the only open filehandle of the
+associated device node:
 
-.. code-block:: none
+:cpp:func:`v4l2_fh_is_singular <v4l2_fh_is_singular>`
+(:c:type:`fh <v4l2_fh>`)
 
-	int v4l2_fh_is_singular(struct v4l2_fh *fh)
+-  Returns 1 if the file handle is the only open file handle, else 0.
 
-  Returns 1 if the file handle is the only open file handle, else 0.
+:cpp:func:`v4l2_fh_is_singular_file <v4l2_fh_is_singular_file>`
+(struct file \*filp)
 
-.. code-block:: none
-
-	int v4l2_fh_is_singular_file(struct file *filp)
-
-  Same, but it calls v4l2_fh_is_singular with filp->private_data.
+- Same, but it calls v4l2_fh_is_singular with filp->private_data.
 
 
 V4L2 File Handler kAPI
-- 
2.7.4

