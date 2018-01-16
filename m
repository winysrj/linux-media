Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:40932 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbeAPFHx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 00:07:53 -0500
Subject: Re: [PATCH 4/7] si2168: Add ts bus coontrol, turn off bus on sleep
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
 <1515773982-6411-5-git-send-email-brad@nextdimension.cc>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <ce8faa6a-0ffb-a432-e269-58486c857fea@iki.fi>
Date: Tue, 16 Jan 2018 07:07:49 +0200
MIME-Version: 1.0
In-Reply-To: <1515773982-6411-5-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
And what is rationale here, is there some use case demod must be active 
and ts set to tristate (disabled)? Just put demod sleep when you don't 
use it.

regards
Antti

On 01/12/2018 06:19 PM, Brad Love wrote:
> Includes a function to set TS MODE property os si2168. The function
> either disables the TS output bus, or sets mode to config option.
> 
> When going to sleep the TS bus is turned off, this makes the driver
> compatible with multiple frontend usage.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>   drivers/media/dvb-frontends/si2168.c | 38 ++++++++++++++++++++++++++++--------
>   drivers/media/dvb-frontends/si2168.h |  1 +
>   2 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 539399d..429c03a 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -409,6 +409,30 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   	return ret;
>   }
>   
> +static int si2168_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
> +{
> +	struct i2c_client *client = fe->demodulator_priv;
> +	struct si2168_dev *dev = i2c_get_clientdata(client);
> +	struct si2168_cmd cmd;
> +	int ret = 0;
> +
> +	dev_dbg(&client->dev, "%s acquire: %d\n", __func__, acquire);
> +
> +	/* set TS_MODE property */
> +	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
> +	if (acquire)
> +		cmd.args[4] |= dev->ts_mode;
> +	else
> +		cmd.args[4] |= SI2168_TS_TRISTATE;
> +	if (dev->ts_clock_gapped)
> +		cmd.args[4] |= 0x40;
> +	cmd.wlen = 6;
> +	cmd.rlen = 4;
> +	ret = si2168_cmd_execute(client, &cmd);
> +
> +	return ret;
> +}
> +
>   static int si2168_init(struct dvb_frontend *fe)
>   {
>   	struct i2c_client *client = fe->demodulator_priv;
> @@ -540,14 +564,7 @@ static int si2168_init(struct dvb_frontend *fe)
>   		 dev->version >> 24 & 0xff, dev->version >> 16 & 0xff,
>   		 dev->version >> 8 & 0xff, dev->version >> 0 & 0xff);
>   
> -	/* set ts mode */
> -	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
> -	cmd.args[4] |= dev->ts_mode;
> -	if (dev->ts_clock_gapped)
> -		cmd.args[4] |= 0x40;
> -	cmd.wlen = 6;
> -	cmd.rlen = 4;
> -	ret = si2168_cmd_execute(client, &cmd);
> +	ret = si2168_ts_bus_ctrl(fe, 1);
>   	if (ret)
>   		goto err;
>   
> @@ -584,6 +601,9 @@ static int si2168_sleep(struct dvb_frontend *fe)
>   
>   	dev->active = false;
>   
> +	/* tri-state data bus */
> +	si2168_ts_bus_ctrl(fe, 0);
> +
>   	/* Firmware B 4.0-11 or later loses warm state during sleep */
>   	if (dev->version > ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
>   		dev->warm = false;
> @@ -681,6 +701,8 @@ static const struct dvb_frontend_ops si2168_ops = {
>   	.init = si2168_init,
>   	.sleep = si2168_sleep,
>   
> +	.ts_bus_ctrl          = si2168_ts_bus_ctrl,
> +
>   	.set_frontend = si2168_set_frontend,
>   
>   	.read_status = si2168_read_status,
> diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
> index 3225d0c..f48f0fb 100644
> --- a/drivers/media/dvb-frontends/si2168.h
> +++ b/drivers/media/dvb-frontends/si2168.h
> @@ -38,6 +38,7 @@ struct si2168_config {
>   	/* TS mode */
>   #define SI2168_TS_PARALLEL	0x06
>   #define SI2168_TS_SERIAL	0x03
> +#define SI2168_TS_TRISTATE	0x00
>   	u8 ts_mode;
>   
>   	/* TS clock inverted */
> 

-- 
http://palosaari.fi/
