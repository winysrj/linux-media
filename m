Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33973 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbbGTNTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] bt819/saa7110/vpx3220: remove legacy control ops
Date: Mon, 20 Jul 2015 15:18:22 +0200
Message-Id: <1437398302-6211-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
References: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The zoran driver has now been converted to the control framework
which means that these three subdevice drivers no longer need to
support the legacy core control ops since the last bridge driver
that needed that has now been converted.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/bt819.c   | 11 -----------
 drivers/media/i2c/saa7110.c | 11 -----------
 drivers/media/i2c/vpx3220.c |  7 -------
 3 files changed, 29 deletions(-)

diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 76b334a..9b5187b 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -379,16 +379,6 @@ static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
 	.s_ctrl = bt819_s_ctrl,
 };
 
-static const struct v4l2_subdev_core_ops bt819_core_ops = {
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
 static const struct v4l2_subdev_video_ops bt819_video_ops = {
 	.s_std = bt819_s_std,
 	.s_routing = bt819_s_routing,
@@ -398,7 +388,6 @@ static const struct v4l2_subdev_video_ops bt819_video_ops = {
 };
 
 static const struct v4l2_subdev_ops bt819_ops = {
-	.core = &bt819_core_ops,
 	.video = &bt819_video_ops,
 };
 
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index 99689ee..41fcaed 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -357,16 +357,6 @@ static const struct v4l2_ctrl_ops saa7110_ctrl_ops = {
 	.s_ctrl = saa7110_s_ctrl,
 };
 
-static const struct v4l2_subdev_core_ops saa7110_core_ops = {
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
 static const struct v4l2_subdev_video_ops saa7110_video_ops = {
 	.s_std = saa7110_s_std,
 	.s_routing = saa7110_s_routing,
@@ -376,7 +366,6 @@ static const struct v4l2_subdev_video_ops saa7110_video_ops = {
 };
 
 static const struct v4l2_subdev_ops saa7110_ops = {
-	.core = &saa7110_core_ops,
 	.video = &saa7110_video_ops,
 };
 
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index 016e766..c060551 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -450,13 +450,6 @@ static const struct v4l2_ctrl_ops vpx3220_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops vpx3220_core_ops = {
 	.init = vpx3220_init,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_video_ops vpx3220_video_ops = {
-- 
2.1.4

