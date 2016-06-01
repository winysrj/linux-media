Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39246 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbcFAHD2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2016 03:03:28 -0400
Subject: Re: [PATCH v2] [media] af9035: fix for MXL5007T devices with I2C read
 issues
To: Alessandro Radicati <alessandro@radicati.net>,
	areguero@telefonica.net
References: <1463050032-16771-1-git-send-email-alessandro@radicati.net>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <ec4af54e-830c-b837-c10e-b41948415ab1@iki.fi>
Date: Wed, 1 Jun 2016 10:03:25 +0300
MIME-Version: 1.0
In-Reply-To: <1463050032-16771-1-git-send-email-alessandro@radicati.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied for 4.8, thanks!

Antti

On 05/12/2016 01:47 PM, Alessandro Radicati wrote:
> The MXL5007T tuner will lock-up on some devices after an I2C
> read transaction.  This patch works around this issue by inhibiting such
> operations and emulating a 0x00 response.  The workaround is only applied to
> USB devices known to exhibit this flaw.
>
> Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
> ---
>  drivers/media/usb/dvb-usb-v2/af9035.c | 21 +++++++++++++++++++++
>  drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
>  2 files changed, 22 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 2638e32..06e300e 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -348,6 +348,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>
>  			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
>  					msg[1].len);
> +		} else if (state->no_read) {
> +			memset(msg[1].buf, 0, msg[1].len);
> +			ret = 0;
>  		} else {
>  			/* I2C write + read */
>  			u8 buf[MAX_XFER_SIZE];
> @@ -421,6 +424,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>  		if (msg[0].len > 40) {
>  			/* TODO: correct limits > 40 */
>  			ret = -EOPNOTSUPP;
> +		} else if (state->no_read) {
> +			memset(msg[0].buf, 0, msg[0].len);
> +			ret = 0;
>  		} else {
>  			/* I2C read */
>  			u8 buf[5];
> @@ -962,6 +968,21 @@ skip_eeprom:
>  			state->af9033_config[i].clock = clock_lut_af9035[tmp];
>  	}
>
> +	state->no_read = false;
> +	/* Some MXL5007T devices cannot properly handle tuner I2C read ops. */
> +	if (state->af9033_config[0].tuner == AF9033_TUNER_MXL5007T &&
> +		le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA)
> +
> +		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
> +		case USB_PID_AVERMEDIA_A867:
> +		case USB_PID_AVERMEDIA_TWINSTAR:
> +			dev_info(&d->udev->dev,
> +				"%s: Device may have issues with I2C read operations. Enabling fix.\n",
> +				KBUILD_MODNAME);
> +			state->no_read = true;
> +			break;
> +		}
> +
>  	return 0;
>
>  err:
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
> index 89e629a..c91d1a3 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
> @@ -62,6 +62,7 @@ struct state {
>  	u8 chip_version;
>  	u16 chip_type;
>  	u8 dual_mode:1;
> +	u8 no_read:1;
>  	u16 eeprom_addr;
>  	u8 af9033_i2c_addr[2];
>  	struct af9033_config af9033_config[2];
>

-- 
http://palosaari.fi/
