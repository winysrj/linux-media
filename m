Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44450 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKECo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 21:44:27 -0500
Message-ID: <54598F06.1090904@iki.fi>
Date: Wed, 05 Nov 2014 04:44:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2] [media] af0933: Don't go past arrays
References: <24ac978937a28c248cc55a3d3f59a061344ec7d3.1415133273.git.mchehab@osg.samsung.com>
In-Reply-To: <24ac978937a28c248cc55a3d3f59a061344ec7d3.1415133273.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

anyhow, I think these branches could never taken in real life. But as a 
killing warnings and potential future changes I am pretty fine!

regards
Antti

On 11/04/2014 10:35 PM, Mauro Carvalho Chehab wrote:
> Fixes the following sparse warnings:
> 	drivers/media/dvb-frontends/af9033.c:295 af9033_init() error: buffer overflow 'clock_adc_lut' 11 <= 11
> 	drivers/media/dvb-frontends/af9033.c:300 af9033_init() error: buffer overflow 'clock_adc_lut' 11 <= 11
> 	drivers/media/dvb-frontends/af9033.c:584 af9033_set_frontend() error: buffer overflow 'coeff_lut' 3 <= 3
> 	drivers/media/dvb-frontends/af9033.c:595 af9033_set_frontend() error: buffer overflow 'clock_adc_lut' 11 <= 11
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> -
> v2: Only changed the patch subject, as it fixes occurrences on 3
>      different arrays.
>
> diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
> index c17e34fd0fb4..82ce47bdf5dc 100644
> --- a/drivers/media/dvb-frontends/af9033.c
> +++ b/drivers/media/dvb-frontends/af9033.c
> @@ -291,6 +291,12 @@ static int af9033_init(struct dvb_frontend *fe)
>   		if (clock_adc_lut[i].clock == dev->cfg.clock)
>   			break;
>   	}
> +	if (i == ARRAY_SIZE(clock_adc_lut)) {
> +		dev_err(&dev->client->dev,
> +			"Couldn't find ADC config for clock=%d\n",
> +			dev->cfg.clock);
> +		goto err;
> +	}
>
>   	adc_cw = af9033_div(dev, clock_adc_lut[i].adc, 1000000ul, 19ul);
>   	buf[0] = (adc_cw >>  0) & 0xff;
> @@ -580,7 +586,15 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
>   				break;
>   			}
>   		}
> -		ret =  af9033_wr_regs(dev, 0x800001,
> +		if (i == ARRAY_SIZE(coeff_lut)) {
> +			dev_err(&dev->client->dev,
> +				"Couldn't find LUT config for clock=%d\n",
> +				dev->cfg.clock);
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		ret = af9033_wr_regs(dev, 0x800001,
>   				coeff_lut[i].val, sizeof(coeff_lut[i].val));
>   	}
>
> @@ -592,6 +606,13 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
>   			if (clock_adc_lut[i].clock == dev->cfg.clock)
>   				break;
>   		}
> +		if (i == ARRAY_SIZE(clock_adc_lut)) {
> +			dev_err(&dev->client->dev,
> +				"Couldn't find ADC clock for clock=%d\n",
> +				dev->cfg.clock);
> +			ret = -EINVAL;
> +			goto err;
> +		}
>   		adc_freq = clock_adc_lut[i].adc;
>
>   		/* get used IF frequency */
>

-- 
http://palosaari.fi/
