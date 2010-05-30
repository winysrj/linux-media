Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56343 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab0E3AW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 20:22:26 -0400
Received: by gwaa12 with SMTP id a12so1907066gwa.19
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 17:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C013BBF.3080509@gmx.de>
References: <1274349174-3961-1-git-send-email-npajkovs@redhat.com>
	<4C000A96.3010308@iki.fi>
	<AANLkTinFIakra2JzIiI74qEZBO_D2bqgp8T55R_Df9rc@mail.gmail.com>
	<4C013BBF.3080509@gmx.de>
Date: Sun, 30 May 2010 08:22:25 +0800
Message-ID: <AANLkTil20ry1QgNxRz7SDrb7sQvSbtSaulCMaK2TAT3u@mail.gmail.com>
Subject: Re: Fwd: [PATCH] V4L/DVB: New NXP tda18218 tuner
From: Bee Hock Goh <beehock@gmail.com>
To: Lauris Ding <lding@gmx.de>, LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lauris,

thanks for the reply. I am just a user. :)

As you are the original driver developer, it would great if you could
endorsed/ack the patch sent by Nikola.

thanks,
 Hock.

On Sun, May 30, 2010 at 12:07 AM, Lauris Ding <lding@gmx.de> wrote:
> On 29.05.2010 11:39, Bee Hock Goh wrote:
>>
>> Dear Lauris,
>>
>> Are you still active? Nikola have submitted a patch for af9015/tda18218.
>>
>> Could you maybe spend some time to help and endorsed it?
>>
>> thanks,
>>  Hock.
>>
>>
>> ---------- Forwarded message ----------
>> From: Antti Palosaari<crope@iki.fi>
>> Date: Sat, May 29, 2010 at 2:25 AM
>> Subject: Re: [PATCH] V4L/DVB: New NXP tda18218 tuner
>> To: Nikola Pajkovsky<npajkovs@redhat.com>
>> Cc: linux-media@vger.kernel.org
>>
>>
>> Terve,
>>
>> On 05/20/2010 12:52 PM, Nikola Pajkovsky wrote:
>>
>>>
>>> Signed-off-by: Nikola Pajkovsky<npajkovs@redhat.com>
>>> ---
>>>  drivers/media/common/tuners/Kconfig         |    7 +
>>>  drivers/media/common/tuners/Makefile        |    1 +
>>>  drivers/media/common/tuners/tda18218.c      |  432
>>> +++++++++++++++++++++++++++
>>>  drivers/media/common/tuners/tda18218.h      |   44 +++
>>>  drivers/media/common/tuners/tda18218_priv.h |   36 +++
>>>  drivers/media/dvb/dvb-usb/af9015.c          |   13 +-
>>>  drivers/media/dvb/frontends/af9013.c        |   15 +
>>>  drivers/media/dvb/frontends/af9013_priv.h   |    5 +-
>>>  8 files changed, 548 insertions(+), 5 deletions(-)
>>>  create mode 100644 drivers/media/common/tuners/tda18218.c
>>>  create mode 100644 drivers/media/common/tuners/tda18218.h
>>>  create mode 100644 drivers/media/common/tuners/tda18218_priv.h
>>>
>>
>> tda18218_write_reg() could use tda18218_write_regs()
>>
>> tda18218_set_params() correct frequency limits. No need to check both
>> upper and lower limit.
>>
>> printk(KERN_INFO "We've got a lock!");
>> it does not sounds good idea to print INFO when lock
>>
>> while(i<  10) {
>> use for loop insted. Two rows less code.
>>
>> tda18218_init()
>> why return -EREMOTEIO; ?
>>
>> tda18218_attach()
>> printk(KERN_WARNING "Device is not a TDA18218!\n");
>> we should fail without noise since many times tuner attach is used for
>> probe correct tuner
>>
>> A lot of error checkings are missing when reg write / read
>>
>> checkpatch returns a lot of warnings and for errors too almost every
>> file changed
>>
>> Is that checked TDA18218 uses same demod settings as TDA18271?
>>
>> And the biggest problem is that driver author Lauris haven't replied
>> any mails...
>>
>> regards
>> Antti
>>
>>
>> --
>> http://palosaari.fi/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> Hi,
>
> well, I've stopped doing anything on it after I finally got it working, as
> it was enough for me having it just working, more or less regardless of what
> the code looked like.
>
> I very much appreciate your work on it, but I'm quite unexperienced in
> kernel programming; I'll try to help whenever I can from now on, though.
>
> Regards, Lauris
>
