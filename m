Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36920 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdFFPBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 11:01:09 -0400
Received: by mail-it0-f45.google.com with SMTP id m47so110102472iti.0
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 08:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNVuKc8kXVQN5MiAannTK_1GwFqZLVvptcQbWyiborX0xQ@mail.gmail.com>
References: <CAP2KGUmvsnWOE9t8uR5YQuGNptt8OcUmbALjB3pD6ChpA0tcug@mail.gmail.com>
 <CAP2KGU=779YZ6MutWgsdNc5zGEfAxJYeepWXq4x1zKEX0B62tg@mail.gmail.com> <CALzAhNVuKc8kXVQN5MiAannTK_1GwFqZLVvptcQbWyiborX0xQ@mail.gmail.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Tue, 6 Jun 2017 11:00:58 -0400
Message-ID: <CALzAhNVFWDvOPPhgqirrL8iRJACGFioDn7P0zXwhYkC44D57Kw@mail.gmail.com>
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: Adam Zegelin <adam@zegelin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 21, 2017 at 7:57 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> Just a follow up on this. I had a bit more time to dig deeper into this today.
>>
>> Enabling debug output for the cx23885 driver *fixes* the issue.
>>
>> I added this to my kernel command line: cx23885.debug=8
>
> The driver's been around a very long time and is very stable with
> almost anything anyone has every added, or I originally added during
> the early development. That being said..... this sounds like the quad
> is producing some kind of race condition, or the PLX bridge is in
> someway not as transparent as everyone would like.

I happen to have tip installed on a dev box, so I thought I'd install
a quad-hd and test for the issues you'd mentioned.

I do not see any of the issues you are describing, regardless of
whether I tested with w_scan, tzap, dvbtraffic.

No unusual module options used, everything 'default'.

Everything looks fine to me, no fault found, Ubuntu 16.04 Kernel
4.12-rc1, 64bit.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
