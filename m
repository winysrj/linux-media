Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33689 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932441AbcJLG4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 02:56:23 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so905590wma.0
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 23:56:22 -0700 (PDT)
Date: Wed, 12 Oct 2016 08:56:18 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "Clark, Rob" <robdclark@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Eric Anholt <eric@anholt.net>,
        "Syrjala, Ville" <ville.syrjala@linux.intel.com>
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161012065618.GI20761@phenom.ffwll.local>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <20161011154359.GD20761@phenom.ffwll.local>
 <20161011164305.GA14337@e106950-lin.cambridge.arm.com>
 <CAKMK7uFqiLCCcCz154SU-ZG5rygSBz2_P7M29EkFh8pGMfXvOw@mail.gmail.com>
 <20161011194422.GC14337@e106950-lin.cambridge.arm.com>
 <CAKMK7uEQsiBLQGghdDvmPicc_F6+3Ra_sd7keSKTPAgsNKbdog@mail.gmail.com>
 <20161011212423.GA10077@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161011212423.GA10077@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:24:23PM +0100, Brian Starkey wrote:
> On Tue, Oct 11, 2016 at 10:02:43PM +0200, Daniel Vetter wrote:
> > The problem with just that is that there's lots of different things
> > that can feed into the overall needs_modeset variable. That's why we
> > split it up into multiple booleans.
> > 
> > So yes you're supposed to clear connectors_changed if there is some
> > change that you can handle without a full modeset. If you want, think
> > of connectors_changed as
> > needs_modeset_due_to_change_in_connnector_state, but that's cumbersome
> > to type and too long ;-)
> > 
> 
> All right, got it :-). This intention wasn't clear to me from the
> comments in the code.

A patch to update the kernel-doc to make it clearer (there's mode_changed,
connectors_changed and active_changed, plus drm_crtc_needs_modeset) would
be awesome. I'm trying to write useful docs, but since I designed this all
I sometimes forget to make the non-obvious assumptions clear enough.

Volunteered?

> > > > tbh I don't like that, I think it'd be better to make this truly
> > > > one-shot. Otherwise we'll have real fun problems with hw where the
> > > > writeback can take longer than a vblank (it happens ...). So one-shot,
> > > > with auto-clearing to NULL/0 is imo the right approach.
> > > 
> > > That's an interesting point about hardware which won't finish within
> > > one frame; but I don't see how "true one-shot" helps.
> > > 
> > > What's the expected behaviour if userspace makes a new atomic commit
> > > with a writeback framebuffer whilst a previous writeback is ongoing?
> > > 
> > > In both cases, you either need to block or fail the commit - whether
> > > the framebuffer gets removed when it's done is immaterial.
> > 
> > See Eric's question. We need to define that, and I think the simplest
> > approach is a completion fence/sync_file. It's destaged now in 4.9, we
> > can use them. I think the simplest uabi would be a pointer property
> > (u64) where we write the fd of the fence we'll signal when write-out
> > completes.
> > 
> 
> That tells userspace that the previous writeback is finished, I agree that's
> needed. It doesn't define any behaviour in case userspace asks for another
> writeback before that fence fires though.

Hm, good point. I guess we could just state that if userspace does a
writeback, and issues a new writeback before both a) the atomic flip and
b) the write back complete fence signalled will lead to undefined
behaviour. Undefined as in: data corruption, rejected atomic commit or
anything else than a kernel crash is allowed. This is similar to doing a
page flip and starting to render to the old buffers before the flip event
signalled completion: Userspace gets the mess it asked for ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
