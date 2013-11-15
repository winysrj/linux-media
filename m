Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33020 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab3KONGj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 08:06:39 -0500
Message-ID: <52861C55.6050307@iki.fi>
Date: Fri, 15 Nov 2013 15:06:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103
 driver
References: <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk>
In-Reply-To: <28089.1384515232@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.11.2013 13:33, David Howells wrote:
> I think I've isolated the significant part of the demod register setup.
> Discarding the reads and sorting them in address order, I see
>
> ANTTI			DVBSKY			DIFFER?
> =======================	=======================	=======
> demod_write(22, [ac])	demod_write(22, [ac])	no
> demod_write(24, [5c])	demod_write(24, [5c])	no
> 			demod_write(25, [8a])	YES
seems to be on init table

> demod_write(29, [80])	demod_write(29, [80])	no
> demod_write(30, [08])	demod_write(30, [08])	no
> demod_write(33, [00])				YES

That is config option already. Did you set value? If yes, then there is 
driver bug. If not, then add value.

> demod_write(4d, [91])	demod_write(4d, [91])	no
> 			demod_write(56, [00])	YES

driver bug

> demod_write(61, [5549])	demod_write(61, [55])	no
> 	"	"	demod_write(62, [49])	no
> 			demod_write(76, [38])	YES

on init table

> demod_write(c3, [08])	demod_write(c3, [08])	no
> demod_write(c4, [08])	demod_write(c4, [08])	no
> demod_write(c7, [00])	demod_write(c7, [00])	no
> demod_write(c8, [06])	demod_write(c8, [06])	no
> demod_write(ea, [ff])	demod_write(ea, [ff])	no
> demod_write(fd, [46])	demod_write(fd, [06])	YES

driver bug

> demod_write(fe, [6f])	demod_write(fe, [6f])	no

Two clear driver bugs, 1 case unclear and the rest should be programmed 
earlier.

So hard code those bugs, if you already didn't, 0x33=0x99, 0x56=0x00, 
0xfd=0x46 and make test. Do that same to find out all buggy registers 
until it performs as it should.

regards
Antti

-- 
http://palosaari.fi/
