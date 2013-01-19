Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:59409 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3ASViY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 16:38:24 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so1995796eaa.31
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2013 13:38:23 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] noon010p30: Remove unneeded v4l2 control compatibility ops
Date: Sat, 19 Jan 2013 22:38:13 +0100
Message-Id: <1358631493-12822-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All host drivers using this subdev driver are already converted
to use the control framework so the compatibility ops can be dropped.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/i2c/noon010pc30.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 440c129..8554b47 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -660,13 +660,6 @@ static const struct v4l2_ctrl_ops noon010_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops noon010_core_ops = {
 	.s_power	= noon010_s_power,
-	.g_ctrl		= v4l2_subdev_g_ctrl,
-	.s_ctrl		= v4l2_subdev_s_ctrl,
-	.queryctrl	= v4l2_subdev_queryctrl,
-	.querymenu	= v4l2_subdev_querymenu,
-	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
 	.log_status	= noon010_log_status,
 };
 
-- 
1.7.4.1

