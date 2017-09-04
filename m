Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55854
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753953AbdIDUlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 16:41:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] media: pixfmt-srggb12p.rst: better format the table for PDF output
Date: Mon,  4 Sep 2017 17:41:28 -0300
Message-Id: <662653a6f051497957a8804940ae59595123e668.1504557671.git.mchehab@s-opensource.com>
In-Reply-To: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
References: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
In-Reply-To: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
References: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the table to be better displayed on PDF output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst | 59 +++++++++---------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
index c0541e5acd01..59918a7913fe 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
@@ -30,6 +30,7 @@ Below is an example of a small V4L2_PIX_FMT_SBGGR12P image:
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{2.7cm}|p{1.0cm}|p{1.0cm}|p{2.7cm}|
 
 
 .. flat-table::
@@ -38,66 +39,48 @@ Each cell is one byte.
     :widths:       2 1 1 1 1 1 1
 
 
-    -  .. row 1
-
-       -  start + 0:
-
+    -  -  start + 0:
        -  B\ :sub:`00high`
-
        -  G\ :sub:`01high`
+       -  G\ :sub:`01low`\ (bits 7--4)
 
-       -  G\ :sub:`01low`\ (bits 7--4) B\ :sub:`00low`\ (bits 3--0)
-
+          B\ :sub:`00low`\ (bits 3--0)
        -  B\ :sub:`02high`
-
        -  G\ :sub:`03high`
+       -  G\ :sub:`03low`\ (bits 7--4)
 
-       -  G\ :sub:`03low`\ (bits 7--4) B\ :sub:`02low`\ (bits 3--0)
-
-    -  .. row 2
-
-       -  start + 6:
+          B\ :sub:`02low`\ (bits 3--0)
 
+    -  -  start + 6:
        -  G\ :sub:`10high`
-
        -  R\ :sub:`11high`
+       -  R\ :sub:`11low`\ (bits 7--4)
 
-       -  R\ :sub:`11low`\ (bits 7--4) G\ :sub:`10low`\ (bits 3--0)
-
+          G\ :sub:`10low`\ (bits 3--0)
        -  G\ :sub:`12high`
-
        -  R\ :sub:`13high`
+       -  R\ :sub:`13low`\ (bits 3--2)
 
-       -  R\ :sub:`13low`\ (bits 3--2) G\ :sub:`12low`\ (bits 3--0)
-
-    -  .. row 3
-
-       -  start + 12:
-
+          G\ :sub:`12low`\ (bits 3--0)
+    -  -  start + 12:
        -  B\ :sub:`20high`
-
        -  G\ :sub:`21high`
+       -  G\ :sub:`21low`\ (bits 7--4)
 
-       -  G\ :sub:`21low`\ (bits 7--4) B\ :sub:`20low`\ (bits 3--0)
-
+          B\ :sub:`20low`\ (bits 3--0)
        -  B\ :sub:`22high`
-
        -  G\ :sub:`23high`
+       -  G\ :sub:`23low`\ (bits 7--4)
 
-       -  G\ :sub:`23low`\ (bits 7--4) B\ :sub:`22low`\ (bits 3--0)
-
-    -  .. row 4
-
-       -  start + 18:
-
+          B\ :sub:`22low`\ (bits 3--0)
+    -  -  start + 18:
        -  G\ :sub:`30high`
-
        -  R\ :sub:`31high`
+       -  R\ :sub:`31low`\ (bits 7--4)
 
-       -  R\ :sub:`31low`\ (bits 7--4) G\ :sub:`30low`\ (bits 3--0)
-
+          G\ :sub:`30low`\ (bits 3--0)
        -  G\ :sub:`32high`
-
        -  R\ :sub:`33high`
+       -  R\ :sub:`33low`\ (bits 3--2)
 
-       -  R\ :sub:`33low`\ (bits 3--2) G\ :sub:`32low`\ (bits 3--0)
+          G\ :sub:`32low`\ (bits 3--0)
-- 
2.13.5
