Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:51766 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab0JOPeC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 11:34:02 -0400
Message-ID: <4CB87464.5010209@iki.fi>
Date: Fri, 15 Oct 2010 18:33:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC] Resource reservation for frontend - Was: Re: xc5000 and
 switch RF input
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>	<20100525114939.067404eb@glory.loctelecom.ru>	<4C32044C.3060007@redhat.com>	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>	<20101006155256.11ec6d6d@glory.local>	<4CAC6E45.5030005@redhat.com>	<4CB6C049.70907@iki.fi> <AANLkTikz+eczKDwo4-1H-QFXsg0dzRcbsdgwb=XL0cXH@mail.gmail.com>
In-Reply-To: <AANLkTikz+eczKDwo4-1H-QFXsg0dzRcbsdgwb=XL0cXH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/14/2010 11:41 AM, Devin Heitmueller wrote:
> On Thu, Oct 14, 2010 at 4:33 AM, Antti Palosaari<crope@iki.fi>  wrote:
>> I haven't examined this yet enough, but for the background information I can
>> say I have one device which needs this. There is tuner behind demodulator,
>> but instead of normal I2C-gate switch, it is rather much likely repeater.
>> All tuner commands are send to the demod which then writes those to the
>> tuner.
>>
>> DD = demod I2C addr
>> TT = tuner I2C addr
>> Bn = payload data
>>
>> traditional I2C send to the tuner:
>> TT>>  B0 B1 B2 ...
>>
>> demod as repeater send to the tuner:
>> DD>>  TT B0 B1 B2 ...
>
> You can accomplish this by having the demod create an i2c adapter
> instance, which generates i2c commands to the bridge.  Then when
> instantiating the tuner subdev, pass a pointer to the demod's i2c
> adapter instead of the i2c adapter provided by the bridge.
>
> No changes required to the core framework.

Thank you Devin. I didn't realized that earlier. It worked just fine.

Antti
-- 
http://palosaari.fi/
