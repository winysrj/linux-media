Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3KOOB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 09:01:58 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19278.1384523789@warthog.procyon.org.uk>
References: <19278.1384523789@warthog.procyon.org.uk> <19084.1384522337@warthog.procyon.org.uk> <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: dhowells@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 14:01:19 +0000
Message-ID: <27277.1384524079@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> > I guess I need to check the tuner writes too.
> 
> From dvbsky:
> 
> 	TUNER_write(10, [0a])
> 	TUNER_write(11, [40])
> 
> and from your driver:
> 
> 	TUNER_write(10, [0b40])
> 
> That would appear to be some sort of tuner frequency setting?

Setting it to 0x0a in the driver doesn't seem to help.

David
