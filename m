Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2LKK36 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 05:29:58 -0500
Date: Tue, 11 Dec 2012 08:29:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: First draft of guidelines for submitting patches to
 linux-media
Message-ID: <20121211082930.5f851888@redhat.com>
In-Reply-To: <3944995.8KQFg2P9gX@avalon>
References: <201212101407.09338.hverkuil@xs4all.nl>
 <20121210163313.424eb48d@redhat.com>
 <3944995.8KQFg2P9gX@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Dec 2012 00:52:39 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi,
> 
> On Monday 10 December 2012 16:33:13 Mauro Carvalho Chehab wrote:
> > Em Mon, 10 Dec 2012 14:07:09 +0100 Hans Verkuil escreveu:
> > > Hi all,
> > > 
> > > As discussed in Barcelona I would write a text describing requirements for
> > > new drivers and what to expect when submitting patches to linux-media.
> > > 
> > > This is a first rough draft and nothing is fixed yet.
> > > 
> > > I have a few open questions:
> > > 
> > > 1) Where to put it?
> > 
> > Maybe at media-build.git.
> 
> Not everybody uses (or is even aware of) media-build. The goal here is to make 
> sure that new driver developers will run into the guidelines before then spend 
> months writing code that can't be upstreamed. Documentation/ thus looks like a 
> good place to me.
> 
> It might be a good idea to add a reference to the guidelines in the API 
> DocBook documentation, regardless of where the guidelines end up being stored. 
> If a developer reads a single document only it will probably be the API 
> reference.

Agreed.
> 
> > I'm thinking on putting there, under devel_contrib, the main scripts I use
> > here to handle patches.
> > 
> > /me needs some time to sanitize them and add there.
> > 
> > > One thing I would propose that we improve is to move the dvb and
> > > video4linux directories in Documentation/ to Documentation/media to
> > > correctly reflect the drivers/media structure. If we do that, then we can
> > > put this document in Documentation/media/SubmittingMediaPatches.
> > 
> > Hmm... I don't see any other subsystems having their own document for that.
> > We may need to discuss it upstream before doing that, and be prepared
> > to answer why we thing sub-systems would need their own rules there.
> 
> Things like requiring the use of the control framework is obviously V4L-
> specific, we can't add that to Documentation/SubmittingPatches :-)
> 
> > In any case, I think that the better is to store it at media-build.git tree,
> > and later open such discussions upstream, if we think it is valuable
> > enough.
> >
> > > Alternatively, this is something we can document in our wiki.
> > > 
> > > 2) Are there DVB requirements as well for new drivers? We discussed a list
> > > of V4L2 requirements in Barcelona, but I wonder if there is a similar
> > > list that can be made for DVB drivers. Input on that will be welcome.
> > 
> > See below.
> > 
> > > 3) This document describes the situation we will have when the
> > > submaintainers take their place early next year. So please check if I got
> > > that part right.
> > > 
> > > 4) In Barcelona we discussed 'tags' for patches to help organize them.
> > > I've made a proposal for those in this document. Feedback is very welcome.
> > > 
> > > 5) As discussed in Barcelona there will be git tree maintainers for
> > > specific platforms, but we didn't really go into detail who would be
> > > responsible for which platform. If you want to maintain a particular
> > > platform, then please let me know.
> > > 
> > > 6) The patchwork section is very short at the moment. It should be
> > > extended
> > > when patchwork gets support to recognize the various tags.
> > > 
> > > 7) Anything else that should be discussed here?
> > > 
> > > Again, remember that this is a rough draft only, so be gentle with me :-)
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > > 
> > > --------------------------- cut here -------------------------------
> > > 
> > > General Information
> > > ===================
> > > 
> > > For general information on how to submit patches see:
> > > 
> > > http://linuxtv.org/wiki/index.php/Developer_Section
> > > 
> > > In particular the section 'Submitting Your Work'.
> > > 
> > > This document goes into more detail regarding media specific requirements
> > > when submitting patches and what the patch flow looks like in this
> > > subsystem.
> >
> > I think we should add a paragraph here saying that rules may have
> > exceptions, when there's a clear reason why a certain submission should need
> > a different criteria.
> 
> I agree. For instance the uvcvideo driver doesn't use the control framework, 
> and has good reasons not to. This must be the exception rather than the rule, 
> but we might have more than one exception.

Yes.

> 
> > Also, IMHO, we should add a notice that this list is not exhaustive, and may
> > be changed, keeping it for at least one or two Kernel cycles, while it
> > doesn't get proofed/matured, as I'm sure we'll forget things.
> > 
> > > Submitting New Media Drivers
> > > ============================
> > > 
> > > When submitting new media drivers for inclusion in drivers/staging/media
> > > all that is required is that the driver compiles with the latest kernel
> > > and that an entry is added to the MAINTAINERS file
> > 
> > Please add:
> > 
> > 	"and what is missing there for it to be promoted to be a main driver
> > is documented at the TODO file.
> > 
> > 	It should be noticed, however, that it is expected that the driver
> > will be fixed to fulfill the requirements for upstream addition. If a
> > driver at staging lacks relevant patches fixing it for more than a
> > kernel cycle, it can be dropped without further notice."
> 
> Maybe a single kernel cycle is a bit too strict. The unexpected can happen, so 
> let's not be too harsh.

The above is not saying that it should be fixed on one kernel cycle. It says,
instead, that drivers without relevant changes during a cycle can be dropped.
We'll likely not enforce it too hard, except if we notice some sort of bad
faith from the driver's maintainer.

> And I'm pretty sure we'll always send a notice.

The "notice" will likely be just a patch to the ML c/c the driver's maintainer
and the mailing list. As the driver's maintainer email's address might have 
changed, and/or he might not be subscribed at the ML, it may happen that such
email will never reach him.

So, the "it can be dropped without further notice" wording is meant to
avoid later complains that from driver's maintainer that he was not
warned. It also passes the idea that no ack from the driver's maintainer is
needed/expected on such patch.

If you think it is badly written, feel free to change it, but keeping this
idea.

> 
> > > For inclusion as a non-staging driver the requirements are more strict:
> > > 
> > > General requirements:
> > > 
> > > - It must pass checkpatch.pl, but see the note regarding interpreting the
> > >   output from checkpatch below.
> > > 
> > > - An entry for the driver is added to the MAINTAINERS file.
> > 
> > Please add:
> >   - Properly use the kernel internal APIs;
> >   - Should re-invent the wheel, by adding new defines, math logic, etc that
> >     already exists in the Kernel;
> 
> Should *not* ? :-)

Gah... Yeah, it should read, instead: "shouldn't". 

> 
> >   - Errors should be reported as negative numbers, using the Kernel error
> >     codes;
> 
> CodingStyle, chapter 16 (although not as clearly stated).

Yes, I know. Yet, this is one of the most frequent bad things we notice on
code from new developers. IMHO, it doesn't hurt to explicitly say it here,
likely pointing to the CodingStyle corresponding chapter.

> 
> >   - typedefs should't be used;
> 
> CodingStyle, chapter 5.

Same as above: that's the second most frequent bad thing. It seems that
windows-way is to create typedefs for each struct and return positive,
driver-specific return codes. At least I saw the very same pattern on all
windows drivers I looked.
 
> > > V4L2 specific requirements:
> > > 
> > > - Use struct v4l2_device for bridge drivers, use struct v4l2_subdev for
> > >   sub-device drivers.
> > 
> > Please add:
> >   - each I2C chip should be mapped as a separate sub-device driver;
> > 
> > > - Use the control framework for control handling.
> > > - Use struct v4l2_fh if the driver supports events (implied by the use of
> > >   controls) or priority handling.
> > > 
> > > - Use videobuf2 for buffer handling. Mike Krufky will look into extending
> > >   vb2 to support DVB buffers. Note: using vb2 for VBI devices has not been
> > >   tested yet, but it should work. Please contact the mailinglist in case
> > >   of problems with that.
> > > 
> > > - Must pass the v4l2-compliance tests.
> > 
> > Please add:
> >  - hybrid tuners should be shared with DVB;
> > 
> > > DVB specific requirements:
> >  - Use the DVB core, for both internal and external APIs;
> >  - Each I2C-based chip should have its own driver;
> >  - Tuners and frontends should be mapped as different drivers;
> >  - hybrid tuners should be shared with V4L;
> > 
> > > How to deal with checkpatch.pl?
> > > ===============================
> > > 
> > > First of all, the requirement to comply to the kernel coding style is
> > > there for a reason. Sometimes people feel that it is a pointless
> > > exercise: after all, code is code, right? Why would just changing some
> > > spacing improve it?
> > > 
> > > But the coding style is not there to help you (at least, not directly), it
> > > is there to help those who have to review and/or maintain your code as it
> > > takes a lot of time to review code or try to figure out how someone
> > > else's code works. By at least ensuring that the coding style is
> > > consistent with other code we can concentrate on what humans to best:
> > > pattern matching. Ever read a book or article that did not use the
> > > correct spelling, grammar and/or punctuation rules? Did you notice how
> > > your brain 'stumbles' whenever it encounters such mistakes? It makes the
> > > text harder to understand and slower to read. The same happens with code
> > > that does not comply to the conventions of the project and it is the
> > > reason why most large projects, both open source and proprietary, have a
> > > coding style.
> > > 
> > > However, when interpreting the checkpatch output it is good to remember
> > > that it is just an automated tool and there are cases where what
> > > checkpatch recommends does not actually results in the best readable
> > > code. This is particularly true for the line length warnings. A warning
> > > that a line is 82 characters long can probably be ignored, since breaking
> > > up such a line will usually make the code harder to understand. A warning
> > > that a line is 101 characters long definitely needs attention, since
> > > that's an indication that the line is really too long.
> > I wouldn't say that, as people will likely read that an 82 chars long line
> > should be ignored ;)
> > 
> > IMHO, the better is to give some examples for this specific warning (for
> > example: function calls and function declarations with more than 80 chars
> > should likely be broken, even if they have 81 columns; lines with an string
> > at the end should likely not be broken, even if it has more than 80
> > columns, etc).
> 
> Agreed.
> 
> > > The guideline here is to check such warnings, but use common sense whether
> > > or not to fix them.
> > > 
> > > Please do run checkpatch before posting any code to the mailinglist. Code
> > > that clearly violates the kernel coding style will be rejected and you
> > > will be asked to repost after fixing the style. We are not going to waste
> > > time trying to review code that uses a non-standard coding style, our
> > > time is too limited for that.
> > > 
> > > The sole exception are staging drivers as the only rule there is that it
> > > compiles.
> > > 
> > > 
> > > Timeline for code submissions
> > > =============================
> > > 
> > > After a new kernel is released the merge window will be open for about two
> > > weeks
> > 
> > Please add:
> > 	"for the maintainers to send him the patches they already received
> 
> "him" ? I suppose you mean Linus :-)

Yes. Maybe it can be changed from "send him" to "send upstream".
> 
> > during the last development cycle, and that went into the linux-next tree
> > in time for the other maintainers and reviewers to double-check the entire
> > set of changes for the next Linux version."
> > 
> > (yeah, I know you're talking more about it later, but I think this makes it
> > a little clearer that no submissions will typically be accepted so late at
> > the development cycle).
> > 
> > > During that time Linus will merge any pending work for the next kernel.
> > > Once that merge window is closed only regression fixes and serious bug
> > > fixes will be accepted, everything else will be postponed
> > 
> > please add:
> > 	"upstream"
> 
> postponed upstream ? What do you mean ?

This is just a small correction, but maybe it can be a little more verbose.

What I meant to say is that, after the merge window, the patches will be 
"postponed for upstream merge until the next merge window".

The original text could give the impression that even at the subsystem
submaintainers/maintainers tree, the patches will be merged only during
a merge window.

> 
> > > until the next merge window.
> > > 
> > > In addition, before anything can be merged (regardless of whether this is
> > > during the merge window or not) the new code should have been in the
> > > linux-next tree for about a week at minimum to ensure there are no
> > > conflicts with work being done in other kernel subsystems.
> > > 
> > > Furthermore, before code can be added to linux-next it has to be reviewed
> > > first.  This will take time as well. Adding everything up this means that
> > > if you want your code to be merged for the next kernel you should have it
> > > posted to the linux-media mailinglist no later than rc5 of the current
> > > kernel, or it may be too late. In fact, the earlier the better since
> > > reviews will take time, and if corrections need to be made you may have
> > > to do several review/submit cycles.
> > > 
> > > Remember that the core media developers have a job as well, and so won't
> > > always have the time to review immediately. A general rule of thumb is to
> > > post a reminder if a full week has passed without receiving any feedback.
> > > There is a fair amount of traffic on the mailinglist and it wouldn't be
> > > the first time that a patch was missed by reviewers.
> > > 
> > > One consequence of this is that as submitter you can get into the
> > > situation that you post something, two weeks later you get a review, you
> > > post the corrected version, you get more reviews 10 days later, etc. So it
> > > can be a drawn-out process. This can be frustrating, but please stick with
> > > it.
> > 
> > Please add:
> > 	"The reason for these measures is to warrant, in our best, that no
> > regressions will be added into the Kernel, keeping it with a high quality,
> > and, yet, allowing to release a new Kernel on every 7-9 weeks."
> > 
> > > We have seen cases where people seem to give up, but that is not our
> > > intention. We welcome new code, but since none of the core developers work
> > > full time on this we are constrained by the time we have available. Just
> > > be aware of this, plan accordingly and don't give up.
> > > 
> > > 
> > > Contacting developers
> > > =====================
> > > 
> > > The linux-media mailinglist is the central place to get into contact with
> > > developers. However, there are also two irc channels: #linuxtv (mostly DVB
> > > related) and #v4l (mostly V4L related). Most developers are based in the
> > > US or in Europe, so take those timezones into account.
> > 
> > I would add there:
> > 
> > 	"If you ask something at the IRC channel, please wait for your
> > answer, as it may take some time for a developer to be able to find a
> > timeslot to answer you".
> > 
> > > Finally, you can often find developers during the three main Linux
> > > conferences relevant to us: the Linux Plumbers Conference, the Embedded
> > > Linux Conference and the Embedded Linux Conference Europe.
> > 
> > I would say (maybe instead) to the Media mini-summits that happen typically
> > together with one major Linux Foundation conference (typically either in
> > Europe or US), like the Linux Plumbers Conference, the Embedded Linux
> > Conference and/or the Embedded Linux Conference Europe.
> > 
> > > Patch tags
> > > ==========
> > > 
> > > When posting patches it is recommended to tag them to help us sort through
> > > them quickly and efficiently.
> > > 
> > > The tags are:
> > > 
> > > [RFC PATCH x/y]: use this for preliminary patches for which you want to
> > > get some early feedback.
> > > 
> > > [REVIEW PATCH x/y]: use this for patches that you consider OK for merging,
> > > but that need to be reviewed.
> > > 
> > > Once your patches have been reviewed/acked you can post either a pull
> > > request ("[GIT PULL]") or use the "[FINAL PATCH x/y]" tag if you don't
> > > have a public git tree.
> > > 
> > > If you post a new version of a patch series, then add 'v1', 'v2', etc. to
> > > the RFC or REVIEW word, e.g.: "[RFCv2 PATCH x/y]".
> > > 
> > > If your patch is for the current rc kernel (so it is a regression or
> > > serious bug fix), then add " FOR v3.x" after the PATCH or PULL keyword.
> > > For example: "[REVIEW PATCH FOR v3.7 x/y]", or "[GIT PULL FOR v3.7]".
> > > 
> > > You can use the option --subject-prefix="REVIEW PATCHv1" with the 'git
> > > send-email' to specify the prefix.
> > > 
> > > Patches without the appropriate tags will be processed manually, which
> > > will take more time and may actually cause them to be dropped altogether.
> > > 
> > > 
> > > Reviewed-by/Acked-by
> > > ====================
> > > 
> > > Within the media subsystem there are three levels of maintainership: Mauro
> > > Carvalho Chehab is the maintainer of the whole subsystem and the
> > > DVB/V4L/IR/Media Controller core code in particular, then there are a
> > > number of submaintainers for specific areas of the subsystem:
> > > 
> > > - Kamil Debski: codec (aka memory-to-memory) drivers
> > > - Hans de Goede: non-UVC USB webcam drivers
> > > - Mike Krufky: frontends/tuners/demodulators In addition he'll be the
> > >   reviewer for DVB core patches.
> > 
> > I'll change it to "a reviewer", as perhaps he won't be able to review
> > everything, and because we're welcoming others to also review it.
> 
> Maybe "the core reviewer" or "the main reviewer" ? Everybody is of course 
> welcome to review patches, the point here is to state who a good contact 
> person is when a patch doesn't get reviewed.

Well, having the name there as a reviewer is enough to say that the person
is a good contact when a patch doesn't get reviewed. 

When we point that responsibility to a single person, I'm afraid that
the message passed is that he is the sole/main responsible for reviewing 
core changes, and this is not the case, as it is everybody's responsibility 
to review v4l/dvb/media controller core changes
> 
> > > - Guennadi Liakhovetski: soc-camera drivers
> > > - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the
> > >   reviewer for Media Controller core patches.
> > 
> > I'll change it to "a reviewer", as perhaps he won't be able to review
> > everything, and because we're welcoming others to also review it.
> 
> Ditto.
> 
> > > - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka
> > >   video receivers and transmitters). In addition he'll be the reviewer for
> > >   V4L2 core patches.
> > 
> > I'll change it to "a reviewer", as perhaps he won't be able to review
> > everything, and because we're welcoming others to also review it.
> 
> Ditto.
> 
> > > Finally there are maintainers for specific drivers. This is documented in
> > > the MAINTAINERS file.
> > > 
> > > When modifying existing code you need to get the Reviewed-by/Acked-by of
> > > the maintainer of that code. So CC that maintainer when posting patches.
> > > If said maintainer is unavailable then the submaintainer or even Mauro
> > > can accept it as well, but that should be the exception, not the rule.
> > > 
> > > Once patches are accepted they will flow through the git tree of the
> > > submaintainer to the git tree of the maintainer (Mauro) who will do a
> > > final
> > > review.
> > > 
> > > There are a few exceptions: code for certain platforms goes through git
> > > trees specific to that platform. The submaintainer will still review it
> > > and add a acked-by or reviewed-by line, but it will not go through the
> > > submaintainer's git tree.
> > > 
> > > The platform maintainers are:
> > > 
> > > TDB
> > 
> > - s5p/exynos?
> > - DaVinci?
> > - Omap3?
> > - Omap2?
> > - dvb-usb-v2?
> 
> Some of those (OMAP2 and OMAP3 at least) are really single drivers. I'm not 
> sure whether we need to list them as platforms.

We're currently handling all those Nokia/TI drivers as one "platform set" of
drivers and waiting for Prabhakar to merge them on his tree and submit via
git pull request, just like all s5p/exynos stuff, where Sylwester is acting
as a sub-maintainer.

So, either someone has to explicitly say otherwise, or we should document it
here.

> > > In case patches touch on areas that are the responsibility of multiple
> > > submaintainers, then they will decide among one another who will merge the
> > > patches.
> > > 
> > > 
> > > Patchwork
> > > =========
> > > 
> > > Patchwork is an automated system that takes care of all posted patches. It
> > > can be found here: http://patchwork.linuxtv.org/project/linux-media/list/
> > > 
> > > If your patch does not appear in patchwork after [TBD], then check if you
> > > used the right patch tags and if your patch is formatted correctly (no
> > > HTML, no mangled lines).
> > 
> > s/[TBD]/a couple minutes/
> > 
> > Please add:
> > 	Unfortunately, patchwork currently doesn't send you any email when a
> > 	patch successfully arrives there.
> > 
> > (perhaps Laurent could take a look on this for us?)
> 
> Sure. Do you have a list of features you would like to see implemented in 
> patchwork ? I can't look at that before January though.

We can work on it together on such lists. The ones I remember right now are:

	- confirmation email when a patch is successfully added;
	- allow patch submitters to change the status of their own patches,
	  in order to allow them to mark obsoleted/superseeded patches as such;
	- create some levels of ACL on patchwork, in order to make delegations
	  work, e. g. let the maintainer/sub-maintainers to send a patch to
	  a driver maintainer, while keeping control about what's happening
	  with a delegated patch.

> > > Whenever you patch changes state you'll get an email informing you about
> > > that.
> >
> > Patchwork has an opt-out way to disable those notifications. While I expect
> > that nobody would opt-out, I think we should mention it, as patchwork is
> > not a spammer: it only sends email only to track the status of a patch, and
> > only after its submission. Also, it offers a way to opt-out of such
> > notifications.
> 


-- 

Cheers,
Mauro
