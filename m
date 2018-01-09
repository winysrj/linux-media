Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:41307 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbeAIS6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 13:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <CANn89iLo9WsFq-cvL63zD6hOXFRs97hDifksNsAHTegNQqXzZw@mail.gmail.com>
References: <20180107090336.03826df2@vento.lan> <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
 <20180108074324.3c153189@vento.lan> <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <20180108223109.66c91554@redhat.com> <20180108214427.GT29822@worktop.programming.kicks-ass.net>
 <20180108231656.3bbd1968@redhat.com> <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
 <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
 <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com> <CANn89iLo9WsFq-cvL63zD6hOXFRs97hDifksNsAHTegNQqXzZw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Jan 2018 10:58:30 -0800
Message-ID: <CA+55aFwq42Nzq47csw=ME8zbHYiw2rPN_Zp+=+Bu+Ruq9XquhQ@mail.gmail.com>
Subject: Re: Re: dvb usb issues since kernel 4.9
To: Eric Dumazet <edumazet@google.com>
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

On Tue, Jan 9, 2018 at 9:57 AM, Eric Dumazet <edumazet@google.com> wrote:
>
> Your patch considers TASKLET_SOFTIRQ being a candidate for 'immediate
> handling', but TCP Small queues heavily use TASKLET,
> so as far as I am concerned a revert would have the same effect.

Does it actually?

TCP ends up dropping packets outside of the window etc, so flooding a
machine with TCP packets and causing some further processing up the
stack sounds very different from the basic packet flooding thing that
happens with NET_RX_SOFTIRQ.

Also, honestly, the kinds of people who really worry about flooding
tend to have packet filtering in the receive path etc.

So I really think "you can use up 90% of CPU time with a UDP packet
flood from the same network" is very very very different - and
honestly not at all as important - as "you want to be able to use a
USB DVB receiver and watch/record TV".

Because that whole "UDP packet flood from the same network" really is
something you _fundamentally_ have other mitigations for.

I bet that whole commit was introduced because of a benchmark test,
rather than real life. No?

In contrast, now people are complaining about real loads not working.

             Linus
