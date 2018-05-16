Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:17598 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbeEPP2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 11:28:17 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [RESEND PATCH v9 2/2] media: dw9807: Add dw9807 vcm driver
Date: Wed, 16 May 2018 15:28:12 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D59E549@PGSMSX111.gar.corp.intel.com>
References: <1525276428-17379-1-git-send-email-andy.yeh@intel.com>
        <1525276428-17379-3-git-send-email-andy.yeh@intel.com>
 <20180509160332.75c1eb1b@vento.lan>
In-Reply-To: <20180509160332.75c1eb1b@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


>-----Original Message-----
>From: Mauro Carvalho Chehab [mailto:mchehab+samsung@kernel.org] 
>Sent: Thursday, May 10, 2018 3:04 AM
>To: Yeh, Andy <andy.yeh@intel.com>
>Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; devicetree@vger.kernel.org; tfiga@chromium.org; jacopo@jmondi.org; Chiang, AlanX <alanx.chiang@intel.com>
>Subject: Re: [RESEND PATCH v9 2/2] media: dw9807: Add dw9807 vcm driver
>
>This adds a new warning.
>
>Thanks,
>Mauro
> 
>    drivers/media/i2c/dw9807.c: In function 'dw9807_set_dac':
>    drivers/media/i2c/dw9807.c:81:16: warning: unused variable 'retry' [-Wunused-variable]
>      int val, ret, retry = 0;
>                    ^
>    
>Please either fix or fold the following patch.
>

I noticed you just submitted a patch to the list to address the warning. Thanks.
https://patchwork.linuxtv.org/patch/49575/

Just in the meantime, I uploaded the same one before noticing your patch.  I would like to obsolete mine, so let me know if you agree too. Thanks.
https://patchwork.linuxtv.org/patch/49574/


Regards, Andy

>diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c index 28ede2b47acf..6ebb98717fb1 100644
>--- a/drivers/media/i2c/dw9807.c
>+++ b/drivers/media/i2c/dw9807.c
>@@ -78,7 +78,7 @@ static int dw9807_set_dac(struct i2c_client *client, u16 data)
>        const char tx_data[3] = {
>                DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
>        };
>-       int val, ret, retry = 0;
>+       int val, ret;
> 
>        /*
>         * According to the datasheet, need to check the bus status before we
