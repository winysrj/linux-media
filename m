Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47877 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3EKOkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 May 2013 10:40:08 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so9887121iec.15
        for <linux-media@vger.kernel.org>; Sat, 11 May 2013 07:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
References: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
	<CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
Date: Sat, 11 May 2013 11:40:08 -0300
Message-ID: <CALF0-+U5isYqbW5DSYauZOYmqit6Q8TMsSQGRxWg-TkJY7oPMw@mail.gmail.com>
Subject: Re: stk1160: cannot alloc 196608 bytes
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: a b <genericgroupmail@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 11, 2013 at 10:28 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
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

Could you try using "keep_buffers" option? This option should tell the driver
to try to not release the video buffers, in an attempt to prevent
memory from fragmenting.

Like this:

$ modprobe stk1160 keep_buffers=1

or like this to make it permanent:

$ echo "options stk1160 keep_buffers=1" > /etc/modprobe.d/stk1160.conf

Please try this, see if it solves your issue and report your results.
-- 
    Ezequiel
