Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:40534 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbeAIR51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 12:57:27 -0500
Received: by mail-wm0-f41.google.com with SMTP id f206so22258529wmf.5
        for <linux-media@vger.kernel.org>; Tue, 09 Jan 2018 09:57:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
References: <20180107090336.03826df2@vento.lan> <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
 <20180108074324.3c153189@vento.lan> <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <20180108223109.66c91554@redhat.com> <20180108214427.GT29822@worktop.programming.kicks-ass.net>
 <20180108231656.3bbd1968@redhat.com> <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
 <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com> <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 Jan 2018 09:57:24 -0800
Message-ID: <CANn89iLo9WsFq-cvL63zD6hOXFRs97hDifksNsAHTegNQqXzZw@mail.gmail.com>
Subject: Re: Re: dvb usb issues since kernel 4.9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 9:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 9, 2018 at 9:27 AM, Eric Dumazet <edumazet@google.com> wrote:
>>
>> So yes, commit 4cd13c21b207 ("softirq: Let ksoftirqd do its job") has
>> shown up multiple times in various 'regressions'
>> simply because it could surface the problem more often.
>> But even if you revert it, you can still make the faulty
>> driver/subsystem misbehave by adding more stress to the cpu handling
>> the IRQ.
>
> ..but that's always true. People sometimes live on the edge - often by
> design (ie hardware has been designed/selected to be the crappiest
> possible that still work).
>
> That doesn't change anything. A patch that takes "bad things can
> happen" to "bad things DO happen" is a bad patch.

I was expecting that people could get a chance to fix the root cause,
instead of trying to keep status quo.

Strangely, it took 18 months for someone to complain enough and
'bisect to this commit'

Your patch considers TASKLET_SOFTIRQ being a candidate for 'immediate
handling', but TCP Small queues heavily use TASKLET,
so as far as I am concerned a revert would have the same effect.
