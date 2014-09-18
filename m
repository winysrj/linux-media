Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39519 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaIRNCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 09:02:04 -0400
Message-ID: <541AD7C7.7060000@iki.fi>
Date: Thu, 18 Sep 2014 16:01:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/8] anysee: convert tda18212 tuner to I2C client
References: <1410055200-32170-1-git-send-email-crope@iki.fi>	<1410055200-32170-3-git-send-email-crope@iki.fi> <20140918093115.4e37c3a7@recife.lan>
In-Reply-To: <20140918093115.4e37c3a7@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/18/2014 03:31 PM, Mauro Carvalho Chehab wrote:
> Em Sun,  7 Sep 2014 04:59:55 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Used tda18212 tuner is implemented as I2C driver. Implement I2C
>> client to anysee and use it for tda18212.

>> +static int anysee_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
>> +		void *platform_data)

>> +
>> +static void anysee_del_i2c_dev(struct dvb_usb_device *d)

>
> Please, instead of adding a function to insert/remove an I2C driver on every
> place, put them into a common place.
>
> I would actually very much prefer if you could reuse the same code that
> are already at the media subsystem (see v4l2_i2c_new_subdev_board &
> friends at drivers/media/v4l2-core/v4l2-common.c), eventually making it
> more generic.
>
> Btw, as we want to use the media controller also for DVB, we'll end
> by needing to use a call similar to v4l2_device_register_subdev().
> So, having this code all on just one place will make easier for us to
> go to this next step.

I am just learning and finding out best practices to use I2C drivers. 
That was one implementation solution and IMHO not so bad even. Sure 
those 2 functions could be replaced some more common at some phase, but 
currently, when there is only few drivers, I don't see need for common 
implementation. Let it happen when best practices are clear. And I 
really wonder why there is no such general implementation provided by 
I2C framework?

If you look how I have improved that in a long ran; 1st implementation 
is in em28xx driver, 2nd test was dd-bridge driver, then this anysee and 
eventually there is af9035 (which is almost same than this anysee).


>> @@ -939,46 +1025,63 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
>>   		 * fails attach old simple PLL. */
>>
>>   		/* attach tuner */
>> -		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
>> -				&anysee_tda18212_config);
>> +		if (state->has_tda18212) {
>> +			struct tda18212_config tda18212_config =
>> +					anysee_tda18212_config;
>>
>> -		if (fe && adap->fe[1]) {
>> -			/* attach tuner for 2nd FE */
>> -			fe = dvb_attach(tda18212_attach, adap->fe[1],
>> -					&d->i2c_adap, &anysee_tda18212_config);
>> -			break;
>> -		} else if (fe) {
>> -			break;
>> -		}
>> -
>> -		/* attach tuner */
>> -		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
>> -				&d->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
>> +			tda18212_config.fe = adap->fe[0];
>> +			ret = anysee_add_i2c_dev(d, "tda18212", 0x60,
>> +					&tda18212_config);
>> +			if (ret)
>> +				goto err;
>> +
>> +			/* copy tuner ops for 2nd FE as tuner is shared */
>> +			if (adap->fe[1]) {
>> +				adap->fe[1]->tuner_priv =
>> +						adap->fe[0]->tuner_priv;
>> +				memcpy(&adap->fe[1]->ops.tuner_ops,
>> +						&adap->fe[0]->ops.tuner_ops,
>> +						sizeof(struct dvb_tuner_ops));
>> +			}
>>
>> -		if (fe && adap->fe[1]) {
>> -			/* attach tuner for 2nd FE */
>> -			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
>> +			return 0;
>> +		} else {
>> +			/* attach tuner */
>> +			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
>>   					(0xc0 >> 1), &d->i2c_adap,
>>   					DVB_PLL_SAMSUNG_DTOS403IH102A);
>
> Please don't use dvb_attach() for those converted modules. The
> dvb_attach() is a very dirty hack that was created as an alternative
> to provide an abstraction similar to the one that the I2C core already
> provides. See how V4L calls the subdev callbacks at
> include/media/v4l2-subdev.h.

You looked it wrong, it is dvb_pll_attach. tda18212 attach is replaced 
here with I2C driver. It is tda18212 which is converted here to I2C 
driver, whilst dvb-pll leaves old.

>
> One of the big disadvantages of the dvb_attach() is that it allows just
> _one_ entry point function on a sub-device. This only works for very
> simple demods that don't provide, for example, hardware filtering.
>
>> +
>> +			if (fe && adap->fe[1]) {
>> +				/* attach tuner for 2nd FE */
>> +				fe = dvb_attach(dvb_pll_attach, adap->fe[1],
>> +						(0xc0 >> 1), &d->i2c_adap,
>> +						DVB_PLL_SAMSUNG_DTOS403IH102A);
>> +			}

That patch has nothing wrong as I explained :)
It could be improved by implementing general I2C sub-driver loading 
functions, but these driver specific implementations are just fine until 
more common solution is developed.

regards
Antti

-- 
http://palosaari.fi/
