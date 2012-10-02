Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57892 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab2JBTZ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 15:25:59 -0400
Message-ID: <506B3FB0.8070301@iki.fi>
Date: Tue, 02 Oct 2012 22:25:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] drxk: allow loading firmware synchrousnously
References: <1349204716-25971-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1349204716-25971-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2012 10:05 PM, Mauro Carvalho Chehab wrote:
> Due to udev-182, the firmware load was changed to be async, as
> otherwise udev would give up of loading a firmware.
>
> Add an option to return to the previous behaviour, async firmware
> loads cause failures with the tda18271 driver.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Tested-by: Antti Palosaari <crope@iki.fi>

Hauppauge WinTV HVR 930C
MaxMedia UB425-TC
PCTV QuatroStick nano (520e)


> ---
>   drivers/media/dvb-frontends/drxk.h      |  2 ++
>   drivers/media/dvb-frontends/drxk_hard.c | 20 +++++++++++++++-----
>   2 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
> index d615d7d..94fecfb 100644
> --- a/drivers/media/dvb-frontends/drxk.h
> +++ b/drivers/media/dvb-frontends/drxk.h
> @@ -28,6 +28,7 @@
>    *				A value of 0 (default) or lower indicates that
>    *				the correct number of parameters will be
>    *				automatically detected.
> + * @load_firmware_sync:		Force the firmware load to be synchronous.
>    *
>    * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
>    * UIO-3.
> @@ -39,6 +40,7 @@ struct drxk_config {
>   	bool	parallel_ts;
>   	bool	dynamic_clk;
>   	bool	enable_merr_cfg;
> +	bool	load_firmware_sync;
>
>   	bool	antenna_dvbt;
>   	u16	antenna_gpio;
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index 1ab8154..8b4c6d5 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -6609,15 +6609,25 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>
>   	/* Load firmware and initialize DRX-K */
>   	if (state->microcode_name) {
> -		status = request_firmware_nowait(THIS_MODULE, 1,
> +		if (config->load_firmware_sync) {
> +			const struct firmware *fw = NULL;
> +
> +			status = request_firmware(&fw, state->microcode_name,
> +						  state->i2c->dev.parent);
> +			if (status < 0)
> +				fw = NULL;
> +			load_firmware_cb(fw, state);
> +		} else {
> +			status = request_firmware_nowait(THIS_MODULE, 1,
>   					      state->microcode_name,
>   					      state->i2c->dev.parent,
>   					      GFP_KERNEL,
>   					      state, load_firmware_cb);
> -		if (status < 0) {
> -			printk(KERN_ERR
> -			"drxk: failed to request a firmware\n");
> -			return NULL;
> +			if (status < 0) {
> +				printk(KERN_ERR
> +				       "drxk: failed to request a firmware\n");
> +				return NULL;
> +			}
>   		}
>   	} else if (init_drxk(state) < 0)
>   		goto error;
>


-- 
http://palosaari.fi/
