Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48796 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2JCAhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:37:23 -0400
Message-ID: <506B88AE.7050806@iki.fi>
Date: Wed, 03 Oct 2012 03:37:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 2/7] [media] ds3000: remove useless 'locking'
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-3-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-3-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> Since b9bf2eafaad9c1ef02fb3db38c74568be601a43a, the function
> ds3000_firmware_ondemand() is called only once during init. This
> locking scheme may have been useful when the firmware was loaded at
> each tune.
>
> Furthermore, it looks like this 'lock' was put in to prevent concurrent
> access (and not recursion as the comments suggest). However, this open-
> coded mechanism is anything but race-free and should have used a proper
> mutex.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/dvb-frontends/ds3000.c |    9 ---------
>   1 file changed, 9 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 46874c7..474f26e 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -233,7 +233,6 @@ struct ds3000_state {
>   	struct i2c_adapter *i2c;
>   	const struct ds3000_config *config;
>   	struct dvb_frontend frontend;
> -	u8 skip_fw_load;
>   	/* previous uncorrected block counter for DVB-S2 */
>   	u16 prevUCBS2;
>   };
> @@ -395,8 +394,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>   	if (ds3000_readreg(state, 0xb2) <= 0)
>   		return ret;
>
> -	if (state->skip_fw_load)
> -		return 0;
>   	/* Load firmware */
>   	/* request the firmware, this will block until someone uploads it */
>   	printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
> @@ -410,9 +407,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>   		return ret;
>   	}
>
> -	/* Make sure we don't recurse back through here during loading */
> -	state->skip_fw_load = 1;
> -
>   	ret = ds3000_load_firmware(fe, fw);
>   	if (ret)
>   		printk("%s: Writing firmware to device failed\n", __func__);
> @@ -422,9 +416,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>   	dprintk("%s: Firmware upload %s\n", __func__,
>   			ret == 0 ? "complete" : "failed");
>
> -	/* Ensure firmware is always loaded if required */
> -	state->skip_fw_load = 0;
> -
>   	return ret;
>   }
>
>


-- 
http://palosaari.fi/
