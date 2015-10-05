Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33217 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbJEOnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 10:43:07 -0400
Received: by igbkq10 with SMTP id kq10so64313417igb.0
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2015 07:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56128AA6.8010106@tresar-electronics.com.au>
References: <5610B12B.8090201@tresar-electronics.com.au>
	<CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
	<5611D97B.9020101@tresar-electronics.com.au>
	<CALzAhNVVipTAE3T9Hpmi8_CT=ZS5Wd04W5LfMaf-X5QP2d0sQw@mail.gmail.com>
	<56128AA6.8010106@tresar-electronics.com.au>
Date: Mon, 5 Oct 2015 10:43:05 -0400
Message-ID: <CALzAhNVDYgBbCfW5XSwVXJKqm7CgB23=xpsf25Y2Z0yY=tEKBQ@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Do you have a large number of other devices / drivers loaded? I
>> suspect another driver is burning through kernel memory before the
>> saa7164 has a chance to be initialized.
>
> Nope nothing I can see Its actually the only addon card I have in this
> system..
> I'd be buggered If 4GB of RAM is fragmented enough early on in the boot
> stage...?

I agree.

> I've hunted but can't find a nice way to determine what contiguous blocks
> are available..
> Noted there was a simple module that could be compiled in to test such
> things, I'll play with that and see what it turns up..

Let us know how that goes.

>
>> I took a quick look at saa7164-fw.c this morning, I see no reason why
>> the allocation is required at all. With a small patch the function
>> could be made to memcpy from 'src' directly, dropping the need to
>> allocate srcbuf what-so-ever. This would remove the need for the 4MB
>> temporary allocation, and might get you past this issue, likely on to
>> the next (user buffer allocations are also large - as I recall). Note
>> that the 4MB allocation is temporary, so its not a long term saving,
>> but it might get you past the hump.
>
> That was my thoughts exactly.. but I took a minimal fiddling approach to
> begin with..
> I wasn't sure if there was some requirement for the memcpy_toio requiring a
> specially allocated source..? can't see why..
> Was going to dig into that next as a side job..

At this stage the code is 7-8 years old, so I don't recall the
rationale for why I did that back in 2008(?) - but looking at it
today, I think its needless.... and its a fairly trivial thing to
remove and test.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
