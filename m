Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3EEL3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 May 2013 07:29:22 -0400
Date: Sun, 5 May 2013 08:29:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jon Arne =?UTF-8?B?SsO4cmdlbnNlbg==?= <jonarne@jonarne.no>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org, jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
Message-ID: <20130505082910.13ba43e9@redhat.com>
In-Reply-To: <20130505082007.GA2812@dell.arpanet.local>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
	<1367268069-11429-2-git-send-email-jonarne@jonarne.no>
	<20130503020913.GB5722@localhost>
	<20130503065846.GD1232@dell.arpanet.local>
	<20130503112052.GB2291@localhost>
	<5183A8B0.3040301@redhat.com>
	<20130505082007.GA2812@dell.arpanet.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 5 May 2013 10:20:08 +0200
Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:

> On Fri, May 03, 2013 at 09:08:16AM -0300, Mauro Carvalho Chehab wrote:
> > Em 03-05-2013 08:20, Ezequiel Garcia escreveu:
> > >Hi Jon,
> > >
> > >On Fri, May 03, 2013 at 08:58:46AM +0200, Jon Arne Jørgensen wrote:
> > >[...]
> > >>>You can read more about this in Documentation/SubmittingPatches.
> > >>
> > >>I just re-read SubmittingPatches.
> > >>I couldn't see that there is anything wrong with multiple sign-off's.
> > >>
> > >
> > >Indeed there isn't anything wrong with multiple SOBs tags, but they're
> > >used a bit differently than this.
> > >
> > >>Quote:
> > >>   The Signed-off-by: tag indicates that the signer was involved in the
> > >>   development of the patch, or that he/she was in the patch's delivery
> > >>   path.
> > >>
> > >>
> > >
> > >Ah, I see your point.
> > >
> > >@Mauro, perhaps you can explain this better then me?
> > 
> > The SOB is used mainly to describe the patch flow. Each one that touched
> > on a patch attests that:
> > 
> >        "Developer's Certificate of Origin 1.1
> > 
> >         By making a contribution to this project, I certify that:
> > 
> >         (a) The contribution was created in whole or in part by me and I
> >             have the right to submit it under the open source license
> >             indicated in the file; or
> > 
> >         (b) The contribution is based upon previous work that, to the best
> >             of my knowledge, is covered under an appropriate open source
> >             license and I have the right under that license to submit that
> >             work with modifications, whether created in whole or in part
> >             by me, under the same open source license (unless I am
> >             permitted to submit under a different license), as indicated
> >             in the file; or
> > 
> >         (c) The contribution was provided directly to me by some other
> >             person who certified (a), (b) or (c) and I have not modified
> >             it.
> > 
> > 	(d) I understand and agree that this project and the contribution
> > 	    are public and that a record of the contribution (including all
> > 	    personal information I submit with it, including my sign-off) is
> > 	    maintained indefinitely and may be redistributed consistent with
> > 	    this project or the open source license(s) involved."
> > 
> > In other words, it tracks the custody chain, with is typically one of
> > the alternatives below[1]:
> > 
> > 	Author -> maintainer's tree -> upstream
> > 	Author -> sub-maintainer's tree -> maintainer's tree -> upstream
> > 	Author -> driver's maintainer -> maintainer's tree -> upstream
> > 	Author -> driver's maintainer -> sub-maintainer's tree -> maintainer's tree -> upstream\
> > 
> > In this specific case, as patches 1 and 2 are identical to the ones I submitted,
> > the right way would be for you both to just reply to my original e-mail with
> > your tested-by or reviewed-by. That patches will then be applied (either directly
> > or via Hverkuil's tree, as he is the sub-maintainer for those I2C drivers).
> >
> 
> The patch you submitted lacked all register setup so there wasn't that much
> to test without the stuff I added in the third patch in this
> series.

That's by purpose. I didn't want to touch on the things you authored/tested:
the gm7113c special setup. I also didn't want to merge a pure cosmetic
change that re-group the logic with the new table setup for gm7113c, as
we do prefer to have one logical change by patch.

In any case, the patches can be tested as a hole or in separate.

The first one is a "cosmetic" patch, moving things into a separate function.
A tested-by there means that it didn't break anything. The second one detects
the saa7113 clone. Again, a tested by means that it does what it proposes:
detect this new variant.

Of course, your third patch is needed in order to make gm7113c to work.
That's basically why I didn't merge them on my tree yet.

> Is there any way to accnowledge this when I reply to your patch with tested-by?

Feel free to add your notes when replying to the email. We generally
don't add such notes at git history to avoid polluting it, but they
are stored at patchwork, and at the list archives.

For example:
	https://patchwork.linuxtv.org/patch/15524/

In this case, one patch touched on several different drivers. Some
drivers' maintainers replied with their ack, but noted that their
ack are limited to just their own stuff[1].

[1] they did it by cutting-off the diffstat lines for the drivers
they don't maintain. So, Prabhakar acked for DaVinci; Guennadi
acked for sh_vou/soc_camera changes.

> Should I maybe add the third patch in this series into that reply?

Yeah, you can do that. If you're using "git send-email", it
allows you to put the message ID of a message on your reply.
This way, you can bind your patch to an existing patch thread.

You may also add a note on your patch for the maintainer, after
your SOB, like:

	...
	Signed-off-by: my name <my@email>
	
	---

	Note: please apply this one together with the other patches
	...

Everything after "---" are suppressed when merging (such
notes is a transitory condition that doesn't deserve to
be at git history, as it just pollutes its content), but
it is important to bold merge instructions and other related
stuff.

> Also, when I post the next RFC for my smi2021 driver that
> depends on this patch. Are there any correct way to mention that
> dependency in the smi2021 patch?

Yes. See above.

The better is to point there at the note the patchwork URL,
as the (sub)maintainer(s) use it as the patch queue.

> 
> Best,
> Jon Arne

Regards,
Mauro
