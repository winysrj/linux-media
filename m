Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38516 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaJATMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:12:48 -0400
Message-ID: <542C522C.1090303@iki.fi>
Date: Wed, 01 Oct 2014 22:12:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V2 05/13] cx231xx: Modifiy the symbolic constants for
 i2c ports and describe
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org> <1412140821-16285-6-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-6-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 10/01/2014 08:20 AM, Matthias Schwarzott wrote:
> Change to I2C_0 ... I2C_2 for the master ports
> and add I2C_1_MUX_1 and I2C_1_MUX_3 for the muxed ones.
>
> V2: Renamed mux adapters to seperate them from master adapters.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx.h | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index c92382f..377216b 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -322,10 +322,11 @@ enum cx231xx_decoder {
>   };
>
>   enum CX231XX_I2C_MASTER_PORT {
> -	I2C_0 = 0,
> -	I2C_1 = 1,
> -	I2C_2 = 2,
> -	I2C_3 = 3
> +	I2C_0 = 0,       /* master 0 - internal connection */
> +	I2C_1 = 1,       /* master 1 - used with mux */
> +	I2C_2 = 2,       /* master 2 */
> +	I2C_1_MUX_1 = 3, /* master 1 - port 1 (I2C_DEMOD_EN = 0) */
> +	I2C_1_MUX_3 = 4  /* master 1 - port 3 (I2C_DEMOD_EN = 1) */
>   };
>
>   struct cx231xx_board {
>

-- 
http://palosaari.fi/
