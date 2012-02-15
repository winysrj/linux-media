Return-path: <linux-media-owner@vger.kernel.org>
Received: from v38276.1blu.de ([88.84.155.223]:54453 "EHLO barth.jannau.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab2BOL4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 06:56:40 -0500
Date: Wed, 15 Feb 2012 12:46:38 +0100
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Taylor Ralph <taylor.ralph@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: missing patches in patchwork (was Re: [PATCH] [media] hdpvr:
 update picture controls to support firmware versions > 0.15)
Message-ID: <20120215114638.GC13315@jannau.net>
References: <CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
 <20111020170811.GD7530@jannau.net>
 <CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
 <CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com>
 <CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
 <4EB7CD59.1010303@redhat.com>
 <CAOTqeXoavdYLkfp+FRLj3v24z2m+xZHiKhnOOiHJhZ+Y858y9w@mail.gmail.com>
 <CANOx78GENFQXfuX0OeYPa=YCHREk3H2OKmKQhkEsQx9qFieksg@mail.gmail.com>
 <CAGoCfiwH8pYmJLB_4rkXF7gqfe2_PhFDz3XyNFO6VHsUQq=8tw@mail.gmail.com>
 <CANOx78GKYv9fdHx6ZVABojMBHJCXH3Y8YCGg2nK+HrBjPw-74g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOx78GKYv9fdHx6ZVABojMBHJCXH3Y8YCGg2nK+HrBjPw-74g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-02-14 17:09:55 -0500, Jarod Wilson wrote:
> On Tue, Feb 14, 2012 at 4:32 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> > On Tue, Feb 14, 2012 at 3:43 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> >> Looks sane to me, and really needs to get in ASAP. I'd even suggest we
> >> get it sent to stable, as these newer firmware HDPVR are pretty wonky
> >> with any current kernel.
> >>
> >> Acked-by: Jarod Wilson <jarod@redhat.com>
> >> Reviewed-by: Jarod Wilson <jarod@redhat.com>
> >> CC: stable@vger.kernel.org
> >
> > Where did the process break down here?  Taylor did this patch *months*
> > ago, and there has been absolutely no comment with why it wouldn't go
> > upstream.  If he hadn't been diligent in pinging the ML repeatedly, it
> > would have been lost.
> 
> It looks like for some reason, the v3 patch got eaten. :\
> 
> http://patchwork.linuxtv.org/patch/8183/ is the v2, in state Changes
> Requested, but you can see in the comments a mail that says v3 is
> attached, which contains the requested change (added s-o-b). A v3
> patch object is nowhere to be found though. The patch *was* indeed
> attached to the mail though, I've got it here in my linux-media
> mailbox.
> 
> So at least on this one, I think I'm blaming patchwork, but it would
> be good to better understand how that patch got eaten, and to know if
> indeed its happened to other patches as well.

Patchwork ignored the patch because of its mime type. Patchwork only 
handles text/{x-patch,x-diff,plain} but the v3 patch was attached as
application/octet-stream.

I have a clumsy patch to handle application/octet-stream for libav's
patchwork instance. I'll try to find time to clean it up and submit it
upstream.

Janne
