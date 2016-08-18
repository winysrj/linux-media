Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754724AbcHSDas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 06/20] [media] pixfmt-packed-rgb.rst: Fix cell spans
Date: Thu, 18 Aug 2016 13:15:35 -0300
Message-Id: <3a295ee7bcbbe1ccecbfb3600a0dcb4addeeb16a.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is an extra column just before eack pack of bits, to
improve table reading, but the header file didn't take this
into account.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 78 ++++++++++++----------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 8997b51ac230..3a7133fbec80 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -39,10 +39,13 @@ next to each other in memory.
        -
        -  :cspan:`7` Byte 0 in memory
 
+       -
        -  :cspan:`7` Byte 1
 
+       -
        -  :cspan:`7` Byte 2
 
+       -
        -  :cspan:`7` Byte 3
 
     -  .. row 2
@@ -205,13 +208,13 @@ next to each other in memory.
        -  b\ :sub:`0`
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`3`
 
@@ -285,7 +288,7 @@ next to each other in memory.
        -  b\ :sub:`0`
 
        -
-       -  -
+       -
 
        -  r\ :sub:`4`
 
@@ -388,7 +391,7 @@ next to each other in memory.
        -  'XR15' | (1 << 31)
 
        -
-       -  -
+       -
 
        -  r\ :sub:`4`
 
@@ -620,34 +623,34 @@ next to each other in memory.
 
        -  r\ :sub:`0`
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
     -  .. _V4L2-PIX-FMT-ABGR32:
 
@@ -781,21 +784,21 @@ next to each other in memory.
        -  r\ :sub:`0`
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
     -  .. _V4L2-PIX-FMT-ARGB32:
 
@@ -878,21 +881,21 @@ next to each other in memory.
        -  'BX24'
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -
        -  r\ :sub:`7`
@@ -1124,10 +1127,13 @@ either the corresponding ARGB or XRGB format, depending on the driver.
        -
        -  :cspan:`7` Byte 0 in memory
 
+       -
        -  :cspan:`7` Byte 1
 
+       -
        -  :cspan:`7` Byte 2
 
+       -
        -  :cspan:`7` Byte 3
 
     -  .. row 2
-- 
2.7.4


