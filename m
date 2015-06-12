Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 15/19] media/i2c/tlv320aic23b: Implement g_def_ext_ctrls
 core_op
Date: Fri, 12 Jun 2015 18:46:34 +0200
Message-id: <1434127598-11719-16-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Via control framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/tlv320aic23b.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tlv320aic23b.c b/drivers/media/i2c/tlv320aic23b.c
index ef87f7b09ea2..4e279de8e194 100644
--- a/drivers/media/i2c/tlv320aic23b.c
+++ b/drivers/media/i2c/tlv320aic23b.c
@@ -123,6 +123,7 @@ static const struct v4l2_ctrl_ops tlv320aic23b_ctrl_ops = {
 static const struct v4l2_subdev_core_ops tlv320aic23b_core_ops = {
 	.log_status = tlv320aic23b_log_status,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.g_def_ext_ctrls = v4l2_subdev_g_def_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
 	.g_ctrl = v4l2_subdev_g_ctrl,
-- 
2.1.4
