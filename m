Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54307 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaIOIQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 04:16:30 -0400
From: Maciej Matraszek <m.matraszek@samsung.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Maciej Matraszek <m.matraszek@samsung.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] [media] v4l2-common: fix overflow in v4l_bound_align_image()
Date: Mon, 15 Sep 2014 10:14:48 +0200
Message-id: <1410768888-14367-1-git-send-email-m.matraszek@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix clamp_align() used in v4l_bound_align_image() to prevent overflow when
passed large value like UINT32_MAX. In the current implementation:
    clamp_align(UINT32_MAX, 8, 8192, 3)
returns 8, because in line:
    x = (x + (1 << (align - 1))) & mask;
x overflows to (-1 + 4) & 0x7 = 3, while expected value is 8192.

v4l_bound_align_image() is heavily used in VIDIOC_S_FMT
and VIDIOC_SUBDEV_S_FMT ioctls handlers, and documentation of the latter
explicitly states that:

"The modified format should be as close as possible to the original request."
  -- http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-fmt.html

Thus one would expect, that passing UINT32_MAX as format width and height
will result in setting maximum possible resolution for the device.
Particularly, when the driver doesn't support VIDIOC_ENUM_FRAMESIZES ioctl,
which is common in the codebase.

Fixes: b0d3159be9a3 ("V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images")
Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: <stable@vger.kernel.org>

---
v2: use clamp() instead of clamp_t(), as suggested by Sakari
v3: correct way of submitting patches for inclusion in the stable tree

 drivers/media/v4l2-core/v4l2-common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index ccaa38f65cf1..2e9d81f4c1a5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -435,16 +435,13 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 	/* Bits that must be zero to be aligned */
 	unsigned int mask = ~((1 << align) - 1);
 
+	/* Clamp to aligned min and max */
+	x = clamp(x, (min + ~mask) & mask, max & mask);
+
 	/* Round to nearest aligned value */
 	if (align)
 		x = (x + (1 << (align - 1))) & mask;
 
-	/* Clamp to aligned value of min and max */
-	if (x < min)
-		x = (min + ~mask) & mask;
-	else if (x > max)
-		x = max & mask;
-
 	return x;
 }
 
-- 
1.9.1

