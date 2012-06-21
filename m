Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab2FUTKe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:10:34 -0400
Message-ID: <4FE37194.30407@redhat.com>
Date: Thu, 21 Jun 2012 16:10:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-06-2012 10:36, Mauro Carvalho Chehab escreveu:
> The firmware blob may not be available when the driver probes.
> 
> Instead of blocking the whole kernel use request_firmware_nowait() and
> continue without firmware.
> 
> This shouldn't be that bad on drx-k devices, as they all seem to have an
> internal firmware. So, only the firmware update will take a little longer
> to happen.

While thinking on converting another DVB frontend driver, I just realized
that a patch like that won't work fine.

As most of you know, there are _several_ I2C chips that don't tolerate any
usage of the I2C bus while a firmware is being loaded (I dunno if this is the
case of drx-k, but I won't doubt).

The current approach makes the device probe() logic is serialized. So, there's
no chance that two different I2C drivers to try to access the bus at the same
time, if the bridge driver is properly implemented.

However, now that firmware is loaded asynchronously, several other I2C drivers
may be trying to use the bus at the same time. So, events like IR (and CI) polling,
tuner get_status, etc can happen during a firmware transfer, causing the firmware
to not load properly.

A fix for that will require to lock the firmware load I2C traffic into a single
transaction.

So, the code that sends the firmware to the board need to be changed to something like:

static int DownloadMicrocode(struct drxk_state *state,
			     const u8 pMCImage[], u32 Length)
{

...
	i2c_lock_adapter(state->i2c);
	...
	for (i = 0; i < nBlocks; i += 1) {
		...

		status =  __i2c_transfer(state->i2c, ...);
		...
	}
	i2c_unlock_adapter(state->i2c);
	return status;
}

where __i2c_transfer() would be a variant of i2c_transfer() that won't take the
I2C lock.

Other drivers that load firmware at I2C and use request_firmware_nowait() will also
need a similar approach.

Jean,

What do you think?

Regards,
Mauro

> 
> Cc: Antti Palosaari <crope@iki.fi>
> Cc: Kay Sievers <kay@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   drivers/media/dvb/frontends/drxk_hard.c |  109 +++++++++++++++++++------------
>   drivers/media/dvb/frontends/drxk_hard.h |    3 +
>   2 files changed, 72 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
> index 60b868f..4cb8d1e 100644
> --- a/drivers/media/dvb/frontends/drxk_hard.c
> +++ b/drivers/media/dvb/frontends/drxk_hard.c
> @@ -5968,29 +5968,9 @@ error:
>   	return status;
>   }
>   
> -static int load_microcode(struct drxk_state *state, const char *mc_name)
> -{
> -	const struct firmware *fw = NULL;
> -	int err = 0;
> -
> -	dprintk(1, "\n");
> -
> -	err = request_firmware(&fw, mc_name, state->i2c->dev.parent);
> -	if (err < 0) {
> -		printk(KERN_ERR
> -		       "drxk: Could not load firmware file %s.\n", mc_name);
> -		printk(KERN_INFO
> -		       "drxk: Copy %s to your hotplug directory!\n", mc_name);
> -		return err;
> -	}
> -	err = DownloadMicrocode(state, fw->data, fw->size);
> -	release_firmware(fw);
> -	return err;
> -}
> -
>   static int init_drxk(struct drxk_state *state)
>   {
> -	int status = 0;
> +	int status = 0, n = 0;
>   	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
>   	u16 driverVersion;
>   
> @@ -6073,8 +6053,12 @@ static int init_drxk(struct drxk_state *state)
>   		if (status < 0)
>   			goto error;
>   
> -		if (state->microcode_name)
> -			load_microcode(state, state->microcode_name);
> +		if (state->fw) {
> +			status = DownloadMicrocode(state, state->fw->data,
> +						   state->fw->size);
> +			if (status < 0)
> +				goto error;
> +		}
>   
>   		/* disable token-ring bus through OFDM block for possible ucode upload */
>   		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
> @@ -6167,6 +6151,20 @@ static int init_drxk(struct drxk_state *state)
>   			state->m_DrxkState = DRXK_POWERED_DOWN;
>   		} else
>   			state->m_DrxkState = DRXK_STOPPED;
> +
> +		/* Initialize the supported delivery systems */
> +		n = 0;
> +		if (state->m_hasDVBC) {
> +			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
> +			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
> +			strlcat(state->frontend.ops.info.name, " DVB-C",
> +				sizeof(state->frontend.ops.info.name));
> +		}
> +		if (state->m_hasDVBT) {
> +			state->frontend.ops.delsys[n++] = SYS_DVBT;
> +			strlcat(state->frontend.ops.info.name, " DVB-T",
> +				sizeof(state->frontend.ops.info.name));
> +		}
>   	}
>   error:
>   	if (status < 0)
> @@ -6175,11 +6173,44 @@ error:
>   	return status;
>   }
>   
> +static void load_firmware_cb(const struct firmware *fw,
> +			     void *context)
> +{
> +	struct drxk_state *state = context;
> +
> +	if (!fw) {
> +		printk(KERN_ERR
> +		       "drxk: Could not load firmware file %s.\n",
> +			state->microcode_name);
> +		printk(KERN_INFO
> +		       "drxk: Copy %s to your hotplug directory!\n",
> +			state->microcode_name);
> +		state->microcode_name = NULL;
> +
> +		/*
> +		 * As firmware is now load asynchronous, it is not possible
> +		 * anymore to fail at frontend attach. We might silently
> +		 * return here, and hope that the driver won't crash.
> +		 * We might also change all DVB callbacks to return -ENODEV
> +		 * if the device is not initialized.
> +		 * As the DRX-K devices have their own internal firmware,
> +		 * let's just hope that it will match a firmware revision
> +		 * compatible with this driver and proceed.
> +		 */
> +	}
> +	state->fw = fw;
> +
> +	init_drxk(state);
> +}
> +
>   static void drxk_release(struct dvb_frontend *fe)
>   {
>   	struct drxk_state *state = fe->demodulator_priv;
>   
>   	dprintk(1, "\n");
> +	if (state->fw)
> +		release_firmware(state->fw);
> +
>   	kfree(state);
>   }
>   
> @@ -6371,10 +6402,9 @@ static struct dvb_frontend_ops drxk_ops = {
>   struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>   				 struct i2c_adapter *i2c)
>   {
> -	int n;
> -
>   	struct drxk_state *state = NULL;
>   	u8 adr = config->adr;
> +	int status;
>   
>   	dprintk(1, "\n");
>   	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
> @@ -6425,22 +6455,21 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>   	state->frontend.demodulator_priv = state;
>   
>   	init_state(state);
> -	if (init_drxk(state) < 0)
> -		goto error;
>   
> -	/* Initialize the supported delivery systems */
> -	n = 0;
> -	if (state->m_hasDVBC) {
> -		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
> -		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
> -		strlcat(state->frontend.ops.info.name, " DVB-C",
> -			sizeof(state->frontend.ops.info.name));
> -	}
> -	if (state->m_hasDVBT) {
> -		state->frontend.ops.delsys[n++] = SYS_DVBT;
> -		strlcat(state->frontend.ops.info.name, " DVB-T",
> -			sizeof(state->frontend.ops.info.name));
> -	}
> +	/* Load firmware and initialize DRX-K */
> +	if (state->microcode_name) {
> +		status = request_firmware_nowait(THIS_MODULE, 1,
> +					      state->microcode_name,
> +					      state->i2c->dev.parent,
> +					      GFP_KERNEL,
> +					      state, load_firmware_cb);
> +		if (status < 0) {
> +			printk(KERN_ERR
> +			"drxk: failed to request a firmware\n");
> +			return NULL;
> +		}
> +	} else if (init_drxk(state) < 0)
> +		goto error;
>   
>   	printk(KERN_INFO "drxk: frontend initialized.\n");
>   	return &state->frontend;
> diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
> index 4bbf841..36677cd 100644
> --- a/drivers/media/dvb/frontends/drxk_hard.h
> +++ b/drivers/media/dvb/frontends/drxk_hard.h
> @@ -338,7 +338,10 @@ struct drxk_state {
>   	bool	antenna_dvbt;
>   	u16	antenna_gpio;
>   
> +	/* Firmware */
>   	const char *microcode_name;
> +	struct completion fw_wait_load;
> +	const struct firmware *fw;
>   };
>   
>   #define NEVER_LOCK 0
> 


