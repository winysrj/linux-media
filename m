Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:6722 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbeJISrv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 14:47:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] media: docs: Document metadata format in struct v4l2_format
Date: Tue,  9 Oct 2018 14:31:06 +0300
Message-Id: <20181009113106.14202-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format fields in struct v4l2_format were otherwise reported but the
meta field was missing. Document it.

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/dev-meta.rst     | 2 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
index f7ac8d0d3af14..b65dc078abeb8 100644
--- a/Documentation/media/uapi/v4l/dev-meta.rst
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -40,7 +40,7 @@ To use the :ref:`format` ioctls applications set the ``type`` field of the
 the desired operation. Both drivers and applications must set the remainder of
 the :c:type:`v4l2_format` structure to 0.
 
-.. _v4l2-meta-format:
+.. c:type:: v4l2_meta_format
 
 .. tabularcolumns:: |p{1.4cm}|p{2.2cm}|p{13.9cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index 3ead350e099f9..9ea494a8facab 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -133,6 +133,11 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
       - Definition of a data format, see :ref:`pixfmt`, used by SDR
 	capture and output devices.
     * -
+      - struct :c:type:`v4l2_meta_format`
+      - ``meta``
+      - Definition of a metadata format, see :ref:`meta-formats`, used by
+	metadata capture devices.
+    * -
       - __u8
       - ``raw_data``\ [200]
       - Place holder for future extensions.
-- 
2.11.0
