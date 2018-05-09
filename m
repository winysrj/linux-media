Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbeEITDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 15:03:40 -0400
Date: Wed, 9 May 2018 16:03:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, tfiga@chromium.org, jacopo@jmondi.org,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v9 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180509160332.75c1eb1b@vento.lan>
In-Reply-To: <1525276428-17379-3-git-send-email-andy.yeh@intel.com>
References: <1525276428-17379-1-git-send-email-andy.yeh@intel.com>
        <1525276428-17379-3-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  2 May 2018 23:53:48 +0800
Andy Yeh <andy.yeh@intel.com> escreveu:

> From: Alan Chiang <alanx.chiang@intel.com>
> 
> DW9807 is a 10 bit DAC from Dongwoon, designed for linear
> control of voice coil motor.
> 
> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> Acked-by: Rob Herring <robh@kernel.org>

This adds a new warning.

Thanks,
Mauro
 
    drivers/media/i2c/dw9807.c: In function 'dw9807_set_dac':
    drivers/media/i2c/dw9807.c:81:16: warning: unused variable 'retry' [-Wunused-variable]
      int val, ret, retry = 0;
                    ^
    
Please either fix or fold the following patch.

diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
index 28ede2b47acf..6ebb98717fb1 100644
--- a/drivers/media/i2c/dw9807.c
+++ b/drivers/media/i2c/dw9807.c
@@ -78,7 +78,7 @@ static int dw9807_set_dac(struct i2c_client *client, u16 data)
        const char tx_data[3] = {
                DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
        };
-       int val, ret, retry = 0;
+       int val, ret;
 
        /*
         * According to the datasheet, need to check the bus status before we
