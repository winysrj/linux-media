Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbcHTBlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 21:41:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/3] [media] subdev-formats.rst: adjust tables size for LaTeX output
Date: Fri, 19 Aug 2016 22:40:52 -0300
Message-Id: <bb0ad67625f529519625c0b6544beb355f8543cf.1471657229.git.mchehab@s-opensource.com>
In-Reply-To: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
References: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
In-Reply-To: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
References: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two big tables here that are very hard to adjust its
size.

The first one would fit into one page, but the latex.py logic
at Sphinx auto-switches to longtable when there are more than 30
rows. There's no way to override without coding.

The second one is really big, and won't fit on a single page.
So, it has to use tiny font to fit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 36 ++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index a347fcc206db..0b31943bb300 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -154,18 +154,26 @@ half of the green value) transferred first will be named
 
 The following tables list existing packed RGB formats.
 
-.. FIXME: I was unable to find a way to use adjustbox or landscape for this table!
+.. HACK: ideally, we would be using adjustbox here. However, Sphinx
+.. is a very bad behaviored guy: if the table has more than 30 cols,
+.. it switches to long table, and there's no way to override it.
 
-.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{-1.0cm}|
+
+.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22}|
 
 .. _v4l2-mbus-pixelcode-rgb:
 
+.. raw:: latex
+
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
+
 .. flat-table:: RGB formats
     :header-rows:  2
     :stub-columns: 0
     :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
-
     -  .. row 1
 
        -  Identifier
@@ -2355,6 +2363,10 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
+.. raw:: latex
+
+    \endgroup
+
 On LVDS buses, usually each sample is transferred serialized in seven
 time slots per pixel clock, on three (18-bit) or four (24-bit)
 differential data pairs at the same time. The remaining bits are used
@@ -3751,13 +3763,22 @@ the following codes.
 
 -  d for dummy bits
 
-.. FIXME: I was unable to find a way to use adjustbox or landscape for this table!
 
-.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{-1.0cm}|
+.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22}|
 
 .. _v4l2-mbus-pixelcode-yuv8:
 
-.. cssclass:: longtable
+
+.. HACK: ideally, we would be using adjustbox here. However, this
+.. will never work for this table, as, even with tiny font, it is
+.. to big for a single page. So, we need to manually adjust the
+.. size.
+
+.. raw:: latex
+
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
 
 .. flat-table:: YUV Formats
     :header-rows:  2
@@ -11439,6 +11460,9 @@ the following codes.
        -  v\ :sub:`0`
 
 
+.. raw:: latex
+
+	\endgroup
 
 HSV/HSL Formats
 ^^^^^^^^^^^^^^^
-- 
2.7.4

