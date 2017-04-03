Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56121 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752163AbdDCKGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 06:06:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] subdev-formats.rst: remove spurious '-'
Message-ID: <2a9e644e-3c20-4d51-8caa-310c81d7f7c2@xs4all.nl>
Date: Mon, 3 Apr 2017 12:05:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove spurious duplicate '-' in the Bayer Formats description. This resulted in a
weird dot character that also caused the row to be double-height.

The - character was probably used originally as indicator of an unused bit, but as the
number of columns was increased it was never used for the new columns.

Other tables do not use '-' either, so just remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index d6152c907b8b..ad897dbf9696 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1577,10 +1577,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -1598,10 +1598,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1619,10 +1619,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1640,10 +1640,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1661,10 +1661,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -1682,10 +1682,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1703,10 +1703,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1724,10 +1724,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1745,10 +1745,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -1766,10 +1766,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1787,10 +1787,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1808,10 +1808,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1829,10 +1829,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - 0
@@ -1848,10 +1848,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -1869,10 +1869,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -1888,10 +1888,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - 0
@@ -1909,10 +1909,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`9`
       - b\ :sub:`8`
       - b\ :sub:`7`
@@ -1928,10 +1928,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`1`
       - b\ :sub:`0`
       - 0
@@ -1949,10 +1949,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`1`
       - b\ :sub:`0`
       - 0
@@ -1968,10 +1968,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`9`
       - b\ :sub:`8`
       - b\ :sub:`7`
@@ -1987,10 +1987,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`9`
       - b\ :sub:`8`
       - b\ :sub:`7`
@@ -2008,10 +2008,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`9`
       - g\ :sub:`8`
       - g\ :sub:`7`
@@ -2029,10 +2029,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`9`
       - g\ :sub:`8`
       - g\ :sub:`7`
@@ -2050,10 +2050,10 @@ organization is given as an example for the first pixel only.
       -
       -
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - r\ :sub:`9`
       - r\ :sub:`8`
       - r\ :sub:`7`
@@ -2069,10 +2069,10 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SBGGR12_1X12
       - 0x3008
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - b\ :sub:`11`
       - b\ :sub:`10`
       - b\ :sub:`9`
@@ -2090,10 +2090,10 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SGBRG12_1X12
       - 0x3010
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`11`
       - g\ :sub:`10`
       - g\ :sub:`9`
@@ -2111,10 +2111,10 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SGRBG12_1X12
       - 0x3011
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - g\ :sub:`11`
       - g\ :sub:`10`
       - g\ :sub:`9`
@@ -2132,10 +2132,10 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SRGGB12_1X12
       - 0x3012
       -
-      - -
-      - -
-      - -
-      - -
+      -
+      -
+      -
+      -
       - r\ :sub:`11`
       - r\ :sub:`10`
       - r\ :sub:`9`
@@ -2153,8 +2153,8 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SBGGR14_1X14
       - 0x3019
       -
-      - -
-      - -
+      -
+      -
       - b\ :sub:`13`
       - b\ :sub:`12`
       - b\ :sub:`11`
@@ -2174,8 +2174,8 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SGBRG14_1X14
       - 0x301a
       -
-      - -
-      - -
+      -
+      -
       - g\ :sub:`13`
       - g\ :sub:`12`
       - g\ :sub:`11`
@@ -2195,8 +2195,8 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SGRBG14_1X14
       - 0x301b
       -
-      - -
-      - -
+      -
+      -
       - g\ :sub:`13`
       - g\ :sub:`12`
       - g\ :sub:`11`
@@ -2216,8 +2216,8 @@ organization is given as an example for the first pixel only.
       - MEDIA_BUS_FMT_SRGGB14_1X14
       - 0x301c
       -
-      - -
-      - -
+      -
+      -
       - r\ :sub:`13`
       - r\ :sub:`12`
       - r\ :sub:`11`
