Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 8/9] [media] vidioc-querycap.rst: Better format tables on PDF output
Date: Tue, 16 Aug 2016 13:47:36 -0300
Message-Id: <1ad9f90c919381229b17a42f598a61826e4bd8e0.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both tables on this rst file were not shown right, as they miss
the proper tag (tabularcolumns) to specify the column widths
required for PDF and LaTeX output.

Also, the second table is too big to fit into one page. So,
it should use the longtable class to allow it to be split into
two pages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index f37fc3badcdf..05d86b2b87dd 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -43,11 +43,12 @@ specification the ioctl returns an ``EINVAL`` error code.
 
 .. _v4l2-capability:
 
+.. tabularcolumns:: |p{1.5cm}|p{2.5cm}|p{13cm}|
+
 .. flat-table:: struct v4l2_capability
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
-
+    :widths:       3 4 20
 
     -  .. row 1
 
@@ -121,7 +122,9 @@ specification the ioctl returns an ``EINVAL`` error code.
 
 	  ``__u32 version = KERNEL_VERSION(0, 8, 1);``
 
-	  ``printf ("Version: %u.%u.%u\\n", (version >> 16) & 0xFF, (version >> 8) & 0xFF, version & 0xFF);``
+	  ``printf ("Version: %u.%u.%u\\n",``
+
+	  ``(version >> 16) & 0xFF, (version >> 8) & 0xFF, version & 0xFF);``
 
     -  .. row 6
 
@@ -169,12 +172,15 @@ specification the ioctl returns an ``EINVAL`` error code.
 
 .. _device-capabilities:
 
+.. tabularcolumns:: |p{6cm}|p{2.2cm}|p{8.8cm}|
+
+.. cssclass:: longtable
+
 .. flat-table:: Device Capabilities Flags
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
 
-
     -  .. row 1
 
        -  ``V4L2_CAP_VIDEO_CAPTURE``
-- 
2.7.4


