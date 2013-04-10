Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51544 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762270Ab3DJApo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 20:45:44 -0400
Message-ID: <5164B611.2060500@iki.fi>
Date: Wed, 10 Apr 2013 03:45:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 1/5] mxl5007t: fix buggy register read
References: <1365551600-3394-1-git-send-email-crope@iki.fi> <1365551600-3394-2-git-send-email-crope@iki.fi> <CAGoCfiw_pyh5MchkU59Y9NJz+Rgf5B7Gvd92A1pF+e18DVWgKQ@mail.gmail.com>
In-Reply-To: <CAGoCfiw_pyh5MchkU59Y9NJz+Rgf5B7Gvd92A1pF+e18DVWgKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2013 03:20 AM, Devin Heitmueller wrote:
> On Tue, Apr 9, 2013 at 7:53 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Chip uses WRITE + STOP + READ + STOP sequence for I2C register read.
>> Driver was using REPEATED START condition which makes it failing if
>> I2C adapter was implemented correctly.
>>
>> Add use_broken_read_reg_intentionally option to keep old buggy
>> implantation as there is buggy I2C adapter implementation relying
>> that bug...
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Hi Antti,
>
> The existing code actually looks fine.  This is actually how most
> devices do register reads.

Yes, most devices do that, but not all!
MxL5007t has a special register for setting register to read. Look the 
code and you could see it easily. It was over year ago I fixed it...

> Further, it *should* be done in a single call to i2c_transfer() or
> else you won't hold the lock and you will create a race condition.

No. That's why I added new lock. Single i2c_transfer() means all 
messages are done using repeated START condition.

> This sounds more like it's a bug in the i2c master rather than the 5007 driver.

No.

> Do you have i2c bus traces that clearly show that this was the cause
> of the issue?  If we need to define something as "broken" behavior, at
> first glance it looks like the way *you're* proposing is the broken
> behavior - presumably to work around a bug in the i2c master not
> properly supporting repeated start.

Yes and no. I made own Cypress FX2 firmware and saw initially that issue 
then. Also, as you could see looking the following patches I ensured / 
confirmed issue using two different I2C adapters (AF9015 and AF9035). So 
I have totally 3 working adapters to prove it (which are broken without 
that patch)!

> Also, any reason you didn't put Mike into the cc: for this (since he
> owns the driver)?

you added :)

> Devin

regards
Antti

-- 
http://palosaari.fi/
