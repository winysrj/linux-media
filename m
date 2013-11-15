Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3KOOSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 09:18:03 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <52862797.4070600@iki.fi>
References: <52862797.4070600@iki.fi> <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk> <19084.1384522337@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: dhowells@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 14:17:29 +0000
Message-ID: <2860.1384525049@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> wrote:

> > But you don't give me the option of _not_ setting it.  The dvbsky driver
> > sets it to 0x35 in its init_tab[] - as does yours - and then leaves it
> > alone.
> 
> So what? Do you understand meaning of init tables?

Yes.  You misunderstand what I'm saying.  You unconditionally write cfg->agc
to port 0x33 in m88ds3103_set_frontend() after loading the init tables.  Why
do you need to do that at all if the default is fine?  You don't give me the
option of saying that I want to stick with the default and not change it.

> Just set correct value there and it should be OK.
> +       .agc = 0x99,

Why is 0x99 correct?  The default is 0x35 and the dvbsky driver does not alter
it from that.

Btw, setting it to 0x99 has no obvious effect over leaving it as the default.

> > Whilst that may be so, something clears it between one call to
> > m88ds3103_set_frontend() and the next, so you probably need to
> > unconditionally reload the program init table.
> 
> It is programmed conditionally to avoid I/O.

Obviously.

Nonetheless, register 0x76 seems to change its value between passes through
your code without you touching it inbetween:-/

David
