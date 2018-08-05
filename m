Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:43441 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbeHFAG6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2018 20:06:58 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: m.chehab@samsung.com, hverkuil@xs4all.nl,
        sakari.ailus@linux.intel.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: mt9v111: Fix build error with no VIDEO_V4L2_SUBDEV_API
Date: Mon,  6 Aug 2018 00:00:37 +0200
Message-Id: <1533506437-9932-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev_get_try_format() function is only defined if the
VIDEO_V4L2_SUBDEV_API Kconfig option is enabled. Builds configured
without that symbol fails with:

drivers/media/i2c/mt9v111.c:801:10: error: implicit declaration of function
'v4l2_subdev_get_try_format';

Fix this by protecting the function call by testing for the right symbol.

Fixes: aab7ed1c ("media: i2c: Add driver for Aptina MT9V111")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/mt9v111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index da8f6ab..68fa39f 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -797,7 +797,7 @@ static struct v4l2_mbus_framefmt *__mt9v111_get_pad_format(
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
+#if IS_ENABLED(CONFIG_VIDEO_V4L2_SUBDEV_API)
 		return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);
 #else
 		return &cfg->try_fmt;
--
2.7.4
