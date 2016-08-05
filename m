Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624AbcHEKqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:44 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 10/11] doc-rst: 16-bit BGGR is always 16 bits
Date: Fri,  5 Aug 2016 13:45:40 +0300
Message-Id: <1470393941-26959-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
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
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index 14446ed..7844dc3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -19,9 +19,6 @@ This format is similar to
 has a depth of 16 bits. The least significant byte is stored at lower
 memory addresses (little-endian).
 
-..note:: The actual sampling precision may be lower than 16 bits,
-    for example 10 bits per pixel with values in tange 0 to 1023.
-
 **Byte Order.**
 Each cell is one byte.
 
-- 
2.7.4

