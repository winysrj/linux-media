Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39373 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761087AbdDSLek (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:34:40 -0400
Date: Wed, 19 Apr 2017 13:34:34 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170419133434.229593a1@bbrezillon>
In-Reply-To: <20170419095122.GA6314@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
        <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
        <20170414120823.2cafc748@bbrezillon>
        <20170418173443.GA325@e106950-lin.cambridge.arm.com>
        <20170418215717.4381dd6e@bbrezillon>
        <20170419095122.GA6314@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 19 Apr 2017 10:51:23 +0100
Brian Starkey <brian.starkey@arm.com> wrote:

> On Tue, Apr 18, 2017 at 09:57:17PM +0200, Boris Brezillon wrote:
> >Hi Brian,
> >
> >On Tue, 18 Apr 2017 18:34:43 +0100
> >Brian Starkey <brian.starkey@arm.com> wrote:
> >  
> >> >> @@ -214,6 +214,19 @@ struct drm_connector_state {
> >> >>  	struct drm_encoder *best_encoder;
> >> >>
> >> >>  	struct drm_atomic_state *state;
> >> >> +
> >> >> +	/**
> >> >> +	 * @writeback_job: Writeback job for writeback connectors
> >> >> +	 *
> >> >> +	 * Holds the framebuffer for a writeback connector. As the writeback
> >> >> +	 * completion may be asynchronous to the normal commit cycle, the
> >> >> +	 * writeback job lifetime is managed separately from the normal atomic
> >> >> +	 * state by this object.
> >> >> +	 *
> >> >> +	 * See also: drm_writeback_queue_job() and
> >> >> +	 * drm_writeback_signal_completion()
> >> >> +	 */
> >> >> +	struct drm_writeback_job *writeback_job;  
> >> >
> >> >Maybe I'm wrong, but is feels weird to have the writeback_job field
> >> >directly embedded in drm_connector_state, while drm_writeback_connector
> >> >inherits from drm_connector.
> >> >
> >> >IMO, either you decide to directly put the drm_writeback_connector's
> >> >job_xxx fields in drm_connector and keep the drm_connector_state as is,
> >> >or you create a drm_writeback_connector_state which inherits from
> >> >drm_connector_state and embeds the writeback_job field.  
> >>
> >> I did spend a decent amount of time looking at tracking the writeback
> >> state along with the normal connector state. I couldn't come up with
> >> anything I liked.
> >>
> >> As the comment mentions, one of the problems is that you have to make
> >> sure the relevant parts of the connector_state stay around until the
> >> writeback is finished. That means you've got to block before
> >> "swap_state()" until the previous writeback is done, and that
> >> effectively limits your frame rate to refresh/2.
> >>
> >> The Mali-DP HW doesn't have that limitation - we can queue up a new
> >> commit while the current writeback is ongoing. For that reason I
> >> didn't want to impose such a limitation in the framework.
> >>
> >> In v1 I allowed that by making the Mali-DP driver hold its own
> >> references to the relevant bits of the state for as long as it needed
> >> them. In v3 I moved most of that code back to the core (in part
> >> because Gustavo didn't like me signalling the DRM-"owned" fence from
> >> my driver code directly). I think the new approach of "queue_job()"
> >> and "signal_job()" reduces the amount of tricky code in drivers, and
> >> is generally more clear (also familiar, when compared to vsync
> >> events).
> >>
> >> I'm certain there's other ways to do it (refcount atomic states?), but
> >> it seemed like a biggish overhaul to achieve what would basically be
> >> the same thing.
> >>
> >> I was expecting each driver supporting writeback to have its own
> >> different requirements around writeback lifetime/duration. For example
> >> I think VC4 specifically came up, in that its writeback could take
> >> several frames, whereas on Mali-DP we either finish within the frame
> >> or we fail.
> >>
> >> Letting the driver manage its writeback_job lifetime seemed like a
> >> reasonable way to handle all that, with the documentation stating the
> >> only behaviour which is guaranteed to work on all drivers:
> >>
> >>    *     Userspace should wait for this fence to signal before making another
> >>    *     commit affecting any of the same CRTCs, Planes or Connectors.
> >>    *     **Failure to do so will result in undefined behaviour.**
> >>    *     For this reason it is strongly recommended that all userspace
> >>    *     applications making use of writeback connectors *always* retrieve an
> >>    *     out-fence for the commit and use it appropriately.
> >>
> >>
> >>
> >> ... so all of that is why the _job fields don't live in a *_state
> >> structure directly, and instead have to live in the separately-managed
> >> structure pointed to by ->writeback_job.
> >>
> >> Now, I did look at creating drm_writeback_connector_state, but as it
> >> would only be holding the job pointer (see above) it didn't seem worth
> >> scattering around the
> >>
> >>     if (conn_state->connector->connector_type ==
> >>         DRM_MODE_CONNECTOR_WRITEBACK)
> >>
> >> checks everywhere before up-casting - {clear,reset,duplicate}_state(),
> >> prepare_signalling(), complete_signalling(), etc. It just touched a
> >> lot of code for the sake of an extra pointer field in each connector
> >> state.
> >>
> >> I can easily revisit that part if you like.  
> >
> >I think there's a misunderstanding. I was just suggesting to be
> >consistent in the inheritance vs 'one object to handle everything'
> >approach.  
> 
> doh.. right yeah I misread. Sorry for the tangent. :-)
> 
> >
> >I'm perfectly fine with embedding the writeback_job pointer directly in
> >drm_connector_state, but then it would IMO make more sense to do the
> >same for the drm_connector object (embed drm_writeback_connector fields
> >into drm_connector instead of making drm_writeback_connector inherit
> >from drm_connector).
> >  
> 
> I agree that it's inconsistent. I guess I did it out of pragmatism -
> there's quite a lot of new fields in drm_writeback_connector, and the
> code needed to support it was comparatively small. On the other hand
> there's only one additional field in drm_connector_state and the code
> required to subclass it looked comparatively large.
> 
> >Anyway, that's just a detail.
> >  
> >>  
> >> >
> >> >Anyway, wait for Daniel's feedback before doing this change.
> >> >  
> >>
> >> Am I expecting some more feedback from Daniel?  
> >
> >No, I was just saying that before doing the changes I was suggesting,
> >you should wait for Daniel's opinion, because I might be wrong.
> >  
> >>  
> >> >>  };
> >> >>
> >> >>  /**
> >> >> diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
> >> >> index bf9991b2..3d3d07f 100644
> >> >> --- a/include/drm/drm_mode_config.h
> >> >> +++ b/include/drm/drm_mode_config.h
> >> >> @@ -634,6 +634,20 @@ struct drm_mode_config {
> >> >>  	 */
> >> >>  	struct drm_property *suggested_y_property;
> >> >>
> >> >> +	/**
> >> >> +	 * @writeback_fb_id_property: Property for writeback connectors, storing
> >> >> +	 * the ID of the output framebuffer.
> >> >> +	 * See also: drm_writeback_connector_init()
> >> >> +	 */
> >> >> +	struct drm_property *writeback_fb_id_property;
> >> >> +	/**
> >> >> +	 * @writeback_pixel_formats_property: Property for writeback connectors,
> >> >> +	 * storing an array of the supported pixel formats for the writeback
> >> >> +	 * engine (read-only).
> >> >> +	 * See also: drm_writeback_connector_init()
> >> >> +	 */
> >> >> +	struct drm_property *writeback_pixel_formats_property;
> >> >> +
> >> >>  	/* dumb ioctl parameters */
> >> >>  	uint32_t preferred_depth, prefer_shadow;
> >> >>
> >> >> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
> >> >> new file mode 100644
> >> >> index 0000000..6b2ac45
> >> >> --- /dev/null
> >> >> +++ b/include/drm/drm_writeback.h
> >> >> @@ -0,0 +1,78 @@
> >> >> +/*
> >> >> + * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
> >> >> + * Author: Brian Starkey <brian.starkey@arm.com>
> >> >> + *
> >> >> + * This program is free software and is provided to you under the terms of the
> >> >> + * GNU General Public License version 2 as published by the Free Software
> >> >> + * Foundation, and any use by you of this program is subject to the terms
> >> >> + * of such GNU licence.
> >> >> + */
> >> >> +
> >> >> +#ifndef __DRM_WRITEBACK_H__
> >> >> +#define __DRM_WRITEBACK_H__
> >> >> +#include <drm/drm_connector.h>
> >> >> +#include <linux/workqueue.h>
> >> >> +
> >> >> +struct drm_writeback_connector {
> >> >> +	struct drm_connector base;  
> >> >
> >> >AFAIU, a writeback connector will always require an 'dummy' encoder to
> >> >make the DRM framework happy (AFAIK, a connector is always connected to
> >> >a CRTC through an encoder).
> >> >
> >> >Wouldn't it make more sense to have a drm_encoder object embedded in
> >> >drm_writeback_connector so that people don't have to declare an extra
> >> >structure containing both the drm_writeback_connector connector and a
> >> >drm_encoder? Is there a good reason to keep them separate?
> >> >  
> >>
> >> Yeah that's not a bad idea. The encoder funcs could be passed in to
> >> drm_writeback_connector_init() (in which case adding a writeback
> >> encoder type would also make sense).  
> >
> >Well, the more I look at it the more I find it weird to represent this
> >writeback feature as a connector. To me, it seems to be closer to a
> >plane object (DRM_PLANE_TYPE_WRITEBACK?) than a real connector.
> >Actually, the Atmel HLCDC IP use the same register interface to expose
> >the overlay planes and writeback features.
> >Of course, representing it as a plane requires patching the core to
> >allow enabling a CRTC that has no active connectors connected to it if
> >at least one writeback plane is enabled and connected to the CRTC, but
> >it should be doable.  
> 
> Could you expand a bit on how you think planes fit better?

Just had the impression that the writeback feature was conceptually
closer to a plane object (which is attached buffers and expose ways to
specify which portion of the buffer should be used, provides way to
atomically switch 2 buffers, ...).

> It is
> something we've previously talked about internally, but so far I'm not
> convinced :-)

Okay, as I said, I don't know all the history, hence my questions ;-).

> 
> >By doing that, we would also get rid of these fake connector/encoder
> >objects as well as the fake modes we are returning in
> >connector->get_modes().  
> 
> What makes the connector/encoder fake? They represent a real piece of
> hardware just the same as a drm_plane would.

Well, that's probably subject to interpretation, but I don't consider
these writeback encoders/connectors as real encoders/connectors. They
are definitely real HW blocks, but not what we usually consider as an
encoder/connector.

> 
> I don't mind dropping the mode list and letting userspace just make
> up whatever timing it wants - it'd need to do the same if writeback
> was a plane - but in some respects giving it a list of modes the same
> way we normally do seems nicer for userspace.
> 
> >
> >As far as I can tell, the VC4 and Atmel HLCDC IP should fit pretty well
> >in this model, not sure about the mali-dp though.
> >
> >Brian, did you consider this approach, and if you did, can you detail
> >why you decided to expose this feature as a connector?
> >
> >Daniel (or anyone else), please step in if you think this is a stupid
> >idea :-).  
> 
> Ville originally suggested using a connector, which Eric followed up
> by saying that's what he was thinking of for VC4 writeback too[1].

Thanks for the pointer.

> That was my initial reason for focussing on a connector-based
> approach.
> 
> I prefer connector over plane conceptually because it keeps with the
> established data flow: planes are sources, connectors are sinks.

Okay, it's a valid point.

> 
> In some respects the plane _object_ looks like it would fit - it has a
> pixel format list and an FB_ID. But everything else would be acting
> the exact opposite to a normal plane, and I think there's a bunch of
> baked-in assumptions in the kernel and userspace around CRTCs always
> having at least one connector.

Yep, but writeback connectors are already different enough to not be
considered as regular connectors, so userspace programs will have to
handle them differently anyway (pass a framebuffer and pixel format to
it before adding them to the display pipeline).

Anyway, I see this approach has already been suggested in [1], and you
all agreed that the writeback feature should be exposed as a connector,
so I'll just stop here :-).

Thanks for taking the time to explain the rationale behind this
decision.

> 
> On the other hand, a writeback connector gains a few extra properties
> over a normal connector, but most stuff stays the same. The pipeline
> setup looks the same as normal to userspace, you don't need a CRTC to
> be active with no connectors, output cloning is the same etc.
> 
> Thanks,
> -Brian
> 
> [1] https://lists.freedesktop.org/archives/dri-devel/2016-July/113329.html
> 
