Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0JGA2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 20:28:31 -0400
Message-ID: <4CAD1424.4000403@redhat.com>
Date: Wed, 06 Oct 2010 21:28:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC] Resource reservation for frontend - Was: Re: xc5000 and
 switch RF input
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>	<20100525114939.067404eb@glory.loctelecom.ru>	<4C32044C.3060007@redhat.com>	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>	<20101006155256.11ec6d6d@glory.local>	<4CAC6E45.5030005@redhat.com> <20101007090058.3fe0043a@glory.local>
In-Reply-To: <20101007090058.3fe0043a@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-10-2010 10:00, Dmitri Belimov escreveu:
> Hi
> 
>> Em 06-10-2010 16:52, Dmitri Belimov escreveu:
>>> Hi
>>>
>>> Our TV card Behold X7 has two different RF input. This RF inputs
>>> can switch between different RF sources. 
>>>
>>> ANT 1 for analog and digital TV
>>> ANT 2 for FM radio
>>>
>>> The switch controlled by zl10353.
>>>
>>> How to I can control this switch?
>>>
>>> I found 2 way
>>>
>>> 1. 
>>> Use tuner callback to saa1734. add some params like
>>> XC5000_TUNER_SET/XC5000_TUNER_SET_TV to the xc5000.h call tuner
>>> callback from xc5000_set_analog_params with new params about
>>> switching. In this case inside saa7134 need know about zl10353 and
>>> configuration. I don't understand how to do. The structure
>>> saa7134_dev hasn't pointer to the structure dvb_frontend. Or use
>>> hardcoded i2c_addr and params.
>>>
>>> 2.
>>> Direct call switch the switcher from the tuner code. In this case
>>> need know TV card type. I think it is not so good idea.
>>
>> The issues between FM and TV mode is only a small part of a big
>> problem that we're currently facing: drivers that support multiple
>> types of streams, like radio, analog TV and digital TV need a way to
>> avoid conflicts between different parts of the driver, and between a
>> DVB and a V4L call.
>>
>> The long-term solution seems to implement a tuner/frontend resource
>> reservation routine. This will solve other problems as well, like
>> having both analog and digital parts of the driver trying to access
>> the same resource at the same time.
>>
>> While implementing both analog and ISDB-T support for a saa7134-based
>> board, I got one issue where analog tuner were trying to do RF
>> callibration while the DVB demod were initialized. As the access to
>> the demod requires one I2C gate setup and the access to the tuner
>> requires another setup, both operations failed.
>>
>> We had similar problems in em28xx and cx231xx. Both were partially
>> solved with a lock, but still if the user tries to open both DVB and
>> V4L interfaces, it will likely have problems.
>>
>> So, we really need to implement some type of resource locking that
>> will properly setup I2C gates, RF gates, etc, depending on the type
>> of resource currently in use.
>>
>> Basically, the idea would be to implement something like:
>>
>> enum frontend_resource {
>> 	ANALOG_TV_TUNER,
>> 	DIGITAL_TV_TUNER,
>> 	FM_TUNER,
>> 	ANALOG_DEMOD,
>> 	DIGITAL_DEMOD,
>> };
>>
>> And add a new callback at struct dvb_frontend_ops():
>>
>> 	int (*set_resource)(struct dvb_frontend* fe, enum
>> frontend_resource, bool reserve);
>>
>> Those callbacks may replace i2c_gate_ctrl().
>>
>> With those changes, when a driver needs to access, for example, a
>> tuner at a dvb part of the driver, it would do:
>>
>> fe->ops.set_resource(fe, DIGITAL_TV_TUNER, true);
>> /* All i2c transactions and other operations needed at tuner */
>> fe->ops.set_resource(fe, DIGITAL_TV_TUNER, false);
>>
>> In other words, it will basically replace the current occurrences of
>> i2c_gate_ctrl(), providing a clearer indication that the I2C change
>> needed are to enable the access to the tuner.
>>
>> The fun begins if other parts of the driver try to do different
>> things on resources that may be shared. They can now say that they
>> want to access the demod with:
>>
>> fe->ops.set_resource(fe, DIGITAL_DEMOD, true);
>>
>> So, demods operations will be protected by:
>>
>> fe->ops.set_resource(fe, DIGITAL_DEMOD, true);
>> 	/* All i2c transactions and other operations applied on demod
>> */ fe->ops.set_resource(fe, DIGITAL_DEMOD, false);
>>
>> It is up to driver callback to handle this call. If both
>> DIGITAL_DEMOD and DIGITAL_TV_TUNER are at the same i2c bus (e.g.
>> there's no i2c gate), and if there's no risk for one I2C access to
>> affect the other, the callback can just return 0. Otherwise, it may
>> return -EBUSY and let the caller wait for the resource to be freed
>> with: wake_up(fe->ops.set_resource(fe, DIGITAL_DEMOD, true) == 0); or
>> 	wake_up_interruptible(fe->ops.set_resource(fe, DIGITAL_DEMOD,
>> true) == 0);
>>
>> This way, when the resource is freed, the digital demod logic may
>> happen.
>>
>> Comments?
> 
> What about hardware encoders? May be need switch between some TV and encoders.
> Switch input source, output bus and other.

Yeah, we may need to add encoders here, and other stuff like IR and CA modules.

an approach like that is easy to extend, as new issues that may require
resource reservation is added. 

Cheers,
Mauro
