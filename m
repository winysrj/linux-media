Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcHOQXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 12:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC 5/5] HACK!!!!
Date: Mon, 15 Aug 2016 13:23:44 -0300
Message-Id: <7eddead1e85f4805d508fe6f31d6985e33d4999c.1471277426.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471277426.git.mchehab@s-opensource.com>
References: <cover.1471277426.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471277426.git.mchehab@s-opensource.com>
References: <cover.1471277426.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please, never apply this!

This hack comments out some stuff, in order to fix a few table outputs when
using Sphinx LaTeX output and pdflatex. Please notice that this *won't* fix
all bugs. A lot more similar hacks is needed, as it seems that Sphinx LaTeX
is broken for non-trivial tables.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/buffer.rst                 | 15 ++++++++++-----
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst        | 17 +++++++++--------
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst | 14 ++++++++------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 5deb4a46f992..0b0af04ec955 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -166,11 +166,16 @@ struct v4l2_buffer
 	  output device because the application did not pass new data in
 	  time.
 
-	  .. note:: This may count the frames received e.g. over USB, without
-	     taking into account the frames dropped by the remote hardware due
-	     to limited compression throughput or bus bandwidth. These devices
-	     identify by not enumerating any video standards, see
-	     :ref:`standard`.
+	  FOO
+
+..	  .. note::
+..
+..	     This may count the frames received e.g. over USB, without
+..	     taking into account the frames dropped by the remote hardware due
+..	     to limited compression throughput or bus bandwidth. These devices
+..	     identify by not enumerating any video standards, see
+..	     :ref:`standard`.
+
 
     -  .. row 10
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 90996f69d6ae..f4b79975aefd 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -51,7 +51,6 @@ one until ``EINVAL`` is returned.
     :stub-columns: 0
     :widths:       1 1 2
 
-
     -  .. row 1
 
        -  __u32
@@ -106,15 +105,17 @@ one until ``EINVAL`` is returned.
 
 
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
-
-	  .. attention:: These codes are not the same as those used
-	     in the Windows world.
+..
+..	  .. attention::
+..
+..	     These codes are not the same as those used
+..	     in the Windows world.
 
     -  .. row 7
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 00ab5e19cc1d..8564b9c2983e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -129,12 +129,14 @@ of the corresponding tuner/modulator is set.
        -  :cspan:`2` The supported modulation systems of this frequency
 	  band. See :ref:`band-modulation`.
 
-	  .. note:: Currently only one modulation system per frequency band
-	     is supported. More work will need to be done if multiple
-	     modulation systems are possible. Contact the linux-media
-	     mailing list
-	     (`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__)
-	     if you need such functionality.
+..	  .. note::
+..
+..	     Currently only one modulation system per frequency band
+..	     is supported. More work will need to be done if multiple
+..	     modulation systems are possible. Contact the linux-media
+..	     mailing list
+..	     (`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__)
+..	     if you need such functionality.
 
     -  .. row 8
 
-- 
2.7.4


