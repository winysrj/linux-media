Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42062 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3KBRTS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 13:19:18 -0400
Message-ID: <52753413.4000405@iki.fi>
Date: Sat, 02 Nov 2013 19:19:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2 27/29] af9035: Don't use dynamic static allocation
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com> <1383399097-11615-28-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-28-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 02.11.2013 15:31, Mauro Carvalho Chehab wrote:
> Dynamic static allocation is evil, as Kernel stack is too low, and
> ompilation complains about it on some archs:
>
> 	drivers/media/usb/dvb-usb-v2/af9035.c:142:1: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]
> 	drivers/media/usb/dvb-usb-v2/af9035.c:305:1: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]
>
> Instead, let's enforce a limit for the buffer to be the max size of
> a control URB payload data (80 bytes).
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/dvb-usb-v2/af9035.c | 26 +++++++++++++++++++++++---
>   1 file changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 1ea17dc2a76e..f43e9f336204 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -126,10 +126,16 @@ exit:
>   /* write multiple registers */
>   static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
>   {
> -	u8 wbuf[6 + len];
> +	u8 wbuf[80];
>   	u8 mbox = (reg >> 16) & 0xff;
>   	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
>
> +	if (6 + len > sizeof(wbuf)) {
> +		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
> +			 KBUILD_MODNAME, len);
> +		return -EREMOTEIO;
> +	}
> +
>   	wbuf[0] = len;
>   	wbuf[1] = 2;
>   	wbuf[2] = 0;
> @@ -228,9 +234,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   					msg[1].len);
>   		} else {
>   			/* I2C */
> -			u8 buf[5 + msg[0].len];
> +			u8 buf[80];
>   			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
>   					buf, msg[1].len, msg[1].buf };
> +
> +			if (5 + msg[0].len > sizeof(buf)) {
> +				dev_warn(&d->udev->dev,
> +					 "%s: i2c xfer: len=%d is too big!\n",
> +					 KBUILD_MODNAME, msg[0].len);
> +				return -EREMOTEIO;
> +			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[1].len;
>   			buf[1] = msg[0].addr << 1;
> @@ -257,9 +270,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   					msg[0].len - 3);
>   		} else {
>   			/* I2C */
> -			u8 buf[5 + msg[0].len];
> +			u8 buf[80];
>   			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
>   					0, NULL };
> +
> +			if (5 + msg[0].len > sizeof(buf)) {
> +				dev_warn(&d->udev->dev,
> +					 "%s: i2c xfer: len=%d is too big!\n",
> +					 KBUILD_MODNAME, msg[0].len);
> +				return -EREMOTEIO;
> +			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[0].len;
>   			buf[1] = msg[0].addr << 1;
>


-- 
http://palosaari.fi/
