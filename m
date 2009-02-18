Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZBRLyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 06:54:47 -0500
Date: Wed, 18 Feb 2009 08:54:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: urishk@yahoo.com, "Jean Delvare" <khali@linux-fr.org>,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090218085416.6ecc61ff@pedra.chehab.org>
In-Reply-To: <27074.62.70.2.252.1234954470.squirrel@webmail.xs4all.nl>
References: <27074.62.70.2.252.1234954470.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 11:54:30 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> > On Wed, 18 Feb 2009 09:55:53 +0100 (CET)
> > "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> >
> >> Not at all. I work with embedded systems and what happens is that you
> >> effectively take a kernel snapshot for your device and stick to that.
> >> You're not using v4l-dvb, but you might backport important fixes on
> >> occasion.
> >>
> >> Again, it's not our job. The linux model is to get your drivers into the
> >> kernel, then let distros take care of the rest, which includes
> >> backporting
> >> if needed to older kernels. We are doing the work that distros should be
> >> doing. A few years ago I moved ivtv to v4l-dvb and the kernel with the
> >> express purpose to be finally free of keeping it backwards compatible
> >> with
> >> older kernels. Now I find myself doing the same AGAIN.
> >>
> >> And you are talking about that mythical user that needs it. I've yet to
> >> SEE that user here and telling me that it is essential to their product.
> >>
> >> PROVE to me that it is really necessary and really our job, and esp. my
> >> job, since *I'm* the one keeping the backwards compatibility for i2c
> >> modules alive. All I hear is 'there might be', 'I know some company', 'I
> >> heard'.
> >>
> >> Right now there is crappy code in the kernel whose only purpose is to
> >> facilitate support for old kernels. That's actually against the kernel
> >> policy.
> >>
> >> One alternative is it create a separate repository just before the
> >> compat
> >> code is removed, and merge important fixes for drivers in there. That
> >> should tide us over until RHEL 6 is released.
> >>
> >> Which also raises the other question: what criterium is there anyway to
> >> decide what is the oldest kernel to support? RHEL 5 will no doubt be
> >> used
> >> for 1-2 years after RHEL 6 is release, do we still keep support for
> >> that?
> >> Old kernels will be used for a long time in embedded systems, do we
> >> still
> >> keep support for that too?
> >
> > Hans, I'm doing backport since 2005. So, you are not the only one that are
> > doing backports. On V4L, this started ever since. In the case of DVB, we
> > started backport on 2006. Before that, they use to support only the latest
> > kernel version.
> 
> I never said otherwise. All the more reason to abandon this model. I
> honestly think we should re-evaluate our development process. Whenever new
> developers come in (and a lot are coming in from the embedded space) their
> first question is: where is your git tree? There is a reason why this
> model is being adopted widely.
> 
> > If you get a snapshot of our tree of about 6 months to one year ago, we
> > had
> > even support for linux-2.4 I2C (and yes, this works - I have a tree here
> > for
> > vivi and bttv drivers based on that i2c support, working with 2.4).
> >
> > In the past, our criteria were simply to support all 2.6 versions and the
> > latest 2.4 versions. Sometime after having the last 2.4 distro moving
> > their
> > stable repo to 2.6, we decided to drop 2.4, because we got no complains to
> > keep
> > 2.4 on that time.
> >
> > Maybe the current solution for i2c backport is not the better one, and we
> > need to use another approach. If the current i2c backport is interfering
> > on the
> > development, then maybe we need to re-think about the backport
> > implementation.
> > The backport shouldn't affect the upstream. It were never affected until
> > the
> > recent i2c backport. Even the 2.4 i2c backport didn't interfere upstream,
> > even
> > having a completely different implementation on 2.4.
> >
> >> The only reasonable criterium I see is technical: when you start to
> >> introduce cruft into the kernel just to support older kernels, then it
> >> is
> >> time to cut off support to those kernels.
> >
> > The criteria for backport is not technical. It is all about offering a
> > version
> > that testers with standard distros can use it, without needing to use the
> > latest -rc kernel.
> >
> > I'm fine to drop support to unused kernels, but the hole idea to have
> > backport
> > is to allow an easy usage of the newer drivers by users with their
> > environment.
> > If we start removing such code, due to any other criteria different than
> > having
> > support for kernels that people are still using on their desktop and
> > enterprise
> > environments, then it is time to forget about -hg and use -git instead,
> > supporting only the latest tip kernel, just like almost all other
> > maintainers
> > do.
> 
> Yes please!
> 
> > While we are stick on have backport, we need at least to support the
> > latest
> > desktop and enterprise kernel versions of the major distros.
> >
> > So, it is a matter of deciding what we want:
> > 	keep our current criteria of offering backport kernels that include
> > 	at least the kernel version used on the major desktop and enterprise
> > 	kernel distros
> > OR
> > 	just use -git and drop all backport code.
> >
> > Both solutions work for me, although I prefer to keep backport, even
> > having more trouble[1].
> >
> > Anything else and we will enter of a grey area that will likely go
> > nowhere.
> >
> > [1] Side note: i2c is not the only subsystem whose changes affect our
> > tree. I
> > have on my TODO list a backport on dvbnet, due to some net changes at
> > 2.6.29-rc:
> >
> > $ diffstat /tmp/diff
> >  dvb_net.c |   57
> > ++++++++++++++++++++++++++++-----------------------------
> >  1 file changed, 28 insertions(+), 29 deletions(-)
> >
> > In this case, several data that used to be stored on one struct moved to
> > another.
> > So, if applied as-is, it will just break support for all kernels lower
> > than 2.6.29 on all drivers that supports DVB. On the other hand, our -hg
> > trees don't work with 2.6.29-rc.
> 
> This really proves my point, I think: it's not our business to do this
> sort of work. Our model is outdated. Consider also that several years ago
> v4l-dvb was considerably smaller and easier to maintain. It has grown
> substantially with more devices coming in all the time. The old model IMHO
> no longer scales to this rate of development.

Ok. Then, please start a RFC thread about this. Let's see the views of the
other community members.

Cheers,
Mauro
