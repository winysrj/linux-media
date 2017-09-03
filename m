Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751454AbdICUMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:12:36 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-doc@vger.kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>
Subject: [PATCH 1/1] docs-rst: media: Don't use \small for V4L2_PIX_FMT_SRGGB10 documentation
Date: Sun,  3 Sep 2017 23:12:33 +0300
Message-Id: <20170903201233.31638-1-sakari.ailus@linux.intel.com>
In-Reply-To: <82fc5322d611390dca21f28e3fd5f7cbe0c27be4.1504464984.git.mchehab@s-opensource.com>
References: <82fc5322d611390dca21f28e3fd5f7cbe0c27be4.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There appears to be an issue in using \small in certain cases on Sphinx
1.4 and 1.5. Other format documents don't use \small either, remove it
from here as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Mauro,

What would you think of this as an alternative approach? No hacks needed.
Just a recognition \small could have issues. For what it's worth, I
couldn't reproduce the issue on Sphinx 1.4.9.

Regards,
Sakari

 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index 86cd07e5bfa3..368ee61ab209 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -33,13 +33,6 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
 **Byte Order.**
 Each cell is one byte.
 
-
-.. raw:: latex
-
-    \small
-
-.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -73,7 +66,3 @@ Each cell is one byte.
       - R\ :sub:`33high`
       - R\ :sub:`33low`\ (bits 7--6) G\ :sub:`32low`\ (bits 5--4)
 	R\ :sub:`31low`\ (bits 3--2) G\ :sub:`30low`\ (bits 1--0)
-
-.. raw:: latex
-
-    \normalsize
-- 
2.11.0
