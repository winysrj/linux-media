Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbcHPQrm (ORCPT
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
Subject: [PATCH 6/9] [media] docs-rst: get rid of code-block inside tables
Date: Tue, 16 Aug 2016 13:47:34 -0300
Message-Id: <ec129bcabb1a9538d1d0f677b399eff30e4555c3.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two tables with a C code-block inside it. Unfortunately,
that causes LaTeX output to break. Yet, there's nothing special
there, so let's remove the code-block from them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst |  5 +----
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 12 +++---------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 4715261631ab..13d5b509a829 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -105,11 +105,8 @@ one until ``EINVAL`` is returned.
 
        -  :cspan:`2`
 
-
 	  .. _v4l2-fourcc:
-	  .. code-block:: c
-
-	      #define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))
+	  ``#define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))``
 
 	  Several image formats are already defined by this specification in
 	  :ref:`pixfmt`.
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index b10fed313f99..f37fc3badcdf 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -117,17 +117,11 @@ specification the ioctl returns an ``EINVAL`` error code.
 
        -  :cspan:`2`
 
+	  ``#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))``
 
-	  .. code-block:: c
+	  ``__u32 version = KERNEL_VERSION(0, 8, 1);``
 
-	      #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
-
-	      __u32 version = KERNEL_VERSION(0, 8, 1);
-
-	      printf ("Version: %u.%u.%u\\n",
-		  (version >> 16) & 0xFF,
-		  (version >> 8) & 0xFF,
-		   version & 0xFF);
+	  ``printf ("Version: %u.%u.%u\\n", (version >> 16) & 0xFF, (version >> 8) & 0xFF, version & 0xFF);``
 
     -  .. row 6
 
-- 
2.7.4


