Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38455
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750785AbdAXVmm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 16:42:42 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] [media] exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT
Date: Tue, 24 Jan 2017 18:42:26 -0300
Message-Id: <1485294146-7467-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There isn't an ioctl to enum the supported field orders, so a user-space
application can call VIDIOC_TRY_FMT using different field orders to know
if one is supported. For example, GStreamer does this so during playback
dozens of the following messages appear in the kernel log buffer:

[ 442.143393] Not supported field order(4)

Instead of printing this as an error, just keep it as debug information.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/exynos-gsc/gsc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 8524fe15fa80..678b600f0500 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -408,7 +408,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	if (pix_mp->field == V4L2_FIELD_ANY)
 		pix_mp->field = V4L2_FIELD_NONE;
 	else if (pix_mp->field != V4L2_FIELD_NONE) {
-		pr_err("Not supported field order(%d)\n", pix_mp->field);
+		pr_debug("Not supported field order(%d)\n", pix_mp->field);
 		return -EINVAL;
 	}
 
-- 
2.7.4

