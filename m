Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:47828 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbcLMFdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 00:33:38 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: HeungJun Kim <riverful.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] m5mols: set usleep_range delta greater 0
Date: Tue, 13 Dec 2016 06:34:53 +0100
Message-Id: <1481607293-23888-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This delay is in non-atomic context and it does not seem to be
time-critical so relax it to allow the timer subsystem to optimize
hrtimers. 

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
anyway so there is not guarantee of precision here.

As this is not a critical delay and the jitter of any system is
in the 10s of microseconds range anyway the range is set to 200
to 300 microseconds - this change cold have a negligible impact
on bandwidth (though I doubt this is relevant or even measurable
here) thus it needs a review by someone that knows the details
of the device and preferably would increase that range.

A comment in the second case was added to clarify the intent of
the delay as time between i2c transfers.

Patch was only compile tested against: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m
MEDIA_CAMERA_SUPPORT=y, VIDEO_V4L2_SUBDEV_API, MEDIA_DIGITAL_TV-_SUPPORT=y
MEDIA_RC_SUPPORT=y, MEDIA_CONTROLLER=y, VIDEO_V4L2_SUBDEV_API=y
MEDIA_SUBDRV_AUTOSELECT=n, CONFIG_VIDEO_M5MOLS=m

Patch is against 4.9.0 (localversion-next is next-20161212)

 drivers/media/i2c/m5mols/m5mols_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index acb804b..23e8616 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -168,7 +168,7 @@ static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 	msg[1].buf = rbuf;
 
 	/* minimum stabilization time */
-	usleep_range(200, 200);
+	usleep_range(200, 300);
 
 	ret = i2c_transfer(client->adapter, msg, 2);
 
@@ -268,7 +268,8 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 
 	*buf = m5mols_swap_byte((u8 *)&val, size);
 
-	usleep_range(200, 200);
+	/* minimum stabilization time */
+	usleep_range(200, 300);
 
 	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret == 1)
-- 
2.1.4

