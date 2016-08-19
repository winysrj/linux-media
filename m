Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754706AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 04/15] [media] vidioc-g-sliced-vbi-cap.rst: make tables fit on LaTeX output
Date: Fri, 19 Aug 2016 10:04:54 -0300
Message-Id: <0e7c7bacdf7c80360e10eaa76545c05e59925c78.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tables don't fit at the page on this file. As noticed
before, Sphinx (or LaTeX?) does a crap job on tables with
cell span, and some work has to be done to make it fit.

Move the see also reference to a footnote, break one paragraph
into two and adjust the table columns to make it visible.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     | 30 +++++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 0d4b6b0044a0..740324e6e5db 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -48,7 +48,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. _v4l2-sliced-vbi-cap:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|
+.. tabularcolumns:: |p{1.2cm}|p{4.2cm}|p{4.1cm}|p{4.0cm}|p{4.0cm}|
 
 .. flat-table:: struct v4l2_sliced_vbi_cap
     :header-rows:  0
@@ -63,6 +63,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
        -  ``service_set``
 
        -  :cspan:`2` A set of all data services supported by the driver.
+
 	  Equal to the union of all elements of the ``service_lines`` array.
 
     -  .. row 2
@@ -74,8 +75,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
        -  :cspan:`2` Each element of this array contains a set of data
 	  services the hardware can look for or insert into a particular
 	  scan line. Data services are defined in :ref:`vbi-services`.
-	  Array indices map to ITU-R line numbers (see also :ref:`vbi-525`
-	  and :ref:`vbi-625`) as follows:
+	  Array indices map to ITU-R line numbers\ [#f1]_ as follows:
 
     -  .. row 3
 
@@ -171,14 +171,22 @@ the sliced VBI API is unsupported or ``type`` is invalid.
        -  ``reserved``\ [3]
 
        -  :cspan:`2` This array is reserved for future extensions.
+
 	  Applications and drivers must set it to zero.
 
+.. [#f1]
 
+   See also :ref:`vbi-525` and :ref:`vbi-625`.
+
+
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
 
 .. _vbi-services:
 
-.. tabularcolumns:: |p{4.4cm}|p{2.2cm}|p{2.2cm}|p{4.4cm}|p{4.3cm}|
-
 .. flat-table:: Sliced VBI services
     :header-rows:  1
     :stub-columns: 0
@@ -203,7 +211,9 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  0x0001
 
-       -  :ref:`ets300706`, :ref:`itu653`
+       -  :ref:`ets300706`,
+
+	  :ref:`itu653`
 
        -  PAL/SECAM line 7-22, 320-335 (second field 7-22)
 
@@ -242,7 +252,9 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  0x4000
 
-       -  :ref:`en300294`, :ref:`itu1119`
+       -  :ref:`en300294`,
+
+	  :ref:`itu1119`
 
        -  PAL/SECAM line 23
 
@@ -270,6 +282,10 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  :cspan:`2` Set of services applicable to 625 line systems.
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
+
 
 Return Value
 ============
-- 
2.7.4


