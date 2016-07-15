Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33514 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbcGOHdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 03:33:39 -0400
Received: by mail-wm0-f54.google.com with SMTP id r190so8211564wmr.0
        for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 00:33:38 -0700 (PDT)
Date: Fri, 15 Jul 2016 09:33:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	liviu.dudau@arm.com
Subject: Re: DRM device memory writeback (Mali-DP)
Message-ID: <20160715073334.GO17101@phenom.ffwll.local>
References: <20160714170340.GA32755@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160714170340.GA32755@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 14, 2016 at 06:03:40PM +0100, Brian Starkey wrote:
> Hi,
> 
> The Mali-DP display processors have a memory-writeback engine which
> can write the result of the composition (CRTC output) to a memory
> buffer in a variety of formats.
> 
> We're looking for feedback/suggestions on how to expose this in the
> mali-dp DRM kernel driver - possibly via V4L2.
> 
> We've got a few use cases where writeback is useful:
>    - testing, to check the displayed image

This might or might not need a separate interface. There are efforts to
make the intel kms validation tests in i-g-t generic (well under way
already), and part of that is creating a generic infrastructure to capture
display CRCs for functional tests (still in progress).

But it might be better if userspace abstracts between full readback and
display CRC, assuming we can make full writeback cross-vendor enough for
that use-case.

>    - screen recording
>    - wireless display (e.g. Miracast)
>    - dual-display clone mode
>    - memory-to-memory composition
> Note that the HW is capable of writing one of the input planes instead
> of the CRTC output, but we've no good use-case for wanting to expose
> that.
> 
> In our Android ADF driver[1] we exposed the memory write engine as
> part of the ADF device using ADF's "MEMORY" interface type. DRM/KMS
> doesn't have any similar support for memory output from CRTCs, but we
> want to expose the functionality in the mainline Mali-DP DRM driver.
> 
> A previous discussion on the topic went towards exposing the
> memory-write engine via V4L2[2].
> 
> I'm thinking to userspace this would look like two distinct devices:
>    - A DRM KMS display controller.
>    - A V4L2 video source.
> They'd both exist in the same kernel driver.
> A V4L2 client can queue up (CAPTURE) buffers in the normal way, and
> the DRM driver would see if there's a buffer to dequeue every time a
> new modeset is received via the DRM API - if so, it can configure the
> HW to dump into it (one-shot operation).
> 
> An implication of this is that if the screen is actively displaying a
> static scene and the V4L2 client queues up a buffer, it won't get
> filled until the DRM scene changes. This seems best, otherwise the
> V4L2 driver has to change the HW configuration out-of-band from the
> DRM device which sounds horribly racy.
> 
> One further complication is scaling. Our HW has a scaler which can
> tasked with either scaling an input plane or the buffer being written
> to memory, but not both at the same time. This means we need to
> arbitrate the scaler between the DRM device (scaling input planes) and
> the V4L2 device (scaling output buffers).
> 
> I think the simplest approach here is to allow V4L2 to "claim" the
> scaler by setting the image size (VIDIOC_S_FMT) to something other
> than the CRTC's current resolution. After that, any attempt to use the
> scaler on an input plane via DRM should fail atomic_check().

That's perfectly fine atomic_check behaviour. Only trouble is that the v4l
locking must integrate into the drm locking, but that should be doable.
Worst case you must shadow all v4l locks with a wait/wound
drm_modeset_lock to avoid deadlocks (since you could try to grab locks
from either end).

> If the V4L2 client goes away or sets the image size to the CRTC's
> native resolution, then the DRM device is allowed to use the scaler.
> I don't know if/how the DRM device should communicate to userspace
> that the scaler is or isn't available for use.
> 
> Any thoughts on this approach?
> Is it acceptable to both V4L2 and DRM folks?

For streaming a V4L2 capture device seems like the right interface. But if
you want to use writeback in your compositor you must know which atomic
kms update results in which frame, since if you don't you can't use that
composited buffer for the next frame reliable.

For that case I think a drm-only solution would be better, to make sure
you can do an atomic update and writeback in one step. v4l seems to grow
an atomic api of its own, but I don't think we'll have one spanning
subsystems anytime soon.

For the kms-only interface the idea was to add a property on the crtc
where you can attach a writeback drm_framebuffer. Extending that idea to
the drm->v4l case we could create special drm_framebuffer objects
representing a v4l sink, and attach them to the same property. That would
also solve the problem of getting some agreement on buffer metadata
between v4l and drm side.

Laurent had some poc patches a while ago for this, he's definitely the one
to ping.
-Daniel

> 
> Thanks for your time,
> 
> -Brian
> 
> [1] http://malideveloper.arm.com/resources/drivers/open-source-mali-dp-adf-kernel-device-drivers/
> [2] https://people.freedesktop.org/~cbrill/dri-log/?channel=dri-devel&date=2016-05-04
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
