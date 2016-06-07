Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43013 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbcFGH3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 03:29:23 -0400
Subject: Re: [PATCH v2] [media] rtl2832: add support for slave ts pid filter
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	linux-media@vger.kernel.org
References: <1463932987-10526-1-git-send-email-martin.blumenstingl@googlemail.com>
Cc: benjamin@southpole.se
From: Antti Palosaari <crope@iki.fi>
Message-ID: <42c783e0-aa1d-ee6d-3481-43ed5814b1e3@iki.fi>
Date: Tue, 7 Jun 2016 10:29:20 +0300
MIME-Version: 1.0
In-Reply-To: <1463932987-10526-1-git-send-email-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
That patch does not apply anymore as new register access functions are 
now regmap ones. Also I don't see reason you set slave_ts value to false 
on rtl2832_init(). It just be just enough setting its value on 
rtl2832_slave_ts_ctrl().

regards
Antti


On 05/22/2016 07:03 PM, Martin Blumenstingl wrote:
> The rtl2832 demod has 2 sets of PID filters. This patch enables
> the filter support when using a slave demod.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> This patch was originally written by Benjamin Larsson, all I did was
> rebasing the patch and to extend the dev_dbg statements with the
> slave_ts information.
> This also supersedes the following patch:
> https://patchwork.linuxtv.org/patch/34358/
>
>  drivers/media/dvb-frontends/rtl2832.c      | 26 ++++++++++++++++++++------
>  drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
>  2 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index 7c96f76..ba67fb4 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -409,6 +409,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
>  	c->post_bit_count.len = 1;
>  	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  	dev->sleeping = false;
> +	dev->slave_ts = false;
>
>  	return 0;
>  err:
> @@ -1103,6 +1104,8 @@ static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
>  			goto err;
>  	}
>
> +	dev->slave_ts = enable;
> +
>  	return 0;
>  err:
>  	dev_dbg(&client->dev, "failed=%d\n", ret);
> @@ -1116,7 +1119,7 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
>  	int ret;
>  	u8 u8tmp;
>
> -	dev_dbg(&client->dev, "onoff=%d\n", onoff);
> +	dev_dbg(&client->dev, "onoff=%d, slave_ts=%d\n", onoff, dev->slave_ts);
>
>  	/* enable / disable PID filter */
>  	if (onoff)
> @@ -1124,7 +1127,10 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
>  	else
>  		u8tmp = 0x00;
>
> -	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
> +	if (dev->slave_ts)
> +		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
> +	else
> +		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
>  	if (ret)
>  		goto err;
>
> @@ -1142,8 +1148,8 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
>  	int ret;
>  	u8 buf[4];
>
> -	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
> -		index, pid, onoff);
> +	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d slave_ts=%d\n",
> +		index, pid, onoff, dev->slave_ts);
>
>  	/* skip invalid PIDs (0x2000) */
>  	if (pid > 0x1fff || index > 32)
> @@ -1159,14 +1165,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
>  	buf[1] = (dev->filters >>  8) & 0xff;
>  	buf[2] = (dev->filters >> 16) & 0xff;
>  	buf[3] = (dev->filters >> 24) & 0xff;
> -	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
> +
> +	if (dev->slave_ts)
> +		ret = rtl2832_bulk_write(client, 0x022, buf, 4);
> +	else
> +		ret = rtl2832_bulk_write(client, 0x062, buf, 4);
>  	if (ret)
>  		goto err;
>
>  	/* add PID */
>  	buf[0] = (pid >> 8) & 0xff;
>  	buf[1] = (pid >> 0) & 0xff;
> -	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
> +
> +	if (dev->slave_ts)
> +		ret = rtl2832_bulk_write(client, 0x026 + 2 * index, buf, 2);
> +	else
> +		ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
>  	if (ret)
>  		goto err;
>
> diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
> index 6b875f4..8eb2e0b 100644
> --- a/drivers/media/dvb-frontends/rtl2832_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2832_priv.h
> @@ -45,6 +45,7 @@ struct rtl2832_dev {
>  	bool sleeping;
>  	struct delayed_work i2c_gate_work;
>  	unsigned long filters; /* PID filter */
> +	bool slave_ts;
>  };
>
>  struct rtl2832_reg_entry {
>

-- 
http://palosaari.fi/
