Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45539 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754815AbcIFL5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:57:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 5/8] doc-rst: 16-bit BGGR is always 16 bits
Date: Tue,  6 Sep 2016 14:55:37 +0300
Message-Id: <1473162940-31486-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_SBGGR16 format is documented to contain samples of fewer
than 16 bits. However, we do have specific definitions for smaller sample
sizes. Therefore, this note is redundant from the API point of view.

Currently only two drivers, am437x and davinci, use the
V4L2_PIX_FMT_SBGGR16 pixelformat currently. The sampling precision is
understood to be 16 bits in all current cases.

Remove the note on sampling precision.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index 801b78c..e3b53e3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -17,11 +17,6 @@ This format is similar to
 has a depth of 16 bits. The least significant byte is stored at lower
 memory addresses (little-endian).
 
-.. note::
-
-    The actual sampling precision may be lower than 16 bits,
-    for example 10 bits per pixel with values in tange 0 to 1023.
-
 **Byte Order.**
 Each cell is one byte.
 
-- 
2.7.4

