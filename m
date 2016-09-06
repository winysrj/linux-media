Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:41506 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbcIFL4o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:56:44 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 3/8] doc-rst: Clean up raw bayer pixel format definitions
Date: Tue,  6 Sep 2016 14:55:35 +0300
Message-Id: <1473162940-31486-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Explicitly state that the most significant n bits are zeroed on 10 and
  12 bpp formats.
- Remove extra comma from the last entry of the format list
- Add a missing colon before a list
- Use figures versus word numerals consistently

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst  | 15 ++++++++-------
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst |  8 ++++----
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst  |  5 +++--
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
index 8af7569..b145c75 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
@@ -20,15 +20,16 @@ Description
 ===========
 
 These four pixel formats are raw sRGB / Bayer formats with 10 bits per
-colour. Each colour component is stored in a 16-bit word, with 6 unused
-high bits filled with zeros. Each n-pixel row contains n/2 green samples
-and n/2 blue or red samples, with alternating red and blue rows. Bytes
-are stored in memory in little endian order. They are conventionally
-described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
-of one of these formats
+sample. Each sample is stored in a 16-bit word, with 6 unused
+high bits filled with zeros. Each n-pixel row contains n/2 green samples and
+n/2 blue or red samples, with alternating red and blue rows. Bytes are
+stored in memory in little endian order. They are conventionally described
+as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of
+these formats:
 
 **Byte Order.**
-Each cell is one byte, high 6 bits in high bytes are 0.
+Each cell is one byte, the 6 most significant bits in the high bytes
+are 0.
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index cc573c9..80e3457 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -20,10 +20,10 @@ Description
 ===========
 
 These four pixel formats are packed raw sRGB / Bayer formats with 10
-bits per colour. Every four consecutive colour components are packed
-into 5 bytes. Each of the first 4 bytes contain the 8 high order bits of
-the pixels, and the fifth byte contains the two least significants bits
-of each pixel, in the same order.
+bits per sample. Every four consecutive samples are packed into 5
+bytes. Each of the first 4 bytes contain the 8 high order bits
+of the pixels, and the 5th byte contains the 2 least significants
+bits of each pixel, in the same order.
 
 Each n-pixel row contains n/2 green samples and n/2 blue or red samples,
 with alternating green-red and green-blue rows. They are conventionally
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index b2880df..4776f3f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -26,10 +26,11 @@ high bits filled with zeros. Each n-pixel row contains n/2 green samples
 and n/2 blue or red samples, with alternating red and blue rows. Bytes
 are stored in memory in little endian order. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
-of one of these formats
+of one of these formats:
 
 **Byte Order.**
-Each cell is one byte, high 4 bits in high bytes are 0.
+Each cell is one byte, the 4 most significant bits in the high bytes are
+0.
 
 
 
-- 
2.7.4

