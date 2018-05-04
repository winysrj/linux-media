Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:44141 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeEDJca (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 05:32:30 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, sakari.ailus@iki.fi
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: renesas-ceu: Set mbus_fmt on subdev operations
Date: Fri,  4 May 2018 11:32:17 +0200
Message-Id: <1525426337-17636-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The renesas-ceu driver intializes the desired mbus_format at 'complete'
time, inspecting the supported subdevice ones, and tuning some
parameters to produce the requested memory format from what the sensor
can produce. Although, the initially selected mbus_format was not
provided to the subdevice during set_fmt and try_fmt operations,
providing instead a '0' mbus format code.

As long as the sensor defaults to a compatible mbus_format when an
invalid code as '0' is provided, capture operations work correctly. If
the subdevice defaults to an unsupported format (eg. some RGB
permutations) capture does not work properly due to a mismatch on the
expected and received image format on the wire.

Fix that by re-using the initially selected mbus_format code during
set_fmt and try_fmt subdevice operation calls.

Tested by printing out the format selection procedure with ov7670
sensor.

Before this patch:
[    0.866001] ov7670_try_fmt_internal -- Looking for mbus_code 0x0000
[    0.870882] ov7670_try_fmt_internal -- Try mbus_code 0x2008
[    0.876336] ov7670_try_fmt_internal -- Try mbus_code 0x1002
[    0.881387] ov7670_try_fmt_internal -- Try mbus_code 0x1008
[    0.886537] ov7670_try_fmt_internal -- Try mbus_code 0x3001
[    0.891584] ov7670_try_fmt_internal -- mbus_code defaulted to 0x2008

With this patch applied:
[    0.867015] ov7670_try_fmt_internal -- Looking for mbus_code 0x2008
[    0.873205] ov7670_try_fmt_internal -- Try mbus_code 0x2008: match

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/renesas-ceu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 6599dba..dec1b35 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -777,8 +777,15 @@ static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 	const struct ceu_fmt *ceu_fmt;
 	int ret;

+	/*
+	 * Set format on sensor sub device: bus format used to produce memory
+	 * format is selected at initialization time.
+	 */
 	struct v4l2_subdev_format sd_format = {
-		.which = V4L2_SUBDEV_FORMAT_TRY,
+		.which	= V4L2_SUBDEV_FORMAT_TRY,
+		.format	= {
+			.code = ceu_sd->mbus_fmt.mbus_code,
+		},
 	};

 	switch (pix->pixelformat) {
@@ -800,10 +807,6 @@ static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 	v4l_bound_align_image(&pix->width, 2, CEU_MAX_WIDTH, 4,
 			      &pix->height, 4, CEU_MAX_HEIGHT, 4, 0);

-	/*
-	 * Set format on sensor sub device: bus format used to produce memory
-	 * format is selected at initialization time.
-	 */
 	v4l2_fill_mbus_format_mplane(&sd_format.format, pix);
 	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, &pad_cfg, &sd_format);
 	if (ret)
@@ -827,8 +830,15 @@ static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
 	int ret;

+	/*
+	 * Set format on sensor sub device: bus format used to produce memory
+	 * format is selected at initialization time.
+	 */
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format	= {
+			.code = ceu_sd->mbus_fmt.mbus_code,
+		},
 	};

 	ret = ceu_try_fmt(ceudev, v4l2_fmt);
--
2.7.4
