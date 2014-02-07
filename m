Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47735 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaBGI70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 03:59:26 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0M00DCZBN0EKA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Feb 2014 17:59:24 +0900 (KST)
Message-id: <52F4A06C.2050606@samsung.com>
Date: Fri, 07 Feb 2014 17:59:24 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: dheitmueller@kernellabs.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 07/24] xc5000: properly report i2c write failures
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for response about the past post.

> The logic as written would *never* actually return an error condition, since
> the loop would run until the counter hit zero but the check was for a value
> less than zero.
>
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
>   drivers/media/common/tuners/xc5000.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
> index f660e33..a7fa17e 100644
> --- a/drivers/media/common/tuners/xc5000.c
> +++ b/drivers/media/common/tuners/xc5000.c
> @@ -341,7 +341,7 @@    static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
>   			}
>   		}
>   	}
> -	if (WatchDogTimer < 0)
> +	if (WatchDogTimer <= 0)

I can't load firmware like error of below link.

https://bugs.launchpad.net/ubuntu/+source/linux-firmware-nonfree/+bug/1263837 
<https://bugs.launchpad.net/ubuntu/+source/linux-firmware-nonfree/+bug/1263837>

This error is related with this patch. This fix is right but above error 
is created after this fix
because my device makes WatchDogTimer to 0 when load firmware.
Maybe it will be related with XREG_BUSY register but i can't check it.

I removed this fix, but i have faced at other error with "xc5000: PLL 
not running after fwload"
So i have commented like below.

static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
         .name = XC5000A_FIRMWARE,
         .size = 12401,
         //.pll_reg = 0x806c,
};

Then, xc5000 device works well.

I don't have xc5000 datasheet so i can't debug xc5000 driver anymore.

Any help?

Thanks.

>   		result = XC_RESULT_I2C_WRITE_FAILURE;
>   
>   	return result;
>
