Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46295 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3KONyh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 08:54:37 -0500
Message-ID: <52862797.4070600@iki.fi>
Date: Fri, 15 Nov 2013 15:54:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103
 driver
References: <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk> <19084.1384522337@warthog.procyon.org.uk>
In-Reply-To: <19084.1384522337@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.11.2013 15:32, David Howells wrote:
> Antti Palosaari <crope@iki.fi> wrote:
>
>>> demod_write(33, [00])				YES
>>
>> That is config option already. Did you set value? If yes, then there is driver
>> bug. If not, then add value.
>
> But you don't give me the option of _not_ setting it.  The dvbsky driver sets
> it to 0x35 in its init_tab[] - as does yours - and then leaves it alone.

So what? Do you understand meaning of init tables? If you look those 
demod drivers about everyone has init tables and it is used just to set 
some reasonable default values to registers. After that you could change 
those or leave as is, it is just driver logic.

Just set correct value there and it should be OK.
+       .agc = 0x99,


>
>>> 			demod_write(76, [38])	YES
>>
>> on init table
>
> Whilst that may be so, something clears it between one call to
> m88ds3103_set_frontend() and the next, so you probably need to unconditionally
> reload the program init table.

It is programmed conditionally to avoid I/O. Loading logic is simply and 
relies to S/S2/sleep mode change. If there is bug then it should be 
fixed, but I suspect it is just OK as my device is working. If that 
logic is broken then result is likely very dramatic - you will be able 
to view only DVB-S or DVB-S2 channels.

>
>> So hard code those bugs, if you already didn't, 0x33=0x99, 0x56=0x00,
>> 0xfd=0x46 and make test. Do that same to find out all buggy registers until it
>> performs as it should.
>
> I've made my version of your driver now set up the demod regs as per the
> dvbsky driver for:
>
> 	S 11919000 V 27500000 3/4
>
> but:
>
> 	./scan-s2/scan-s2 -a1 ./e.1 >/tmp/s -O S9.0E -D S2
>
> still doesn't work for your driver, despite two goes at tuning.  I guess I
> need to check the tuner writes too.

These bugs sounds more like a demod bugs.


Have you tried simple tune using szap/s2-szap to single channel? Don't 
try scan before it works for single S and S2 channel using zap.

Antti

-- 
http://palosaari.fi/
