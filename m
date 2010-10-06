Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab0JFM0D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 08:26:03 -0400
Message-ID: <4CAC6AD2.6050600@redhat.com>
Date: Wed, 06 Oct 2010 09:25:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: xc5000 and switch RF input
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>	<20100525114939.067404eb@glory.loctelecom.ru>	<4C32044C.3060007@redhat.com>	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com> <20101006155256.11ec6d6d@glory.local>
In-Reply-To: <20101006155256.11ec6d6d@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-10-2010 16:52, Dmitri Belimov escreveu:
> Hi
> 
> Our TV card Behold X7 has two different RF input. This RF inputs can switch between
> different RF sources. 
> 
> ANT 1 for analog and digital TV
> ANT 2 for FM radio
> 
> The switch controlled by zl10353.
> 
> How to I can control this switch?
> 
> I found 2 way
> 
> 1. 
> Use tuner callback to saa1734. add some params like XC5000_TUNER_SET/XC5000_TUNER_SET_TV to the xc5000.h
> call tuner callback from xc5000_set_analog_params with new params about switching.
> In this case inside saa7134 need know about zl10353 and configuration. I don't understand how to do.
> The structure saa7134_dev hasn't pointer to the structure dvb_frontend. 
> Or use hardcoded i2c_addr and params.
> 
> 2.
> Direct call switch the switcher from the tuner code. In this case need know TV card type. I think it is not so good idea.


Alternative 2 is not a good idea.

There's another alternative: just call some code at saa7134-video, when changing from TV or from video, 
for example, at s_freq. It may be hard to track when this happens, as the user may be using a program 
like kradio, that may keep the device open even while not using it.

This problem looks like one I'm currently having where both DVB and analog parts are trying to access
tda18271 tuner and mb86a20s demod at the same time. The same problem also happened on em28xx and cx231xx.
The solution there were to (ab)use of the device lock, but it is not perfect.

There's a better alternative that requires adding more glue at frontend.

I'll post soon an email with a proposal for that. It would also solve other problems that we're currently
experiencing.

Cheers,
Mauro
