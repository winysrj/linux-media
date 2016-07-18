Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:57235 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbcGRK3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 06:29:44 -0400
Date: Mon, 18 Jul 2016 11:29:33 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Eric Anholt <eric@anholt.net>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?=
	<ville.syrjala@linux.intel.com>, dri-devel@lists.freedesktop.org,
	liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org, david.brown@arm.com,
	daniel.vetter@ffwll.ch
Subject: Re: DRM device memory writeback (Mali-DP)
Message-ID: <20160718102933.GA603@e106950-lin.cambridge.arm.com>
References: <20160714170340.GA32755@e106950-lin.cambridge.arm.com>
 <20160715073334.GO17101@phenom.ffwll.local>
 <20160715090918.GB32755@e106950-lin.cambridge.arm.com>
 <20160715105715.GG4329@intel.com>
 <87r3auajdi.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r3auajdi.fsf@eliezer.anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Jul 15, 2016 at 10:42:01AM -0700, Eric Anholt wrote:
>Ville Syrjälä <ville.syrjala@linux.intel.com> writes:
>
>> On Fri, Jul 15, 2016 at 10:09:19AM +0100, Brian Starkey wrote:
>>> Hi Daniel,
>>>
>>> Thanks for taking a look.
>>>
>>> (+Cc Laurent)
>>>
>>> On Fri, Jul 15, 2016 at 09:33:34AM +0200, Daniel Vetter wrote:
>>> >On Thu, Jul 14, 2016 at 06:03:40PM +0100, Brian Starkey wrote:
>>> >> Hi,
>>> >>
>>> >> The Mali-DP display processors have a memory-writeback engine which
>>> >> can write the result of the composition (CRTC output) to a memory
>>> >> buffer in a variety of formats.
>>> >>
>>> >> We're looking for feedback/suggestions on how to expose this in the
>>> >> mali-dp DRM kernel driver - possibly via V4L2.
>>> >>
>>> >> We've got a few use cases where writeback is useful:
>>> >>    - testing, to check the displayed image
>>> >
>>> >This might or might not need a separate interface. There are efforts to
>>> >make the intel kms validation tests in i-g-t generic (well under way
>>> >already), and part of that is creating a generic infrastructure to capture
>>> >display CRCs for functional tests (still in progress).
>>> >
>>> >But it might be better if userspace abstracts between full readback and
>>> >display CRC, assuming we can make full writeback cross-vendor enough for
>>> >that use-case.
>>> >
>>>
>>> I'd lean towards the userspace abstraction.
>>> Encumbering a simple CRC interface with all the complexity of
>>> full-writeback (size, scaling, pixel format, multi-planar etc.) sounds
>>> a bit unnecessary.
>>>
>>> Of course, if v4l2 isn't going to be the cross-vendor full-writeback
>>> implementation, then we need to be aiming to use whatever _is_ in
>>> the mali-dp driver.
>>>
>>> >>    - screen recording
>>> >>    - wireless display (e.g. Miracast)
>>> >>    - dual-display clone mode
>>> >>    - memory-to-memory composition
>>> >> Note that the HW is capable of writing one of the input planes instead
>>> >> of the CRTC output, but we've no good use-case for wanting to expose
>>> >> that.
>>> >>
>>> >> In our Android ADF driver[1] we exposed the memory write engine as
>>> >> part of the ADF device using ADF's "MEMORY" interface type. DRM/KMS
>>> >> doesn't have any similar support for memory output from CRTCs, but we
>>> >> want to expose the functionality in the mainline Mali-DP DRM driver.
>>> >>
>>> >> A previous discussion on the topic went towards exposing the
>>> >> memory-write engine via V4L2[2].
>>> >>
>>> >> I'm thinking to userspace this would look like two distinct devices:
>>> >>    - A DRM KMS display controller.
>>> >>    - A V4L2 video source.
>>> >> They'd both exist in the same kernel driver.
>>> >> A V4L2 client can queue up (CAPTURE) buffers in the normal way, and
>>> >> the DRM driver would see if there's a buffer to dequeue every time a
>>> >> new modeset is received via the DRM API - if so, it can configure the
>>> >> HW to dump into it (one-shot operation).
>>> >>
>>> >> An implication of this is that if the screen is actively displaying a
>>> >> static scene and the V4L2 client queues up a buffer, it won't get
>>> >> filled until the DRM scene changes. This seems best, otherwise the
>>> >> V4L2 driver has to change the HW configuration out-of-band from the
>>> >> DRM device which sounds horribly racy.
>>> >>
>>> >> One further complication is scaling. Our HW has a scaler which can
>>> >> tasked with either scaling an input plane or the buffer being written
>>> >> to memory, but not both at the same time. This means we need to
>>> >> arbitrate the scaler between the DRM device (scaling input planes) and
>>> >> the V4L2 device (scaling output buffers).
>>> >>
>>> >> I think the simplest approach here is to allow V4L2 to "claim" the
>>> >> scaler by setting the image size (VIDIOC_S_FMT) to something other
>>> >> than the CRTC's current resolution. After that, any attempt to use the
>>> >> scaler on an input plane via DRM should fail atomic_check().
>>> >
>>> >That's perfectly fine atomic_check behaviour. Only trouble is that the v4l
>>> >locking must integrate into the drm locking, but that should be doable.
>>> >Worst case you must shadow all v4l locks with a wait/wound
>>> >drm_modeset_lock to avoid deadlocks (since you could try to grab locks
>>> >from either end).
>>> >
>>>
>>> Yes, I haven't looked at the details of the locking but I'm hoping
>>> it's manageable.
>>>
>>> >> If the V4L2 client goes away or sets the image size to the CRTC's
>>> >> native resolution, then the DRM device is allowed to use the scaler.
>>> >> I don't know if/how the DRM device should communicate to userspace
>>> >> that the scaler is or isn't available for use.
>>> >>
>>> >> Any thoughts on this approach?
>>> >> Is it acceptable to both V4L2 and DRM folks?
>>> >
>>> >For streaming a V4L2 capture device seems like the right interface. But if
>>> >you want to use writeback in your compositor you must know which atomic
>>> >kms update results in which frame, since if you don't you can't use that
>>> >composited buffer for the next frame reliable.
>>> >
>>> >For that case I think a drm-only solution would be better, to make sure
>>> >you can do an atomic update and writeback in one step. v4l seems to grow
>>> >an atomic api of its own, but I don't think we'll have one spanning
>>> >subsystems anytime soon.
>>> >
>>>
>>> I've been thinking about this from the point of view of a HWComposer
>>> implementation and I think the hybrid DRM-V4L2 device would work OK.
>>> However it depends on the behaviour I mentioned above:
>>>
>>> >> if the screen is actively displaying a
>>> >> static scene and the V4L2 client queues up a buffer, it won't get
>>> >> filled until the DRM scene changes.
>>>
>>> V4L2 buffer queues are FIFO, so as long as the compositor queues only
>>> one V4L2 buffer per atomic update, there's no ambiguity.
>>> In the most simplistic case the compositor would alternate between:
>>>   - Queue V4L2 buffer
>>>   - DRM atomic update
>>> ... and dequeue either in the same thread or a different one. As long
>>> as the compositor keeps track of how many buffers it has queued and
>>> how many atomic updates it's made, it doesn't really matter.
>>>
>>> We'd probably be looking to add in V4L2 asynchronous dequeue using
>>> fences for synchronisation, but that's a separate issue.
>>>
>>> >For the kms-only interface the idea was to add a property on the crtc
>>> >where you can attach a writeback drm_framebuffer. Extending that idea to
>>> >the drm->v4l case we could create special drm_framebuffer objects
>>> >representing a v4l sink, and attach them to the same property. That would
>>> >also solve the problem of getting some agreement on buffer metadata
>>> >between v4l and drm side.
>>> >
>>>
>>> I think a drm_framebuffer on its own wouldn't be enough to handle our
>>> scaling case - at that point it starts to look more like a plane.
>>> However, if "special" CRTC sinks became a thing it could allow us to
>>> chain our writeback output to another CRTC's input (via memory)
>>> without a trip through userspace, which would be nice.
>>
>> My thinking has been that we could represent the writeback sink
>> as a connector. Combine that with my other idea of exposing a
>> fixed mode property for each connector (to make output scaling
>> user configurable), and we should end up with a way to control
>> the scaling of the writeback path.
>>
>> Also it would mean there's always a connector attached to the
>> crtc, even for the pure writeback only case, which I think should
>> result in less problems in general as I'm sure there are a lot of
>> assumptions in the code that there must be at least one connector
>> for an active crtc.
>
>This is what I've been thinking for vc4's writeback as well.  I
>definitely want my writeback to be using the same drivers/gpu/drm/vc4
>code for setting up the hardware.  And, since I expect writeback to be
>mostly used by compositors for the case where a frame exceeds bandwidth
>constraints, I want userspace to be able to use the same DRM APIs for
>setting up the frame to be written back as it was trying to use for
>setting up the frame before.

OK, so let's talk about using connectors instead then :-)

We can attach a generic fixed_mode property which can represent panel
fitters or Mali-DP's writeback scaling, that sounds good.

The DRM driver can create a new "virtual" encoder/connector pair, I
guess with a new connector type specifically for memory-writeback?
On this connector we allow the fb_id property to attach a framebuffer
for writing into.
We'd probably want an additional property to enable writeback, perhaps
an enum: "disabled", "streaming", "oneshot".

I think it makes sense to put the output buffer format, size etc.
validation in the virtual encoder's atomic_check. It has access to
both CRTC and connector state, and the encoder is supposed to
represent the format/stream conversion element anyway.

What I'm not so clear on is how to manage the API with userspace.

Changing connectors is a "full modeset required" operation. I expect
this means an application needs to know up-front if it will ever make
use of memory-writeback, and if so do its initial modeset on both the
writeback and the normal connector, even if it doesn't attach a
writeback framebuffer until much later. Otherwise, enabling writeback
will force a full disable-modeset-enable cycle.

The writeback connector would have to be hidden from legacy clients
which would expect it to work like a normal connector - I suppose
that's somewhat similar to universal planes.

For the case that Ville mentioned where only the writeback connector
is connected, would userspace be expected to "make up" a
drm_mode_modeinfo to set? I can't think of any meaningful list of
available modes for the writeback connector to report.

Thanks for all the input so far!

-Brian
