Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48057 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758140AbbEaNLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/9] adv7511: add xfer_func support
Date: Sun, 31 May 2015 15:11:33 +0200
Message-Id: <1433077899-18516-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Still preliminary, but the information is at least there.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 12d9320..9032567 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -101,6 +101,7 @@ struct adv7511_state {
 	u32 colorspace;
 	u32 ycbcr_enc;
 	u32 quantization;
+	u32 xfer_func;
 	/* controls */
 	struct v4l2_ctrl *hdmi_mode_ctrl;
 	struct v4l2_ctrl *hotplug_ctrl;
@@ -861,11 +862,13 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd,
 		format->format.colorspace = fmt->colorspace;
 		format->format.ycbcr_enc = fmt->ycbcr_enc;
 		format->format.quantization = fmt->quantization;
+		format->format.xfer_func = fmt->xfer_func;
 	} else {
 		format->format.code = state->fmt_code;
 		format->format.colorspace = state->colorspace;
 		format->format.ycbcr_enc = state->ycbcr_enc;
 		format->format.quantization = state->quantization;
+		format->format.xfer_func = state->xfer_func;
 	}
 
 	return 0;
@@ -912,6 +915,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 		fmt->colorspace = format->format.colorspace;
 		fmt->ycbcr_enc = format->format.ycbcr_enc;
 		fmt->quantization = format->format.quantization;
+		fmt->xfer_func = format->format.xfer_func;
 		return 0;
 	}
 
@@ -936,6 +940,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	state->colorspace = format->format.colorspace;
 	state->ycbcr_enc = format->format.ycbcr_enc;
 	state->quantization = format->format.quantization;
+	state->xfer_func = format->format.xfer_func;
 
 	switch (format->format.colorspace) {
 	case V4L2_COLORSPACE_ADOBERGB:
-- 
2.1.4

