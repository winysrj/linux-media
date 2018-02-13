Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:39884 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933444AbeBMHNW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 02:13:22 -0500
Received: by mail-io0-f172.google.com with SMTP id b198so20252823iof.6
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 23:13:22 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: todor.tomov@linaro.org, nicolas.dechesne@linaro.org,
        dragonboard@lists.96boards.org, manivannanece23@gmail.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] Add pixel clock support to OV5640 camera sensor
Date: Tue, 13 Feb 2018 12:43:07 +0530
Message-Id: <1518505988-8389-1-git-send-email-manivannan.sadhasivam@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the camera subsystems like camss in Qualcommm MSM chipsets
require pixel clock support in camera sensor drivers for proper functioning.
So, add a default pixel clock rate of 96MHz to OV5640 camera sensor driver.

According to the datasheet, 96MHz can be used as a pixel clock rate for
most of the modes.

This patch has been validated on Dragonboard410c with OV5640 connected
using D3 Camera Mezzanine.

Manivannan Sadhasivam (1):
  media: i2c: ov5640: Add pixel clock support

 drivers/media/i2c/ov5640.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.7.4
