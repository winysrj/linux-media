Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46989 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab1JCMvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Oct 2011 08:51:01 -0400
Message-ID: <4E89AFB1.9030707@iki.fi>
Date: Mon, 03 Oct 2011 15:50:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: =?UTF-8?B?SXN0dsOhbiBWw6FyYWRp?= <ivaradi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>	<4E485F81.9020700@iki.fi>	<4E48FF99.7030006@iki.fi>	<4E4C2784.2020003@iki.fi>	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>	<4E5BA751.6090709@iki.fi> <CAAMvbhFayrVYNiT8GxQfEJi4D7KG-MCr4wM3+DKC2kc4ZOp7ZA@mail.gmail.com>
In-Reply-To: <CAAMvbhFayrVYNiT8GxQfEJi4D7KG-MCr4wM3+DKC2kc4ZOp7ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2011 03:36 PM, James Courtier-Dutton wrote:
> 2011/8/29 Antti Palosaari<crope@iki.fi>:
>> Only De facto serial smartcard protocol is so called Phoenix/Smartmouse,
>> implementing new protocol is totally dead idea. It will never got any
>> support.
>>
>> There is already such drivers, at least Infinity Unlimited USB Phoenix
>> driver (iuu_phoenix.c). It uses USB-serial driver framework and some small
>> emulation for Phoenix protocol. Look that driver to see which kind of
>> complexity it adds. Anysee have *just* same situation.
>>
> I helped write the iuu_phoenix.c driver.
> With regards to "The character device supports two ioctl's (see
> anysee_sc), one for
> detecting the presence of a card, the other one for resetting the card
> and querying the ATR."
> The iuu_phoenix.c driver uses standard phoenix/smartmouse reset and
> atr controls. (i.e. with DCD, DTR, RTS, CTS lines etc)
> As the result the iuu_phoenix.c driver works out of the box with oscam.
> It might be a good idea to use a similar interface for your driver.
> The result would be that your driver would work out of the box with
> oscam as well as other user space programs that read smart cards.
> The problem would be if you wished to support smart card program
> capabilities, the Phoenix/Smartmouse interface does not support that.
> If I add programmer functionallity to the iuu_phoenix driver, I would
> probably add an IOCTL for it.

Thank you for the feedback. I already did that. See latest tree:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/anysee

Adding IOCTLs and making new userspace IFD was István idea / propose.

Interface is now de facto standard Phoenix. Unfortunately it is not very 
compatible yet. I used oscam as client during development mainly since 
as a open source it was easy to look and add debugs to see what kind of 
protocol is. Unfortunately I did mistake and removed accidentally my 
original tree and was forced to rewrite it. At that point oscam stopped 
working, but it is surely small bug. I suspect .set_termios() or 
.tiocmget() or .tiocmset().

Currently device name and location are under the discussion. Mainly, 
should that device be under /dev/tty* as other character devices or 
under /dev/dvb/adapterN/ as a property of DVB card.

regards
Antti
-- 
http://palosaari.fi/
