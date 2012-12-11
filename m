Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2LKOcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 09:32:53 -0500
Date: Tue, 11 Dec 2012 12:31:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: First draft of guidelines for submitting patches to
 linux-media
Message-ID: <20121211123107.7f028468@redhat.com>
In-Reply-To: <201212111250.21158.hverkuil@xs4all.nl>
References: <201212101407.09338.hverkuil@xs4all.nl>
	<3944995.8KQFg2P9gX@avalon>
	<20121211082930.5f851888@redhat.com>
	<201212111250.21158.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Dec 2012 12:50:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > > 
> > > >   - typedefs should't be used;
> > > 
> > > CodingStyle, chapter 5.
> 
> Surprisingly this chapter doesn't mention typedefs for function pointers.
> Those are very hard to manage without a typedef.

It seems you detected a potential patch for CodingStyle ;)

Anyway, this one of the exceptions that would be accepted. Very unlikely
to have it at driver level anyway, as function pointers is more used at
the core handlers.

> > > > > DVB specific requirements:
> > > >  - Use the DVB core, for both internal and external APIs;
> > > >  - Each I2C-based chip should have its own driver;
> > > >  - Tuners and frontends should be mapped as different drivers;
> > > >  - hybrid tuners should be shared with V4L;
> 
> Should something be mentioned with regards to DVBv5 and using GET/SET_PROPERTY?

The DVB internal API already enforces it. There's only one thing
that could be miss-filled due to DVBv3. So, please add:

- dvb_frontend_ops should specify the delivery system, instead of
  specifying the frontend type via dvb_frontend_ops info.type field.

You can also add:

- DVB frontends should not implement dummy function handlers; if the
  function is not implemented, the DVB core should be handled it
  properly.

...

> > When we point that responsibility to a single person, I'm afraid that
> > the message passed is that he is the sole/main responsible for reviewing 
> > core changes, and this is not the case, as it is everybody's responsibility 
> > to review v4l/dvb/media controller core changes
> 
> True, but I think it is a good idea to have a main reviewer assigned whose
> Acked-by you definitely need. Sure, I can ack a DVB core patch, but that
> carries a lot less weight than if Mike acks it.

I think you'll likely be surprised if you play a little bit with
get_maintainer.pl under the DVB tree. For example:

$ ./scripts/get_maintainer.pl -f --git-blame drivers/media/dvb-core/dvb_ca_en50221.c
Mauro Carvalho Chehab <mchehab@redhat.com> (maintainer:MEDIA INPUT INFRA...,commit_signer:2/2=100%,commits:18/24=75%)
Andrew de Quincey <adq_dvb@lidskialf.net> (authored lines:41/172=24%,commits:3/24=12%)
Matthias Dahl <devel@mortal-soul.de> (authored lines:21/172=12%)
Johannes Stezenbach <js@linuxtv.org> (authored lines:19/172=11%,commits:3/24=12%)
Harvey Harrison <harvey.harrison@gmail.com> (authored lines:18/172=10%)
Robert Schedel <r.schedel@yahoo.de> (authored lines:16/172=9%)
Andrew Morton <akpm@osdl.org> (commits:7/24=29%)
Oliver Endriss <o.endriss@gmx.de> (commits:6/24=25%)
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
linux-kernel@vger.kernel.org (open list)

So, your ack for a patch at dvb_ca_en50221.c is as good as Mike's one,
as none of you ever touched there, according with git blame.

> > > > > - Guennadi Liakhovetski: soc-camera drivers
> > > > > - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the
> > > > >   reviewer for Media Controller core patches.
> > > > 
> > > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > > everything, and because we're welcoming others to also review it.
> > > 
> > > Ditto.
> > > 
> > > > > - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka
> > > > >   video receivers and transmitters). In addition he'll be the reviewer for
> > > > >   V4L2 core patches.
> > > > 
> > > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > > everything, and because we're welcoming others to also review it.
> > > 
> > > Ditto.
> > > 
> > > > > Finally there are maintainers for specific drivers. This is documented in
> > > > > the MAINTAINERS file.
> > > > > 
> > > > > When modifying existing code you need to get the Reviewed-by/Acked-by of
> > > > > the maintainer of that code. So CC that maintainer when posting patches.
> > > > > If said maintainer is unavailable then the submaintainer or even Mauro
> > > > > can accept it as well, but that should be the exception, not the rule.
> > > > > 
> > > > > Once patches are accepted they will flow through the git tree of the
> > > > > submaintainer to the git tree of the maintainer (Mauro) who will do a
> > > > > final
> > > > > review.
> > > > > 
> > > > > There are a few exceptions: code for certain platforms goes through git
> > > > > trees specific to that platform. The submaintainer will still review it
> > > > > and add a acked-by or reviewed-by line, but it will not go through the
> > > > > submaintainer's git tree.
> > > > > 
> > > > > The platform maintainers are:
> > > > > 
> > > > > TDB
> > > > 
> > > > - s5p/exynos?
> > > > - DaVinci?
> > > > - Omap3?
> > > > - Omap2?
> > > > - dvb-usb-v2?
> > > 
> > > Some of those (OMAP2 and OMAP3 at least) are really single drivers. I'm not 
> > > sure whether we need to list them as platforms.
> > 
> > We're currently handling all those Nokia/TI drivers as one "platform set" of
> > drivers and waiting for Prabhakar to merge them on his tree and submit via
> > git pull request
> 
> That's only for the davinci code. Prabhakar doesn't handle omap3, that's a single
> driver at the moment. Ideally there would be an omap directory where TI would
> maintain the omap family, but we all know that's not the case.
> 
> I guess we have just two 'SoC-family' maintainers: Prabhakar for davinci, and
> Sylwester for s5p/exynos.

Ok.

> One thing that we might want to add here is that submaintainers can submit
> patches for the drivers that they maintain through their own git tree.
> 
> I.e., Laurent maintains omap3, but strictly speaking that would have to go
> through my git tree. But I think that's silly, all that is needed is my Acked-by.
> 
> What do you think?

For drivers, I agree. For core changes through[1], I think it should be
submitted separated.

[1] Of course, very trivial core changes, like just adding a new FOURCC 
proprietary format could just follow through the driver's tree.
> 
> > , just like all s5p/exynos stuff, where Sylwester is acting
> > as a sub-maintainer.
> > 
> > So, either someone has to explicitly say otherwise, or we should document it
> > here.
> > 
> > > > > In case patches touch on areas that are the responsibility of multiple
> > > > > submaintainers, then they will decide among one another who will merge the
> > > > > patches.
> > > > > 
> > > > > 
> > > > > Patchwork
> > > > > =========
> > > > > 
> > > > > Patchwork is an automated system that takes care of all posted patches. It
> > > > > can be found here: http://patchwork.linuxtv.org/project/linux-media/list/
> > > > > 
> > > > > If your patch does not appear in patchwork after [TBD], then check if you
> > > > > used the right patch tags and if your patch is formatted correctly (no
> > > > > HTML, no mangled lines).
> > > > 
> > > > s/[TBD]/a couple minutes/
> > > > 
> > > > Please add:
> > > > 	Unfortunately, patchwork currently doesn't send you any email when a
> > > > 	patch successfully arrives there.
> > > > 
> > > > (perhaps Laurent could take a look on this for us?)
> > > 
> > > Sure. Do you have a list of features you would like to see implemented in 
> > > patchwork ? I can't look at that before January though.
> > 
> > We can work on it together on such lists. The ones I remember right now are:
> > 
> > 	- confirmation email when a patch is successfully added;
> > 	- allow patch submitters to change the status of their own patches,
> > 	  in order to allow them to mark obsoleted/superseeded patches as such;
> > 	- create some levels of ACL on patchwork, in order to make delegations
> > 	  work, e. g. let the maintainer/sub-maintainers to send a patch to
> > 	  a driver maintainer, while keeping control about what's happening
> > 	  with a delegated patch.
> 
> - detect the tags described in this document and set the patchwork state
> accordingly.
> - not sure if this is possible: if a v2 patch series is posted, then automatically
> remove v1. This would require sanity checks: same subject, same author.

IMO, It should not be that hard to do it automatically, when the reference-ID 
of the original patch is kept. If this is not the case, it is better to not
deprecate the v1, and let someone manually check it.

Regards,
Mauro
