Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:38931 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3AHRij (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 12:38:39 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so777561lab.29
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 09:38:37 -0800 (PST)
Message-ID: <50EC59BA.1040809@googlemail.com>
Date: Tue, 08 Jan 2013 18:39:06 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] ir-kbd-i2c: fix get_key_knc1()
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com> <1356649368-5426-7-git-send-email-fschaefer.oss@googlemail.com> <20130105003950.5463ee70@redhat.com> <50E82B6E.3090609@googlemail.com> <20130105132548.7ad6d0aa@redhat.com> <50E9DF5F.8070802@googlemail.com> <20130107144035.34700518@redhat.com>
In-Reply-To: <20130107144035.34700518@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 07.01.2013 17:40, schrieb Mauro Carvalho Chehab:
>>> Also, this was widely discussed several years ago, when we decided to cleanup
>>> the I2C code. We then invested lot of efforts to move those get_keys away
>>> from ir-i2c-kbd. The only things left there are the ones we identified that
>>> were needed by auto-detection mode on old devices that we don't have.
>>>
>>> What was decided is to move everything that we know to the *-input driver,
>>> keeping there only the legacy stuff.
>> Uhm... ok.
>> My assumption was, that the goal is the opposite (move as much common
>> code as possible to i2c-ir-kbd).
>> I'm a bit puzzled about this decision...
>>
>> Okay.... but then... why do we still use ir-kbd-i2c in em28xx ?
>> We can easily get rid of it. Everything we need is already on board.
>>
>> I can send a patch if you want.
> No. We don't want to mix I2C client code inside the I2C bus drivers.

Well, you can't have both at the same time. :D
Either do it in a separate module (ir-kbd-i2c) or in the em28xx driver !? ;)

> If we had started to code it right now, we would likely have used a
> different approach for those I2C IR's, but it is not valuable enough
> to change it right now, as it works, and there's nothing new happening
> here.
>
> The RC trend is to not use hardware decoding anymore, as this doesn't
> follow Microsoft's MCE architecture. All newer chipsets I'm aware of
> just sends a sequence of pulse/space duration, and let the kernel to
> decode. Empia seems to be late on following this market trend. Even so,
> I don't see any new board design with an IR I2C hardware for years.

True, but doesn't change the fact that the current code can be improved.
I think it's valuable enough, as we can get rid of a module dependency here.

> So, the better is to just not re-engineer the things that are working,
> in order to avoid breaking them.

Yeah, we  should _always_  be careful.
But it's definitely not re-engineering. The key polling and decoding
functions are already there.
The main change is, that em28xx-input would call them itself instead of
ir-kbd-i2c, which is what it already does with the built-in decoders.
For maximum safety, we can use the same key handling function as ir-kbd-i2c.
If we don't do it now (yet we have devices for testing), it will likely
never happen.


>
>>> In any case, I don't see any need for patches 4/6 or 6/6.
>>>
>>>> The second thing is the small fix for the key code debug output. Don't
>>>> you think it makes sense ?
>>> Now that we have "ir-keycode -t", all those key/scancode printk's inside
>>> the driver are pretty much useless, as both are reported as events.
>>>
>>> In the past, when most of the RC code were written, those prints were
>> Then we should remove them.
> That makes sense on my eyes. 
>
> Yet, writing/reviewing such cleanup patches would have a very low priority. 
> Btw, all drivers have a lot of printk's message from the time they were 
> written that can be cleaned up, especially nowadays, as several of those 
> printk's can be replaced by Kernel tracing facilities.
>
> If one is willing to do it, I expect that it would be reviewing all
> of them and not just those ones.
Sure.

Regards,
Frank

