Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:50934 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935605AbeEXHzq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 03:55:46 -0400
Subject: Re: [PATCHv13 22/28] Documentation: v4l: document request API
To: Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-23-hverkuil@xs4all.nl> <2851052.gK8z6gIKGK@avalon>
 <CAAFQd5Ce0PuB7KwShEzQBaTNeWCJCLipCZcjOY-H2P0jqFzmiA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ff45c9a4-e7bf-f05f-8cbc-672a37f82c11@xs4all.nl>
Date: Thu, 24 May 2018 09:55:43 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ce0PuB7KwShEzQBaTNeWCJCLipCZcjOY-H2P0jqFzmiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/05/18 06:32, Tomasz Figa wrote:
> Hi Laurent,
> 
> Thanks for detailed review. Please let me add my thoughts inline as well.
> 
> On Fri, May 18, 2018 at 11:46 PM Laurent Pinchart <
> laurent.pinchart@ideasonboard.com> wrote:
> 
>> Hi Hans,
> 
>> Thank you for the patch.
> 
>> On Thursday, 3 May 2018 17:53:12 EEST Hans Verkuil wrote:
> 
> [snip]
> 
>>> +Name
>>> +====
>>> +
>>> +MEDIA_REQUEST_IOC_REINIT - Re-initialize a request
>>> +
>>> +
>>> +Synopsis
>>> +========
>>> +
>>> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_REINIT )
>>> +    :name: MEDIA_REQUEST_IOC_REINIT
>>> +
>>> +
>>> +Arguments
>>> +=========
>>> +
>>> +``request_fd``
>>> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> 
>> I was expecting an argument to this ioctl, with a reference to another
> request
>> (and I expected the same reference for the MEDIA_IOC_REQUEST_ALLOC
> ioctl). I
>> think this topic has been discussed several times in the past, but
> possibly
>> not in venues where everybody was present, so I'll detail the problem
> here.
> 
>> The idea behind this version of the request API is to split request
> handling
>> in three parts:
> 
>> 1. A request is allocated (MEDIA_IOC_REQUEST_ALLOC) or an existing
> request is
>> re-initialized (MEDIA_REQUEST_IOC_REINIT). At that point the request
> contains
>> no property (control, format, ...) to be modified.
> 
>> 2. The request is filled with properties to be modified using existing
> V4L2
>> ioctls (VIDIOC_S_EXT_CTRLS, VIDIOC_SUBDEV_S_FMT,
> VIDIOC_SUBDEV_S_SELECTION,
>> ..). The current implementation supports controls only, with support for
>> formats and selection rectangles to be added later.
> 
>> 3. The request is queued with MEDIA_REQUEST_IOC_QUEUE.
> 
>> As usual the devil is in the details, and the details of the second step
> in
>> particular.
> 
>> The idea behind splitting request handling in those three steps is to
> reuse
>> existing V4L2 ioctls as much as possible, and to keep the existing
> semantics
>> of those ioctls. I believe this isn't possible with the proposed
>> MEDIA_IOC_REQUEST_ALLOC and MEDIA_REQUEST_IOC_REINIT ioctls, neither for
>> controls nor for formats or selection rectangles, although the problem is
> more
>> limited for controls. I will thus take formats and selection rectangles to
>> explain where the problem lies.
> 
>> The S_FMT and S_SELECTION semantics on subdevs (and, for that matter, on
> video
>> nodes too) is that those ioctls don't fail when passed parameters invalid
> for
>> the device, but return a valid configuration as close as possible to the
>> requested one. This allows implementing negotiation of formats and
> selection
>> rectangles through an iterative process that involves back-and-forth calls
>> between user space and kernel space until the application finds a usable
>> configuration accepted by the driver, or until it decides to fail because
> such
>> a configuration doesn't exist. (As a reminder, such negotiation is needed
>> because it was deemed impossible to create a proper API that would expose
> all
>> device constraints in a static way.)
> 
>> Formats and selection rectangles are propagated within subdevs from sink
> pads
>> to source pads by the driver. Sink formats and selection rectangles thus
>> influence the result of negotiation on source pads. For instance, on a
> scaler
>> subdev that can't perform format conversion, the format on the source pad
> will
>> be dictated by the format on the sink pad. In order to implement S_FMT on
> the
>> source pad the kernel driver thus needs context information to get the
> format
>> on the sink pad.
> 
>> Without the request API this is easy. The context is either stored in the
>> driver-specific device structure (for active formats) or in the file
> handle
>> (for try formats). With the proposed request API, however, we have no such
>> context: the requests are created empty (or re-initialized to be empty).
>> Kernel drivers can access the active state of the device, or the state of
>> previously queued requests, but can't access the state of prepared but
> not yet
>> queued requests.
> 
>> My proposal to solve this was to link requests by specifying the handle
> of a
>> previous request to the MEDIA_IOC_REQUEST_ALLOC and
> MEDIA_REQUEST_IOC_REINIT
>> ioctls. That way kernel drivers would know in which order requests will be
>> queued, and would be able to access the correct context information to
>> implement the existing semantics of the S_FMT and S_SELECTION ioctls (as
> well
>> as being able to implement the G_FMT and G_SELECTION ioctls). Note that
> the
>> problem isn't limited to format and selection rectangles, similar
> problems can
>> exist when multiple controls are related, such as auto and manual
> controls.
> 
>> This would result in a more complex API and a more complex request
> lifetime
>> management, as well as a more complex semantics of the request API. While
> I
>> thought this was unavoidable, I came to reconsider my position on this
> topic,
>> and I believe that the current request API proposal is acceptable in that
>> regard, provided that we agree that the existing semantics of the S_FMT
> and
>> S_SELECTION ioctls won't need to be implemented for requests as it won't
> be
>> possible to do so. The reason that prompted me to change my mind is that I
>> believe the API would be simpler to define and simpler to use if we
> dropped
>> that semantics, and required applications to create requests that are
> fully
>> valid instead of trying to mangle the content of a request the same way
> we do
>> for format and selection rectangle negotiation. Obviously, negotiation is
>> still needed in order for applications to find a valid configuration, but
> we
>> have the V4L2_SUBDEV_FORMAT_TRY API for that that, in conjunction with the
>> S_FMT and S_SELECTION ioctls, can be used to negotiate a configuration.
> The
>> negotiated configuration could then be set in a request, and would be
>> guaranteed to be valid.
> 
> I really like the idea of requiring the requests to be valid. I believe
> this is something similar to DRM atomic API and it avoids the state
> negotiation hell in the drivers and userspace, where the drivers would be
> adjusting settings back and forth and eventually arriving to some values
> not matching any of the ones originally given.

I agree. If there is a desire to 'try' a request and let the driver modify
incompatible values, then we can make a new ioctl for that, specifically
for that purpose. But I'm not sure if that's really needed.

> 
> [snip]
> 
>>> Codec +v2). One such requirement is the ability for devices belonging to
>>> the same +pipeline to reconfigure and collaborate closely on a per-frame
>>> basis. Another is +efficient support of stateless codecs, which need
>>> per-frame controls to be set +asynchronously in order to be used
>>> efficiently.
> 
>> Do you really mean asynchronously ? I thought the purpose of the request
> API
>> with codecs was to set controls synchronously with frames.
> 
> Set controls synchronized with frames, but submit frames (with matching
> controls) to be processed asynchronously, as compared to no request API,
> when you would have to: - set controls, - queue buffer, - wait for
> decoding, -set controls, - queue buffer, and so on, all synchronously.
> 
> [snip]
> 
>>> synchronize +so the requested pipeline's topology is applied before the
>>> buffers are +processed. This is at the discretion of media controller
>>> drivers and is not a +requirement.
> 
>> One of the main purposes of the request API is to support atomic
>> configuration. Saying that it's simply optional defeats that purpose. I
> agree
>> that atomicity can't be achieved in all cases, and that there will often
> be a
>> best-effort approach, but for hardware devices that support atomic
>> configuration I think applications need to be able to rely on the driver
>> implementing that feature. I would thus put a bit more pressure on drivers
>> than just saying it's fully optional.
> 
> I think we should say that drivers should make their best effort to apply
> the state atomically. However, I'd want to avoid userspace (or users)
> blindly relying on the API as guarantying atomicity, since this really
> depends on hardware capability.

VIDIOC_S_EXT_CTRLS works like that as well: it does a best-effort to ensure
atomicity, but it is constrained by HW capabilities.

> 
> 
>>> +Buffers queued without an associated request after a request-bound
> buffer
>>> will +be processed using the state of the hardware at the time of the
>>> request +completion.
> 
>> I'm not sure to follow that, could you explain in a bit more details ?
> Also,
>> even more than for controls (see below), I really want to know about use
> cases
>> for mixing buffers in and outside of requests for the same buffer queue
> before
>> accepting it.
> 
> AFAIR this was defined just to avoid making the API have undefined
> behavior. I can't think of any real use case for mixing requests with
> non-request processing (at least within the same buffer queue)...

In my upcoming v15 of this patch series I prohibit mixing of request
and non-request buffers: once the first request buffer is queued to a
vb2_queue all following buffers must also be part of a request until the
queue is canceled.

This is a fair restriction in my opinion.

> 
> [snip]
> 
>>> All the same, controls set without a request are applied +immediately,
>>> regardless of whether a request is in use or not.
> 
>> This will be tricky to implement, and will potentially generate side
> effects
>> difficult to handle, and difficult to debug. I understand that this is a
>> requirement for codecs, but I don't know the exact use case(s), so I can't
>> comment on whether this is the right approach.
> 
> I don't think this is a requirement for codecs. Not for stateless ones for
> sure, because for them the requirement is to actually use the requests for
> setting controls.
> 
> As above, I think this was defined to avoid making the API have undefined
> behavior, but I can also see some classes of controls which should be
> handled regardless of buffers flow, e.g. autofocus, where the userspace
> just wants the motor to start moving instantly after the user clicks the
> screen (tap-to-focus).

I implemented the same for VIDIOC_S_EXT_CTRLS: once a queue switches to
using requests it is no longer allowed to set controls outside of requests.
You can still read the current HW state, though.

I'm not sure yet whether this is what I want. I think there are controls
where using requests do not necessarily make sense. E.g. setting the
powerline frequency (50 vs 60 Hz): really not something you need a request
for.

I see the following options here:

1) Allow setting controls directly or via requests as implemented in v13:
   it is up to userspace to not do anything stupid.
2) Never allow mixing (as is currently implemented in v15)
3) Have drivers explicitly mark controls that should only be set via
   requests (new control flag). Thus drivers can prevent mixing on a
   per-control basis.
4) Once a control was made part of a request then the core marks it
   as 'request-only' and will refuse setting it directly. Basically the
   same as 3, but done automatically.

Even though I implemented 2 for v15, I am not actually happy about it.
I like 1 or 3 better. Option 4, while relatively easy to implement, leads
to unexpected side-effects (you add a control to a request and suddenly
you can't set it directly anymore).

Personally I do not see a problem with 1. It makes debugging easier
(you can still set controls while streaming to test behavior) and I think
it is not unreasonable to expect userspace to do sane things. Adding a
fat notice to the spec that says that setting the same control both directly
and through requests can lead to undefined results seems sufficient to me.

I might actually switch back to option 1 before I post v15, I'm doing a
good job of convincing myself :-)

Regards,

	Hans
