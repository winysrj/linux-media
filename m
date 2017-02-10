Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34885 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbdBJVCE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 16:02:04 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so9053749wmu.2
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2017 13:02:03 -0800 (PST)
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
To: Marcel Heinz <quisquilia@gmx.de>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
 <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
 <8792984d-54c9-01a8-0f84-7a1f0312a12f@gmx.de>
 <CAJxGH0-ewWzxSJ1vE+n4FMkqv+pnmT9G0uAZS5oUYkhxWm+=5A@mail.gmail.com>
 <ba755934-7946-59ea-e900-fe76d4ea2f0a@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        mchehab@osg.samsung.com
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <458abbd2-a98b-243b-bf2f-48d5e5a8060b@googlemail.com>
Date: Fri, 10 Feb 2017 22:02:01 +0100
MIME-Version: 1.0
In-Reply-To: <ba755934-7946-59ea-e900-fe76d4ea2f0a@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro & DVB-S maintainers,

could you please have a look at the bug report below? Marcel was so kind
to bisect the problem to the following commit:

https://git.linuxtv.org/v4l-utils.git/commit/?id=d982b0d03b1f929269104bb716c9d4b50c945125

Bug report against libdvbv5 is here:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854100

On 2/4/17 5:43 PM, Marcel Heinz wrote:
> Am 04.02.2017 um 15:57 schrieb Gregor Jasny:
>> Thanks for sharing! Maybe you could try to bisect to find the breaking
>> commit?
> 
> OK, I ended up with
> 
> d982b0d03b1f929269104bb716c9d4b50c945125 is the first bad commit
> commit d982b0d03b1f929269104bb716c9d4b50c945125
> Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:   Tue Dec 13 16:43:28 2016 -0200
> 
>     dvb-sat: change the LNBf logic to make it more generic
> 
>     There are some new LNBf models with more than two frequency
>     ranges. Change the logic there to allow adding those new
>     LNBf types.
> 
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> :040000 040000 5c0591da94959207f4b1573a40383b8143d12278
> 34df9c19cb42119706fce20dec00d18552ddf058 M      lib
> 
> 
> This looks very related to the frequency range error I got from the kernel:
> 
>> | [42607.855196] b2c2_flexcop_pci 0000:09:00.0: DVB: adapter 0 frontend
>> 0 frequency 12551500 out of range (950000..2150000)
>>
>> This frequency range doesn't look like DVB-S at all...

Thanks,
Gregor

