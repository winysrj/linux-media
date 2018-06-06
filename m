Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752005AbeFFQ5P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 12:57:15 -0400
Date: Wed, 6 Jun 2018 13:57:01 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tomasz Figa <tfiga@chromium.org>, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606135620.38668a3f@coco.lan>
In-Reply-To: <20180606100150.GA32299@amd>
References: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
        <20180319120043.GA20451@amd>
        <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
        <20180319095544.7e235a3e@vento.lan>
        <20180515200117.GA21673@amd>
        <20180515190314.2909e3be@vento.lan>
        <20180602210145.GB20439@amd>
        <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
        <20180606084612.GB18743@amd>
        <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
        <20180606100150.GA32299@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 6 Jun 2018 12:01:50 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > > Who would be calling this function?
> > > >
> > > > The scenario that I could think of is:
> > > > - legacy app would call open(/dev/video?), which would be handled by
> > > > libv4l open hook (v4l2_open()?),  
> > >
> > > I don't think that kind of legacy apps is in use any more. I'd prefer
> > > not to deal with them.  
> > 
> > In another thread ("[ANN v2] Complex Camera Workshop - Tokyo - Jun,
> > 19"), Mauro has mentioned a number of those:
> > 
> > "open source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and closed
> > source ones (Skype, Chrome, ...)"  
> 
> Yep, ok. Still would prefer not to deal with them.

I guess we'll end by needing to handle them. Anyway, now that PCs are
starting to come with complex cameras[1], we'll need to address this
with a focus on adding support for existing apps.

[1] we had a report from one specific model but I heard from a reliable
source that there are already other devices with similar issues.

> (Opening additional fds behind application's back is quite nasty,
> those apps should really switch to v4l2_ variants).

Only closed source apps use the LD_PRELOAD hack. All the others
use v4l2_ variants, but, as Nicolas mentioned at the other
thread, there are a number of problems with the current approach.

Perhaps is time for us to not be limited to the current ABI, writing
a new API from scratch, and then adding a compatibility layer to be
used by apps that rely on v4l2_ variants, in order to avoid breaking
the ABI and keep providing LD_PRELOAD. We can then convert the apps
we use/care most to use the new ABI.

> 
> > > > - v4l2_open() would check if given /dev/video? figures in its list of
> > > > complex pipelines, for example by calling v4l2_open_complex() and
> > > > seeing if it succeeds,  
> > >
> > > I'd rather not have v4l2_open_complex() called on devices. We could
> > > test if argument is regular file and then call it... But again, that's
> > > next step.
> > >  
> > > > - if it succeeds, the resulting fd would represent the complex
> > > > pipeline, otherwise it would just open the requested node directly.  
> > 
> > What's the answer to my original question of who would be calling
> > v4l2_open_complex(), then?  
> 
> Application ready to deal with additional fds being
> opened. contrib/test/sdlcam will be the first one.
> 
> We may do some magic to do v4l2_open_complex() in v4l2_open(), but I
> believe that should be separate step.

In order to avoid breaking the ABI for existing apps, v4l2_open() should
internally call v4l2_open_complex() (or whatever we call it at the new
API design).

> > > >  - handling metadata CAPTURE and OUTPUT buffers controlling the 3A
> > > > feedback loop - this might be optional if all we need is just ability
> > > > to capture some frames, but required for getting good quality,
> > > >  - actually mapping legacy controls into the above metadata,  
> > >
> > > I'm not sure what 3A is. If you mean hardware histograms and friends,
> > > yes, it would be nice to support that, but, again, statistics can be
> > > computed in software.  
> > 
> > Auto-exposure, auto-white-balance, auto-focus. In complex camera
> > subsystems these need to be done in software. On most hardware
> > platforms, ISP provides necessary input data (statistics) and software
> > calculates required processing parameters.  
> 
> Ok, so... statistics support would be nice, but that is really
> separate problem.
> 
> v4l2 already contains auto-exposure and auto-white-balance. I have
> patches for auto-focus. But hardware statistics are not used.

Feel free to submit the auto-focus patches anytime. With all 3A
algos there (even on a non-optimal way using hw stats), it will
make easier for us when designing a solution that would work for
both IMAP3 and ISP (and likely be generic enough for other hardware).

For the full complex hardware solution, though, it is probably better
to fork v4l-utils into a separate project, in order to do the development
without affecting current users of it, merging it back only after we'll
be sure that existing apps will keep working with v4l2_foo() functions
and LD_PRELOAD.

Anyway, this is something that it makes sense to discuss during the
Complex Camera Workshop.

> > > Yes, we'll need something more advanced.
> > >
> > > But.. we also need something to run the devices today, so that kernel
> > > drivers can be tested and do not bitrot. That's why I'm doing this
> > > work.  
> > 
> > I guess the most important bit I missed then is what is the intended
> > use case for this. It seems to be related to my earlier, unanswered
> > question about who would be calliing v4l2_open_complex(), though.
> > 
> > What userspace applications would be used for this testing?  
> 
> Main use case is kernel testing.
> 
> Secondary use case is taking .jpg photos using sdlcam.

If a v4l2_complex_open() will, for now, be something that we don't
export publicly, using it only for the tools already at libv4l2,
I don't see much troubles on adding it, but I would hate to have to
stick with this ABI. Otherwise, we should analyze it after having
a bigger picture. So, better to wait for the Complex Camera
Workshop before adding this.

Btw, would you be able to join us there (either locally or
remotely via Google Hangouts)?
 
> Test apps such as qv4l2 would be nice to have, and maybe I'll
> experiment with capturing video somehow one day. I'm pretty sure it
> will not be easy.

Capture video is a must have for PCs. The final solution should
take it into account.

> 
> Oh and I guess a link to how well it works? See
> https://www.youtube.com/watch?v=fH6zuK2OOVU .
> 
> Best regards,
> 								Pavel

Thanks,
Mauro
