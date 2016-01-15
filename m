Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52358 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbcAORN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 12:13:28 -0500
Received: from [192.168.6.10] ([185.17.205.228]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0M8Nik-1Zyu5X4BBS-00vyoV for
 <linux-media@vger.kernel.org>; Fri, 15 Jan 2016 18:13:26 +0100
Subject: Re: [PATCH] af9035: add support for 2nd tuner of MSI DigiVox
 Diversity
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <568AE147.6070908@gmx.de>
From: =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>
Message-ID: <569928B0.9060703@gmx.de>
Date: Fri, 15 Jan 2016 18:13:20 +0100
MIME-Version: 1.0
In-Reply-To: <568AE147.6070908@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just wanted to ask if there is any further information needed regarding my patch.

Best regards,
	Stefan

Am 04.01.2016 um 22:16 schrieb Stefan Pöschel:
> PIP tested with VLC. Diversity tested with the Windows driver.
> 
> Signed-off-by: Stefan Pöschel <basic.master@gmx.de>
> ---
>  drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++--
>  drivers/media/usb/dvb-usb-v2/af9035.h | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 6e02a15..b3c09fe 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -684,7 +684,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
>  	if (ret < 0)
>  		goto err;
> 
> -	if (tmp =1 || tmp == 3) {
> +	if (tmp =1 || tmp == 3 || tmp == 5) {
>  		/* configure gpioh1, reset & power slave demod */
>  		ret =f9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
>  		if (ret < 0)
> @@ -823,7 +823,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
>  	if (ret < 0)
>  		goto err;
> 
> -	if (tmp =1 || tmp == 3)
> +	if (tmp =1 || tmp == 3 || tmp == 5)
>  		state->dual_mode =rue;
> 
>  	dev_dbg(&d->udev->dev, "%s: ts mode= dual mode=%d\n", __func__,
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
> index 416a97f..df22001 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
> @@ -112,9 +112,10 @@ static const u32 clock_lut_it9135[] =
>   * 0  TS
>   * 1  DCA + PIP
>   * 3  PIP
> + * 5  DCA + PIP
>   * n  DCA
>   *
> - * Values 0 and 3 are seen to this day. 0 for single TS and 3 for dual TS.
> + * Values 0, 3 and 5 are seen to this day. 0 for single TS and 3/5 for dual TS.
>   */
> 
>  #define EEPROM_BASE_AF9035        0x42fd
> 
