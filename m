Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40523
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932382AbcI3VRL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 17:17:11 -0400
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
Subject: [PATCH 0/4] [media] exynos-gsc: Cleanup and fixes
Date: Fri, 30 Sep 2016 17:16:40 -0400
Message-Id: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series contains a cleanup and some fixes for the exynos-gsc
driver. I found these issues when trying to use the driver with the
GStreamer v4l2videoconvert element. I wasn't able to display to Exynos
DRM/KMS driver and only a small set of formats were working correctly.

After these patches, I'm able to display the captured frames to the
Exynos DRM driver using kmssink or chain two v4l2videoconvert elements
using the two GSC instances. Also, most supported formats are working.

I've tested all supported formats with the following script:

FORMATS="BGRx YUY2 UYVY YVYU Y42B NV16 NV61 YV12 NV21 NV12 I420"

for IN in ${FORMATS}; do
    for OUT in ${FORMATS}; do
        gst-launch-1.0 videotestsrc num-buffers=30 ! video/x-raw,format=${IN} ! \
        v4l2video$1convert ! video/x-raw,format=${OUT} ! videoconvert ! kmssink
    done
done

There are though still two issues remaining after these patches:

1) The NV21 and NV61 formats aren't show correctly (NV12 and NV16 works).
2) The Y42B format works when used as input but no when used as output.

But those can be addressed as a follow-up since I believe are not related,
and the fixes in the series improve the support for most exposed formats.

Best regards,
Javier


Javier Martinez Canillas (4):
  [media] exynos-gsc: change spamming try_fmt log message to debug
  [media] exynos-gsc: don't clear format when freeing buffers with
    REQBUFS(0)
  [media] exynos-gsc: fix supported RGB pixel format
  [media] exynos-gsc: do proper bytesperline and sizeimage calculation

 drivers/media/platform/exynos-gsc/gsc-core.c | 27 ++++++++++++++++++++-------
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |  8 +-------
 2 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.7.4

