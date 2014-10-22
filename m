Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41691 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbaJVT5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 15:57:03 -0400
Date: Wed, 22 Oct 2014 17:56:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [REVIEW] Submitting Media Patches
Message-ID: <20141022175656.64cab0a4@recife.lan>
In-Reply-To: <5447BB4B.9000001@xs4all.nl>
References: <5447BB4B.9000001@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for doing that!

I added a few comments below.

Regards,
Mauro

Em Wed, 22 Oct 2014 16:12:27 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> During the mini-summit it was decided that we should put up a document on how
> to post/handle patches etc. for the media drivers in the wiki. I had such a
> doc already which I'm posting now for review. Once it's all OK Pawel offered
> to put it up in the wiki.
> 
> -----------------------------------------------------------------------------
> 
> For general information on how to submit patches see:
> 
> http://linuxtv.org/wiki/index.php/Developer_Section
> 
> In particular the section 'Submitting Your Work'.
> 
> This document goes into more detail regarding media specific requirements when
> submitting patches and what the patch flow looks like in this subsystem.
> 
> Note 1: there are always exceptions to the rule, so if you believe certain
> requirements do not apply to your code, then let us know and we can discuss
> it.
> 
> Note 2: this list is not exhaustive and will be updated over time, so make
> sure you always use the latest version of this document. The latest version
> will always be available here: TBD.

Just a remind: don't forget to replace TBD by something at the final
version ;)

> 
> Note 3: when submitting a patch use ./scripts/get_maintainer.pl to figure
> out who is maintaining the sources you touched.
> 
> 
> Submitting New Media Drivers
> ============================
> 
> When submitting new media drivers for inclusion in drivers/staging/media all
> that is required is that the driver compiles with the latest kernel, that an
> entry is added to the MAINTAINERS file, and that a TODO file is added with a
> list of action items that need to be taken before the driver can be moved to
> drivers/media.

I would replace "all that is required" by "the requirements are", or the
"basic requirements are". There are of course other reasons why the 
(sub)maintainers will not allow a driver to be merged at staging, but
I'm pretty sure we won't be able to list all of them. 

For example, very likely a staging a driver for a device already supported at
mainstream won't be merged. Also, a driver at staging to be used by some other
driver in the mainstream is something that should be avoided.

So, better to avoid the usage of "all", as I'm sure that will always be
some valid exceptions on both directions.

Also, IMHO, the best is to present it as a list of requirements.

Another requirement that should be added there:

- The email of the driver maintainer should always be kept updated.

> 
> It should be noticed, however, that it is expected that the driver will be
> fixed to fulfill the requirements for upstream addition. If a driver at
> staging lacks relevant patches fixing it for more than a few kernel cycles,
> it can be dropped from staging. We will contact you before doing that
> provided that the email address of the maintainer is still valid.
> 
> For inclusion as a non-staging driver the requirements are more strict:
> 
> General requirements:
> 
> - It must pass checkpatch.pl, but see the note regarding interpreting the
>   output from checkpatch below.
> - An entry for the driver is added to the MAINTAINERS file.
> - The kernel internal APIs are used properly.
> - Don't reinvent the wheel by adding new defines, math logic, etc. for which
>   there are already solutions in the kernel.
> - Follow the CodingStyle guidelines, paying specific attention to the follow
>   frequently made mistakes:
> 	- Errors should be reported as negative numbers using the kernel
> 	  error codes. See also the CodingStyle document, chapter 16.
> 	- Don't use typedefs. See also the CodingStyle document, chapter 5.
> - When adding/enhancing the API the documentation must be updated as well,
>   otherwise the patch will not be accepted.
> 
> V4L2 specific requirements:
> 
> - Use struct v4l2_device for bridge drivers, use struct v4l2_subdev for
>   sub-device drivers.
> - Each i2c/spi device should be implemented as a separate sub-device driver.
> - Use the control framework for control handling.
> - Use struct v4l2_fh if the driver supports events (implied by the use of
>   controls) or priority handling.
> - Use videobuf2 for buffer handling.
> - Must pass the v4l2-compliance tests.
> - Hybrid tuners should be shared with DVB.

According with the discussions at the media mini-summit, they should now
use the I2C binding model for both DVB and V4L2.
(I suspect you missed this part of the meeting - it was together with the
DVB discussions that happened on Friday afternoon).

> - When introducing new APIs:
> 	- update v4l2-ctl
> 	- updates to v4l2-compliance (if applicable) are highly appreciated
> 	- update valgrind: support for v4l2 and media ioctls was added for
> 	  valgrind 3.10 synced to the 3.18 kernel. This should be kept up to
> 	  date. Patches should be posted as a bug report. See:
> 	  http://valgrind.org/support/bug_reports.html
> 
> DVB specific requirements:
> 
> - Use the DVB core for both internal and external APIs.
> - Each I2C-based chip should have its own driver.
> - Tuners and frontends should be mapped as different drivers.
> - dvb_frontend_ops should specify the delivery system instead of
>   specifying the frontend type via the dvb_frontend_ops info.type field.

A side note: we'll likely add another requirement here when we add
advanced support for DVB capabilities.

> - DVB frontends should not implement dummy function handlers; if the
>   function is not implemented, the DVB core should handle it properly.
> - Hybrid tuners should be shared with V4L.

This should be changed to:
  - New DVB tuners should use the I2C binding model. If the tuner is
hybrid, it should also support V4L ops.

There are already some models of DVB tuners using the I2C binding, but
some cleanup work is needed. Also, we should likely convert one hybrid
model to fully support this new way and allowing it to be called by both
V4L and DVB cores.

> How to deal with checkpatch.pl?
> ===============================
> 
> First of all, the requirement to comply to the kernel coding style is there for
> a reason. Sometimes people feel that it is a pointless exercise: after all,
> code is code, right? Why would just changing some spacing improve it?
> 
> But the coding style is not there to help you (at least, not directly), it is
> there to help those who have to review and/or maintain your code as it takes a
> lot of time to review code or try to figure out how someone else's code works.
> By at least ensuring that the coding style is consistent with other code we can
> concentrate on what humans to best: pattern matching. Ever read a book or
> article that did not use the correct spelling, grammar and/or punctuation
> rules? Did you notice how your brain 'stumbles' whenever it encounters such
> mistakes? It makes the text harder to understand and slower to read. The same
> happens with code that does not comply to the conventions of the project and it
> is the reason why most large projects, both open source and proprietary, have a
> coding style.
> 
> However, when interpreting the checkpatch output it is good to remember that it
> is just an automated tool and there are cases where what checkpatch recommends
> does not actually result in the best readable code. This is particularly true
> for the line length warnings. Use common sense there: if breaking up the line
> can be done without reducing the code readability, then do so. Otherwise it is
> better to keep the line as is.
> 
> As an example: typically function calls and function declarations can be split
> up without reducing the readability, but splitting up literal strings just to
> keep within the 80 character limit often leads to hard-to-read code.

Please add:

"Also, breaking strings on a print message, for example, makes harder to find the
 string if one needs to discover what line of code produced an error message.".

> 
> So the guideline here is to check such warnings, but use common sense whether
> or not to fix them.
> 
> Please do run checkpatch before posting any code to the mailinglist. Code that
> clearly violates the kernel coding style will be rejected and you will be asked
> to repost after fixing the style. We are not going to waste time trying to
> review code that uses a non-standard coding style, our time is too limited for
> that.
> 
> The only exception are staging drivers as the only rule there is that it
> compiles.

Please add:

"Still, please run checkpatch for staging drivers too, as checkpatch can also
 point to a few other issues on the code, like using some deprecated APIs.
 Also, if the staging code has checkpatch issues, it should be listed at the
 TODO file.".

> Timeline for code submissions
> =============================
> 
> After a new kernel is released the merge window will be open for about two
> weeks for the maintainers to send Linus the patches they already received
> during the last development cycle, and that went into the linux-next tree
> in time for the other maintainers and reviewers to double-check the entire
> set of changes for the next Linux version. During that time Linus will merge
> all those patches for the next kernel.
> 
> Once that merge window is closed only regression fixes and serious bug fixes
> will be accepted into the mainline kernel, everything else will have to stay
> in the maintainer's git tree until the next merge window opens.
> 
> In addition, before anything can be merged (regardless of whether this is
> during the merge window or not) the new code should have been in the linux-next
> tree for about a week at minimum to ensure there are no conflicts with work
> being done in other kernel subsystems.
> 
> Furthermore, before code can be added to linux-next it has to be reviewed
> first.  This will take time as well. Adding everything up this means that if
> you want your code to be merged for the next kernel you should have it posted
> to the linux-media mailinglist no later than rc5 of the current kernel, or it
> may be too late. In fact, the earlier the better since reviews will take time,
> and if corrections need to be made you may have to do several review/submit
> cycles.

Not sure about mentioning "rc5" above. Core maintainers want to reduce the
merge window, and Linus tried to release 3.18 cycle to only 6 release candidates.

I would change the above for something similar to:

"if you want your code to be merged for the next kernel you should have it posted
 it as soon as possible. So, for example, if you send your patches, for example,
 at rc6, it is likely too late for it to go to the next version."

> Remember that the core media developers have a job as well, and so won't always
> have the time to review immediately. A general rule of thumb is to post a
> reminder if a full week has passed without receiving any feedback. There is a
> fair amount of traffic on the mailinglist and it wouldn't be the first time
> that a patch was missed by reviewers.
> 
> One consequence of this is that as submitter you can get into the situation
> that you post something, two weeks later you get a review, you post the
> corrected version, you get more reviews 10 days later, etc. So it can be a
> drawn-out process. This can be frustrating, but please stick with it. We have
> seen cases where people seem to give up, but that is not our intention. We
> welcome new code, but since none of the core developers work full time on this
> we are constrained by the time we have available. Just be aware of this, plan
> accordingly and don't give up.
> 
> The reason for all these measures is simply to ensure to the best of our
> abilities that no regressions are added into the kernel, the code remains of
> a high quality, and still be able to release a new kernel every 7-9 weeks.
> 
> 
> Contacting developers
> =====================
> 
> The linux-media mailinglist is the central place to get into contact with
> developers. However, there are also two irc channels #linuxtv (mostly DVB
> related) and #v4l (mostly V4L related). Most developers are based in the US or
> in Europe, so take those timezones into account. If you ask something in the
> irc channel, please wait for your answer as it may take some time for a
> developer to be able to find a timeslot to answer you.
> 
> Finally, you can often find developers during the three main Linux conferences
> relevant to us: the Linux Plumbers Conference, the Embedded Linux Conference
> and the Embedded Linux Conference Europe. 

Not sure if we should list just the above three conferences. We try to
be on other conferences as well. I would change it to say, instead:

"you can often find developers during the major Open Source conferences,
 specially the ones organized by the Linux Foundation. Please check the
 events schedule and/or ping at the IRC channels if you desire to contact
 the media developers and/or maintainers."

> Check the mailinglist as well: we
> often have a Media Summit during one of these conferences.

Please add the media-workshop ML here.

> 
> 
> Patch tags
> ==========
> 
> When posting patches it is recommended to tag them to help us sort through them
> quickly and efficiently.
> 
> The tags are:
> 
> [RFC PATCH x/y]: use this for preliminary patches for which you want to get
> some early feedback.
> 
> [REVIEW PATCH x/y]: use this for patches that you consider OK for merging, but
> that need to be reviewed.
> 
> Once your patches have been reviewed/acked you can post either a pull request
> ("[GIT PULL]") or use the "[FINAL PATCH x/y]" tag if you don't have a public
> git tree.
> 
> If you post a new version of a patch series, then add 'v1', 'v2', etc. to the
> RFC or REVIEW word, e.g.: "[RFCv2 PATCH x/y]".
> 
> If your patch is for the current rc kernel (so it is a regression or serious
> bug fix), then add " FOR v3.x" after the PATCH or PULL keyword. For example:
> "[REVIEW PATCH FOR v3.7 x/y]", or "[GIT PULL FOR v3.7]".
> 
> Git pull requests containing urgent fixes for the current rc kernel that
> should be upstreamed quickly should use "[GIT FIXES for v3.x]".
> 
> You can use the option --subject-prefix="REVIEW PATCHv1" with the 'git
> send-email' to specify the prefix.
> 
> Patches without the appropriate tags will be processed manually, which will
> take more time and may actually cause them to be dropped altogether.
> 
> 
> Reviewed-by/Acked-by
> ====================
> 
> Within the media subsystem there are three levels of maintainership: Mauro
> Carvalho Chehab is the maintainer of the whole subsystem and the
> DVB/V4L/IR/Media Controller core code in particular, then there are a number of
> submaintainers for specific areas of the subsystem:
> 
> - Kamil Debski: codec (aka memory-to-memory) drivers
> - Hans de Goede: non-UVC USB webcam drivers
> - Guennadi Liakhovetski: soc-camera drivers
> - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the main
>   reviewer for Media Controller core patches.
> - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
>   receivers and transmitters). In addition he'll be the main reviewer for V4L2
>   core patches.
> 
> Finally there are maintainers for specific drivers. This is documented in the
> MAINTAINERS file. Note: if a submaintainer also maintains specific drivers,
> then they should also go through his own git tree. E.g. Laurent maintains
> the UVC driver, but it would be silly if UVC driver patches would have to go
> through Hans' git tree just because he is the submaintainer for V4L2 drivers.
> 
> BTW, just for the record: everyone is invited to review code posted to the
> mailinglist, especially core patches. It can be a good way to learn how the
> media drivers work.
> 
> When modifying existing code you need to get the Reviewed-by/Acked-by of the
> maintainer of that code. So CC that maintainer when posting patches. If said
> maintainer is unavailable then the submaintainer or even Mauro can accept it as
> well, but that should be the exception, not the rule.
> 
> Once patches are accepted they will flow through the git tree of the
> submaintainer to the git tree of the maintainer (Mauro) who will do a final
> review.
> 
> There are a few exceptions: code for certain platforms goes through git trees
> specific to that platform. The submaintainer will still review it and add a
> acked-by or reviewed-by line, but it will not go through the submaintainer's
> git tree.
> 
> The platform maintainers are:
> 
> - Prabhakar Lad for all DaVinci drivers (drivers/media/platform/davinci)
> - Sylwester Nawrocki for all s5p/exynos drivers (drivers/media/platform/s5p*
>   and drivers/media/platform/exynos*)
> 
> In case patches touch on areas that are the responsibility of multiple
> submaintainers, then they will decide among one another who will merge the
> patches.
> 
> 
> How to submit patches for a stable kernel
> =========================================
> 
> The standard method is to add this tag:
> 
>         Cc: stable@vger.kernel.org
> 
> possibly with a comment saying to which versions it should be applied, like:
> 
>         Cc: stable@vger.kernel.org      # for v3.5 and up
> 
> Then just send the patch/pull request to linux-media.
> 
> If it is only noticed later that a patch should be added to stable, or if a
> backport is needed, then the patch author should send the patch to
> stable@vger.kernel.org, c/c the linux-media mailinglist, preferably pointing to
> the upstream commit ID. The patch has to be merged upstream before it can be
> merged at stable.
> 
> 
> Patchwork
> =========
> 
> Patchwork is an automated system that takes care of all posted patches. It can
> be found here: http://patchwork.linuxtv.org/project/linux-media/list/
> 
> If your patch does not appear in patchwork after a couple of minutes, then
> check if you used the right patch tags and if your patch is formatted correctly
> (no HTML, no mangled lines). Unfortunately, patchwork currently doesn't send you
> any email when a patch successfully arrives there, so you will have to check
> this yourself.
> 
> Whenever you patch changes state you'll get an email informing you about that.
> Note that you can change the mail settings in order to opt-out of these
> notifications.
> 
> If you want to remove a patch or pull request from patchwork, then you can
> reply to the patch with a 'Nacked-by:' line.

Actually, "Nacked-by" only applies to patches not yet merged. If the
patch was already merged, a new patch with the fixup should be sent,
or a request to revert the patch, if the old behavior is already the proper
code.

