Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57468 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750790AbdL2M7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:59:16 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, yong.zhi@intel.com
Subject: [PATCH 1/2] v4l: Fix references in Intel IPU3 Bayer documentation
Date: Fri, 29 Dec 2017 14:59:13 +0200
Message-Id: <20171229125914.7218-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20171229125914.7218-1-sakari.ailus@linux.intel.com>
References: <20171229125914.7218-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The references in Intel IPU3 Bayer format documentation were wrong. Fix
them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
index 72fbd8f96381..99cde5077519 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
@@ -1,9 +1,9 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _V4L2_PIX_FMT_IPU3_SBGGR10:
-.. _V4L2_PIX_FMT_IPU3_SGBRG10:
-.. _V4L2_PIX_FMT_IPU3_SGRBG10:
-.. _V4L2_PIX_FMT_IPU3_SRGGB10:
+.. _v4l2-pix-fmt-ipu3-sbggr10:
+.. _v4l2-pix-fmt-ipu3-sgbrg10:
+.. _v4l2-pix-fmt-ipu3-sgrbg10:
+.. _v4l2-pix-fmt-ipu3-srggb10:
 
 **********************************************************************************************************************************************
 V4L2_PIX_FMT_IPU3_SBGGR10 ('ip3b'), V4L2_PIX_FMT_IPU3_SGBRG10 ('ip3g'), V4L2_PIX_FMT_IPU3_SGRBG10 ('ip3G'), V4L2_PIX_FMT_IPU3_SRGGB10 ('ip3r')
-- 
2.11.0
