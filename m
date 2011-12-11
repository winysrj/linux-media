Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44253 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1LKPes (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 10:34:48 -0500
Message-ID: <4EE4CD95.2030909@iki.fi>
Date: Sun, 11 Dec 2011 17:34:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] af9013
References: <4ED666E9.2020405@iki.fi> <4EE48D13.7030702@redhat.com>
In-Reply-To: <4EE48D13.7030702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2011 12:59 PM, Mauro Carvalho Chehab wrote:
> On 30-11-2011 15:24, Antti Palosaari wrote:
>> Morjens Mauro,
>>
>> I rewrote whole af9013 demodulator driver in order to decrease I2C
>> load. Please pull that to the next Kernel merge window.
>>
>> Antti
>>
>> The following changes since commit
>> a235af24a74a0fa03ece0a9f5e28a72e4d1e2cad:
>>
>> ce168: remove experimental from Kconfig (2011-11-19 23:07:54 +0200)
>>
>> are available in the git repository at:
>> git://linuxtv.org/anttip/media_tree.git misc
>>
>> Antti Palosaari (1):
>> af9013: rewrite whole driver
>>
>> drivers/media/dvb/dvb-usb/af9015.c | 82 +-
>> drivers/media/dvb/frontends/af9013.c | 1756 ++++++++++++++---------------
>> drivers/media/dvb/frontends/af9013.h | 113 +-
>> drivers/media/dvb/frontends/af9013_priv.h | 93 +-
>> 4 files changed, 1017 insertions(+), 1027 deletions(-)
>>
>
> There was a minor context change here:
>
> @@ -1156,7 +1158,7 @@ static int af9015_af9013_sleep(struct dvb_frontend
> *fe)
> if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> return -EAGAIN;
>
> - ret = priv->init[adap->id](fe);
> + ret = priv->sleep[adap->id](fe);

Correct, that is bug fix for the earlier patch I made. As a result we 
call demod .init() in case we should call .sleep() resulting demod will 
never sleep. I found that very late phase, when af9013 rewrite was 
almost complete. At that time I was too lazy at that point to made 
separate patch for fixing it because I had made so many changes for 
af9015 already.

But if you like, I can rebase whole thing and move that fix as own patch.

> Basically, the current code doesn't have that mutex_lock_interruptible
> logic. It
> may be into the fixes we'll send for 3.2.

Do you mean I should change all mutex_lock_interruptible => mutex_lock 
and send as bugfix to 3.2? Anyway, I asked you to push those 
mutex_lock_interruptible things to 3.3 and I think you haven't send 
those 3.2 so not fixes for 3.2 hopefully.

There is one old mutex_lock_interruptible inside af9015_rw_udev(). It 
have been there many years and it is copied from dvb_usb_generic_rw(). I 
think better to not change it as bugfix.

It is not even clear for me when to use mutex_lock_interruptible or 
mutex_lock. I suspect mutex_lock is cheaper and that's why it should be 
used when possible? I am happy to hear reasons and learn (and too lazy 
to look through docs and codes...).

> However, after this patch, compilation broke:
>
> drivers/media/dvb/dvb-usb/af9015.c: In function ‘af9015_rc_query’:
> drivers/media/dvb/dvb-usb/af9015.c:1089:12: error: ‘struct af9015_state’
> has no member named ‘sleep’
> drivers/media/dvb/dvb-usb/af9015.c:1089:20: error: ‘adap’ undeclared
> (first use in this function)
> drivers/media/dvb/dvb-usb/af9015.c:1089:20: note: each undeclared
> identifier is reported only once for each function it appears in
> drivers/media/dvb/dvb-usb/af9015.c:1089:30: error: ‘fe’ undeclared
> (first use in this function)

Arg, how the I hell I missed af9015.h file from that change-set.

After all, I hope it was not TLDR :) What you think I should made in 
order to fix these issues correctly?

regards
Antti
-- 
http://palosaari.fi/
