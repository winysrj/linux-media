Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34231 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcHWPPh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 11:15:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id q128so18579926wma.1
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 08:15:36 -0700 (PDT)
Date: Tue, 23 Aug 2016 17:15:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160823151531.GK10980@phenom.ffwll.local>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
 <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
 <20160822124930.02dbbafc@vento.lan>
 <20160823060135.GJ24290@phenom.ffwll.local>
 <20160823070818.42ffec00@lwn.net>
 <CAKMK7uFMDcwk=ovX9+_R4FBOx6=sYnaOZwHuHSdQixdk-5_hwg@mail.gmail.com>
 <20160823081633.123ae938@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160823081633.123ae938@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 23, 2016 at 08:16:33AM -0600, Jonathan Corbet wrote:
> On Tue, 23 Aug 2016 15:28:55 +0200
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > I think the more interesting story is, what's your plan with all the
> > other driver related subsystem? Especially the ones which already have
> > full directories of their own, like e.g. Documentation/gpio/. I think
> > those should be really part of the infrastructure section (or
> > something equally high-level), together with other awesome servies
> > like pwm, regman, irqchip, ... And then there's also the large-scale
> > subsystems like media or gpu. What's the plan to tie them all
> > together? Personally I'm leaning towards keeping the existing
> > directories (where they exist already), but inserting links into the
> > overall driver-api section.
> 
> To say I have a plan is to overstate things somewhat...
> 
> One objective I do have, though, is to declutter Documentation/.
> Presenting people looking for docs with a 270-file directory is
> unfriendly to say the least.  We don't organize the code that way; the
> average in the kernel is <... find | wc -l ... > about 15
> files/directory, which is rather more manageable.  Someday I'd like
> Documentation/ to look a lot more like the top-level directory.
> 
> It seems to me that we have a few basic types of stuff here:
> 
>  - Driver API documentation, obviously, is a lot of it, and I would like
>    to organize it better and to move it out of the top-level directory.
> 
>  - Hardware usage information - module parameters, sysfs files, supported
>    hardware information, graphic descriptions of the ancestry of hardware
>    engineers, etc.  The readership for this stuff is quite different, and
>    I think it should be separate; often it's intertwined with API
>    information at the moment.
> 
>  - Other usage information - a lot of what's under filesystems/ for
>    example, and more.

Hm yeah, I don't have a plan really for what to do with usage docs for
users (as opposed to api docs for kernel developers). With DRM
comparatively few people end up writing userspace for our apis, hence I
think this is a lower priority issue for us. Definitely something I'd like
to address eventually. I think for drivers a big part here is documenting
the ioctls and all the other uapi bits&pieces.

>  - Core API documentation.

Personally I'm very much interesting in dragging all the locking
primitives into the rst/sphinx world. We already make heavy use fo
ww_mutex, and we started to make rather heavy use of rcu in drm and
drm/i915. I'd like to be able to directly reference these underlying
primitives. For KS I'll try to convince Paul that this is an awesome idea
;-)

>  - Kernel development tools - the stuff I started pulling together into
>    the dev-tools/ subdirectory.
> 
>  - How to deal with this unruly mob - SubmittingPatches, CodingStyle,
>    development-process, etc.  There's process stuff, and general
>    development documents like volatile-considered-harmful.txt or
>    memory-barriers.txt

tbh I think the process stuff is important enough that we should imo leave
it in the top-level Documentation/ directory. Maybe collated together into
a contributing.rst index file (besides the top-level index.rst ofc).

> We can go a long way by organizing this stuff within the formatted
> documentation, but I really think we need to organize the directory
> structure as well.  I see that as a slow-moving process that will take
> years, but I do think it's a direction we should go.

Fully agreed on the larger-scale picture, and I think what I've seen thus
far from you looks great. Was simply wondering whether you have a more
concrete plane for drivers specifically already. I'm wondering whether we
should have Documentation/drivers/(gpu|media|...) too, but otoh nesting
things too deeply isn't great either. Starting out with a proper driver
directory in there is definitely the right step forward though. We can
shuffle the other bits into that later on anytime we like really.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
