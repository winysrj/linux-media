Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaDQONh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 33/49] adv7604: Remove subdev control handlers
Date: Thu, 17 Apr 2014 16:13:04 +0200
Message-Id: <1397744000-23967-34-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Control operations are handled by the control framework and the subdev
control handlers are never called directly. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1720daf..ca75906 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2172,13 +2172,6 @@ static const struct v4l2_ctrl_ops adv7604_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops adv7604_core_ops = {
 	.log_status = adv7604_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.interrupt_service_routine = adv7604_isr,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv7604_g_register,
-- 
1.8.3.2

