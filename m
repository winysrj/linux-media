Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3KOOZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 09:25:53 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <528628B7.5010808@iki.fi>
References: <528628B7.5010808@iki.fi> <19084.1384522337@warthog.procyon.org.uk> <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk> <19278.1384523789@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: dhowells@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 14:25:24 +0000
Message-ID: <2943.1384525524@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> wrote:

> >> I guess I need to check the tuner writes too.
> >
> >>From dvbsky:
> >
> > 	TUNER_write(10, [0a])
> > 	TUNER_write(11, [40])
> >
> > and from your driver:
> >
> > 	TUNER_write(10, [0b40])
> >
> > That would appear to be some sort of tuner frequency setting?
> 
> ... and the result is same, reg 10 will be 0a and reg 11 40. It is register
> write using register address auto-increment. The later one is I/O optimized.

Yes, I understand that.  However, reg 10 is set to 0a in one driver and 0b in
the other.

David
