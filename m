Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56620 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbeAIOZ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:25:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        alan@linux.intel.com, peterz@infradead.org, netdev@vger.kernel.org,
        tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        torvalds@linux-foundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via speculative execution
Date: Tue, 09 Jan 2018 16:26:28 +0200
Message-ID: <2835808.JOrOUjDU6l@avalon>
In-Reply-To: <20180109100410.GA11968@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com> <7187306.jmXyF4vJKt@avalon> <20180109100410.GA11968@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Tuesday, 9 January 2018 12:04:10 EET Greg KH wrote:
> On Tue, Jan 09, 2018 at 10:40:21AM +0200, Laurent Pinchart wrote:
> > On Saturday, 6 January 2018 11:40:26 EET Greg KH wrote:
> >> On Sat, Jan 06, 2018 at 10:09:07AM +0100, Greg KH wrote:
> >>=20
> >> While I'm all for fixing this type of thing, I feel like we need to do
> >> something "else" for this as playing whack-a-mole for this pattern is
> >> going to be a never-ending battle for all drivers for forever.
> >=20
> > That's my concern too, as even if we managed to find and fix all the
> > occurrences of the problematic patterns (and we won't), new ones will k=
eep
> > being merged all the time.
>=20
> And what about the millions of lines of out-of-tree drivers that we all
> rely on every day in our devices?  What about the distro kernels that
> add random new drivers?

Of course, even though the out-of-tree drivers probably come with lots of=20
security issues worse than this one.

> We need some sort of automated way to scan for this.

Is there any initiative to implement such a scan in an open-source tool ?

We also need to educate developers. An automatic scanner could help there, =
but=20
in the end the information has to spread to all our brains. It won't be eas=
y,=20
and is likely not fully feasible, but it's no different than how developers=
=20
have to be educated about race conditions and locking for instance. It's a=
=20
mind set.

> Intel, any chance we can get your coverity rules?  Given that the date
> of this original patchset was from last August, has anyone looked at
> what is now in Linus's tree?  What about linux-next?  I just added 3
> brand-new driver subsystems to the kernel tree there, how do we know
> there isn't problems in them?
>=20
> And what about all of the other ways user-data can be affected?  Again,
> as Peter pointed out, USB devices.  I want some chance to be able to at
> least audit the codebase we have to see if that path is an issue.
> Without any hint of how to do this in an automated manner, we are all
> in deep shit for forever.

Or at least until the hardware architecture evolves. Let's drop the x86=20
instruction set, expose the =B5ops, and have gcc handle the scheduling. Sur=
e, it=20
will mean recompiling everything for every x86 CPU model out there, but we=
=20
have source-based distros to the rescue :-D

> >> Either we need some way to mark this data path to make it easy for too=
ls
> >> like sparse to flag easily, or we need to catch the issue in the driver
> >> subsystems, which unfortunatly, would harm the drivers that don't have
> >> this type of issue (like here.)
> >=20
> > But how would you do so ?
>=20
> I do not know, it all depends on the access pattern, right?

Any data coming from userspace could trigger such accesses. If we want=20
complete coverage the only way I can think of is starting from syscalls and=
=20
tainting data down the call stacks (__user could help to some extend), but=
=20
we'll likely be drowned in false positives. I don't see how we could mark=20
paths manually.

> >> I'm guessing that other operating systems, which don't have the luxury
> >> of auditing all of their drivers are going for the "big hammer in the
> >> subsystem" type of fix, right?
> >=20
> > Other operating systems that ship closed-source drivers authored by
> > hardware vendors and not reviewed by third parties will likely stay
> > vulnerable forever. That's a small concern though as I expect those
> > drivers to contain much large security holes anyway.
>=20
> Well yes, but odds are those operating systems are doing something to
> mitigate this, right?  Slowing down all user/kernel data paths?
> Targeted code analysis tools?  Something else?  I doubt they just don't
> care at all about it.  At the least, I would think Coverity would be
> trying to sell licenses for this :(

Given their track record of security issues in drivers (and I won't even=20
mention the ones that are present by design, such as root kits in game copy=
=20
protection systems for instance) I doubt they will do much beside sprinklin=
g a=20
bit of PR dust, at least for the consumer market. On the server market it=20
might be different as there's less hardware variation, and thus less driver=
s=20
to handle.

=2D-=20
Regards,

Laurent Pinchart
