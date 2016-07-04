Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbcGDLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 51/51] Documentation: pixfmt-nv12m.rst: fix conversion issues
Date: Mon,  4 Jul 2016 08:47:12 -0300
Message-Id: <f1b27df962ed52a250a18d11ffd1dcbcf1b3004c.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion added an empty column (probably, it was used on
DocBook just to increase spacing.

It also added an extra line on one of the texts, breaking
the original paragraph into two ones.

Remove them.

Finally, a space is required before :sub:, as otherwise it
won't display it right. Add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
index c7db4038609a..a769808aab9b 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
@@ -26,8 +26,8 @@ occupies the first plane. The Y plane has one byte per pixel. In the
 second plane there is a chrominance data with alternating chroma
 samples. The CbCr plane is the same width, in bytes, as the Y plane (and
 of the image), but is half as tall in pixels. Each CbCr pair belongs to
-four pixels. For example, Cb\ :sub:`0`/Cr:sub:`0` belongs to
-Y'\ :sub:`00`, Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
+four pixels. For example, Cb :sub:`0`/Cr :sub:`0` belongs to
+Y' :sub:`00`, Y' :sub:`01`, Y' :sub:`10`, Y' :sub:`11`.
 ``V4L2_PIX_FMT_NV12MT_16X16`` is the tiled version of
 ``V4L2_PIX_FMT_NV12M`` with 16x16 macroblock tiles. Here pixels are
 arranged in 16x16 2D tiles and tiles are arranged in linear order in
@@ -43,11 +43,8 @@ If the Y plane has pad bytes after each row, then the CbCr plane has as
 many pad bytes after its rows.
 
 **Byte Order..**
-
 Each cell is one byte.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -148,7 +145,6 @@ Each cell is one byte.
        -  
        -  1
 
-       -  
        -  2
 
        -  
@@ -163,7 +159,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -177,7 +172,6 @@ Each cell is one byte.
 
        -  
        -  
-       -  
        -  C
 
        -  
@@ -191,7 +185,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -210,7 +203,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
@@ -238,7 +230,6 @@ Each cell is one byte.
        -  
        -  Y
 
-       -  
        -  Y
 
        -  
-- 
2.7.4


