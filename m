Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/11] [media] v4l2-fh.rst: add fh contents from v4l2-framework.rst
Date: Fri, 22 Jul 2016 12:03:02 -0300
Message-Id: <6f4d26f21c2fb1bb501fb8de92117d9d0ed4005a.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the v4l2_fh specific content from v4l2-framework.rst
to v4l2-fh.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-fh.rst        | 134 ++++++++++++++++++++++++++++
 Documentation/media/kapi/v4l2-framework.rst | 133 ---------------------------
 2 files changed, 134 insertions(+), 133 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index 9309c18e967a..f39374262d3f 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -1,3 +1,137 @@
+V4L2 File handlers
+------------------
+
+struct v4l2_fh provides a way to easily keep file handle specific data
+that is used by the V4L2 framework. New drivers must use struct v4l2_fh
+since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY).
+
+The users of v4l2_fh (in the V4L2 framework, not the driver) know
+whether a driver uses v4l2_fh as its file->private_data pointer by
+testing the V4L2_FL_USES_V4L2_FH bit in video_device->flags. This bit is
+set whenever v4l2_fh_init() is called.
+
+struct v4l2_fh is allocated as a part of the driver's own file handle
+structure and file->private_data is set to it in the driver's open
+function by the driver.
+
+In many cases the struct v4l2_fh will be embedded in a larger structure.
+In that case you should call v4l2_fh_init+v4l2_fh_add in open() and
+v4l2_fh_del+v4l2_fh_exit in release().
+
+Drivers can extract their own file handle structure by using the container_of
+macro. Example:
+
+.. code-block:: none
+
+	struct my_fh {
+		int blah;
+		struct v4l2_fh fh;
+	};
+
+	...
+
+	int my_open(struct file *file)
+	{
+		struct my_fh *my_fh;
+		struct video_device *vfd;
+		int ret;
+
+		...
+
+		my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+
+		...
+
+		v4l2_fh_init(&my_fh->fh, vfd);
+
+		...
+
+		file->private_data = &my_fh->fh;
+		v4l2_fh_add(&my_fh->fh);
+		return 0;
+	}
+
+	int my_release(struct file *file)
+	{
+		struct v4l2_fh *fh = file->private_data;
+		struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
+
+		...
+		v4l2_fh_del(&my_fh->fh);
+		v4l2_fh_exit(&my_fh->fh);
+		kfree(my_fh);
+		return 0;
+	}
+
+Below is a short description of the v4l2_fh functions used:
+
+.. code-block:: none
+
+	void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+
+  Initialise the file handle. This *MUST* be performed in the driver's
+  v4l2_file_operations->open() handler.
+
+.. code-block:: none
+
+	void v4l2_fh_add(struct v4l2_fh *fh)
+
+  Add a v4l2_fh to video_device file handle list. Must be called once the
+  file handle is completely initialized.
+
+.. code-block:: none
+
+	void v4l2_fh_del(struct v4l2_fh *fh)
+
+  Unassociate the file handle from video_device(). The file handle
+  exit function may now be called.
+
+.. code-block:: none
+
+	void v4l2_fh_exit(struct v4l2_fh *fh)
+
+  Uninitialise the file handle. After uninitialisation the v4l2_fh
+  memory can be freed.
+
+
+If struct v4l2_fh is not embedded, then you can use these helper functions:
+
+.. code-block:: none
+
+	int v4l2_fh_open(struct file *filp)
+
+  This allocates a struct v4l2_fh, initializes it and adds it to the struct
+  video_device associated with the file struct.
+
+.. code-block:: none
+
+	int v4l2_fh_release(struct file *filp)
+
+  This deletes it from the struct video_device associated with the file
+  struct, uninitialised the v4l2_fh and frees it.
+
+These two functions can be plugged into the v4l2_file_operation's open() and
+release() ops.
+
+
+Several drivers need to do something when the first file handle is opened and
+when the last file handle closes. Two helper functions were added to check
+whether the v4l2_fh struct is the only open filehandle of the associated
+device node:
+
+.. code-block:: none
+
+	int v4l2_fh_is_singular(struct v4l2_fh *fh)
+
+  Returns 1 if the file handle is the only open file handle, else 0.
+
+.. code-block:: none
+
+	int v4l2_fh_is_singular_file(struct file *filp)
+
+  Same, but it calls v4l2_fh_is_singular with filp->private_data.
+
+
 V4L2 File Handler kAPI
 ^^^^^^^^^^^^^^^^^^^^^^
 .. kernel-doc:: include/media/v4l2-fh.h
diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index d46380ac7c1d..8b4f684e1a7a 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -80,139 +80,6 @@ The V4L2 framework also optionally integrates with the media framework. If a
 driver sets the struct v4l2_device mdev field, sub-devices and video nodes
 will automatically appear in the media framework as entities.
 
-struct v4l2_fh
---------------
-
-struct v4l2_fh provides a way to easily keep file handle specific data
-that is used by the V4L2 framework. New drivers must use struct v4l2_fh
-since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY).
-
-The users of v4l2_fh (in the V4L2 framework, not the driver) know
-whether a driver uses v4l2_fh as its file->private_data pointer by
-testing the V4L2_FL_USES_V4L2_FH bit in video_device->flags. This bit is
-set whenever v4l2_fh_init() is called.
-
-struct v4l2_fh is allocated as a part of the driver's own file handle
-structure and file->private_data is set to it in the driver's open
-function by the driver.
-
-In many cases the struct v4l2_fh will be embedded in a larger structure.
-In that case you should call v4l2_fh_init+v4l2_fh_add in open() and
-v4l2_fh_del+v4l2_fh_exit in release().
-
-Drivers can extract their own file handle structure by using the container_of
-macro. Example:
-
-.. code-block:: none
-
-	struct my_fh {
-		int blah;
-		struct v4l2_fh fh;
-	};
-
-	...
-
-	int my_open(struct file *file)
-	{
-		struct my_fh *my_fh;
-		struct video_device *vfd;
-		int ret;
-
-		...
-
-		my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
-
-		...
-
-		v4l2_fh_init(&my_fh->fh, vfd);
-
-		...
-
-		file->private_data = &my_fh->fh;
-		v4l2_fh_add(&my_fh->fh);
-		return 0;
-	}
-
-	int my_release(struct file *file)
-	{
-		struct v4l2_fh *fh = file->private_data;
-		struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
-
-		...
-		v4l2_fh_del(&my_fh->fh);
-		v4l2_fh_exit(&my_fh->fh);
-		kfree(my_fh);
-		return 0;
-	}
-
-Below is a short description of the v4l2_fh functions used:
-
-.. code-block:: none
-
-	void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
-
-  Initialise the file handle. This *MUST* be performed in the driver's
-  v4l2_file_operations->open() handler.
-
-.. code-block:: none
-
-	void v4l2_fh_add(struct v4l2_fh *fh)
-
-  Add a v4l2_fh to video_device file handle list. Must be called once the
-  file handle is completely initialized.
-
-.. code-block:: none
-
-	void v4l2_fh_del(struct v4l2_fh *fh)
-
-  Unassociate the file handle from video_device(). The file handle
-  exit function may now be called.
-
-.. code-block:: none
-
-	void v4l2_fh_exit(struct v4l2_fh *fh)
-
-  Uninitialise the file handle. After uninitialisation the v4l2_fh
-  memory can be freed.
-
-
-If struct v4l2_fh is not embedded, then you can use these helper functions:
-
-.. code-block:: none
-
-	int v4l2_fh_open(struct file *filp)
-
-  This allocates a struct v4l2_fh, initializes it and adds it to the struct
-  video_device associated with the file struct.
-
-.. code-block:: none
-
-	int v4l2_fh_release(struct file *filp)
-
-  This deletes it from the struct video_device associated with the file
-  struct, uninitialised the v4l2_fh and frees it.
-
-These two functions can be plugged into the v4l2_file_operation's open() and
-release() ops.
-
-
-Several drivers need to do something when the first file handle is opened and
-when the last file handle closes. Two helper functions were added to check
-whether the v4l2_fh struct is the only open filehandle of the associated
-device node:
-
-.. code-block:: none
-
-	int v4l2_fh_is_singular(struct v4l2_fh *fh)
-
-  Returns 1 if the file handle is the only open file handle, else 0.
-
-.. code-block:: none
-
-	int v4l2_fh_is_singular_file(struct file *filp)
-
-  Same, but it calls v4l2_fh_is_singular with filp->private_data.
-
 V4L2 clocks
 -----------
 
-- 
2.7.4

