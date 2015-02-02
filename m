Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38349 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965024AbbBBVNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 16:13:40 -0500
Message-ID: <54CFE87F.4030800@iki.fi>
Date: Mon, 02 Feb 2015 23:13:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Mark Brown <broonie@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
References: <1419367799-14263-1-git-send-email-crope@iki.fi>	<1419367799-14263-21-git-send-email-crope@iki.fi>	<20150202180726.454dc878@recife.lan> <20150202215623.5e289f24@endymion.delvare>
In-Reply-To: <20150202215623.5e289f24@endymion.delvare>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2015 10:56 PM, Jean Delvare wrote:
> Hi Mauro, Antti,
>
> On Mon, 2 Feb 2015 18:07:26 -0200, Mauro Carvalho Chehab wrote:
>> Em Tue, 23 Dec 2014 22:49:14 +0200
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> Own I2C locking is needed due to two special reasons:
>>> 1) Chips uses multiple register pages/banks on single I2C slave.
>>> Page is changed via I2C register access.
>
> This is no good reason to implement your own i2c bus locking. Lots of
> i2c slave device work that way, and the way to handle it is through a
> dedicated lock at the i2c slave device level. This is in addition to
> the standard i2c bus locking and not a replacement.

Patch description is bit misleading as it does not implement own I2C bus 
lock but own 'I2C lock' is there to warrant none will interrupt I/O 
operation as it needs multiple I2C calls.

*** take own I2C lock here
1) I2C mux read to read current register page
2) I2C mux write to switch register page (if needed)
3) I2C mux write to change mux (open gate/repeater for I2C bus tuner is)
4) perform tuner I2C access
*** release own I2C lock here

Mux is closed automatically after tuner I2C in that case, but very often 
there is I2C commands needed for that too.


>>> 2) Chip offers muxed/gated I2C adapter for tuner. Gate/mux is
>>> controlled by I2C register access.
>
> This, OTOH, is a valid reason for calling __i2c_transfer, and as a
> matter of fact a number of dvb frontend drivers already do so.
>
>>> Due to these reasons, I2C locking did not fit very well.
>>
>> I don't like the idea of calling __i2c_transfer() without calling first
>> i2c_lock_adapter(). This can be dangerous, as the I2C core itself uses
>> the lock for its own usage.
>
> I think the idea is that the i2c bus lock is already held at the time
> the muxing code is called. This happens each time the I2C muxing chip
> is an I2C chip itself.
>
>> Ok, this may eventually work ok for now, but a further change at the I2C
>> core could easily break it. So, we need to double check about such
>> patch with the I2C maintainer.
>
> If it breaks than it'll break a dozen drivers which are already doing
> that, not just this one. But it's OK, I don't see this happening soon.
>
>> Jean,
>>
>> Are you ok with such patch? If so, please ack.
>
> First of all: I am no longer the maintainer of the I2C subsystem. That
> being said...
>
> The changes look OK to me. I think it's how they are presented which
> make them look suspect. As I understand it, the extra locking at device
> level is unrelated with calling unlocked i2c transfer functions. The
> former change is to address the multi-page/bank register mapping, while
> the latter is to solve the deadlock due to the i2c bus topology and
> i2c-based muxing. If I am correct then it would be clearer to make that
> two separate patches with better descriptions.
>
> And if I'm wrong then the patch needs a better description too ;-)
>

regards
Antti

-- 
http://palosaari.fi/
