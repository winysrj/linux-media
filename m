Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:46607 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJ0LqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 07:46:25 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE3006J5Q1CWG20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 07:46:24 -0400 (EDT)
Date: Mon, 27 Oct 2014 09:46:19 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Michael Krufky <mkrufky@hotmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 1/3] xc5000: tuner firmware update
Message-id: <20141027094619.69851745.m.chehab@samsung.com>
In-reply-to: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
References: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Oct 2014 16:17:21 -0400
Michael Krufky <mkrufky@hotmail.com> escreveu:

> From: Richard Vollkommer <linux@hauppauge.com>
> 
> - Update the xc5000 tuner firmware to version 1.6.821
> 
> - Update the xc5000c tuner firmware to version 4.1.33
> 
> Firmware files can be downloaded from:
> 
> - http://hauppauge.lightpath.net/software/hvr950q/xc5000c-4.1.33.zip
> - http://hauppauge.lightpath.net/software/hvr950q/xc5000-1.6.821.zip
> 
> Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>

Hi Michael,

Please use a logic that would allow the old firmware files to allow
falling back to the previous firmware version if the new one is not
available.

Regards,
Mauro

> ---
>  drivers/media/tuners/xc5000.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index e44c8ab..fafff4c 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -222,15 +222,15 @@ struct xc5000_fw_cfg {
>  	u8 fw_checksum_supported;
>  };
>  
> -#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
> -static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.821.fw"
> +static const struct xc5000_fw_cfg xc5000a_fw_cfg = {
>  	.name = XC5000A_FIRMWARE,
>  	.size = 12401,
> -	.pll_reg = 0x806c,
> +	.pll_reg = 0x8067,
>  };
>  
> -#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.30.7.fw"
> -static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.33.fw"
> +static const struct xc5000_fw_cfg xc5000c_fw_cfg = {
>  	.name = XC5000C_FIRMWARE,
>  	.size = 16497,
>  	.pll_reg = 0x13,
> @@ -243,9 +243,9 @@ static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
>  	switch (chip_id) {
>  	default:
>  	case XC5000A:
> -		return &xc5000a_1_6_114;
> +		return &xc5000a_fw_cfg;
>  	case XC5000C:
> -		return &xc5000c_41_024_5;
> +		return &xc5000c_fw_cfg;
>  	}
>  }
>  
