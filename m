Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35642 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeC2OzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 10:55:10 -0400
Received: by mail-pf0-f171.google.com with SMTP id u86so3395455pfd.2
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 07:55:10 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: todor.tomov@linaro.org, nicolas.dechesne@linaro.org,
        dragonboard@lists.96boards.org, loic.poulain@linaro.org,
        daniel.thompson@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [RESEND PATCH] Add pixel clock support to OV5640 camera sensor
Date: Thu, 29 Mar 2018 20:24:59 +0530
Message-Id: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
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
