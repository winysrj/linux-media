Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40489 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765173Ab3DJBxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 21:53:42 -0400
Message-ID: <5164C5FE.709@iki.fi>
Date: Wed, 10 Apr 2013 04:53:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 1/5] mxl5007t: fix buggy register read
References: <1365551600-3394-1-git-send-email-crope@iki.fi> <1365551600-3394-2-git-send-email-crope@iki.fi> <CAGoCfiw_pyh5MchkU59Y9NJz+Rgf5B7Gvd92A1pF+e18DVWgKQ@mail.gmail.com> <5164B611.2060500@iki.fi> <CAGoCfix+GByPDoAQhPBQqzD3_s30+wbE9F-kACtZc6rTD94YBg@mail.gmail.com>
In-Reply-To: <CAGoCfix+GByPDoAQhPBQqzD3_s30+wbE9F-kACtZc6rTD94YBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2013 04:38 AM, Devin Heitmueller wrote:
> On Tue, Apr 9, 2013 at 8:45 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Yes, most devices do that, but not all!
>> MxL5007t has a special register for setting register to read. Look the code
>> and you could see it easily. It was over year ago I fixed it...
>
> That sounds kind of insane, but I haven't looked at the datasheets and
> if Mike Ack'd it, then so be it.
>
>>> Further, it *should* be done in a single call to i2c_transfer() or
>>> else you won't hold the lock and you will create a race condition.
>>
>>
>> No. That's why I added new lock. Single i2c_transfer() means all messages
>> are done using repeated START condition.
>
> No need to add a new lock to your bridge driver.  You can just use
> __i2c_transfer() and i2c_lock_adapter(state->i2c).  That's what
> they're doing in the drx-k driver for just such cases where they need
> the lock to span multiple calls to i2c_transfer().

Thanks for the tip. It could be cleaner way to do it like that and 
likely I will change it after quick check.

I don't need to lock whole adapter, only unsure there is none changing 
"register to read" value (stored to special register) before I read it. 
So I have to ensure I could do normal writes without a unneeded waiting 
- even those happens just between that two phase read.

>>> This sounds more like it's a bug in the i2c master rather than the 5007
>>> driver.
>>
>>
>> No.
>>
>>
>>> Do you have i2c bus traces that clearly show that this was the cause
>>> of the issue?  If we need to define something as "broken" behavior, at
>>> first glance it looks like the way *you're* proposing is the broken
>>> behavior - presumably to work around a bug in the i2c master not
>>> properly supporting repeated start.
>>
>>
>> Yes and no. I made own Cypress FX2 firmware and saw initially that issue
>> then. Also, as you could see looking the following patches I ensured /
>> confirmed issue using two different I2C adapters (AF9015 and AF9035). So I
>> have totally 3 working adapters to prove it (which are broken without that
>> patch)!
>
> The whole think sounds screwed up, and without a real i2c trace of the
> bus we'll never know.  That said, I'm not really in a position to
> dispute it given I don't have any devices with the chip in question.
>
> I would suggest renaming the configuration value to something less
> controversial, such as "use_repeated_start_for_reads" and avoid using
> terms like broken where it's not clear that's actually the case.

It is 100% clearly broken :-] And MxL5007t will not reply correct value. 
It returns 0x3f for chip ID. I didn't tested it, but quite good theory 
is that there is some other than chip id reg to set special register 
when that happens.

I have tested it with 3 devices and there is two devices to left which 
are using that new parameter.

regards
Antti

-- 
http://palosaari.fi/
