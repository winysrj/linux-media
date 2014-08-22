Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:47036 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHVLrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 07:47:53 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAP004AKI3SOZ00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 22 Aug 2014 07:47:52 -0400 (EDT)
Date: Fri, 22 Aug 2014 06:47:48 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 01/21] si2168: clean logging
Message-id: <20140822064748.70691346.m.chehab@samsung.com>
In-reply-to: <1408705093-5167-2-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
 <1408705093-5167-2-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Please don't add "GIT PULL" on patches. That breaks my scripts, as they
will run a completely different logic when those magic words are there
on a message at patchwork.

Also, the word "FINAL" makes me nervous... That means that you sent me
a non-final pull request?

I'll tag all patches in this series, except for the real pull request,
as superseded, as I'll look on them only when dealing with the real
pull request.

Regards,
Mauro

Em Fri, 22 Aug 2014 13:57:53 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> From: Olli Salonen <olli.salonen@iki.fi>
> 
> Same thing for si2168 as Antti did earlier for tda18212:
> 
> There is no need to print module name nor function name as those
> are done by kernel logging system when dev_xxx logging is used and
> driver is proper I2C driver.
> 
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-frontends/si2168.c | 70 +++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 8f81d97..59a4218 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -55,8 +55,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
>  				break;
>  		}
>  
> -		dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n",
> -				__func__,
> +		dev_dbg(&s->client->dev, "cmd execution took %d ms\n",
>  				jiffies_to_msecs(jiffies) -
>  				(jiffies_to_msecs(timeout) - TIMEOUT));
>  
> @@ -75,7 +74,7 @@ err_mutex_unlock:
>  
>  	return 0;
>  err:
> -	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&s->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -150,12 +149,12 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
>  		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  	}
>  
> -	dev_dbg(&s->client->dev, "%s: status=%02x args=%*ph\n",
> -			__func__, *status, cmd.rlen, cmd.args);
> +	dev_dbg(&s->client->dev, "status=%02x args=%*ph\n",
> +			*status, cmd.rlen, cmd.args);
>  
>  	return 0;
>  err:
> -	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&s->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -168,8 +167,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>  	u8 bandwidth, delivery_system;
>  
>  	dev_dbg(&s->client->dev,
> -			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u\n",
> -			__func__, c->delivery_system, c->modulation,
> +			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u\n",
> +			c->delivery_system, c->modulation,
>  			c->frequency, c->bandwidth_hz, c->symbol_rate,
>  			c->inversion);
>  
> @@ -343,7 +342,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>  
>  	return 0;
>  err:
> -	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&s->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -357,7 +356,7 @@ static int si2168_init(struct dvb_frontend *fe)
>  	struct si2168_cmd cmd;
>  	unsigned int chip_id;
>  
> -	dev_dbg(&s->client->dev, "%s:\n", __func__);
> +	dev_dbg(&s->client->dev, "\n");
>  
>  	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
>  	cmd.wlen = 13;
> @@ -400,16 +399,16 @@ static int si2168_init(struct dvb_frontend *fe)
>  		break;
>  	default:
>  		dev_err(&s->client->dev,
> -				"%s: unkown chip version Si21%d-%c%c%c\n",
> -				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
> +				"unknown chip version Si21%d-%c%c%c\n",
> +				cmd.args[2], cmd.args[1],
>  				cmd.args[3], cmd.args[4]);
>  		ret = -EINVAL;
>  		goto err;
>  	}
>  
>  	/* cold state - try to download firmware */
> -	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
> -			KBUILD_MODNAME, si2168_ops.info.name);
> +	dev_info(&s->client->dev, "found a '%s' in cold state\n",
> +			si2168_ops.info.name);
>  
>  	/* request the firmware, this will block and timeout */
>  	ret = request_firmware(&fw, fw_file, &s->client->dev);
> @@ -422,18 +421,18 @@ static int si2168_init(struct dvb_frontend *fe)
>  
>  		if (ret == 0) {
>  			dev_notice(&s->client->dev,
> -					"%s: please install firmware file '%s'\n",
> -					KBUILD_MODNAME, SI2168_B40_FIRMWARE);
> +					"please install firmware file '%s'\n",
> +					SI2168_B40_FIRMWARE);
>  		} else {
>  			dev_err(&s->client->dev,
> -					"%s: firmware file '%s' not found\n",
> -					KBUILD_MODNAME, fw_file);
> +					"firmware file '%s' not found\n",
> +					fw_file);
>  			goto err;
>  		}
>  	}
>  
> -	dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
> -			KBUILD_MODNAME, fw_file);
> +	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
> +			fw_file);
>  
>  	for (remaining = fw->size; remaining > 0; remaining -= i2c_wr_max) {
>  		len = remaining;
> @@ -446,8 +445,8 @@ static int si2168_init(struct dvb_frontend *fe)
>  		ret = si2168_cmd_execute(s, &cmd);
>  		if (ret) {
>  			dev_err(&s->client->dev,
> -					"%s: firmware download failed=%d\n",
> -					KBUILD_MODNAME, ret);
> +					"firmware download failed=%d\n",
> +					ret);
>  			goto err;
>  		}
>  	}
> @@ -462,8 +461,8 @@ static int si2168_init(struct dvb_frontend *fe)
>  	if (ret)
>  		goto err;
>  
> -	dev_info(&s->client->dev, "%s: found a '%s' in warm state\n",
> -			KBUILD_MODNAME, si2168_ops.info.name);
> +	dev_info(&s->client->dev, "found a '%s' in warm state\n",
> +			si2168_ops.info.name);
>  
>  	s->active = true;
>  
> @@ -472,7 +471,7 @@ err:
>  	if (fw)
>  		release_firmware(fw);
>  
> -	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&s->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -482,7 +481,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
>  	int ret;
>  	struct si2168_cmd cmd;
>  
> -	dev_dbg(&s->client->dev, "%s:\n", __func__);
> +	dev_dbg(&s->client->dev, "\n");
>  
>  	s->active = false;
>  
> @@ -495,7 +494,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
>  
>  	return 0;
>  err:
> -	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&s->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -528,8 +527,7 @@ static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
>  	/* open tuner I2C gate */
>  	ret = __i2c_transfer(s->client->adapter, &gate_open_msg, 1);
>  	if (ret != 1) {
> -		dev_warn(&s->client->dev, "%s: i2c write failed=%d\n",
> -				KBUILD_MODNAME, ret);
> +		dev_warn(&s->client->dev, "i2c write failed=%d\n", ret);
>  		if (ret >= 0)
>  			ret = -EREMOTEIO;
>  	} else {
> @@ -553,8 +551,7 @@ static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
>  	/* close tuner I2C gate */
>  	ret = __i2c_transfer(s->client->adapter, &gate_close_msg, 1);
>  	if (ret != 1) {
> -		dev_warn(&s->client->dev, "%s: i2c write failed=%d\n",
> -				KBUILD_MODNAME, ret);
> +		dev_warn(&s->client->dev, "i2c write failed=%d\n", ret);
>  		if (ret >= 0)
>  			ret = -EREMOTEIO;
>  	} else {
> @@ -607,12 +604,12 @@ static int si2168_probe(struct i2c_client *client,
>  	struct si2168 *s;
>  	int ret;
>  
> -	dev_dbg(&client->dev, "%s:\n", __func__);
> +	dev_dbg(&client->dev, "\n");
>  
>  	s = kzalloc(sizeof(struct si2168), GFP_KERNEL);
>  	if (!s) {
>  		ret = -ENOMEM;
> -		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
> +		dev_err(&client->dev, "kzalloc() failed\n");
>  		goto err;
>  	}
>  
> @@ -637,12 +634,11 @@ static int si2168_probe(struct i2c_client *client,
>  	i2c_set_clientdata(client, s);
>  
>  	dev_info(&s->client->dev,
> -			"%s: Silicon Labs Si2168 successfully attached\n",
> -			KBUILD_MODNAME);
> +			"Silicon Labs Si2168 successfully attached\n");
>  	return 0;
>  err:
>  	kfree(s);
> -	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
> +	dev_dbg(&client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> @@ -650,7 +646,7 @@ static int si2168_remove(struct i2c_client *client)
>  {
>  	struct si2168 *s = i2c_get_clientdata(client);
>  
> -	dev_dbg(&client->dev, "%s:\n", __func__);
> +	dev_dbg(&client->dev, "\n");
>  
>  	i2c_del_mux_adapter(s->adapter);
>  


-- 

Cheers,
Mauro
