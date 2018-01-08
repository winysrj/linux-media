Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:42654 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbeAHRz4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:55:56 -0500
Date: Mon, 8 Jan 2018 18:55:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
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
Message-ID: <20180108175551.wp6thxmiozrz4yp2@gmail.com>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
 <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
 <20171217112738.4f3a4f9b@recife.lan>
 <trinity-1fa14556-8596-44b1-95cb-b8919d94d2d4-1515251056328@3c-app-gmx-bs15>
 <20180106175420.275e24e7@recife.lan>
 <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

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
> 
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

Yeah, absolutely - for the revert:

   Acked-by: Ingo Molnar <mingo@kernel.org>

as I doubt we have enough time to root-case this properly.

Thanks,

	Ingo
