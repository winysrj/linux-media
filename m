Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42792 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3KON7Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 08:59:25 -0500
Message-ID: <528628B7.5010808@iki.fi>
Date: Fri, 15 Nov 2013 15:59:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103
 driver
References: <19084.1384522337@warthog.procyon.org.uk> <52861C55.6050307@iki.fi> <20271.1384472102@warthog.procyon.org.uk> <28089.1384515232@warthog.procyon.org.uk> <19278.1384523789@warthog.procyon.org.uk>
In-Reply-To: <19278.1384523789@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.11.2013 15:56, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> I guess I need to check the tuner writes too.
>
>>From dvbsky:
>
> 	TUNER_write(10, [0a])
> 	TUNER_write(11, [40])
>
> and from your driver:
>
> 	TUNER_write(10, [0b40])
>
> That would appear to be some sort of tuner frequency setting?

... and the result is same, reg 10 will be 0a and reg 11 40. It is 
register write using register address auto-increment. The later one is 
I/O optimized.

Antti


-- 
http://palosaari.fi/
