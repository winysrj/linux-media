Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39715 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2FHU41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 16:56:27 -0400
Received: by vbbff1 with SMTP id ff1so1382622vbb.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 13:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4fd09200.830ed80a.24f9.1a54SMTPIN_ADDED@mx.google.com>
References: <4fbf6893.a709d80a.4f7b.0e0eSMTPIN_ADDED@mx.google.com>
 <CACSP8SgSi+v70+-r1wR1hM0rDzmJK0g20i0fxRePLPuTXqrxuA@mail.gmail.com>
 <CAO8GWq=UYWTuJ=V6Luh4z49=og2X2wrHzVNYvbK7Tnw2zgzNeA@mail.gmail.com>
 <CACSP8Sgog0cDtxG+JsWQ=aYyiXtEr-N7+xPPRsAjwt3LAYC+uw@mail.gmail.com>
 <CAO8GWqnVN3tVp2chzsYKjhfzoupxsWwUT_LojzJ7kYWPRdZYJw@mail.gmail.com>
 <CACSP8SiVYiEg8BY9gvmbqiKNXEwEjHa+vxOvXpEgr+W-Wd5+rg@mail.gmail.com> <4fd09200.830ed80a.24f9.1a54SMTPIN_ADDED@mx.google.com>
From: Erik Gilling <konkers@android.com>
Date: Fri, 8 Jun 2012 13:56:05 -0700
Message-ID: <CACSP8SgrB2YxsvUx6y-EomgJhupb3uVmF_hH0Sd-PG6G6G9Cfg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] Synchronizing access to buffers shared with
 dma-buf between drivers/devices
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: "Clark, Rob" <rob@ti.com>, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2012 at 4:35 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
> The alternate is to not associate sync objects with buffers and
> have them be distinct entities, exposed to userspace. This gives
> userpsace more power and flexibility and might allow for use-cases
> which an implicit synchronization mechanism can't satisfy - I'd
> be curious to know any specifics here.

Time and time again we've had problems with implicit synchronization
resulting in bugs where different drivers play by slightly different
implicit rules.  We're convinced the best way to attack this problem
is to move as much of the command and control of synchronization as
possible into a single piece of code (the compositor in our case.)  To
facilitate this we're going to be mandating this explicit approach in
the K release of Android.

> However, every driver which
> needs to participate in the synchronization mechanism will need
> to have its interface with userspace modified to allow the sync
> objects to be passed to the drivers. This seemed like a lot of
> work to me, which is why I prefer the implicit approach. However
> I don't actually know what work is needed and think it should be
> explored. I.e. How much work is it to add explicit sync object
> support to the DRM & v4l2 interfaces?
>
> E.g. I believe DRM/GEM's job dispatch API is "in-order"
> in which case it might be easy to just add "wait for this fence"
> and "signal this fence" ioctls. Seems like vmwgfx already has
> something similar to this already? Could this work over having
> to specify a list of sync objects to wait on and another list
> of sync objects to signal for every operation (exec buf/page
> flip)? What about for v4l2?

If I understand you right a job submission with explicit sync would
become 3 submission:
1) submit wait for pre-req fence job
2) submit render job
3) submit signal ready fence job

Does DRM provide a way to ensure these 3 jobs are submitted
atomically?  I also expect GPU vendor would like to get clever about
GPU to GPU fence dependancies.  That could probably be handled
entirely in the userspace GL driver.

> I guess my other thought is that implicit vs explicit is not
> mutually exclusive, though I'd guess there'd be interesting
> deadlocks to have to debug if both were in use _at the same
> time_. :-)

I think this is an approach worth investigating.  I'd like a way to
either opt out of implicit sync or have a way to check if a dma-buf
has an attached fence and detach it.  Actually, that could work really
well. Consider:

* Each dma_buf has a single fence "slot"
* on submission
   * the driver will extract the fence from the dma_buf and queue a wait on it.
   * the driver will replace that fence with it's own complettion
fence before the job submission ioctl returns.
* dma_buf will have two userspace ioctls:
   * DETACH: will return the fence as an FD to userspace and clear the
fence slot in the dma_buf
   * ATTACH: takes a fence FD from userspace and attaches it to the
dma_buf fence slot.  Returns an error if the fence slot is non-empty.

In the android case, we can do a detach after every submission and an
attach right before.

-Erik
