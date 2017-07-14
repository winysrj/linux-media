Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34674 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdGNU2a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 16:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+DTc_czppqfbqY+7kq6Uej=Nf1Wxf1HutRw4tRxC85Q@mail.gmail.com>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-4-arnd@arndb.de>
 <CA+55aFw9xE_+qnx1=6FbU8HJ23+Go1iS5bxDLOHefETgn5Wx6w@mail.gmail.com> <CA+55aFw+DTc_czppqfbqY+7kq6Uej=Nf1Wxf1HutRw4tRxC85Q@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Jul 2017 22:28:29 +0200
Message-ID: <CAK8P3a2QEOuQXy51q-EqzTh3STKTDHy2V-twi5nFPbuzOSEDkQ@mail.gmail.com>
Subject: Re: [PATCH, RESEND 03/14] drm/vmwgfx: avoid gcc-7 parentheses warning
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Brian Paul <brianp@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 9:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jul 14, 2017 at 12:21 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> NAK. This takes unintentionally insane code and turns it intentionally
>> insane. Any non-zero return is considered an error.
>>
>> The right fix is almost certainly to just return -EINVAL unconditionally.
>
> Btw, this is why I hate compiler warning fix patch series. Even when
> they don't actually break the code (and sometimes they do that too),
> they can actually end up making the code worse.

I generally agree, and this is also why I held up sending patches for the
-Wformat warnings until you brought those up. I also frequently send
patches for recently introduced warnings, which tend to have a better
chance of getting reviewed by the person that just introduced the code,
to catch this kind of mistake in my patches.

I also regularly run into cases where I send a correct patch and find
that another broken patch has been applied the following day ;-)

> The *intent* of that code was to return zero for the CAP_SYS_ADMIN.
> But the code has never done that in its lifetime and nobody ever
> noticed, so clearly the code shouldn't even have tried.

Makes sense, yes. In this case, the review process has failed as
well, as one of the maintainers even gave an Ack on the wrong patch,
and then the patch got dropped without any feedback.

        Arnd
