Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC v2 9/9] HACK: make pdfdocs build with media books
Date: Mon, 15 Aug 2016 18:22:00 -0300
Message-Id: <ad7ca2a4f8e6287504c00dedb837c72d7254e226.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---------------------------------
PLEASE DO NOT APPLY THIS UPSTREAM
---------------------------------

This hack addresses two issues with pdf generation from media
books:

1) Sphinx doesn't do the right thing if a block of code
   is inside a table. This sounds a Sphinx bug. Perhaps it
   can be fixed by preloading some LaTeX code.

2) the file output doesn't do the right thing for PDF.
   This is likely due to the lack of some escape chars when
   generating the output rst file.

This hack makes the document to build fully.

Please notice that tables are not built well yet, as most are too
big. We can very likely fix several of them by rotating the page
to landscape.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx                    |  1 +
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst |  8 ++++----
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 20 ++++++++++----------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index aa7ff32be589..8aa4fffda860 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -49,6 +49,7 @@ ifeq ($(HAVE_PDFLATEX),0)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	$(call cmd,sphinx,latex)
+	(cd $(BUILDDIR); for i in *.rst; do echo >$$i; done)
 	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 4715261631ab..7df7bee142b6 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -107,10 +107,10 @@ one until ``EINVAL`` is returned.
 
 
 	  .. _v4l2-fourcc:
-	  .. code-block:: c
-
-	      #define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))
-
+..	  .. code-block:: c
+..
+..	      #define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))
+..
 	  Several image formats are already defined by this specification in
 	  :ref:`pixfmt`.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index b10fed313f99..96ea81344696 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -118,16 +118,16 @@ specification the ioctl returns an ``EINVAL`` error code.
        -  :cspan:`2`
 
 
-	  .. code-block:: c
-
-	      #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
-
-	      __u32 version = KERNEL_VERSION(0, 8, 1);
-
-	      printf ("Version: %u.%u.%u\\n",
-		  (version >> 16) & 0xFF,
-		  (version >> 8) & 0xFF,
-		   version & 0xFF);
+..	  .. code-block:: c
+..
+..	      #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
+..
+..	      __u32 version = KERNEL_VERSION(0, 8, 1);
+..
+..	      printf ("Version: %u.%u.%u\\n",
+..		  (version >> 16) & 0xFF,
+..		  (version >> 8) & 0xFF,
+..		   version & 0xFF);
 
     -  .. row 6
 
-- 
2.7.4


