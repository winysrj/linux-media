Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:51435 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933366AbeBMHN0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 02:13:26 -0500
Received: by mail-it0-f65.google.com with SMTP id 193so7094858iti.1
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 23:13:26 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: todor.tomov@linaro.org, nicolas.dechesne@linaro.org,
        dragonboard@lists.96boards.org, manivannanece23@gmail.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] media: i2c: ov5640: Add pixel clock support
Date: Tue, 13 Feb 2018 12:43:08 +0530
Message-Id: <1518505988-8389-2-git-send-email-manivannan.sadhasivam@linaro.org>
In-Reply-To: <1518505988-8389-1-git-send-email-manivannan.sadhasivam@linaro.org>
References: <1518505988-8389-1-git-send-email-manivannan.sadhasivam@linaro.org>
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
