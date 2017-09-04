Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55856
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754003AbdIDUlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 16:41:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/2] docs-rst: media: Don't use \small for V4L2_PIX_FMT_SRGGB10 documentation
Date: Mon,  4 Sep 2017 17:41:27 -0300
Message-Id: <a9f55d8af529d904db475134271a37ab70ac5d38.1504557671.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

There appears to be an issue in using \small in certain cases on Sphinx
1.4 and 1.5. Other format documents don't use \small either, remove it
from here as well.

[mchehab@s-opensource.com: kept tabularcolumns - readjusted - and
 add a few blank lines for it to display better]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index 9e52610aa954..d9e07a4b8b31 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -33,12 +33,7 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
 **Byte Order.**
 Each cell is one byte.
 
-
-.. raw:: latex
-
-    \newline\small
-
-.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{5.4cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -51,6 +46,7 @@ Each cell is one byte.
       - B\ :sub:`02high`
       - G\ :sub:`03high`
       - G\ :sub:`03low`\ (bits 7--6) B\ :sub:`02low`\ (bits 5--4)
+
 	G\ :sub:`01low`\ (bits 3--2) B\ :sub:`00low`\ (bits 1--0)
     * - start + 5:
       - G\ :sub:`10high`
@@ -58,6 +54,7 @@ Each cell is one byte.
       - G\ :sub:`12high`
       - R\ :sub:`13high`
       - R\ :sub:`13low`\ (bits 7--6) G\ :sub:`12low`\ (bits 5--4)
+
 	R\ :sub:`11low`\ (bits 3--2) G\ :sub:`10low`\ (bits 1--0)
     * - start + 10:
       - B\ :sub:`20high`
@@ -65,6 +62,7 @@ Each cell is one byte.
       - B\ :sub:`22high`
       - G\ :sub:`23high`
       - G\ :sub:`23low`\ (bits 7--6) B\ :sub:`22low`\ (bits 5--4)
+
 	G\ :sub:`21low`\ (bits 3--2) B\ :sub:`20low`\ (bits 1--0)
     * - start + 15:
       - G\ :sub:`30high`
@@ -72,8 +70,5 @@ Each cell is one byte.
       - G\ :sub:`32high`
       - R\ :sub:`33high`
       - R\ :sub:`33low`\ (bits 7--6) G\ :sub:`32low`\ (bits 5--4)
+
 	R\ :sub:`31low`\ (bits 3--2) G\ :sub:`30low`\ (bits 1--0)
-
-.. raw:: latex
-
-    \normalsize
-- 
2.13.5
