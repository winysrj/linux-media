Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59877 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbbEMUKb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 16:10:31 -0400
Date: Wed, 13 May 2015 17:10:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] dw2102: remove unnecessary newline from log
 printouts
Message-ID: <20150513171026.0a00db81@recife.lan>
In-Reply-To: <1430843635-24002-2-git-send-email-olli.salonen@iki.fi>
References: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
	<1430843635-24002-2-git-send-email-olli.salonen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  5 May 2015 19:33:53 +0300
Olli Salonen <olli.salonen@iki.fi> escreveu:

> The info and warn functions already add a newline to the end of the
> log printouts, so remove the extra newline from the printouts.

Hi Olli,

The best here would be to convert this driver to use dvb-usb2, and replace
the usage of warn()/info()/dprintk() by the standard driver printk macros:
dev_info()/dev_warn()/...

Regards,
Mauro

> 
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/usb/dvb-usb/dw2102.c | 60 +++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 4ad6bb2..b1f8a3f 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -307,7 +307,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  		u8 ibuf[MAX_XFER_SIZE], obuf[3];
>  
>  		if (2 + msg[1].len > sizeof(ibuf)) {
> -			warn("i2c rd: len=%d is too big!\n",
> +			warn("i2c rd: len=%d is too big!",
>  			     msg[1].len);
>  			ret = -EOPNOTSUPP;
>  			goto unlock;
> @@ -332,7 +332,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  			u8 obuf[MAX_XFER_SIZE];
>  
>  			if (2 + msg[0].len > sizeof(obuf)) {
> -				warn("i2c wr: len=%d is too big!\n",
> +				warn("i2c wr: len=%d is too big!",
>  				     msg[1].len);
>  				ret = -EOPNOTSUPP;
>  				goto unlock;
> @@ -350,7 +350,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  			u8 obuf[MAX_XFER_SIZE];
>  
>  			if (2 + msg[0].len > sizeof(obuf)) {
> -				warn("i2c wr: len=%d is too big!\n",
> +				warn("i2c wr: len=%d is too big!",
>  				     msg[1].len);
>  				ret = -EOPNOTSUPP;
>  				goto unlock;
> @@ -426,7 +426,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
>  				u8  ibuf[MAX_XFER_SIZE];
>  
>  				if (2 + msg[j].len > sizeof(ibuf)) {
> -					warn("i2c rd: len=%d is too big!\n",
> +					warn("i2c rd: len=%d is too big!",
>  					     msg[j].len);
>  					ret = -EOPNOTSUPP;
>  					goto unlock;
> @@ -463,7 +463,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
>  				u8 obuf[MAX_XFER_SIZE];
>  
>  				if (2 + msg[j].len > sizeof(obuf)) {
> -					warn("i2c wr: len=%d is too big!\n",
> +					warn("i2c wr: len=%d is too big!",
>  					     msg[j].len);
>  					ret = -EOPNOTSUPP;
>  					goto unlock;
> @@ -507,7 +507,7 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		u8 ibuf[MAX_XFER_SIZE], obuf[3];
>  
>  		if (2 + msg[1].len > sizeof(ibuf)) {
> -			warn("i2c rd: len=%d is too big!\n",
> +			warn("i2c rd: len=%d is too big!",
>  			     msg[1].len);
>  			ret = -EOPNOTSUPP;
>  			goto unlock;
> @@ -532,7 +532,7 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  			u8 obuf[MAX_XFER_SIZE];
>  
>  			if (2 + msg[0].len > sizeof(obuf)) {
> -				warn("i2c wr: len=%d is too big!\n",
> +				warn("i2c wr: len=%d is too big!",
>  				     msg[0].len);
>  				ret = -EOPNOTSUPP;
>  				goto unlock;
> @@ -623,7 +623,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  				u8 ibuf[MAX_XFER_SIZE];
>  
>  				if (msg[j].len > sizeof(ibuf)) {
> -					warn("i2c rd: len=%d is too big!\n",
> +					warn("i2c rd: len=%d is too big!",
>  					     msg[j].len);
>  					ret = -EOPNOTSUPP;
>  					goto unlock;
> @@ -658,7 +658,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  				u8 obuf[MAX_XFER_SIZE];
>  
>  				if (2 + msg[j].len > sizeof(obuf)) {
> -					warn("i2c wr: len=%d is too big!\n",
> +					warn("i2c wr: len=%d is too big!",
>  					     msg[j].len);
>  					ret = -EOPNOTSUPP;
>  					goto unlock;
> @@ -678,7 +678,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  				u8 obuf[MAX_XFER_SIZE];
>  
>  				if (2 + msg[j].len > sizeof(obuf)) {
> -					warn("i2c wr: len=%d is too big!\n",
> +					warn("i2c wr: len=%d is too big!",
>  					     msg[j].len);
>  					ret = -EOPNOTSUPP;
>  					goto unlock;
> @@ -891,7 +891,7 @@ static int su3000_power_ctrl(struct dvb_usb_device *d, int i)
>  	struct dw2102_state *state = (struct dw2102_state *)d->priv;
>  	u8 obuf[] = {0xde, 0};
>  
> -	info("%s: %d, initialized %d\n", __func__, i, state->initialized);
> +	info("%s: %d, initialized %d", __func__, i, state->initialized);
>  
>  	if (i && !state->initialized) {
>  		state->initialized = 1;
> @@ -938,7 +938,7 @@ static int su3000_identify_state(struct usb_device *udev,
>  				 struct dvb_usb_device_description **desc,
>  				 int *cold)
>  {
> -	info("%s\n", __func__);
> +	info("%s", __func__);
>  
>  	*cold = 0;
>  	return 0;
> @@ -1172,7 +1172,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
>  				tuner_ops->set_bandwidth = stb6100_set_bandw;
>  				tuner_ops->get_bandwidth = stb6100_get_bandw;
>  				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -				info("Attached STV0900+STB6100!\n");
> +				info("Attached STV0900+STB6100!");
>  				return 0;
>  			}
>  		}
> @@ -1186,7 +1186,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
>  					&dw2104_stv6110_config,
>  					&d->dev->i2c_adap)) {
>  				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -				info("Attached STV0900+STV6110A!\n");
> +				info("Attached STV0900+STV6110A!");
>  				return 0;
>  			}
>  		}
> @@ -1197,7 +1197,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
>  				&d->dev->i2c_adap);
>  		if (d->fe_adap[0].fe != NULL) {
>  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -			info("Attached cx24116!\n");
> +			info("Attached cx24116!");
>  			return 0;
>  		}
>  	}
> @@ -1208,7 +1208,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
>  		dvb_attach(ts2020_attach, d->fe_adap[0].fe,
>  			&dw2104_ts2020_config, &d->dev->i2c_adap);
>  		d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -		info("Attached DS3000!\n");
> +		info("Attached DS3000!");
>  		return 0;
>  	}
>  
> @@ -1227,7 +1227,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
>  					&d->dev->i2c_adap);
>  		if (d->fe_adap[0].fe != NULL) {
>  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -			info("Attached si21xx!\n");
> +			info("Attached si21xx!");
>  			return 0;
>  		}
>  	}
> @@ -1239,7 +1239,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
>  			if (dvb_attach(stb6000_attach, d->fe_adap[0].fe, 0x61,
>  					&d->dev->i2c_adap)) {
>  				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -				info("Attached stv0288!\n");
> +				info("Attached stv0288!");
>  				return 0;
>  			}
>  		}
> @@ -1251,7 +1251,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
>  					&d->dev->i2c_adap);
>  		if (d->fe_adap[0].fe != NULL) {
>  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -			info("Attached stv0299!\n");
> +			info("Attached stv0299!");
>  			return 0;
>  		}
>  	}
> @@ -1263,7 +1263,7 @@ static int dw3101_frontend_attach(struct dvb_usb_adapter *d)
>  	d->fe_adap[0].fe = dvb_attach(tda10023_attach, &dw3101_tda10023_config,
>  				&d->dev->i2c_adap, 0x48);
>  	if (d->fe_adap[0].fe != NULL) {
> -		info("Attached tda10023!\n");
> +		info("Attached tda10023!");
>  		return 0;
>  	}
>  	return -EIO;
> @@ -1277,7 +1277,7 @@ static int zl100313_frontend_attach(struct dvb_usb_adapter *d)
>  		if (dvb_attach(zl10039_attach, d->fe_adap[0].fe, 0x60,
>  				&d->dev->i2c_adap)) {
>  			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
> -			info("Attached zl100313+zl10039!\n");
> +			info("Attached zl100313+zl10039!");
>  			return 0;
>  		}
>  	}
> @@ -1302,7 +1302,7 @@ static int stv0288_frontend_attach(struct dvb_usb_adapter *d)
>  
>  	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
>  
> -	info("Attached stv0288+stb6000!\n");
> +	info("Attached stv0288+stb6000!");
>  
>  	return 0;
>  
> @@ -1327,7 +1327,7 @@ static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
>  
>  	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
>  
> -	info("Attached ds3000+ts2020!\n");
> +	info("Attached ds3000+ts2020!");
>  
>  	return 0;
>  }
> @@ -1345,7 +1345,7 @@ static int prof_7500_frontend_attach(struct dvb_usb_adapter *d)
>  
>  	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
>  
> -	info("Attached STV0900+STB6100A!\n");
> +	info("Attached STV0900+STB6100A!");
>  
>  	return 0;
>  }
> @@ -1393,11 +1393,11 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
>  	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
>  				&dw2104_ts2020_config,
>  				&d->dev->i2c_adap)) {
> -		info("Attached DS3000/TS2020!\n");
> +		info("Attached DS3000/TS2020!");
>  		return 0;
>  	}
>  
> -	info("Failed to attach DS3000/TS2020!\n");
> +	info("Failed to attach DS3000/TS2020!");
>  	return -EIO;
>  }
>  
> @@ -1442,12 +1442,12 @@ static int t220_frontend_attach(struct dvb_usb_adapter *d)
>  	if (d->fe_adap[0].fe != NULL) {
>  		if (dvb_attach(tda18271_attach, d->fe_adap[0].fe, 0x60,
>  					&d->dev->i2c_adap, &tda18271_config)) {
> -			info("Attached TDA18271HD/CXD2820R!\n");
> +			info("Attached TDA18271HD/CXD2820R!");
>  			return 0;
>  		}
>  	}
>  
> -	info("Failed to attach TDA18271HD/CXD2820R!\n");
> +	info("Failed to attach TDA18271HD/CXD2820R!");
>  	return -EIO;
>  }
>  
> @@ -1468,11 +1468,11 @@ static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
>  	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
>  				&dw2104_ts2020_config,
>  				&d->dev->i2c_adap)) {
> -		info("Attached RS2000/TS2020!\n");
> +		info("Attached RS2000/TS2020!");
>  		return 0;
>  	}
>  
> -	info("Failed to attach RS2000/TS2020!\n");
> +	info("Failed to attach RS2000/TS2020!");
>  	return -EIO;
>  }
>  
