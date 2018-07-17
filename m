Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38078 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729748AbeGQRnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 13:43:16 -0400
MIME-Version: 1.0
References: <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
 <1d3d0fe3-bc02-7720-15ac-6bc06e00067c@marvell.com>
In-Reply-To: <1d3d0fe3-bc02-7720-15ac-6bc06e00067c@marvell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jul 2018 10:09:28 -0700
Message-ID: <CA+55aFwb5hPtPFbB02SSn+wTkqTDSgHGFkiw7LB57mj42VzyZQ@mail.gmail.com>
Subject: Re: dvb usb issues since kernel 4.9
To: hannah@marvell.com
Cc: Jonathan Corbet <corbet@lwn.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ingo Molnar <mingo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        dma <dmaengine@vger.kernel.org>, vkoul@kernel.org,
        Dan Williams <dan.j.williams@intel.com>, nadavh@marvell.com,
        thomas.petazzoni@bootlin.com, omrii@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 17, 2018 at 4:58 AM Hanna Hawa <hannah@marvell.com> wrote:
>
> After some debug/bisect/diff, found that patch "softirq: Let ksoftirqd
> do its job" is problematic patch.

Ok, this thread died down without any resolution.

>- Using v4.14.0 (including softirq patch) and the additional fix
> proposed by Linus - no timeout issue.

Are you talking about the patch that made HI_SOFTIRQ and
TASKLET_SOFTIRQ special, and had this:

  #define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))

in it?

I think I'll just commit the damn thing. It's hacky, but it's simple,
and it never got applied because we had smarter suggestions. But the
smarter suggestions never ended up being applied either, so..

                       Linus
