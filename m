Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:40631 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760052Ab3DJBik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 21:38:40 -0400
Received: by mail-qc0-f171.google.com with SMTP id q2so2311800qch.2
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 18:38:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5164B611.2060500@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
	<1365551600-3394-2-git-send-email-crope@iki.fi>
	<CAGoCfiw_pyh5MchkU59Y9NJz+Rgf5B7Gvd92A1pF+e18DVWgKQ@mail.gmail.com>
	<5164B611.2060500@iki.fi>
Date: Tue, 9 Apr 2013 21:38:39 -0400
Message-ID: <CAGoCfix+GByPDoAQhPBQqzD3_s30+wbE9F-kACtZc6rTD94YBg@mail.gmail.com>
Subject: Re: [PATCH 1/5] mxl5007t: fix buggy register read
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 9, 2013 at 8:45 PM, Antti Palosaari <crope@iki.fi> wrote:
> Yes, most devices do that, but not all!
> MxL5007t has a special register for setting register to read. Look the code
> and you could see it easily. It was over year ago I fixed it...

That sounds kind of insane, but I haven't looked at the datasheets and
if Mike Ack'd it, then so be it.

>> Further, it *should* be done in a single call to i2c_transfer() or
>> else you won't hold the lock and you will create a race condition.
>
>
> No. That's why I added new lock. Single i2c_transfer() means all messages
> are done using repeated START condition.

No need to add a new lock to your bridge driver.  You can just use
__i2c_transfer() and i2c_lock_adapter(state->i2c).  That's what
they're doing in the drx-k driver for just such cases where they need
the lock to span multiple calls to i2c_transfer().

>
>> This sounds more like it's a bug in the i2c master rather than the 5007
>> driver.
>
>
> No.
>
>
>> Do you have i2c bus traces that clearly show that this was the cause
>> of the issue?  If we need to define something as "broken" behavior, at
>> first glance it looks like the way *you're* proposing is the broken
>> behavior - presumably to work around a bug in the i2c master not
>> properly supporting repeated start.
>
>
> Yes and no. I made own Cypress FX2 firmware and saw initially that issue
> then. Also, as you could see looking the following patches I ensured /
> confirmed issue using two different I2C adapters (AF9015 and AF9035). So I
> have totally 3 working adapters to prove it (which are broken without that
> patch)!

The whole think sounds screwed up, and without a real i2c trace of the
bus we'll never know.  That said, I'm not really in a position to
dispute it given I don't have any devices with the chip in question.

I would suggest renaming the configuration value to something less
controversial, such as "use_repeated_start_for_reads" and avoid using
terms like broken where it's not clear that's actually the case.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
