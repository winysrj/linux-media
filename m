Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:46168 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbeAIRzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 12:55:20 -0500
MIME-Version: 1.0
In-Reply-To: <20180109154235.2a42f0a0@vento.lan>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
 <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
 <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com> <20180109154235.2a42f0a0@vento.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Jan 2018 09:55:18 -0800
Message-ID: <CA+55aFxccKqTabDo3iTfLs9zMNpSBUk-tQmF8H7XwVPSV0dB6g@mail.gmail.com>
Subject: Re: dvb usb issues since kernel 4.9
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 9:42 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
>
> On my preliminar tests, writing to a file on an ext4 partition at a
> USB stick loses data up to the point to make it useless (1/4 of the data
> is lost!). However, writing to a class 10 microSD card is doable.

Note that most USB sticks are horrible crap. They can have write
latencies counted in _seconds_.

You can cause VM issues and various other non-hardware stalls with
them, simply because something gets stuck waiting for a page writeout
that should take a few ms on any reasonable hardware, but ends up
talking half a second or more.

For example, even really well-written software that tries to do things
like threaded write-behind to smooth out the IO will be _totally_
screwed by the USB stick behavior (where you might write a few MB at
high speeds, and then the next write - however small - takes a second
because the stupid USB stick does a synchronous garbage collection.
Suddenly all that clever software that tried to keep things moving
along smoothly without any hiccups, and tried hard to make the USB bus
have a nice constant loadm can't do anything at all about the crap
hardware.

So when testing writes to USB sticks, I'm not convinced you're
actually testing any USB bus limitations or even really any other
hardware limitations than the USB stick itself.

                  Linus
