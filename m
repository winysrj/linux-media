Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22714 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755531AbcIFL4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:56:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 2/8] doc-rst: Fix number of zeroed high order bits in 12-bit raw format defs
Date: Tue,  6 Sep 2016 14:55:34 +0300
Message-Id: <1473162940-31486-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The number of high order bits in samples was documented to be 6 for 12-bit
data. This is clearly wrong, fix it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index 109772f..b2880df 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -29,7 +29,7 @@ described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
 of one of these formats
 
 **Byte Order.**
-Each cell is one byte, high 6 bits in high bytes are 0.
+Each cell is one byte, high 4 bits in high bytes are 0.
 
 
 
-- 
2.7.4

