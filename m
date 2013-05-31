Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58771 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3EaOUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:20:12 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so1750363lbf.14
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 07:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALPBhf7vYJh=G7fttft+C=0gCdV2+Bpe09RYZjeRQ3vt9Q5uPQ@mail.gmail.com>
References: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
	<CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
	<CALF0-+U5isYqbW5DSYauZOYmqit6Q8TMsSQGRxWg-TkJY7oPMw@mail.gmail.com>
	<CALPBhf7vYJh=G7fttft+C=0gCdV2+Bpe09RYZjeRQ3vt9Q5uPQ@mail.gmail.com>
Date: Fri, 31 May 2013 15:20:10 +0100
Message-ID: <CALPBhf7qSa7p-kW5+r=XGAqHvGfDyxz15O35vYW2NVZZfDizvw@mail.gmail.com>
Subject: Re: stk1160: cannot alloc 196608 bytes
From: a b <genericgroupmail@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

Just to report that i haven't seen any recurrence of the issue since
applying the suggested "keep_buffers" option.
Many thanks for your help.



On Mon, May 13, 2013 at 9:33 AM, a b <genericgroupmail@gmail.com> wrote:
> Hi Ezequiel,
>
> Sorry, just saw your suggestion RE: keep_buffers, i will definitely
> try this out and let you know how it goes.
> Will probably give it a few days worth of runs to see if it re-occurs.
>
> Thanks again!
>
> On Sat, May 11, 2013 at 3:40 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> On Sat, May 11, 2013 at 10:28 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> On Thu, May 9, 2013 at 1:11 PM, a b <genericgroupmail@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I am seeing occasional issues when using an easycap card on our fedora
>>>> 17 machine.
>>> [...]
>>>
>>> On a very quick look you seem to be getting out of memory (out of
>>> blocks of pages large enough for stk1160). Now, this may be some bug
>>> in stk1160, maybe not.
>>>
>>> I'll take a closer look in the next weeks.
>>
>> Could you try using "keep_buffers" option? This option should tell the driver
>> to try to not release the video buffers, in an attempt to prevent
>> memory from fragmenting.
>>
>> Like this:
>>
>> $ modprobe stk1160 keep_buffers=1
>>
>> or like this to make it permanent:
>>
>> $ echo "options stk1160 keep_buffers=1" > /etc/modprobe.d/stk1160.conf
>>
>> Please try this, see if it solves your issue and report your results.
>> --
>>     Ezequiel
