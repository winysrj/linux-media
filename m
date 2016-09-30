Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40555
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933618AbcI3VR2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 17:17:28 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 3/4] [media] exynos-gsc: fix supported RGB pixel format
Date: Fri, 30 Sep 2016 17:16:43 -0400
Message-Id: <1475270204-14005-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
References: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver exposes 32-bit A/XRGB 8-8-8-8 as supported format but testing
shows that using this format produces frames with wrong colors. The test
was done with the following GStreamer pipeline:

$ gst-launch-1.0 videotestsrc num-buffers=20 ! video/x-raw,format=UYVY \
! v4l2video3convert ! video/x-raw,format=xRGB ! videoconvert ! kmssink

The manual seems to state that the Pixel Format are in Little Endianness
so instead use the 32-bit BGRA/X 8-8-8-8 pixel format. This format works
correctly when using the following pipeline:

$ gst-launch-1.0 videotestsrc num-buffers=20 ! video/x-raw,format=UYVY \
! v4l2video3convert ! video/x-raw,format=BGRx ! kmssink

This change is similar to commit 7f2816e51ea1 ("[media] s5p-fimc: Changed
RGB32 to BGR32") that fixed the same issue on a different Samsung driver.

Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index fac0c0246ad4..8bb1d2be7234 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -39,8 +39,8 @@ static const struct gsc_fmt gsc_formats[] = {
 		.num_planes	= 1,
 		.num_comp	= 1,
 	}, {
-		.name		= "XRGB-8-8-8-8, 32 bpp",
-		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.name		= "BGRX-8-8-8-8, 32 bpp",
+		.pixelformat	= V4L2_PIX_FMT_BGR32,
 		.depth		= { 32 },
 		.color		= GSC_RGB,
 		.num_planes	= 1,
-- 
2.7.4

