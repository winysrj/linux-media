Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47506 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3KGX1m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Nov 2013 18:27:42 -0500
Message-ID: <527C21E7.7040404@iki.fi>
Date: Fri, 08 Nov 2013 01:27:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 18/29] [media] tuners: Don't use dynamic static allocation
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com> <1383645702-30636-19-git-send-email-m.chehab@samsung.com> <527926CB.8070006@iki.fi> <527BE215.4080702@iki.fi> <20131107191345.27ab51df@samsung.com>
In-Reply-To: <20131107191345.27ab51df@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 07.11.2013 23:13, Mauro Carvalho Chehab wrote:
> Em Thu, 07 Nov 2013 20:55:17 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Mauro,
>> I just notified these are all broken. The reason is here that I2C
>> adapter sets I2C operation length using sizeof(buf).
>
> Gah!
>
>> Please take a look of all there patches and check existing use of
>> sizeof(buf).
>
> Thanks for review!
>
> Well not all were broken, as, on most drivers weren't using sizeof().
>
> Anyway, I double-checked everything and fixed the drivers.
>
> Instead of just mailbombing a 29 patch series, it seems better to just
> paste here the differences from v4, and add a pointer to a git tree
> with the full series of patches:
> 	
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/build-fixes-v4
>
> Enclosed is the diff against v3.
>
> PS.: it also addresses the issue pointed by Andy.
>
> Regards,
> Mauro
>
> -
>
> diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
> index 19ba66ad23fa..fb504f1e9125 100644
> --- a/drivers/media/dvb-frontends/af9013.c
> +++ b/drivers/media/dvb-frontends/af9013.c
> @@ -58,7 +58,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
>   		{
>   			.addr = priv->config.i2c_addr,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 3 + len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
> index 11f1555e66dc..30ee59052157 100644
> --- a/drivers/media/dvb-frontends/af9033.c
> +++ b/drivers/media/dvb-frontends/af9033.c
> @@ -48,7 +48,7 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
>   		{
>   			.addr = state->cfg.i2c_addr,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 3 + len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
> index b908800b390d..7efb796c472c 100644
> --- a/drivers/media/dvb-frontends/rtl2830.c
> +++ b/drivers/media/dvb-frontends/rtl2830.c
> @@ -39,7 +39,7 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
>   		{
>   			.addr = priv->cfg.i2c_addr,
>   			.flags = 0,
> -			.len = 1+len,
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index cd1e6965ac11..ff73da9365e3 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -170,7 +170,7 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
>   		{
>   			.addr = priv->cfg.i2c_addr,
>   			.flags = 0,
> -			.len = 1+len,
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
> index 97c400a4297f..93eeaf7118fd 100644
> --- a/drivers/media/dvb-frontends/s5h1420.c
> +++ b/drivers/media/dvb-frontends/s5h1420.c
> @@ -854,7 +854,7 @@ static int s5h1420_tuner_i2c_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c
>
>   	memcpy(&m[1], msg, sizeof(struct i2c_msg) * num);
>
> -	return i2c_transfer(state->i2c, m, 1+num) == 1 + num ? num : -EIO;
> +	return i2c_transfer(state->i2c, m, 1 + num) == 1 + num ? num : -EIO;
>   }
>
>   static struct i2c_algorithm s5h1420_tuner_i2c_algo = {
> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> index 1d8bc2ea4b10..8ad3a57cf640 100644
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -35,7 +35,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>   		{
>   			.addr = priv->cfg.demod_i2c_addr,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> @@ -76,7 +76,7 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>   		}, {
>   			.addr = priv->cfg.demod_i2c_addr,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 87f5bcf29e90..c1f8cc6f14b2 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -327,7 +327,7 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
>   	struct i2c_client *c;
>   	u8 eedata[256];
>
> -	c = kzalloc(sizeof(*c), GFP_ATOMIC);
> +	c = kzalloc(sizeof(*c), GFP_KERNEL);
>
>   	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
>   	c->adapter = &cx->i2c_adap[0];
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index 30192463c9e1..c9cc1232f2e5 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -32,7 +32,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>   		{
>   			.addr = priv->cfg->i2c_addr,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> @@ -73,7 +73,7 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>   		}, {
>   			.addr = priv->cfg->i2c_addr,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
> index 430fa5163ec7..3aecaf465094 100644
> --- a/drivers/media/tuners/fc2580.c
> +++ b/drivers/media/tuners/fc2580.c
> @@ -49,7 +49,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
>   		{
>   			.addr = priv->cfg->i2c_addr,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> @@ -89,7 +89,7 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
>   		}, {
>   			.addr = priv->cfg->i2c_addr,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
> index b3a4adf9ff8f..abe256e1f843 100644
> --- a/drivers/media/tuners/tda18212.c
> +++ b/drivers/media/tuners/tda18212.c
> @@ -40,7 +40,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
>   		{
>   			.addr = priv->cfg->i2c_address,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = 1 + len,
>   			.buf = buf,
>   		}
>   	};
> @@ -81,7 +81,7 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
>   		}, {
>   			.addr = priv->cfg->i2c_address,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = len,
>   			.buf = buf,
>   		}
>   	};
> diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
> index 7e2b32ee5349..9300e9361e3b 100644
> --- a/drivers/media/tuners/tda18218.c
> +++ b/drivers/media/tuners/tda18218.c
> @@ -83,7 +83,7 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
>   		}, {
>   			.addr = priv->cfg->i2c_address,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = reg + len,
>   			.buf = buf,
>   		}
>   	};
>
>
> Cheers,
> Mauro
>


-- 
http://palosaari.fi/
