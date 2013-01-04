Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42011 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3ADVAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:04 -0500
Received: by mail-vc0-f180.google.com with SMTP id p16so17102973vcq.11
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:03 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/15] tvp5150: remove compat control ops.
Date: Fri,  4 Jan 2013 15:59:41 -0500
Message-Id: <1357333186-8466-12-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No longer needed now that em28xx has been converted to the control framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/i2c/tvp5150.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 31104a9..5967e1a0 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1096,13 +1096,6 @@ static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.log_status = tvp5150_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.s_std = tvp5150_s_std,
 	.reset = tvp5150_reset,
 	.g_chip_ident = tvp5150_g_chip_ident,
-- 
1.7.9.5

