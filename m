Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33027 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942434AbcJ0OL0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:11:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id m83so2924990wmc.0
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 07:11:25 -0700 (PDT)
Date: Thu, 27 Oct 2016 16:11:21 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Gustavo Padovan <gustavo@padovan.org>,
        Brian Starkey <brian.starkey@arm.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 9/9] drm: mali-dp: Add writeback out-fence support
Message-ID: <20161027141121.wyugpj27ert3x4iw@phenom.ffwll.local>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-10-git-send-email-brian.starkey@arm.com>
 <20161026214357.GH12629@joana>
 <20161027101847.GC18708@e106950-lin.cambridge.arm.com>
 <20161027112519.GJ12629@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161027112519.GJ12629@joana>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 27, 2016 at 09:25:19AM -0200, Gustavo Padovan wrote:
> 2016-10-27 Brian Starkey <brian.starkey@arm.com>:
> 
> > On Wed, Oct 26, 2016 at 07:43:57PM -0200, Gustavo Padovan wrote:
> > > 2016-10-26 Brian Starkey <brian.starkey@arm.com>:
> > > 
> > > > If userspace has asked for an out-fence for the writeback, we add a
> > > > fence to malidp_mw_job, to be signaled when the writeback job has
> > > > completed.
> > > > 
> > > > Signed-off-by: Brian Starkey <brian.starkey@arm.com>
> > > > ---
> > > >  drivers/gpu/drm/arm/malidp_hw.c |    5 ++++-
> > > >  drivers/gpu/drm/arm/malidp_mw.c |   18 +++++++++++++++++-
> > > >  drivers/gpu/drm/arm/malidp_mw.h |    3 +++
> > > >  3 files changed, 24 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
> > > > index 1689547..3032226 100644
> > > > --- a/drivers/gpu/drm/arm/malidp_hw.c
> > > > +++ b/drivers/gpu/drm/arm/malidp_hw.c
> > > > @@ -707,8 +707,11 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
> > > >  		unsigned long irqflags;
> > > >  		/*
> > > >  		 * We can't unreference the framebuffer here, so we queue it
> > > > -		 * up on our threaded handler.
> > > > +		 * up on our threaded handler. However, signal the fence
> > > > +		 * as soon as possible
> > > >  		 */
> > > > +		malidp_mw_job_signal(drm, malidp->current_mw, 0);
> > > 
> > > Drivers should not deal with fences directly. We need some sort of
> > > drm_writeback_finished() that will do the signalling for you.
> > > 
> > 
> > With a signature like this?
> > 	drm_writeback_finished(struct drm_connector_state *state);
> > 
> > I'll have to think about how to achieve that. The state isn't
> > refcounted and the driver isn't in charge of it's lifetime. I'm not
> > sure how/where to ensure the state doesn't get destroyed before its
> > been signaled.
> 
> Maybe we should do something similar to the crtc vblank handlers and
> even hide the connector_state. Those helpers only take the crtc.
> They are able to hold ref to the event as well.

I guess we could reuse the drm_event stuff, but not sure that's too much
overkill. It would at least be a consistent driver interface, and drivers
could reuse stuff like arm_event and similar functions. Which might be
rather beneficial.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
