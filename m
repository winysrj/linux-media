Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60515 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2LKMTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 07:19:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
Date: Tue, 11 Dec 2012 13:20:32 +0100
Message-ID: <3191306.PADCPVeiLd@avalon>
In-Reply-To: <201212111250.21158.hverkuil@xs4all.nl>
References: <201212101407.09338.hverkuil@xs4all.nl> <20121211082930.5f851888@redhat.com> <201212111250.21158.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 December 2012 12:50:21 Hans Verkuil wrote:
> I've added a few quick remarks below. I'll collect all the very useful
> feedback on Friday and post a new version. After that I'm on vacation
> for three weeks.
> 
> On Tue 11 December 2012 11:29:30 Mauro Carvalho Chehab wrote:
> > Em Tue, 11 Dec 2012 00:52:39 +0100 Laurent Pinchart escreveu:
> > > On Monday 10 December 2012 16:33:13 Mauro Carvalho Chehab wrote:
> > > > Em Mon, 10 Dec 2012 14:07:09 +0100 Hans Verkuil escreveu:

[snip]

> > > > > Submitting New Media Drivers
> > > > > ============================
> > > > > 
> > > > > When submitting new media drivers for inclusion in
> > > > > drivers/staging/media all that is required is that the driver
> > > > > compiles with the latest kernel and that an entry is added to the
> > > > > MAINTAINERS file
> > > > 
> > > > Please add:
> > > > 	"and what is missing there for it to be promoted to be a main driver
> > > >   is documented at the TODO file.
> > > > 
> > > > 	It should be noticed, however, that it is expected that the driver
> > > > 
> > > > will be fixed to fulfill the requirements for upstream addition. If a
> > > > driver at staging lacks relevant patches fixing it for more than a
> > > > kernel cycle, it can be dropped without further notice."
> > > 
> > > Maybe a single kernel cycle is a bit too strict. The unexpected can
> > > happen, so let's not be too harsh.
> > 
> > The above is not saying that it should be fixed on one kernel cycle. It
> > says, instead, that drivers without relevant changes during a cycle can
> > be dropped. We'll likely not enforce it too hard, except if we notice
> > some sort of bad faith from the driver's maintainer.
> > 
> > > And I'm pretty sure we'll always send a notice.
> > 
> > The "notice" will likely be just a patch to the ML c/c the driver's
> > maintainer and the mailing list. As the driver's maintainer email's
> > address might have changed, and/or he might not be subscribed at the ML,
> > it may happen that such email will never reach him.
> > 
> > So, the "it can be dropped without further notice" wording is meant to
> > avoid later complains that from driver's maintainer that he was not
> > warned. It also passes the idea that no ack from the driver's maintainer
> > is needed/expected on such patch.
> > 
> > If you think it is badly written, feel free to change it, but keeping this
> > idea.
> > 
> > > > > For inclusion as a non-staging driver the requirements are more
> > > > > strict:
> > > > > 
> > > > > General requirements:
> > > > > 
> > > > > - It must pass checkpatch.pl, but see the note regarding
> > > > >   interpreting the output from checkpatch below.
> > > > > 
> > > > > - An entry for the driver is added to the MAINTAINERS file.
> > > > 
> > > > Please add:
> > > >   - Properly use the kernel internal APIs;
> > > >   - Should re-invent the wheel, by adding new defines, math logic, etc
> > > >     that already exists in the Kernel;
> > > 
> > > Should *not* ? :-)
> > 
> > Gah... Yeah, it should read, instead: "shouldn't".
> > 
> > > >   - Errors should be reported as negative numbers, using the Kernel
> > > >     error codes;
> > > 
> > > CodingStyle, chapter 16 (although not as clearly stated).
> > 
> > Yes, I know. Yet, this is one of the most frequent bad things we notice on
> > code from new developers. IMHO, it doesn't hurt to explicitly say it here,
> > likely pointing to the CodingStyle corresponding chapter.
> > 
> > > >   - typedefs should't be used;
> > > 
> > > CodingStyle, chapter 5.
> 
> Surprisingly this chapter doesn't mention typedefs for function pointers.
> Those are very hard to manage without a typedef.

Agreed.

> > Same as above: that's the second most frequent bad thing. It seems that
> > windows-way is to create typedefs for each struct and return positive,
> > driver-specific return codes. At least I saw the very same pattern on all
> > windows drivers I looked.
> > 
> > > > > V4L2 specific requirements:
> > > > > 
> > > > > - Use struct v4l2_device for bridge drivers, use struct v4l2_subdev
> > > > >   for sub-device drivers.
> > > > 
> > > > Please add:
> > > >   - each I2C chip should be mapped as a separate sub-device driver;
> > > >   
> > > > > - Use the control framework for control handling.
> > > > > - Use struct v4l2_fh if the driver supports events (implied by the
> > > > >   use of controls) or priority handling.
> > > > > 
> > > > > - Use videobuf2 for buffer handling. Mike Krufky will look into
> > > > >   extending vb2 to support DVB buffers. Note: using vb2 for VBI
> > > > >   devices has not been tested yet, but it should work. Please
> > > > >   contact the mailinglist in case of problems with that.
> > > > > 
> > > > > - Must pass the v4l2-compliance tests.
> > > > 
> > > > Please add:
> > > >  - hybrid tuners should be shared with DVB;
> > > >  
> > > > > DVB specific requirements:
> > > >  - Use the DVB core, for both internal and external APIs;
> > > >  - Each I2C-based chip should have its own driver;
> > > >  - Tuners and frontends should be mapped as different drivers;
> > > >  - hybrid tuners should be shared with V4L;
> 
> Should something be mentioned with regards to DVBv5 and using
> GET/SET_PROPERTY?

[snip]

> > > > > Reviewed-by/Acked-by
> > > > > ====================
> > > > > 
> > > > > Within the media subsystem there are three levels of maintainership:
> > > > > Mauro Carvalho Chehab is the maintainer of the whole subsystem and
> > > > > the DVB/V4L/IR/Media Controller core code in particular, then there
> > > > > are a number of submaintainers for specific areas of the subsystem:
> > > > > 
> > > > > - Kamil Debski: codec (aka memory-to-memory) drivers
> > > > > - Hans de Goede: non-UVC USB webcam drivers
> > > > > - Mike Krufky: frontends/tuners/demodulators In addition he'll be
> > > > >   the reviewer for DVB core patches.
> > > > 
> > > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > > everything, and because we're welcoming others to also review it.
> > > 
> > > Maybe "the core reviewer" or "the main reviewer" ? Everybody is of
> > > course welcome to review patches, the point here is to state who a good
> > > contact person is when a patch doesn't get reviewed.
> > 
> > Well, having the name there as a reviewer is enough to say that the person
> > is a good contact when a patch doesn't get reviewed.
> > 
> > When we point that responsibility to a single person, I'm afraid that
> > the message passed is that he is the sole/main responsible for reviewing
> > core changes, and this is not the case, as it is everybody's
> > responsibility to review v4l/dvb/media controller core changes
> 
> True, but I think it is a good idea to have a main reviewer assigned whose
> Acked-by you definitely need. Sure, I can ack a DVB core patch, but that
> carries a lot less weight than if Mike acks it.

I'm a bit unsure here. For instance I of course welcome your Acked-by on my 
patches, but as you're listed as the reviewer for V4L2 drivers, would that be 
required for an OMAP3 ISP patch that fixes a device-related issue ? I don't 
expect you to become an expert on device-specific parts of all V4L2 drivers 
:-)

> > > > > - Guennadi Liakhovetski: soc-camera drivers
> > > > > - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the
> > > > >   reviewer for Media Controller core patches.
> > > > 
> > > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > > everything, and because we're welcoming others to also review it.
> > > 
> > > Ditto.
> > > 
> > > > > - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers
> > > > >   (aka video receivers and transmitters). In addition he'll be the
> > > > >   reviewer for V4L2 core patches.
> > > > 
> > > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > > everything, and because we're welcoming others to also review it.
> > > 
> > > Ditto.
> > > 
> > > > > Finally there are maintainers for specific drivers. This is
> > > > > documented in the MAINTAINERS file.
> > > > > 
> > > > > When modifying existing code you need to get the
> > > > > Reviewed-by/Acked-by of the maintainer of that code. So CC that
> > > > > maintainer when posting patches. If said maintainer is unavailable
> > > > > then the submaintainer or even Mauro can accept it as well, but that
> > > > > should be the exception, not the rule.
> > > > > 
> > > > > Once patches are accepted they will flow through the git tree of the
> > > > > submaintainer to the git tree of the maintainer (Mauro) who will do
> > > > > a final review.
> > > > > 
> > > > > There are a few exceptions: code for certain platforms goes through
> > > > > git trees specific to that platform. The submaintainer will still
> > > > > review it and add a acked-by or reviewed-by line, but it will not go
> > > > > through the submaintainer's git tree.
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
> > > Some of those (OMAP2 and OMAP3 at least) are really single drivers. I'm
> > > not sure whether we need to list them as platforms.
> > 
> > We're currently handling all those Nokia/TI drivers as one "platform set"
> > of drivers and waiting for Prabhakar to merge them on his tree and submit
> > via git pull request
> 
> That's only for the davinci code. Prabhakar doesn't handle omap3, that's a
> single driver at the moment. Ideally there would be an omap directory where
> TI would maintain the omap family, but we all know that's not the case.

Indeed. OMAP4/5 won't be supported unless someone finds time to work on the 
driver, and if I'm not mistaken there will be no OMAP6+.

> I guess we have just two 'SoC-family' maintainers: Prabhakar for davinci,
> and Sylwester for s5p/exynos.
> 
> One thing that we might want to add here is that submaintainers can submit
> patches for the drivers that they maintain through their own git tree.
> 
> I.e., Laurent maintains omap3, but strictly speaking that would have to go
> through my git tree. But I think that's silly, all that is needed is my
> Acked-by.
> 
> What do you think?

I agree, driver maintainers with a git tree should send pull requests directly 
to Mauro. There's not much point in adding an intermediate git tree there, we 
don't have enough driver maintainers who send pull requests.

> > , just like all s5p/exynos stuff, where Sylwester is acting
> > as a sub-maintainer.
> > 
> > So, either someone has to explicitly say otherwise, or we should document
> > it here.
> > 
> > > > > In case patches touch on areas that are the responsibility of
> > > > > multiple submaintainers, then they will decide among one another who
> > > > > will merge the patches.
> > > > > 
> > > > > 
> > > > > Patchwork
> > > > > =========
> > > > > 
> > > > > Patchwork is an automated system that takes care of all posted
> > > > > patches. It can be found here:
> > > > > http://patchwork.linuxtv.org/project/linux-media/list/
> > > > > 
> > > > > If your patch does not appear in patchwork after [TBD], then check
> > > > > if you used the right patch tags and if your patch is formatted
> > > > > correctly (no HTML, no mangled lines).
> > > > 
> > > > s/[TBD]/a couple minutes/
> > > > 
> > > > Please add:
> > > > 	Unfortunately, patchwork currently doesn't send you any email when a
> > > > 	patch successfully arrives there.
> > > > 
> > > > (perhaps Laurent could take a look on this for us?)
> > > 
> > > Sure. Do you have a list of features you would like to see implemented
> > > in patchwork ? I can't look at that before January though.
> > 
> > We can work on it together on such lists. The ones I remember right now
> > are:
> > 	- confirmation email when a patch is successfully added;
> > 	- allow patch submitters to change the status of their own patches,
> > 	  in order to allow them to mark obsoleted/superseeded patches as such;
> > 	
> > 	- create some levels of ACL on patchwork, in order to make delegations
> > 	  work, e. g. let the maintainer/sub-maintainers to send a patch to
> > 	  a driver maintainer, while keeping control about what's happening
> > 	  with a delegated patch.
> 
> - detect the tags described in this document and set the patchwork state
> accordingly.
> - not sure if this is possible: if a v2 patch series is posted, then
> automatically remove v1. This would require sanity checks: same subject,
> same author.

There's a security issue here as it's easy to spoof a sender e-mail address, 
but I don't think that we need to care about it.

-- 
Regards,

Laurent Pinchart

