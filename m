Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61984 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752038AbdHHLYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:03 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: atomisp: constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:29 +0200
Message-Id: <1502189912-28794-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures are both stored in fields of v4l2_subdev_ops
structures, all of which are const, so these structures can be
const as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/atomisp/i2c/ap1302.c  |    2 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index bacffbe..de687c6 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -1098,7 +1098,7 @@ static long ap1302_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	},
 };
 
-static struct v4l2_subdev_sensor_ops ap1302_sensor_ops = {
+static const struct v4l2_subdev_sensor_ops ap1302_sensor_ops = {
 	.g_skip_frames	= ap1302_g_skip_frames,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 448e072..36a0636 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1806,7 +1806,7 @@ static int mt9m114_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
 	.g_frame_interval = mt9m114_g_frame_interval,
 };
 
-static struct v4l2_subdev_sensor_ops mt9m114_sensor_ops = {
+static const struct v4l2_subdev_sensor_ops mt9m114_sensor_ops = {
 	.g_skip_frames	= mt9m114_g_skip_frames,
 };
 
