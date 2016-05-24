Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5228 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbcEXQvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 17/21] DocBook: media: Document the V4L2 request API
Date: Tue, 24 May 2016 19:47:27 +0300
Message-Id: <1464108451-28142-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The V4L2 request API consists in extensions to existing V4L2 ioctls.
Document it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/common.xml         |  2 +
 Documentation/DocBook/media/v4l/io.xml             |  9 ++-
 Documentation/DocBook/media/v4l/request-api.xml    | 90 ++++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |  9 +++
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  6 ++
 5 files changed, 113 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/request-api.xml

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 8b5e014..30cb0f2 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -1073,6 +1073,8 @@ dheight = format.fmt.pix.height;
 
   &sub-selection-api;
 
+  &sub-request-api;
+
   <section id="streaming-par">
     <title>Streaming Parameters</title>
 
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index e09025d..5695bc8 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -833,10 +833,13 @@ is the file descriptor associated with a DMABUF buffer.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved2</structfield></entry>
+	    <entry><structfield>request</structfield></entry>
 	    <entry></entry>
-	    <entry>A place holder for future extensions. Drivers and applications
-must set this to 0.</entry>
+	    <entry>ID of the request to associate the buffer to. Set by the
+	    application for &VIDIOC-QBUF; and &VIDIOC-PREPARE-BUF;. Set to zero
+	    by the application and the driver in all other cases. See
+	    <xref linkend="v4l2-requests" /> for more information.
+	    </entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/request-api.xml b/Documentation/DocBook/media/v4l/request-api.xml
new file mode 100644
index 0000000..992f25a
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/request-api.xml
@@ -0,0 +1,90 @@
+<section id="v4l2-requests">
+
+  <title>Experimental API for request handling</title>
+
+  <note>
+    <title>Experimental</title>
+    <para>This is an <link linkend="experimental">experimental</link>
+    interface and may change in the future.</para>
+  </note>
+
+  <section>
+    <title>Introduction</title>
+
+<para>It is often useful to apply certain settings when a buffer is about to be
+filled by the DMA capture of a video capture device, ensuring that those
+settings are applied in time for them to be used with that buffer.</para>
+
+<para>One of the prime use-cases of this is Android's CameraHAL v3 which
+requires per-frame configuration support. Other use-cases are possible as well:
+changing codec settings (bit rate, etc.) starting with a specific buffer,
+preparing a configuration to be applied at a certain time, etc.</para>
+
+<para>The request API is the way V4L2 solves this problem.</para>
+
+  </section>
+
+  <section>
+    <title>Request Objects</title>
+
+<para>At the core of the request API is the request object. Applications store
+configuration parameters such as V4L2 controls, formats and selection rectangles
+in request objects and then associate those request objects for processing with
+specific buffers.</para>
+
+<para>Request objects are created and managed through the media controller
+device node. Details on request object management can be found in the
+<link linkend="media-ioc-request-cmd">media controller request API</link>
+documentation and are outside the scope of the V4L2 request API. Once a request
+object is created it can be referenced by its ID in the V4L2 ioctls that support
+requests.</para>
+
+<para>Applications can store controls, subdev formats and subdev selection
+rectangles in requests. To do so they use the usual V4L2 ioctls
+&VIDIOC-S-EXT-CTRLS;, &VIDIOC-SUBDEV-S-FMT; and &VIDIOC-SUBDEV-S-SELECTION; with
+the <structfield>request</structfield> field of the associated structure set to
+the request ID (for subdev formats and selection rectangles the
+<structfield>which</structfield> field need to be additionally set to
+<constant>V4L2_SUBDEV_FORMAT_REQUEST</constant>). Controls, formats and
+selection rectangles will be processed as usual but will be stored in the
+request instead of applied to the device.
+</para>
+
+<para>Parameters stored in requests can further be retrieved by calling the
+&VIDIOC-G-EXT-CTRLS;, &VIDIOC-SUBDEV-G-FMT; or &VIDIOC-SUBDEV-G-SELECTION;
+ioctls similarly with the <structfield>request</structfield> field of the
+associated structure set to the request ID.
+</para>
+
+  </section>
+
+  <section>
+    <title>Applying Requests</title>
+
+<para>The simplest way to apply a request is to associated it with a buffer.
+This is done by setting the <structfield>request</structfield> field of the
+&v4l2-buffer; to the request ID when queuing the buffer with the &VIDIOC-QBUF;
+ioctl.
+</para>
+
+<para>Once a buffer is queued with a non-zero request ID the driver will apply
+all parameters stored in the request atomically. The parameters are guaranteed
+to come in effect before the buffer starts being transferred and after all
+previous buffers have been complete.
+</para>
+
+<para>For devices with multiple video nodes requests might need to be applied
+synchronously with several buffers. This is achieved by first preparing (but not
+queuing) all the related buffers using the &VIDIOC-PREPARE-BUF; ioctl with the
+<structfield>request</structfield> field of the &v4l2-buffer; set to the request
+ID. Once this is done the request is queued using the
+<constant>MEDIA_REQ_CMD_QUEUE</constant> command of the &MEDIA-IOC-REQUEST-CMD;
+ioctl on the media controller device node. The driver will then queue all
+buffers prepared for the request as if the &VIDIOC-QBUF; ioctl was called on all
+of them and will apply the request parameters atomically and synchronously with
+the transfer of the buffers.
+</para>
+
+  </section>
+
+</section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
index 7bde698..2c5b72c1 100644
--- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
@@ -59,6 +59,15 @@ not required, the application can use one of
 <constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
 step.</para>
 
+    <para>Applications can prepare a buffer to be processed for a specific
+request. To do so they set the <structfield>request</structfield> field of the
+struct <structname>v4l2_buffer</structname> to the request ID. The buffer will
+then be automatically queued when the request is processed as if the
+<constant>VIDIOC_QBUF</constant> ioctl was called at that time by the
+application. For more information about requests see
+<xref linkend="v4l2-requests" />.
+</para>
+
     <para>The <structname>v4l2_buffer</structname> structure is
 specified in <xref linkend="buffer" />.</para>
   </refsect1>
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 8b98a0e..742f1dd 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -80,6 +80,12 @@ to a filled-in array of &v4l2-plane; and the <structfield>length</structfield>
 field must be set to the number of elements in that array.
 </para>
 
+    <para>Applications can reference a request to be applied when the buffer is
+processed. To do so they set the <structfield>request</structfield> field of the
+struct <structname>v4l2_buffer</structname> to the request ID. For more
+information about requests see <xref linkend="v4l2-requests" />.
+</para>
+
     <para>To enqueue a <link linkend="mmap">memory mapped</link>
 buffer applications set the <structfield>memory</structfield>
 field to <constant>V4L2_MEMORY_MMAP</constant>. When
-- 
1.9.1

