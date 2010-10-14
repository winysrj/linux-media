Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53389 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JNIlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 04:41:47 -0400
Received: by ewy20 with SMTP id 20so3062344ewy.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 01:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB6C049.70907@iki.fi>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
	<20100525114939.067404eb@glory.loctelecom.ru>
	<4C32044C.3060007@redhat.com>
	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
	<20101006155256.11ec6d6d@glory.local>
	<4CAC6E45.5030005@redhat.com>
	<4CB6C049.70907@iki.fi>
Date: Thu, 14 Oct 2010 04:41:45 -0400
Message-ID: <AANLkTikz+eczKDwo4-1H-QFXsg0dzRcbsdgwb=XL0cXH@mail.gmail.com>
Subject: Re: [RFC] Resource reservation for frontend - Was: Re: xc5000 and
 switch RF input
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 14, 2010 at 4:33 AM, Antti Palosaari <crope@iki.fi> wrote:
> I haven't examined this yet enough, but for the background information I can
> say I have one device which needs this. There is tuner behind demodulator,
> but instead of normal I2C-gate switch, it is rather much likely repeater.
> All tuner commands are send to the demod which then writes those to the
> tuner.
>
> DD = demod I2C addr
> TT = tuner I2C addr
> Bn = payload data
>
> traditional I2C send to the tuner:
> TT >> B0 B1 B2 ...
>
> demod as repeater send to the tuner:
> DD >> TT B0 B1 B2 ...

You can accomplish this by having the demod create an i2c adapter
instance, which generates i2c commands to the bridge.  Then when
instantiating the tuner subdev, pass a pointer to the demod's i2c
adapter instead of the i2c adapter provided by the bridge.

No changes required to the core framework.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
