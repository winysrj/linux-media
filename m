Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2JCAhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:37:48 -0400
Message-ID: <506B88C7.4030305@iki.fi>
Date: Wed, 03 Oct 2012 03:37:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 4/7] [media] ds3000: bail out early on i2c failures during
 firmware load
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-5-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-5-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
>   - if kmalloc() returns NULL, we can return immediately without trying
>     to kfree() a NULL pointer.
>   - if i2c_transfer() fails, error out immediately instead of trying to
>     upload the remaining bytes of the firmware.
>   - the error code is then properly propagated down to ds3000_initfe().
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/dvb-frontends/ds3000.c |   12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 6752222..162faaf 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -280,15 +280,14 @@ static int ds3000_tuner_writereg(struct ds3000_state *state, int reg, int data)
>   static int ds3000_writeFW(struct ds3000_state *state, int reg,
>   				const u8 *data, u16 len)
>   {
> -	int i, ret = -EREMOTEIO;
> +	int i, ret = 0;
>   	struct i2c_msg msg;
>   	u8 *buf;
>
>   	buf = kmalloc(33, GFP_KERNEL);
>   	if (buf == NULL) {
>   		printk(KERN_ERR "Unable to kmalloc\n");
> -		ret = -ENOMEM;
> -		goto error;
> +		return -ENOMEM;
>   	}
>
>   	*(buf) = reg;
> @@ -308,8 +307,10 @@ static int ds3000_writeFW(struct ds3000_state *state, int reg,
>   			printk(KERN_ERR "%s: write error(err == %i, "
>   				"reg == 0x%02x\n", __func__, ret, reg);
>   			ret = -EREMOTEIO;
> +			goto error;
>   		}
>   	}
> +	ret = 0;
>
>   error:
>   	kfree(buf);
> @@ -426,6 +427,7 @@ static int ds3000_load_firmware(struct dvb_frontend *fe,
>   					const struct firmware *fw)
>   {
>   	struct ds3000_state *state = fe->demodulator_priv;
> +	int ret = 0;
>
>   	dprintk("%s\n", __func__);
>   	dprintk("Firmware is %zu bytes (%02x %02x .. %02x %02x)\n",
> @@ -438,10 +440,10 @@ static int ds3000_load_firmware(struct dvb_frontend *fe,
>   	/* Begin the firmware load process */
>   	ds3000_writereg(state, 0xb2, 0x01);
>   	/* write the entire firmware */
> -	ds3000_writeFW(state, 0xb0, fw->data, fw->size);
> +	ret = ds3000_writeFW(state, 0xb0, fw->data, fw->size);
>   	ds3000_writereg(state, 0xb2, 0x00);
>
> -	return 0;
> +	return ret;
>   }
>
>   static int ds3000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
>


-- 
http://palosaari.fi/
