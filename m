Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32506 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBSHpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 02:45:06 -0500
Date: Wed, 19 Feb 2014 10:44:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stv090x: remove indent levels
Message-ID: <20140219074455.GQ26722@mwanda>
References: <20140206092800.GB31780@elgon.mountain>
 <CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
 <20140218085651.GL26722@mwanda>
 <CAHFNz9LUP4UVROk5RWW_-=LQ5=gC8__zD67aLxNq7bHUMgipCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFNz9LUP4UVROk5RWW_-=LQ5=gC8__zD67aLxNq7bHUMgipCQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 19, 2014 at 10:52:32AM +0530, Manu Abraham wrote:
> On Tue, Feb 18, 2014 at 2:26 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Feb 18, 2014 at 09:25:36AM +0530, Manu Abraham wrote:
> >> Hi Dan,
> >>
> >> On Thu, Feb 6, 2014 at 2:58 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >> > 1) We can flip the "if (!lock)" check to "if (lock) return lock;" and
> >> >    then remove a big chunk of indenting.
> >> > 2) There is a redundant "if (!lock)" which we can remove since we
> >> >    already know that lock is zero.  This removes another indent level.
> >>
> >>
> >> The stv090x driver is a mature, but slightly complex driver supporting
> >> quite some
> >> different configurations. Is it that some bug you are trying to fix in there ?
> >> I wouldn't prefer unnecessary code churn in such a driver for
> >> something as simple
> >> as gain in an indentation level.
> >
> > I thought the cleanup was jusitification enough, but the real reason I
> > wrote this patch is that testing:
> >
> >         if (!lock) {
> >                 if (!lock) {
> >
> > sets off a static checker warning.  That kind of code is puzzling and if
> > we don't clean it up then it wastes a lot of reviewer time.
> >
> > Also when you're reviewing these patches please consider that the
> > original code might be buggy and not simply messy.  Perhaps something
> > other than "if (!lock) {" was intended?
> >
> 
> I can't seem to find the possible bug in there..
> 
> The code:
> 
> lock = fn();
> if (!lock) {
>      if (condition1) {
>            lock = fn()
>      } else {
>            if (!lock) {
>            }
>      }
> }
> 
> looks harmless to me, AFAICS.

Yes.  I thought so too.  It's just a messy, but not broken.  Let's just
fix the static checker warning so that we don't have to keep reviewing
it every several months.

> Also, please do note that, if the
> function coldlock exits due to some reason for not finding valid symbols,
> stv090x_search is again fired up from the kernel frontend thread.

This sentence really scares me.  Are you trying to say that the second
check on lock is valid for certain use cases?  That is not possibly
true because it is a stack variable so (ignoring memory corruption)
it can't be modified from outside the code.

Hm...

The code actually looks like this:

lock = fn();
if (!lock) {
     if (condition1) {
           lock = fn()
     } else {
           if (!lock) {
	   	while ((cur_step <= steps) && (!lock)) {
			lock = stv090x_get_dmdlock(state, (timeout_dmd / 3));
		}
           }
     }
}

Are you sure it's not buggy?  Maybe the if statement should be moved
inside the while () condition?

> It is easy to make such cleanup patches and cause breakages, but a
> lot time consuming to fix such issues. My 2c.

Greg K-H and I review more of these cleanup patches than any other
kernel maintainers so I'm aware of the challenges.  If you want to write
a smaller patch to fix the static checker warning then I will review it
for you.  If you do that then please give me a:
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

