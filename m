Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:42173 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab0JNIdS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 04:33:18 -0400
Message-ID: <4CB6C049.70907@iki.fi>
Date: Thu, 14 Oct 2010 11:33:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitri Belimov <d.belimov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC] Resource reservation for frontend - Was: Re: xc5000 and
 switch RF input
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>	<20100525114939.067404eb@glory.loctelecom.ru>	<4C32044C.3060007@redhat.com>	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com> <20101006155256.11ec6d6d@glory.local> <4CAC6E45.5030005@redhat.com>
In-Reply-To: <4CAC6E45.5030005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/06/2010 03:40 PM, Mauro Carvalho Chehab wrote:
> So, we really need to implement some type of resource locking that will properly setup I2C gates,
> RF gates, etc, depending on the type of resource currently in use.
>
> Basically, the idea would be to implement something like:
>
> enum frontend_resource {
> 	ANALOG_TV_TUNER,
> 	DIGITAL_TV_TUNER,
> 	FM_TUNER,
> 	ANALOG_DEMOD,
> 	DIGITAL_DEMOD,
> };

I haven't examined this yet enough, but for the background information I 
can say I have one device which needs this. There is tuner behind 
demodulator, but instead of normal I2C-gate switch, it is rather much 
likely repeater. All tuner commands are send to the demod which then 
writes those to the tuner.

DD = demod I2C addr
TT = tuner I2C addr
Bn = payload data

traditional I2C send to the tuner:
TT >> B0 B1 B2 ...

demod as repeater send to the tuner:
DD >> TT B0 B1 B2 ...

Antti
-- 
http://palosaari.fi/
