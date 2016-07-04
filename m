Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51501 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbcGDIfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 13/14] media/i2c: drop the last users of the ctrl core ops.
Date: Mon,  4 Jul 2016 10:35:09 +0200
Message-Id: <1467621310-8203-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Nobody is using these ops anymore, so remove these callbacks from
the subdev drivers that still have them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/i2c/cs53l32a.c             | 7 -------
 drivers/media/i2c/cx25840/cx25840-core.c | 7 -------
 drivers/media/i2c/msp3400-driver.c       | 7 -------
 drivers/media/i2c/saa7115.c              | 7 -------
 drivers/media/i2c/tvaudio.c              | 7 -------
 drivers/media/i2c/wm8775.c               | 7 -------
 6 files changed, 42 deletions(-)

diff --git a/drivers/media/i2c/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
index b7e87e3..e4b3cf4 100644
--- a/drivers/media/i2c/cs53l32a.c
+++ b/drivers/media/i2c/cs53l32a.c
@@ -121,13 +121,6 @@ static const struct v4l2_ctrl_ops cs53l32a_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cs53l32a_core_ops = {
 	.log_status = cs53l32a_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_audio_ops cs53l32a_audio_ops = {
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 07a3e71..142ae28 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5042,13 +5042,6 @@ static const struct v4l2_ctrl_ops cx25840_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.log_status = cx25840_log_status,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.reset = cx25840_reset,
 	.load_fw = cx25840_load_fw,
 	.s_io_pin_config = common_s_io_pin_config,
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index e016626..503b7c4 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -642,13 +642,6 @@ static const struct v4l2_ctrl_ops msp_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops msp_core_ops = {
 	.log_status = msp_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_video_ops msp_video_ops = {
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index bd3526b..58062b4 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1585,13 +1585,6 @@ static const struct v4l2_ctrl_ops saa711x_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops saa711x_core_ops = {
 	.log_status = saa711x_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.reset = saa711x_reset,
 	.s_gpio = saa711x_s_gpio,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index fece2a4..42d1e26 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1855,13 +1855,6 @@ static const struct v4l2_ctrl_ops tvaudio_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tvaudio_core_ops = {
 	.log_status = tvaudio_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_tuner_ops tvaudio_tuner_ops = {
diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index 6e00f14..5581f4d 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -178,13 +178,6 @@ static const struct v4l2_ctrl_ops wm8775_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops wm8775_core_ops = {
 	.log_status = wm8775_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_tuner_ops wm8775_tuner_ops = {
-- 
2.8.1

