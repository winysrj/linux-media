Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38619 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LKLhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 06:37:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
Date: Tue, 11 Dec 2012 12:39:06 +0100
Message-ID: <2502950.OyW8g4kHxL@avalon>
In-Reply-To: <20121211082930.5f851888@redhat.com>
References: <201212101407.09338.hverkuil@xs4all.nl> <3944995.8KQFg2P9gX@avalon> <20121211082930.5f851888@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 11 December 2012 08:29:30 Mauro Carvalho Chehab wrote:
> Em Tue, 11 Dec 2012 00:52:39 +0100 Laurent Pinchart escreveu:
> > On Monday 10 December 2012 16:33:13 Mauro Carvalho Chehab wrote:
> > > Em Mon, 10 Dec 2012 14:07:09 +0100 Hans Verkuil escreveu:

[snip]

> > > > Submitting New Media Drivers
> > > > ============================
> > > > 
> > > > When submitting new media drivers for inclusion in
> > > > drivers/staging/media all that is required is that the driver compiles
> > > > with the latest kernel and that an entry is added to the MAINTAINERS
> > > > file
> > > 
> > > Please add:
> > > 	"and what is missing there for it to be promoted to be a main driver
> > > 
> > > is documented at the TODO file.
> > > 
> > > 	It should be noticed, however, that it is expected that the driver
> > > 
> > > will be fixed to fulfill the requirements for upstream addition. If a
> > > driver at staging lacks relevant patches fixing it for more than a
> > > kernel cycle, it can be dropped without further notice."
> > 
> > Maybe a single kernel cycle is a bit too strict. The unexpected can
> > happen, so let's not be too harsh.
> 
> The above is not saying that it should be fixed on one kernel cycle. It
> says, instead, that drivers without relevant changes during a cycle can be
> dropped. We'll likely not enforce it too hard, except if we notice some
> sort of bad faith from the driver's maintainer.

That's my point, exactly. The text above just sounds a bit too harsh for my 
taste, it might even scare people :-) I of course share your point of view 
that we want developers to understand that they need to work on staging 
drivers and not let them rot,

> > And I'm pretty sure we'll always send a notice.
> 
> The "notice" will likely be just a patch to the ML c/c the driver's
> maintainer and the mailing list. As the driver's maintainer email's address
> might have changed, and/or he might not be subscribed at the ML, it may
> happen that such email will never reach him.
> 
> So, the "it can be dropped without further notice" wording is meant to
> avoid later complains that from driver's maintainer that he was not
> warned. It also passes the idea that no ack from the driver's maintainer is
> needed/expected on such patch.
> 
> If you think it is badly written, feel free to change it, but keeping this
> idea.

What about

"If no real effort to get a driver out of staging is noticed, the driver can 
be dropped from the kernel altogether. This policy can be applied over a 
single kernel release period and without any notice, although we will try our 
best to communicate with the driver developers and not to enforce the policy 
too harshly."

> > > > For inclusion as a non-staging driver the requirements are more
> > > > strict:
> > > > 
> > > > General requirements:
> > > > 
> > > > - It must pass checkpatch.pl, but see the note regarding interpreting
> > > >   the output from checkpatch below.
> > > > 
> > > > - An entry for the driver is added to the MAINTAINERS file.
> > > 
> > > Please add:
> > >   - Properly use the kernel internal APIs;
> > >   - Should re-invent the wheel, by adding new defines, math logic, etc
> > >   that
> > >   
> > >     already exists in the Kernel;
> > 
> > Should *not* ? :-)
> 
> Gah... Yeah, it should read, instead: "shouldn't".
> 
> > >   - Errors should be reported as negative numbers, using the Kernel
> > >   error
> > >   
> > >     codes;
> > 
> > CodingStyle, chapter 16 (although not as clearly stated).
> 
> Yes, I know. Yet, this is one of the most frequent bad things we notice on
> code from new developers. IMHO, it doesn't hurt to explicitly say it here,
> likely pointing to the CodingStyle corresponding chapter.

Maybe we could just add "Follow the CodingStyle guidelines".

> > >   - typedefs should't be used;
> > 
> > CodingStyle, chapter 5.
> 
> Same as above: that's the second most frequent bad thing. It seems that
> windows-way is to create typedefs for each struct and return positive,
> driver-specific return codes. At least I saw the very same pattern on all
> windows drivers I looked.

[snip]

> > > > Timeline for code submissions
> > > > =============================
> > > > 
> > > > After a new kernel is released the merge window will be open for about
> > > > two weeks
> > > 
> > > Please add:
> > > 	"for the maintainers to send him the patches they already received
> > 
> > "him" ? I suppose you mean Linus :-)
> 
> Yes. Maybe it can be changed from "send him" to "send upstream".
> 
> > > during the last development cycle, and that went into the linux-next
> > > tree in time for the other maintainers and reviewers to double-check the
> > > entire set of changes for the next Linux version."
> > > 
> > > (yeah, I know you're talking more about it later, but I think this makes
> > > it a little clearer that no submissions will typically be accepted so
> > > late at the development cycle).
> > > 
> > > > During that time Linus will merge any pending work for the next
> > > > kernel. Once that merge window is closed only regression fixes and
> > > > serious bug fixes will be accepted, everything else will be postponed
> > > 
> > > please add:
> > > 	"upstream"
> > 
> > postponed upstream ? What do you mean ?
> 
> This is just a small correction, but maybe it can be a little more verbose.
> 
> What I meant to say is that, after the merge window, the patches will be
> "postponed for upstream merge until the next merge window".
> 
> The original text could give the impression that even at the subsystem
> submaintainers/maintainers tree, the patches will be merged only during
> a merge window.

I got your point and I agree that this needs to be clarified.

> > > > until the next merge window.
> > > > 
> > > > In addition, before anything can be merged (regardless of whether this
> > > > is during the merge window or not) the new code should have been in
> > > > the linux-next tree for about a week at minimum to ensure there are no
> > > > conflicts with work being done in other kernel subsystems.
> > > > 
> > > > Furthermore, before code can be added to linux-next it has to be
> > > > reviewed first. This will take time as well. Adding everything up this
> > > > means that if you want your code to be merged for the next kernel you
> > > > should have it posted to the linux-media mailinglist no later than rc5
> > > > of the current kernel, or it may be too late. In fact, the earlier the
> > > > better since reviews will take time, and if corrections need to be
> > > > made you may have to do several review/submit cycles.
> > > > 
> > > > Remember that the core media developers have a job as well, and so
> > > > won't always have the time to review immediately. A general rule of
> > > > thumb is to post a reminder if a full week has passed without
> > > > receiving any feedback. There is a fair amount of traffic on the
> > > > mailinglist and it wouldn't be the first time that a patch was missed
> > > > by reviewers.
> > > > 
> > > > One consequence of this is that as submitter you can get into the
> > > > situation that you post something, two weeks later you get a review,
> > > > you post the corrected version, you get more reviews 10 days later,
> > > > etc. So it can be a drawn-out process. This can be frustrating, but
> > > > please stick with it.
> > > 
> > > Please add:
> > > 	"The reason for these measures is to warrant, in our best, that no
> > > 
> > > regressions will be added into the Kernel, keeping it with a high
> > > quality, and, yet, allowing to release a new Kernel on every 7-9 weeks."
> > > 
> > > > We have seen cases where people seem to give up, but that is not our
> > > > intention. We welcome new code, but since none of the core developers
> > > > work full time on this we are constrained by the time we have
> > > > available. Just be aware of this, plan accordingly and don't give up.

[snip]

> > > > Reviewed-by/Acked-by
> > > > ====================
> > > > 
> > > > Within the media subsystem there are three levels of maintainership:
> > > > Mauro Carvalho Chehab is the maintainer of the whole subsystem and the
> > > > DVB/V4L/IR/Media Controller core code in particular, then there are a
> > > > number of submaintainers for specific areas of the subsystem:
> > > > 
> > > > - Kamil Debski: codec (aka memory-to-memory) drivers
> > > > - Hans de Goede: non-UVC USB webcam drivers
> > > > - Mike Krufky: frontends/tuners/demodulators In addition he'll be the
> > > > 
> > > >   reviewer for DVB core patches.
> > > 
> > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > everything, and because we're welcoming others to also review it.
> > 
> > Maybe "the core reviewer" or "the main reviewer" ? Everybody is of course
> > welcome to review patches, the point here is to state who a good contact
> > person is when a patch doesn't get reviewed.
> 
> Well, having the name there as a reviewer is enough to say that the person
> is a good contact when a patch doesn't get reviewed.
> 
> When we point that responsibility to a single person, I'm afraid that the
> message passed is that he is the sole/main responsible for reviewing core
> changes, and this is not the case, as it is everybody's responsibility to
> review v4l/dvb/media controller core changes

One of the question that this section tries to answer is who the main contact 
person should be for a given part of the code. I don't want to discourage 
others from reviewing the code of course.

> > > > - Guennadi Liakhovetski: soc-camera drivers
> > > > - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the
> > > >   reviewer for Media Controller core patches.
> > > 
> > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > everything, and because we're welcoming others to also review it.
> > 
> > Ditto.
> > 
> > > > - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka
> > > >   video receivers and transmitters). In addition he'll be the reviewer
> > > >   for V4L2 core patches.
> > > 
> > > I'll change it to "a reviewer", as perhaps he won't be able to review
> > > everything, and because we're welcoming others to also review it.
> > 
> > Ditto.
> > 
> > > > Finally there are maintainers for specific drivers. This is documented
> > > > in the MAINTAINERS file.
> > > > 
> > > > When modifying existing code you need to get the Reviewed-by/Acked-by
> > > > of the maintainer of that code. So CC that maintainer when posting
> > > > patches. If said maintainer is unavailable then the submaintainer or
> > > > even Mauro can accept it as well, but that should be the exception,
> > > > not the rule.
> > > > 
> > > > Once patches are accepted they will flow through the git tree of the
> > > > submaintainer to the git tree of the maintainer (Mauro) who will do a
> > > > final review.
> > > > 
> > > > There are a few exceptions: code for certain platforms goes through
> > > > git trees specific to that platform. The submaintainer will still
> > > > review it and add a acked-by or reviewed-by line, but it will not go
> > > > through the submaintainer's git tree.
> > > > 
> > > > The platform maintainers are:
> > > > 
> > > > TDB
> > > 
> > > - s5p/exynos?
> > > - DaVinci?
> > > - Omap3?
> > > - Omap2?
> > > - dvb-usb-v2?
> > 
> > Some of those (OMAP2 and OMAP3 at least) are really single drivers. I'm
> > not sure whether we need to list them as platforms.
> 
> We're currently handling all those Nokia/TI drivers as one "platform set" of
> drivers and waiting for Prabhakar to merge them on his tree and submit via
> git pull request, just like all s5p/exynos stuff, where Sylwester is acting
> as a sub-maintainer.
> 
> So, either someone has to explicitly say otherwise, or we should document it
> here.

For DaVinci, sure, but not for OMAP2 and OMAP3. Those are separate.

> > > > In case patches touch on areas that are the responsibility of multiple
> > > > submaintainers, then they will decide among one another who will merge
> > > > the patches.
> > > > 
> > > > 
> > > > Patchwork
> > > > =========
> > > > 
> > > > Patchwork is an automated system that takes care of all posted
> > > > patches. It can be found here:
> > > > http://patchwork.linuxtv.org/project/linux-media/list/
> > > > 
> > > > If your patch does not appear in patchwork after [TBD], then check if
> > > > you used the right patch tags and if your patch is formatted correctly
> > > > (no HTML, no mangled lines).
> > > 
> > > s/[TBD]/a couple minutes/
> > > 
> > > Please add:
> > > 	Unfortunately, patchwork currently doesn't send you any email when a
> > > 	patch successfully arrives there.
> > > 
> > > (perhaps Laurent could take a look on this for us?)
> > 
> > Sure. Do you have a list of features you would like to see implemented in
> > patchwork ? I can't look at that before January though.
> 
> We can work on it together on such lists. The ones I remember right now are:
> 
> 	- confirmation email when a patch is successfully added;

I wonder whether this should be an opt-in feature. Otherwise people will by 
default get a mail for every patch they send (assuming patchwork picks up the 
patch correctly, which hopefully is what usually happens :-)).

> 	- allow patch submitters to change the status of their own patches,
> 	  in order to allow them to mark obsoleted/superseeded patches as such;

Should that be web-based, e-mail-based or both ?

> 	- create some levels of ACL on patchwork, in order to make delegations
> 	  work, e. g. let the maintainer/sub-maintainers to send a patch to
> 	  a driver maintainer, while keeping control about what's happening
> 	  with a delegated patch.

How do you envision delegation to the sub-maintainers ? Will they have open 
access to patchwork based on a high trust level ?

> > > > Whenever you patch changes state you'll get an email informing you
> > > > about that.
> > > 
> > > Patchwork has an opt-out way to disable those notifications. While I
> > > expect that nobody would opt-out, I think we should mention it, as
> > > patchwork is not a spammer: it only sends email only to track the status
> > > of a patch, and only after its submission. Also, it offers a way to opt-
> > > out of such notifications.

-- 
Regards,

Laurent Pinchart

