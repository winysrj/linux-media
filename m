Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3KONcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 08:32:53 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <52861C55.6050307@iki.fi>
References: <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: dhowells@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 13:32:17 +0000
Message-ID: <19084.1384522337@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> wrote:

> > demod_write(33, [00])				YES
> 
> That is config option already. Did you set value? If yes, then there is driver
> bug. If not, then add value.

But you don't give me the option of _not_ setting it.  The dvbsky driver sets
it to 0x35 in its init_tab[] - as does yours - and then leaves it alone.

> > 			demod_write(76, [38])	YES
> 
> on init table

Whilst that may be so, something clears it between one call to
m88ds3103_set_frontend() and the next, so you probably need to unconditionally
reload the program init table.

> So hard code those bugs, if you already didn't, 0x33=0x99, 0x56=0x00,
> 0xfd=0x46 and make test. Do that same to find out all buggy registers until it
> performs as it should.

I've made my version of your driver now set up the demod regs as per the
dvbsky driver for:

	S 11919000 V 27500000 3/4

but:

	./scan-s2/scan-s2 -a1 ./e.1 >/tmp/s -O S9.0E -D S2

still doesn't work for your driver, despite two goes at tuning.  I guess I
need to check the tuner writes too.

David
