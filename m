Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47637 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932089AbeAHKCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 05:02:14 -0500
Date: Mon, 8 Jan 2018 08:02:00 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
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
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180108080200.77d374c2@vento.lan>
In-Reply-To: <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
        <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
        <20171217112738.4f3a4f9b@recife.lan>
        <trinity-1fa14556-8596-44b1-95cb-b8919d94d2d4-1515251056328@3c-app-gmx-bs15>
        <20180106175420.275e24e7@recife.lan>
        <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Em Sun, 7 Jan 2018 13:23:39 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Sat, Jan 6, 2018 at 11:54 AM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> >
> > Em Sat, 6 Jan 2018 16:04:16 +0100
> > "Josef Griebichler" <griebichler.josef@gmx.at> escreveu:  
> >>
> >> the causing commit has been identified.
> >> After reverting commit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4cd13c21b207e80ddb1144c576500098f2d5f882
> >> its working again.  
> >
> > Just replying to me won't magically fix this. The ones that were involved on
> > this patch should also be c/c, plus USB people. Just added them.  
> 
> Actually, you seem to have added an odd subset of the people involved.
> 
> For example, Ingo - who actually committed that patch - wasn't on the cc.

Sorry, my fault. I forgot to add him to it.

> I do think we need to simply revert that patch. It's very simple: it
> has been reported to lead to actual problems for people, and we don't
> fix one problem and then say "well, it fixed something else" when
> something breaks.
> 
> When something breaks, we either unbreak it, or we revert the change
> that caused the breakage.
> 
> It's really that simple. That's what "no regressions" means.  We don't
> accept changes that cause regressions. This one did.

Yeah, we should either unbreak or revert it. In the specific case of
media devices, Alan came with a proposal of increasing the number of
buffers. This is an one line change, and increase a capture delay from
0.63 ms to 5 ms on this specific case (Digital TV) shouldn't make much
harm. So, I guess it would worth trying it before reverting the patch.

It is hard to foresee the consequences of the softirq changes for other
devices, though.

For example, we didn't have any reports about this issue affecting cameras,
Most cameras use ISOC nowadays, but some only provide bulk transfers.
We usually try to use the minimum number of buffers possible, as
increasing latency on cameras can be very annoying, specially on
videoconference applications.

Thanks,
Mauro
