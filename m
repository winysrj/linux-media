Return-path: <linux-media-owner@vger.kernel.org>
Received: from vs1.galsoft.net ([88.198.34.156]:53296 "EHLO mail.galsoft.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbbGPXdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 19:33:14 -0400
From: Adam Majer <adamm@zombino.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc: Adam Majer <adamm@zombino.com>
Subject: [PATCH] [media]: Fix compilation when CONFIG_VIDEO_V4L2_SUBDEV_API is not set
Date: Thu, 16 Jul 2015 18:20:55 -0500
Message-Id: <1437088855-17002-1-git-send-email-adamm@zombino.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_VIDEO_V4L2_SUBDEV_API is unset, some drivers fail to
compile as they use unavailable API.

  drivers/media/i2c/adv7511.c:968:3: error: implicit declaration of
  function ‘v4l2_subdev_get_try_format’
  [-Werror=implicit-function-declaration]
---
 drivers/media/i2c/adv7511.c | 8 ++++++++
 drivers/media/i2c/adv7604.c | 8 ++++++++
 drivers/media/i2c/adv7842.c | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 95bcd40..e3f5ecb 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -963,6 +963,7 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd,
 	adv7511_fill_format(state, &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
@@ -971,6 +972,9 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd,
 		format->format.ycbcr_enc = fmt->ycbcr_enc;
 		format->format.quantization = fmt->quantization;
 		format->format.xfer_func = fmt->xfer_func;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		format->format.code = state->fmt_code;
 		format->format.colorspace = state->colorspace;
@@ -1016,6 +1020,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 
 	adv7511_fill_format(state, &format->format);
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
@@ -1025,6 +1030,9 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 		fmt->quantization = format->format.quantization;
 		fmt->xfer_func = format->format.xfer_func;
 		return 0;
+#else
+		return -ENOTTY;
+#endif
 	}
 
 	switch (format->format.code) {
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 808360f..c080bca 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1856,10 +1856,14 @@ static int adv76xx_get_format(struct v4l2_subdev *sd,
 	adv76xx_fill_format(state, &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		format->format.code = fmt->code;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		format->format.code = state->format->code;
 	}
@@ -1885,10 +1889,14 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
 	format->format.code = info->code;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		fmt->code = format->format.code;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		state->format = info;
 		adv76xx_setup_format(state);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4cf79b2..5e50b85 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2088,10 +2088,14 @@ static int adv7842_get_format(struct v4l2_subdev *sd,
 	adv7842_fill_format(state, &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		format->format.code = fmt->code;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		format->format.code = state->format->code;
 	}
@@ -2120,10 +2124,14 @@ static int adv7842_set_format(struct v4l2_subdev *sd,
 	format->format.code = info->code;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		struct v4l2_mbus_framefmt *fmt;
 
 		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		fmt->code = format->format.code;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		state->format = info;
 		adv7842_setup_format(state);
-- 
2.1.4

