Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbeGQW4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:56:09 -0400
Date: Wed, 18 Jul 2018 07:21:07 +0900
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hannah@marvell.com, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180718072107.0bfdece8@vela.lan>
In-Reply-To: <CA+55aFwb5hPtPFbB02SSn+wTkqTDSgHGFkiw7LB57mj42VzyZQ@mail.gmail.com>
References: <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
        <1d3d0fe3-bc02-7720-15ac-6bc06e00067c@marvell.com>
        <CA+55aFwb5hPtPFbB02SSn+wTkqTDSgHGFkiw7LB57mj42VzyZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Em Tue, 17 Jul 2018 10:09:28 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Tue, Jul 17, 2018 at 4:58 AM Hanna Hawa <hannah@marvell.com> wrote:
> >
> > After some debug/bisect/diff, found that patch "softirq: Let ksoftirqd
> > do its job" is problematic patch.  
> 
> Ok, this thread died down without any resolution.
> 
> >- Using v4.14.0 (including softirq patch) and the additional fix
> > proposed by Linus - no timeout issue.  
> 
> Are you talking about the patch that made HI_SOFTIRQ and
> TASKLET_SOFTIRQ special, and had this:
> 
>   #define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
> 
> in it?
> 
> I think I'll just commit the damn thing. It's hacky, but it's simple,
> and it never got applied because we had smarter suggestions. But the
> smarter suggestions never ended up being applied either, so..

Yeah, IMHO the best would be to apply your patch[1], c/c stable up to
4.9. Nothing prevents applying a better/smarter solution once we
have it. From my side, I can keep testing whatever smart suggestions
people propose. Yet, better to have one fix on our hand than two
fixes flying around.

[1] e. g. 
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=v4.15%2bmedia%2bdwc2&id=ccf833fd4a5b99c3d3cf2c09c065670f74a230a7

Regards,
Mauro
