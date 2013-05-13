Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f65.google.com ([209.85.215.65]:49115 "EHLO
	mail-la0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3EMIaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 04:30:08 -0400
Received: by mail-la0-f65.google.com with SMTP id er20so504272lab.4
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 01:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
References: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
	<CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
Date: Mon, 13 May 2013 09:30:07 +0100
Message-ID: <CALPBhf6Gt4o2+TW5tb0PMJLKPTd6KjaP_uWVU1ec6hpcNgaCyQ@mail.gmail.com>
Subject: Re: stk1160: cannot alloc 196608 bytes
From: a b <genericgroupmail@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Ezequiel,

Thank you for taking the time to look at this, it really is appreciated.
If you need anything else just let me know.

Thanks!!

On Sat, May 11, 2013 at 2:28 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Thu, May 9, 2013 at 1:11 PM, a b <genericgroupmail@gmail.com> wrote:
>> Hi,
>>
>> I am seeing occasional issues when using an easycap card on our fedora
>> 17 machine.
> [...]
>
> On a very quick look you seem to be getting out of memory (out of
> blocks of pages large enough for stk1160). Now, this may be some bug
> in stk1160, maybe not.
>
> I'll take a closer look in the next weeks.
> --
>     Ezequiel
