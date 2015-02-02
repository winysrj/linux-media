Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38656 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbbBBUHc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 15:07:32 -0500
Date: Mon, 2 Feb 2015 18:07:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>, Mark Brown <broonie@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>, linux-i2c@vger.kernel.org
Cc: linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
Message-ID: <20150202180726.454dc878@recife.lan>
In-Reply-To: <1419367799-14263-21-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
	<1419367799-14263-21-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Dec 2014 22:49:14 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Own I2C locking is needed due to two special reasons:
> 1) Chips uses multiple register pages/banks on single I2C slave.
> Page is changed via I2C register access.
> 2) Chip offers muxed/gated I2C adapter for tuner. Gate/mux is
> controlled by I2C register access.
> 
> Due to these reasons, I2C locking did not fit very well.

I don't like the idea of calling __i2c_transfer() without calling first
i2c_lock_adapter(). This can be dangerous, as the I2C core itself uses
the lock for its own usage.

Ok, this may eventually work ok for now, but a further change at the I2C
core could easily break it. So, we need to double check about such
patch with the I2C maintainer.

Jean,

Are you ok with such patch? If so, please ack.

Regards,
Mauro
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-frontends/rtl2830.c      | 45 +++++++++++++++++++++++++-----
>  drivers/media/dvb-frontends/rtl2830_priv.h |  1 +
>  2 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
> index 8abaca6..3a9e4e9 100644
> --- a/drivers/media/dvb-frontends/rtl2830.c
> +++ b/drivers/media/dvb-frontends/rtl2830.c
> @@ -43,7 +43,7 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
>  	buf[0] = reg;
>  	memcpy(&buf[1], val, len);
>  
> -	ret = i2c_transfer(client->adapter, msg, 1);
> +	ret = __i2c_transfer(client->adapter, msg, 1);
>  	if (ret == 1) {
>  		ret = 0;
>  	} else {
> @@ -73,7 +73,7 @@ static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
>  		}
>  	};
>  
> -	ret = i2c_transfer(client->adapter, msg, 2);
> +	ret = __i2c_transfer(client->adapter, msg, 2);
>  	if (ret == 2) {
>  		ret = 0;
>  	} else {
> @@ -93,16 +93,23 @@ static int rtl2830_wr_regs(struct i2c_client *client, u16 reg, const u8 *val, in
>  	u8 reg2 = (reg >> 0) & 0xff;
>  	u8 page = (reg >> 8) & 0xff;
>  
> +	mutex_lock(&dev->i2c_mutex);
> +
>  	/* switch bank if needed */
>  	if (page != dev->page) {
>  		ret = rtl2830_wr(client, 0x00, &page, 1);
>  		if (ret)
> -			return ret;
> +			goto err_mutex_unlock;
>  
>  		dev->page = page;
>  	}
>  
> -	return rtl2830_wr(client, reg2, val, len);
> +	ret = rtl2830_wr(client, reg2, val, len);
> +
> +err_mutex_unlock:
> +	mutex_unlock(&dev->i2c_mutex);
> +
> +	return ret;
>  }
>  
>  /* read multiple registers */
> @@ -113,16 +120,23 @@ static int rtl2830_rd_regs(struct i2c_client *client, u16 reg, u8 *val, int len)
>  	u8 reg2 = (reg >> 0) & 0xff;
>  	u8 page = (reg >> 8) & 0xff;
>  
> +	mutex_lock(&dev->i2c_mutex);
> +
>  	/* switch bank if needed */
>  	if (page != dev->page) {
>  		ret = rtl2830_wr(client, 0x00, &page, 1);
>  		if (ret)
> -			return ret;
> +			goto err_mutex_unlock;
>  
>  		dev->page = page;
>  	}
>  
> -	return rtl2830_rd(client, reg2, val, len);
> +	ret = rtl2830_rd(client, reg2, val, len);
> +
> +err_mutex_unlock:
> +	mutex_unlock(&dev->i2c_mutex);
> +
> +	return ret;
>  }
>  
>  /* read single register */
> @@ -815,6 +829,10 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
>  	};
>  	int ret;
>  
> +	dev_dbg(&client->dev, "\n");
> +
> +	mutex_lock(&dev->i2c_mutex);
> +
>  	/* select register page */
>  	ret = __i2c_transfer(client->adapter, select_reg_page_msg, 1);
>  	if (ret != 1) {
> @@ -841,6 +859,18 @@ err:
>  	return ret;
>  }
>  
> +static int rtl2830_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
> +{
> +	struct i2c_client *client = mux_priv;
> +	struct rtl2830_dev *dev = i2c_get_clientdata(client);
> +
> +	dev_dbg(&client->dev, "\n");
> +
> +	mutex_unlock(&dev->i2c_mutex);
> +
> +	return 0;
> +}
> +
>  static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
>  {
>  	struct rtl2830_dev *dev = i2c_get_clientdata(client);
> @@ -886,6 +916,7 @@ static int rtl2830_probe(struct i2c_client *client,
>  	dev->client = client;
>  	dev->pdata = client->dev.platform_data;
>  	dev->sleeping = true;
> +	mutex_init(&dev->i2c_mutex);
>  	INIT_DELAYED_WORK(&dev->stat_work, rtl2830_stat_work);
>  
>  	/* check if the demod is there */
> @@ -895,7 +926,7 @@ static int rtl2830_probe(struct i2c_client *client,
>  
>  	/* create muxed i2c adapter for tuner */
>  	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
> -			client, 0, 0, 0, rtl2830_select, NULL);
> +			client, 0, 0, 0, rtl2830_select, rtl2830_deselect);
>  	if (dev->adapter == NULL) {
>  		ret = -ENODEV;
>  		goto err_kfree;
> diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
> index 2931889..517758a 100644
> --- a/drivers/media/dvb-frontends/rtl2830_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2830_priv.h
> @@ -30,6 +30,7 @@ struct rtl2830_dev {
>  	struct i2c_adapter *adapter;
>  	struct dvb_frontend fe;
>  	bool sleeping;
> +	struct mutex i2c_mutex;
>  	u8 page; /* active register page */
>  	unsigned long filters;
>  	struct delayed_work stat_work;
