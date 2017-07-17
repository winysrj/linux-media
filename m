Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0076.outbound.protection.outlook.com ([104.47.36.76]:36256
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751281AbdGQNQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 09:16:12 -0400
Date: Mon, 17 Jul 2017 15:15:49 +0200
From: Sinclair Yeh <syeh@vmware.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Brian Paul <brianp@vmware.com>
Subject: Re: [PATCH, RESEND 03/14] drm/vmwgfx: avoid gcc-7 parentheses warning
Message-ID: <20170717131548.GA15306@pc24.home>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714092540.1217397-4-arnd@arndb.de>
 <CA+55aFw9xE_+qnx1=6FbU8HJ23+Go1iS5bxDLOHefETgn5Wx6w@mail.gmail.com>
 <CA+55aFw+DTc_czppqfbqY+7kq6Uej=Nf1Wxf1HutRw4tRxC85Q@mail.gmail.com>
 <CAK8P3a2QEOuQXy51q-EqzTh3STKTDHy2V-twi5nFPbuzOSEDkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2QEOuQXy51q-EqzTh3STKTDHy2V-twi5nFPbuzOSEDkQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 10:28:29PM +0200, Arnd Bergmann wrote:
> On Fri, Jul 14, 2017 at 9:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Jul 14, 2017 at 12:21 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> NAK. This takes unintentionally insane code and turns it intentionally
> >> insane. Any non-zero return is considered an error.
> >>
> >> The right fix is almost certainly to just return -EINVAL unconditionally.

Correct.  I'll fix this.

> >
> > Btw, this is why I hate compiler warning fix patch series. Even when
> > they don't actually break the code (and sometimes they do that too),
> > they can actually end up making the code worse.
> 
> I generally agree, and this is also why I held up sending patches for the
> -Wformat warnings until you brought those up. I also frequently send
> patches for recently introduced warnings, which tend to have a better
> chance of getting reviewed by the person that just introduced the code,
> to catch this kind of mistake in my patches.
> 
> I also regularly run into cases where I send a correct patch and find
> that another broken patch has been applied the following day ;-)
> 
> > The *intent* of that code was to return zero for the CAP_SYS_ADMIN.
> > But the code has never done that in its lifetime and nobody ever
> > noticed, so clearly the code shouldn't even have tried.
> 
> Makes sense, yes. In this case, the review process has failed as
> well, as one of the maintainers even gave an Ack on the wrong patch,
> and then the patch got dropped without any feedback.

I've done some digging and noticed that my -fixes pull request
didn't get picked up last December.  It's most likely because I
initially made an address typo in the original request, and then
followed it up with a direct email with the correct address.

Sinclair
