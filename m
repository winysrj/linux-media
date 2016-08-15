Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbcHOWjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 18:39:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC] [media] pixfmt-packed-rgb.rst: rotate a big table
Date: Mon, 15 Aug 2016 19:39:30 -0300
Message-Id: <3eaf1d4cfd703bbc591e4c1c444728f3bb2a9fbd.1471300597.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rotates the big RGB packed table to landscape.

This is actually an example patch that depends on the past RFCv2 9 patches
series I sent before.

It uses LaTex adjustbox extension to rotate the packed RGB big table,
and rotate it to landscape. This way, the table appears on the entire
page.

It should be noticed, however, that the table is not well displayed, as the size
hints are not ok. Not sure how to fix such issue.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py                              | 3 +++
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index e081f56a019c..2bc91fcc6d1f 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -291,6 +291,9 @@ latex_elements = {
         \\setromanfont{DejaVu Sans}
         \\setmonofont{DejaVu Sans Mono}
 
+	% To allow adjusting table sizes
+	\\usepackage{adjustbox}
+
      '''
 }
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index c7aa2e91ac78..9a909cd99361 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -19,6 +19,10 @@ graphics frame buffers. They occupy 8, 16, 24 or 32 bits per pixel.
 These are all packed-pixel formats, meaning all the data for a pixel lie
 next to each other in memory.
 
+.. raw:: latex
+
+    \begin{landscape}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. _rgb-formats:
 
@@ -26,7 +30,6 @@ next to each other in memory.
     :header-rows:  2
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  Identifier
@@ -942,6 +945,10 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
+.. raw:: latex
+
+    \end{adjustbox}
+    \end{landscape}
 
 Bit 7 is the most significant bit.
 
-- 
2.7.4


