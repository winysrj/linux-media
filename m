Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0SPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 14:15:07 -0400
Date: Fri, 27 Aug 2010 13:58:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Proposed ir-core (rc-core) changes
Message-ID: <20100827175837.GF22542@redhat.com>
References: <83gjmv84flgq1rq9qxi1bamr.1282924547360@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83gjmv84flgq1rq9qxi1bamr.1282924547360@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Aug 27, 2010 at 11:55:47AM -0400, Andy Walls wrote:
> Heh.  Between "where's the current base?", > 1 hour rebuild times for the whole kernel, and continual retooling of the IR core stuff, I can't keep up with the time I have available.
> 
> Mauro did make an announcement a few weeks back.  I thought it was the media.git tree.

Yeah, the most recent patch I've done was against media_tree.git, branch
staging/v2.6.36.

http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/staging/v2.6.36

I believe there's a slightly updated mceusb.c in there vs. what this
patchset was against, and there are also streamzap.c and ene_ir.c in
there, ported from lirc to ir-core in there that would also need to be
updated for these changes. (Nb: there's a fairly major streamzap.c patch
still pending, wouldn't start working on that port until it gets merged.)


> David Härdeman <david@hardeman.nu> wrote:
> 
> >On Thu, August 26, 2010 21:14, Jarod Wilson wrote:
> >> On Wed, Aug 25, 2010 at 01:01:57AM +0200, David Härdeman wrote:
> >>> The following series merges the different files that currently make up
> >>> the ir-core module into a single-file rc-core module.
> >>>
> >>> In addition, the ir_input_dev and ir_dev_props structs are replaced
> >>> by a single rc_dev struct with an API similar to that of the input
> >>> subsystem.
> >>>
> >>> This allows the removal of all knowledge of any input devices from the
> >>> rc drivers and paves the way for allowing multiple input devices per
> >>> rc device in the future. The namespace conversion from ir_* to rc_*
> >>> should mostly be done for the drivers with this patchset.
> >>>
> >>> I have intentionally not signed off on the patches yet since they
> >>> haven't
> >>> been tested. I'd like your feedback on the general approach before I
> >>> spend
> >>> the time to properly test the result.
> >>>
> >>> Also, the imon driver is not converted (and will thus break with this
> >>> patchset). The reason is that the imon driver wants to generate mouse
> >>> events on the input dev under the control of rc-core. I was hoping that
> >>> Jarod would be willing to convert the imon driver to create a separate
> >>> input device for sending mouse events to userspace :)
> >>
> >> Yeah, I could be persuaded to do that. Means that the imon driver, when
> >> driving one of the touchscreen devices, will bring up 3 separate input
> >> devices, but oh well. (I'd actually considered doing that when porting to
> >> ir-core in the first place, but went the lazy route. ;)
> >
> >That would be good. I'm pretty certain that the split will be necessary
> >sooner or later.
> >
> >>> Comments please...
> >>
> >> Haven't tried it out at all yet or done more than a quick skim through the
> >> patches, but at first glance, I do like the idea of further abstracting
> >> away the input layer. I know I tanked a few things the first go 'round,
> >> thinking I needed to do both some rc-layer and input-layer setup and/or
> >> teardown. It becomes more cut and dry if you don't see anything
> >> input-related anywhere at all.
> >
> >Not to mention we will have a more consistent user experience. For
> >example: some of the current hardware drivers are fiddling with the repeat
> >values of the input dev...something which should be the same across the
> >entire subsystem (you wouldn't expect the repetition rate for the exact
> >same remote control to change just because you change the receiver).
> >
> >Also, it's necessary for any future support of multiple input devices (one
> >per physical remote control being one example)...and it gives us more
> >flexibility to make changes in rc-core when drivers do not muck around in
> >subdevices (input devices that is).
> >
> >> One thing I did note with the patches is that a lot of bits were altered
> >> from ir-foo to rc-foo, but not all of them... If we're going to make the
> >> change, why no go whole hog? (Or was it only things relevant to ir
> >> specifically right now that didn't get renamed?)
> >
> >The rule of thumb I followed was to rename stuff that I touched but leave
> >unchanged code alone. Renaming the remaining functions can be done in
> >later, separate, patches (some of them will be more invasive as file names
> >need changing as well).
> >
> >On a related note, I'm getting confused wrt git the v4l-dvb git branches.
> >The current patches are against staging/rc which hasn't seen much activity
> >in a month or two but staging/other seems to carry some more recent
> >rc-related patches...which one am I supposed to base my work on?
> >
> >-- 
> >David Härdeman
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jarod Wilson
jarod@redhat.com

