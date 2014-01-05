Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58254 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaAEVIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 16:08:15 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so7538745eak.2
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 13:08:14 -0800 (PST)
Message-ID: <52C9CA02.8090104@googlemail.com>
Date: Sun, 05 Jan 2014 22:09:22 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: rename I2C timeout to EM28XX_I2C_XFER_TIMEOUT
References: <1388926014-3706-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388926014-3706-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2014 13:46, schrieb Mauro Carvalho Chehab:
> This macro is used by all em28xx devices, and not just em2800.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 6 +++---
>  drivers/media/usb/em28xx/em28xx.h     | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 9fa7ed51e5b1..a22fec727ae7 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -49,7 +49,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
>   */
>  static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
> +	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
>  	int ret;
>  	u8 b2[6];
>  
> @@ -100,7 +100,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>   */
>  static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
> +	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
>  	u8 buf2[4];
>  	int ret;
>  	int i;
> @@ -171,7 +171,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
>  static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  				 u16 len, int stop)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_I2C_XFER_TIMEOUT);
> +	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
>  	int ret;
>  
>  	if (len < 1 || len > 64)
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 9fe061ff1227..544c7ebeaba9 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -184,7 +184,7 @@
>  #define EM28XX_INTERLACED_DEFAULT 1
>  
>  /* time in msecs to wait for i2c xfers to finish */
> -#define EM2800_I2C_XFER_TIMEOUT		20
> +#define EM28XX_I2C_XFER_TIMEOUT		20
>  
>  /* time in msecs to wait for AC97 xfers to finish */
>  #define EM28XX_AC97_XFER_TIMEOUT	100

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

