Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3FBVdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 17:33:25 -0400
Message-ID: <51ABB9FC.6000601@iki.fi>
Date: Mon, 03 Jun 2013 00:32:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	mkrufky@linuxtv.org
Subject: Re: [PATCH v2] rtl28xxu: fix buffer overflow when probing Rafael
 Micro r820t tuner
References: <1370208264-10276-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1370208264-10276-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2013 12:24 AM, Gianluca Gennari wrote:
> As suggested by Antti, this patch replaces:
> https://patchwork.kernel.org/patch/2649861/
>
> The buffer overflow is fixed by reading only the r820t ID register.
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 22015fe..2cc8ec7 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -376,7 +376,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
>   	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
>   	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
>   	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
> -	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 5, buf};
> +	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
>
>   	dev_dbg(&d->udev->dev, "%s:\n", __func__);
>
> @@ -481,9 +481,9 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
>   		goto found;
>   	}
>
> -	/* check R820T by reading tuner stats at I2C addr 0x1a */
> +	/* check R820T ID register; reg=00 val=69 */
>   	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
> -	if (ret == 0) {
> +	if (ret == 0 && buf[0] == 0x69) {
>   		priv->tuner = TUNER_RTL2832_R820T;
>   		priv->tuner_name = "R820T";
>   		goto found;
>


-- 
http://palosaari.fi/
