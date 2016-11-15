Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37350 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932797AbcKOVtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 16:49:49 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] doc-rst: Specify raw bayer format variant used in the examples
Date: Tue, 15 Nov 2016 23:49:43 +0200
Message-Id: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation simply mentioned that one of the four pixel orders was
used in the example. Now specify the exact pixelformat instead.

for i in pixfmt-s*.rst; do i=$i perl -i -pe '
	my $foo=$ENV{i};
	$foo =~ s/pixfmt-[a-z]+([0-9].*).rst/$1/;
	$foo = uc $foo;
	s/one of these formats/a small V4L2_PIX_FMT_SBGGR$foo image/' $i;
done

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst  | 2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb16.rst  | 2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index 9a41c8d..b6d426c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -28,7 +28,7 @@ bits of each pixel, in the same order.
 Each n-pixel row contains n/2 green samples and n/2 blue or red samples,
 with alternating green-red and green-blue rows. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
-of one of these formats:
+of a small V4L2_PIX_FMT_SBGGR10P image:
 
 **Byte Order.**
 Each cell is one byte.
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index a50ee14..15041e5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -26,7 +26,7 @@ high bits filled with zeros. Each n-pixel row contains n/2 green samples
 and n/2 blue or red samples, with alternating red and blue rows. Bytes
 are stored in memory in little endian order. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
-of one of these formats:
+of a small V4L2_PIX_FMT_SBGGR12 image:
 
 **Byte Order.**
 Each cell is one byte, the 4 most significant bits in the high bytes are
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
index 06facc9..d407b2b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
@@ -22,7 +22,7 @@ sample. Each sample is stored in a 16-bit word. Each n-pixel row contains
 n/2 green samples and n/2 blue or red samples, with alternating red and blue
 rows. Bytes are stored in memory in little endian order. They are
 conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is
-an example of one of these formats:
+an example of a small V4L2_PIX_FMT_SBGGR16 image:
 
 **Byte Order.**
 Each cell is one byte.
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
index a3987d2..5ac25a6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
@@ -20,7 +20,7 @@ These four pixel formats are raw sRGB / Bayer formats with 8 bits per
 sample. Each sample is stored in a byte. Each n-pixel row contains n/2
 green samples and n/2 blue or red samples, with alternating red and
 blue rows. They are conventionally described as GRGR... BGBG...,
-RGRG... GBGB..., etc. Below is an example of one of these formats:
+RGRG... GBGB..., etc. Below is an example of a small V4L2_PIX_FMT_SBGGR8 image:
 
 **Byte Order.**
 Each cell is one byte.
-- 
2.1.4

