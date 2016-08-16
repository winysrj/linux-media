Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbcHPQrm (ORCPT
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
Subject: [PATCH 7/9] [media] pixfmt-packed-rgb.rst: rotate a big table
Date: Tue, 16 Aug 2016 13:47:35 -0300
Message-Id: <b103e0f405929fff61ffe871df8b7d5242c6b793.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rotates the big RGB packed table to landscape.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py                              | 3 +++
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 39b9c4a26f6e..64f5fb4170a9 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -306,6 +306,9 @@ latex_elements = {
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


