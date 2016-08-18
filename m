Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754302AbcHSDoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:44:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 07/20] [media] pixfmt-packed-rgb.rst: adjust tables to fit in LaTeX
Date: Thu, 18 Aug 2016 13:15:36 -0300
Message-Id: <6737a5c68facabb841e19a983d4e72b9a0ad851d.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the tables to fit at the LaTeX and PDF outputs.

Previously, we were displaying the long table in landscape,
but it makes harder to read on displays.

This time, let's use the adjustbox to shrink the size of those
long tables, as the table size can still be visible on screen,
and it is a way better to read in horizontal position and
visible if printed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 37 ++++++++++++++--------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 3a7133fbec80..f7245f5e0854 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -6,11 +6,6 @@
 Packed RGB formats
 ******************
 
-*man Packed RGB formats(2)*
-
-Packed RGB formats
-
-
 Description
 ===========
 
@@ -21,11 +16,12 @@ next to each other in memory.
 
 .. raw:: latex
 
-    \begin{landscape}
-    \begin{adjustbox}{width=\columnwidth}
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
 
 .. _rgb-formats:
 
+.. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
+
 .. flat-table:: Packed RGB Image Formats
     :header-rows:  2
     :stub-columns: 0
@@ -950,10 +946,9 @@ next to each other in memory.
 
 .. raw:: latex
 
-    \end{adjustbox}
-    \end{landscape}
+    \end{adjustbox}\newline\newline
 
-Bit 7 is the most significant bit.
+.. note:: Bit 7 is the most significant bit.
 
 The usage and value of the alpha bits (a) in the ARGB and ABGR formats
 (collectively referred to as alpha formats) depend on the device type
@@ -983,13 +978,16 @@ devices and drivers must ignore those bits, for both
 Each cell is one byte.
 
 
+.. raw:: latex
 
-.. tabularcolumns:: |p{2.5cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{0.7cm}|
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
 
-.. flat-table::
+.. tabularcolumns:: |p{4.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.3cm}|
+
+.. flat-table:: RGB byte order
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1 1 1 1 1
+    :widths:       11 3 3 3 3 3 3 3 3 3 3 3 3
 
 
     -  .. row 1
@@ -1104,6 +1102,9 @@ Each cell is one byte.
 
        -  R\ :sub:`33`
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 Formats defined in :ref:`rgb-formats-deprecated` are deprecated and
 must not be used by new drivers. They are documented here for reference.
@@ -1113,6 +1114,13 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
 .. _rgb-formats-deprecated:
 
+.. raw:: latex
+
+    \newline\newline
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{4.2cm}|p{1.0cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
+
 .. flat-table:: Deprecated Packed RGB Image Formats
     :header-rows:  2
     :stub-columns: 0
@@ -1477,6 +1485,9 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  b\ :sub:`0`
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 A test utility to determine which RGB formats a driver actually supports
 is available from the LinuxTV v4l-dvb repository. See
-- 
2.7.4


