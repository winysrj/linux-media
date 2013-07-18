Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42865 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab3GRCP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 22:15:57 -0400
Message-ID: <51E74FAF.2060709@iki.fi>
Date: Thu, 18 Jul 2013 05:15:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org,
	mchehab@infradead.org, awalls@md.metrocast.net
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com> <CAGoCfizDcOPKiCo54rsoZJyXU3m-_v8jE0aTagxTyjB3QZrZXg@mail.gmail.com>
In-Reply-To: <CAGoCfizDcOPKiCo54rsoZJyXU3m-_v8jE0aTagxTyjB3QZrZXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2013 04:58 AM, Devin Heitmueller wrote:
> On Wed, Jul 17, 2013 at 9:33 PM, Luis Alves <ljalvs@gmail.com> wrote:
>> Hi,
>>
>> This i2c init should stop the interrupt storm that happens in some cards when the IR receiver in enabled.
>> It works perfectly in my TBS6981.
>
> What is at I2C address 0x4c?  Might be useful to have a comment in
> there explaining what this patch actually does.  This assumes you
> know/understand what it does - if you don't then a comment saying "I
> don't know why this is needed but my board doesn't work right without
> it" is just as valuable.
>
>> It would be good to test in other problematic cards.
>>
>> In this patch I've added the IR init to the TeVii S470/S471 (and some others that fall in the same case statment).
>> Other cards but these that suffer the same issue should also be tested.
>
> Without fully understanding the nature of this patch and what cards
> that it actually effects, it may make sense to move your board into a
> separate case statement.  Generally it's bad form to make changes like
> against other cards without any testing against those cards (otherwise
> you can introduce regressions).  Stick it in its own case statement,
> and users of the other boards can move their cards into that case
> statement *after* it's actually validated.
>
> Devin
>

hmm, I looked again the cx23885 driver.

0x4c == [0x98 >> 1] = "flatiron" == some internal block of the chip

There is routine which dumps registers out, 0x00 - 0x23
cx23885_flatiron_dump()

There is also existing routine to write those Flatiron registers. So, 
that direct I2C access could be shorten to:
cx23885_flatiron_write(dev, 0x1f, 0x80);
cx23885_flatiron_write(dev, 0x23, 0x80);


Unfortunately these two register names are not defined. Something clock 
or interrupt related likely.

regards
Antti

-- 
http://palosaari.fi/
