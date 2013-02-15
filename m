Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4425 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161340Ab3BOMzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/10] au8522_decoder: remove obsolete control ops.
Date: Fri, 15 Feb 2013 13:55:13 +0100
Message-Id: <de77b6d585725c70bc0439108f9fa82d45e7488c.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that au0828 has been converted to the control framework these
compatilibity ops are no longer needed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index be2c802..aa7be74 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -649,13 +649,6 @@ static int au8522_g_chip_ident(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_core_ops au8522_core_ops = {
 	.log_status = v4l2_ctrl_subdev_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.g_chip_ident = au8522_g_chip_ident,
 	.reset = au8522_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
1.7.10.4

