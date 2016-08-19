Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43223 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754503AbcHSNFO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 03/15] [media] vidioc-enumstd.rst: adjust video standards table
Date: Fri, 19 Aug 2016 10:04:53 -0300
Message-Id: <804597b80d9a1aa2a5b0309efcc9aa9d0f589754.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This table is too big for LaTeX output, and lacks columns
specs for LaTeX format.

Also, it has a hidden column, as there are some cell spans
with the wrong values.

Fix it, so it can be displayed properly on LaTeX/PDF.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-enumstd.rst | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 9d7d77af0161..28f00a027cc7 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -272,6 +272,12 @@ support digital TV. See also the Linux DVB API at
     #define V4L2_STD_ALL            (V4L2_STD_525_60        |
 		     V4L2_STD_625_50)
 
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+..                            NTSC/M   PAL/M    /N       /B       /D       /H       /I        SECAM/B    /D       /K1     /L
+.. tabularcolumns:: |p{2.7cm}|p{2.6cm}|p{3.0cm}|p{3.2cm}|p{3.2cm}|p{2.2cm}|p{1.2cm}|p{3.2cm}|p{3.0cm}|p{2.0cm}|p{2.0cm}|p{2.0cm}|
 
 .. _video-standards:
 
@@ -312,7 +318,7 @@ support digital TV. See also the Linux DVB API at
 
        -  :cspan:`1` 525
 
-       -  :cspan:`9` 625
+       -  :cspan:`8` 625
 
     -  .. row 3
 
@@ -320,7 +326,7 @@ support digital TV. See also the Linux DVB API at
 
        -  :cspan:`1` 1001/30000
 
-       -  :cspan:`9` 1/25
+       -  :cspan:`8` 1/25
 
     -  .. row 4
 
@@ -330,13 +336,17 @@ support digital TV. See also the Linux DVB API at
 
        -  3579611.49 ± 10
 
-       -  4433618.75 ± 5 (3582056.25 ± 5)
+       -  4433618.75 ± 5
+
+          (3582056.25 ± 5)
 
        -  :cspan:`3` 4433618.75 ± 5
 
        -  4433618.75 ± 1
 
-       -  :cspan:`3` f\ :sub:`OR` = 4406250 ± 2000, f\ :sub:`OB` = 4250000 ± 2000
+       -  :cspan:`2` f\ :sub:`OR` = 4406250 ± 2000,
+
+	  f\ :sub:`OB` = 4250000 ± 2000
 
     -  .. row 5
 
@@ -390,6 +400,11 @@ support digital TV. See also the Linux DVB API at
 
        -  6.5 [#f8]_
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
+
+
 
 Return Value
 ============
-- 
2.7.4


