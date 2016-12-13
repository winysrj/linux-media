Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:42451 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752965AbcLMC3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 21:29:07 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
Date: Tue, 13 Dec 2016 02:58:02 +0100
Message-Id: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this is not in atomic context and it does not seem like a critical 
timing setting a range of 1ms allows the timer subsystem to optimize 
the hrtimer here.

Fixes: commit bfa8dd3a0524 ("[media] v4l: Add v4l2 subdev driver for S5K6AAFX sensor")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

problem was located by coccinelle spatch

The problem is that usleep_range is calculating the delay by
     exp = ktime_add_us(ktime_get(), min)
     delta = (u64)(max - min) * NSEC_PER_USEC
so delta is set to 0
and then calls
  schedule_hrtimeout_range(exp, 0,...)
effectively this means that the clock subsystem has no room to
optimize which makes little sense as this is not atomic context
anyway so there is not guaratee of precision here.

As this is not a critical delay it is set to a range of 4 to 5
milliseconds - this change needs a review by someone that knows
the details of the device though and preferably would increase
that range.

Patch was only compile tested with: x86_64_defconfig + MEDIA_SUPPORT=m
MEDIA_CAMERA_SUPPORT=y (implies VIDEO_V4L2=m)
MEDIA_DIGITAL_TV_SUPPORT=y, CONFIG_MEDIA_CONTROLLER=y,
CONFIG_VIDEO_V4L2_SUBDEV_API=y

Patch is against 4.9.0 (localversion-next is next-20161212)

 drivers/media/i2c/s5k6aa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index faee113..9fd254a 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -838,7 +838,7 @@ static int __s5k6aa_power_on(struct s5k6aa *s5k6aa)
 
 	if (s5k6aa->s_power)
 		ret = s5k6aa->s_power(1);
-	usleep_range(4000, 4000);
+	usleep_range(4000, 5000);
 
 	if (s5k6aa_gpio_deassert(s5k6aa, RST))
 		msleep(20);
-- 
2.1.4

