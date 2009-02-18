Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:41559 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZBRNBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 08:01:22 -0500
Date: Wed, 18 Feb 2009 14:01:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090218140105.17c86bcb@hyperion.delvare>
In-Reply-To: <20090218071041.63c09ba3@pedra.chehab.org>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218071041.63c09ba3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, 18 Feb 2009 07:10:41 -0300, Mauro Carvalho Chehab wrote:
> On Wed, 18 Feb 2009 09:55:53 +0100 (CET)
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> 
> > Not at all. I work with embedded systems and what happens is that you
> > effectively take a kernel snapshot for your device and stick to that.
> > You're not using v4l-dvb, but you might backport important fixes on
> > occasion.
> > 
> > Again, it's not our job. The linux model is to get your drivers into the
> > kernel, then let distros take care of the rest, which includes backporting
> > if needed to older kernels. We are doing the work that distros should be
> > doing. A few years ago I moved ivtv to v4l-dvb and the kernel with the
> > express purpose to be finally free of keeping it backwards compatible with
> > older kernels. Now I find myself doing the same AGAIN.
> > 
> > And you are talking about that mythical user that needs it. I've yet to
> > SEE that user here and telling me that it is essential to their product.
> > 
> > PROVE to me that it is really necessary and really our job, and esp. my
> > job, since *I'm* the one keeping the backwards compatibility for i2c
> > modules alive. All I hear is 'there might be', 'I know some company', 'I
> > heard'.
> > 
> > Right now there is crappy code in the kernel whose only purpose is to
> > facilitate support for old kernels. That's actually against the kernel
> > policy.
> > 
> > One alternative is it create a separate repository just before the compat
> > code is removed, and merge important fixes for drivers in there. That
> > should tide us over until RHEL 6 is released.
> > 
> > Which also raises the other question: what criterium is there anyway to
> > decide what is the oldest kernel to support? RHEL 5 will no doubt be used
> > for 1-2 years after RHEL 6 is release, do we still keep support for that?
> > Old kernels will be used for a long time in embedded systems, do we still
> > keep support for that too?
> 
> Hans, I'm doing backport since 2005. So, you are not the only one that are
> doing backports. On V4L, this started ever since. In the case of DVB, we
> started backport on 2006. Before that, they use to support only the latest
> kernel version.
> 
> If you get a snapshot of our tree of about 6 months to one year ago, we had
> even support for linux-2.4 I2C (and yes, this works - I have a tree here for
> vivi and bttv drivers based on that i2c support, working with 2.4).

Not necessarily something to be proud about. This only shows how slowly
v4l has evolved in the past few years. Big changes that should have
happen have been constantly postponed in the name of compatibility.

> In the past, our criteria were simply to support all 2.6 versions and the
> latest 2.4 versions. Sometime after having the last 2.4 distro moving their
> stable repo to 2.6, we decided to drop 2.4, because we got no complains to keep
> 2.4 on that time.
> 
> Maybe the current solution for i2c backport is not the better one, and we
> need to use another approach. If the current i2c backport is interfering on the
> development, then maybe we need to re-think about the backport implementation.
> The backport shouldn't affect the upstream. It were never affected until the
> recent i2c backport. Even the 2.4 i2c backport didn't interfere upstream, even
> having a completely different implementation on 2.4.

Actually, 2.6 kernels up to 2.6.13 had an i2c API very similar to what
2.4 had. The binding model changes we are undergoing now are way more
intrusive than the migration from 2.4 to early 2.6.

> > The only reasonable criterium I see is technical: when you start to
> > introduce cruft into the kernel just to support older kernels, then it is
> > time to cut off support to those kernels.
> 
> The criteria for backport is not technical.

That technical isn't the only criteria, I agree with. But claiming that
technical isn't a criteria at all is plain wrong. This is equivalent to
claiming that development time doesn't cost anything.

>                                       (...) It is all about offering a version
> that testers with standard distros can use it, without needing to use the
> latest -rc kernel.
> 
> I'm fine to drop support to unused kernels, but the hole idea to have backport
> is to allow an easy usage of the newer drivers by users with their environment.
> If we start removing such code, due to any other criteria different than having
> support for kernels that people are still using on their desktop and enterprise
> environments, 

You're aiming at the wrong target, I am afraid. "Enterprise
environments" have _nothing_ to do with upstream development, by
definition. More on that below.

>         (...) then it is time to forget about -hg and use -git instead,
> supporting only the latest tip kernel, just like almost all other maintainers
> do.
> 
> While we are stick on have backport, we need at least to support the latest
> desktop and enterprise kernel versions of the major distros.
> 
> So, it is a matter of deciding what we want:
> 	keep our current criteria of offering backport kernels that include
> 	at least the kernel version used on the major desktop and enterprise
> 	kernel distros

No, not enterprise kernels!

> OR
> 	just use -git and drop all backport code.
> 
> Both solutions work for me, although I prefer to keep backport, even having more trouble[1]. 
> 
> Anything else and we will enter of a grey area that will likely go nowhere.

I am sorry but I don't follow you here. You are basically claiming that
allowing enterprise users (who typically run RHEL or SLED) to build
bleeding-edge drivers off the v4l-dvb repository is very important, but
allowing non-enterprise users and kernel developers (who typically run
Fedora or openSUSE) isn't that important? I believe this is exactly the
other way around.

I am working on L3 support for SLE products, so I know very well what
enterprise customers want, and what they don't. I doubt that RHEL
customers are any different from SLE ones. Enterprise customers don't
give a damn to the v4l-dvb repository. All they know about and want are
packages provided by the vendor, which change as little as possible
(that is, bug fixes only.) Running bleeding-edge, untrusted and
unmaintained drivers is the last thing they want. If they need a driver
for a recent piece of hardware, they open a feature request for the
next service pack, and leave it to the OS vendor to backport the
driver and maintain it for the next 5 years or so.

As a side note, I doubt that the v4l-dvb repository would always work
that well for enterprise distribution kernels anyway. All the tests are
based on the kernel version, but the enterprise kernels diverge a lot
over time from the upstream version they were originally based on, so I
wouldn't be surprised if things broke from times to times.

The actual audience for the v4l-dvb repository is users who do NOT have
a support contract with the OS vendor. That is, home users. These do
not run RHEL and SLE, especially if they have recent hardware, given
how bad hardware support is in enterprise distributions. Home users
will want their hard disk controller, graphics adapter and sound chip
to work before they even consider getting support for their TV adapter
from the v4l-dvb repository. Which means that they will be running a
recent version of Fedora, openSUSE or equivalent.

Now, if you look at the support policy of Fedora and openSUSE, you'll
see that they are maintained for 13 [1] to 24 [2] months. In practice,
the oldest supported Fedora is Fedora 9, featuring kernel 2.6.25, and
the oldest supported openSUSE is openSUSE 10.3, featuring kernel
2.6.22. Which is why I claim that there is no point in supporting
anything older than that. When openSUSE 10.3 goes out of maintenance
(end of 2009), we can even drop support for kernels < 2.6.25.

[1] http://fedoraproject.org/wiki/LifeCycle
[2] http://en.opensuse.org/SUSE_Linux_Lifetime

There is a reason why the Linux market has been segmented into
enterprise distributions and community distributions. Ignoring that
reason and trying to support all distributions with the same upstream
repository simply doesn't work.

So, I don't buy your claim that we should either support old enterprise
kernels or not support any old kernel at all. Just like I don't buy
your claim that the technical aspect shouldn't be taken into account
when deciding what kernels you want to support. I think we have to be
pragmatic here. We want to support kernels which users really care
about (and these are the ones in maintained popular non-enterprise
distributions) and which don't cost too much to support from a
technical point of view.

Now, if you think that giving up the hg tree and only supporting Linus'
latest kernel is the way to go, I'm not going to prevent you from going
down that road. As a kernel developer, that would make me very happy.
But I remember that the hg tree is there to help users test the newest
developments without running a bleeding-edge kernel, and that certainly
makes some sense.

Thanks,
-- 
Jean Delvare
