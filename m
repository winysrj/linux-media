Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45854 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966589AbeBOLQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 06:16:24 -0500
Date: Thu, 15 Feb 2018 09:16:18 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.17] rc changes
Message-ID: <20180215091618.2db36d39@vento.lan>
In-Reply-To: <20180214213207.axrs6k3cl6tevb2h@gofer.mess.org>
References: <20180212200318.cxnxro2vsqauexqz@gofer.mess.org>
        <20180214164448.32a4c989@vento.lan>
        <20180214213207.axrs6k3cl6tevb2h@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Feb 2018 21:32:07 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> On Wed, Feb 14, 2018 at 04:44:48PM -0200, Mauro Carvalho Chehab wrote:
> > Hi Sean,
> > 
> > Em Mon, 12 Feb 2018 20:03:18 +0000
> > Sean Young <sean@mess.org> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > Just very minor changes this time (other stuff is not ready yet). I would
> > > really appreciate if you could cast an extra critical eye on the commit 
> > > "no need to check for transitions", just to be sure it is the right change.  
> > 
> > Did you send all patches in separate? This is important to allow us
> > to comment on an specific issue inside a patch...  
> 
> All the patches were emailed to linux-media, some of them on the same day
> as the pull request. Maybe I should wait longer. The patch below was sent
> out on the 28th of January.
> 
> > >       media: rc: no need to check for transitions  

No need to wait longer. Yet, it seems that I lost the above patch, as I
couldn't find anything on my email with the above subject.

Perhaps the e-mail got lost somehow on my inbox.

> > 
> > I don't remember the exact reason for that, but, as far as I
> > remember, on a few devices, a pulse (or space) event could be
> > broken into two consecutive events of the same type, e. g.,
> > a pulse with a 125 ms could be broken into two pulses, like
> > one with 100 ms and the other with 25 ms.  
> 
> If that is the case, then the IR decoders could not deal with this anyway.
> For example, the first state transition rc6 is:
> 
> 	if (!eq_margin(ev.duration, RC6_PREFIX_PULSE, RC6_UNIT))
> 
> So if ev.duration is not the complete duration, then decoding will fail;
> I tried to explain in the commit message that if this was the case, then
> decoding would not work so the check was unnecessary.
> 
> > That's said, I'm not sure if the current implementation are
> > adding the timings for both pulses into a single one.  
> 
> That depends on whether the driver uses ir_raw_event_store() or
> ir_raw_event_store_with_filter(). The latter exists precisely for this
> reason.

OK.

> 
> > For now, I'll keep this patch out of the merge.  
> 
> Ok. So in summary, I think:
> 
> 1. Any driver which produces consequentive pulse events is broken
>    and should be fixed;

Agreed.

> 2. The IR decoders cannot deal with consequentive pulses and the current
>    prev_ev code does not help with this (possibly in very special
>    cases).

Ok. Yet, maybe it would worth to produce a warning if this happen, and
reset the state machine, as it would help to identify problems at
the driver or at the hardware.


Thanks,
Mauro
