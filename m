Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43285 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbeC2OzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 10:55:14 -0400
Received: by mail-pg0-f67.google.com with SMTP id i124so3207395pgc.10
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 07:55:14 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: todor.tomov@linaro.org, nicolas.dechesne@linaro.org,
        dragonboard@lists.96boards.org, loic.poulain@linaro.org,
        daniel.thompson@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [RESEND PATCH] media: i2c: ov5640: Add pixel clock support
Date: Thu, 29 Mar 2018 20:25:00 +0530
Message-Id: <1522335300-13467-2-git-send-email-manivannan.sadhasivam@linaro.org>
In-Reply-To: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
References: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the camera subsystems like camss in Qualcommm MSM chipsets
require pixel clock support in camera sensor drivers. So, this commit
adds a default pixel clock rate of 96MHz to OV5640 camera sensor driver.

According to the datasheet, 96MHz can be used as a pixel clock rate for
most of the modes.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/media/i2c/ov5640.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 39a2269..7152c84 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -162,6 +162,7 @@ struct ov5640_ctrls {
 		struct v4l2_ctrl *auto_gain;
 		struct v4l2_ctrl *gain;
 	};
+	struct v4l2_ctrl *pixel_clock;
 	struct v4l2_ctrl *brightness;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *contrast;
@@ -2009,6 +2010,9 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
 					0, 1023, 1, 0);
 
+	/* Pixel clock (default of 96MHz) */
+	ctrls->pixel_clock = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_PIXEL_RATE,
+					1, INT_MAX, 1, 96000000);
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
 					      0, 255, 1, 64);
 	ctrls->hue = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HUE,
-- 
2.7.4
