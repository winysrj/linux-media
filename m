Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34659 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbeEXEcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 00:32:48 -0400
Received: by mail-ua0-f193.google.com with SMTP id f22-v6so208945uam.1
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 21:32:48 -0700 (PDT)
Received: from mail-ua0-f180.google.com (mail-ua0-f180.google.com. [209.85.217.180])
        by smtp.gmail.com with ESMTPSA id s3-v6sm3299767uas.34.2018.05.23.21.32.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 May 2018 21:32:46 -0700 (PDT)
Received: by mail-ua0-f180.google.com with SMTP id b25-v6so207788uak.3
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 21:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180503145318.128315-1-hverkuil@xs4all.nl> <20180503145318.128315-23-hverkuil@xs4all.nl>
 <2851052.gK8z6gIKGK@avalon>
In-Reply-To: <2851052.gK8z6gIKGK@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 24 May 2018 13:32:33 +0900
Message-ID: <CAAFQd5Ce0PuB7KwShEzQBaTNeWCJCLipCZcjOY-H2P0jqFzmiA@mail.gmail.com>
Subject: Re: [PATCHv13 22/28] Documentation: v4l: document request API
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for detailed review. Please let me add my thoughts inline as well.

On Fri, May 18, 2018 at 11:46 PM Laurent Pinchart <
laurent.pinchart@ideasonboard.com> wrote:

> Hi Hans,

> Thank you for the patch.

> On Thursday, 3 May 2018 17:53:12 EEST Hans Verkuil wrote:

[snip]

> > +Name
> > +====
> > +
> > +MEDIA_REQUEST_IOC_REINIT - Re-initialize a request
> > +
> > +
> > +Synopsis
> > +========
> > +
> > +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_REINIT )
> > +    :name: MEDIA_REQUEST_IOC_REINIT
> > +
> > +
> > +Arguments
> > +=========
> > +
> > +``request_fd``
> > +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.

> I was expecting an argument to this ioctl, with a reference to another
request
> (and I expected the same reference for the MEDIA_IOC_REQUEST_ALLOC
ioctl). I
> think this topic has been discussed several times in the past, but
possibly
> not in venues where everybody was present, so I'll detail the problem
here.

> The idea behind this version of the request API is to split request
handling
> in three parts:

> 1. A request is allocated (MEDIA_IOC_REQUEST_ALLOC) or an existing
request is
> re-initialized (MEDIA_REQUEST_IOC_REINIT). At that point the request
contains
> no property (control, format, ...) to be modified.

> 2. The request is filled with properties to be modified using existing
V4L2
> ioctls (VIDIOC_S_EXT_CTRLS, VIDIOC_SUBDEV_S_FMT,
VIDIOC_SUBDEV_S_SELECTION,
> ..). The current implementation supports controls only, with support for
> formats and selection rectangles to be added later.

> 3. The request is queued with MEDIA_REQUEST_IOC_QUEUE.

> As usual the devil is in the details, and the details of the second step
in
> particular.

> The idea behind splitting request handling in those three steps is to
reuse
> existing V4L2 ioctls as much as possible, and to keep the existing
semantics
> of those ioctls. I believe this isn't possible with the proposed
> MEDIA_IOC_REQUEST_ALLOC and MEDIA_REQUEST_IOC_REINIT ioctls, neither for
> controls nor for formats or selection rectangles, although the problem is
more
> limited for controls. I will thus take formats and selection rectangles to
> explain where the problem lies.

> The S_FMT and S_SELECTION semantics on subdevs (and, for that matter, on
video
> nodes too) is that those ioctls don't fail when passed parameters invalid
for
> the device, but return a valid configuration as close as possible to the
> requested one. This allows implementing negotiation of formats and
selection
> rectangles through an iterative process that involves back-and-forth calls
> between user space and kernel space until the application finds a usable
> configuration accepted by the driver, or until it decides to fail because
such
> a configuration doesn't exist. (As a reminder, such negotiation is needed
> because it was deemed impossible to create a proper API that would expose
all
> device constraints in a static way.)

> Formats and selection rectangles are propagated within subdevs from sink
pads
> to source pads by the driver. Sink formats and selection rectangles thus
> influence the result of negotiation on source pads. For instance, on a
scaler
> subdev that can't perform format conversion, the format on the source pad
will
> be dictated by the format on the sink pad. In order to implement S_FMT on
the
> source pad the kernel driver thus needs context information to get the
format
> on the sink pad.

> Without the request API this is easy. The context is either stored in the
> driver-specific device structure (for active formats) or in the file
handle
> (for try formats). With the proposed request API, however, we have no such
> context: the requests are created empty (or re-initialized to be empty).
> Kernel drivers can access the active state of the device, or the state of
> previously queued requests, but can't access the state of prepared but
not yet
> queued requests.

> My proposal to solve this was to link requests by specifying the handle
of a
> previous request to the MEDIA_IOC_REQUEST_ALLOC and
MEDIA_REQUEST_IOC_REINIT
> ioctls. That way kernel drivers would know in which order requests will be
> queued, and would be able to access the correct context information to
> implement the existing semantics of the S_FMT and S_SELECTION ioctls (as
well
> as being able to implement the G_FMT and G_SELECTION ioctls). Note that
the
> problem isn't limited to format and selection rectangles, similar
problems can
> exist when multiple controls are related, such as auto and manual
controls.

> This would result in a more complex API and a more complex request
lifetime
> management, as well as a more complex semantics of the request API. While
I
> thought this was unavoidable, I came to reconsider my position on this
topic,
> and I believe that the current request API proposal is acceptable in that
> regard, provided that we agree that the existing semantics of the S_FMT
and
> S_SELECTION ioctls won't need to be implemented for requests as it won't
be
> possible to do so. The reason that prompted me to change my mind is that I
> believe the API would be simpler to define and simpler to use if we
dropped
> that semantics, and required applications to create requests that are
fully
> valid instead of trying to mangle the content of a request the same way
we do
> for format and selection rectangle negotiation. Obviously, negotiation is
> still needed in order for applications to find a valid configuration, but
we
> have the V4L2_SUBDEV_FORMAT_TRY API for that that, in conjunction with the
> S_FMT and S_SELECTION ioctls, can be used to negotiate a configuration.
The
> negotiated configuration could then be set in a request, and would be
> guaranteed to be valid.

I really like the idea of requiring the requests to be valid. I believe
this is something similar to DRM atomic API and it avoids the state
negotiation hell in the drivers and userspace, where the drivers would be
adjusting settings back and forth and eventually arriving to some values
not matching any of the ones originally given.

[snip]

> > Codec +v2). One such requirement is the ability for devices belonging to
> > the same +pipeline to reconfigure and collaborate closely on a per-frame
> > basis. Another is +efficient support of stateless codecs, which need
> > per-frame controls to be set +asynchronously in order to be used
> > efficiently.

> Do you really mean asynchronously ? I thought the purpose of the request
API
> with codecs was to set controls synchronously with frames.

Set controls synchronized with frames, but submit frames (with matching
controls) to be processed asynchronously, as compared to no request API,
when you would have to: - set controls, - queue buffer, - wait for
decoding, -set controls, - queue buffer, and so on, all synchronously.

[snip]

> > synchronize +so the requested pipeline's topology is applied before the
> > buffers are +processed. This is at the discretion of media controller
> > drivers and is not a +requirement.

> One of the main purposes of the request API is to support atomic
> configuration. Saying that it's simply optional defeats that purpose. I
agree
> that atomicity can't be achieved in all cases, and that there will often
be a
> best-effort approach, but for hardware devices that support atomic
> configuration I think applications need to be able to rely on the driver
> implementing that feature. I would thus put a bit more pressure on drivers
> than just saying it's fully optional.

I think we should say that drivers should make their best effort to apply
the state atomically. However, I'd want to avoid userspace (or users)
blindly relying on the API as guarantying atomicity, since this really
depends on hardware capability.


> > +Buffers queued without an associated request after a request-bound
buffer
> > will +be processed using the state of the hardware at the time of the
> > request +completion.

> I'm not sure to follow that, could you explain in a bit more details ?
Also,
> even more than for controls (see below), I really want to know about use
cases
> for mixing buffers in and outside of requests for the same buffer queue
before
> accepting it.

AFAIR this was defined just to avoid making the API have undefined
behavior. I can't think of any real use case for mixing requests with
non-request processing (at least within the same buffer queue)...

[snip]

> > All the same, controls set without a request are applied +immediately,
> > regardless of whether a request is in use or not.

> This will be tricky to implement, and will potentially generate side
effects
> difficult to handle, and difficult to debug. I understand that this is a
> requirement for codecs, but I don't know the exact use case(s), so I can't
> comment on whether this is the right approach.

I don't think this is a requirement for codecs. Not for stateless ones for
sure, because for them the requirement is to actually use the requests for
setting controls.

As above, I think this was defined to avoid making the API have undefined
behavior, but I can also see some classes of controls which should be
handled regardless of buffers flow, e.g. autofocus, where the userspace
just wants the motor to start moving instantly after the user clicks the
screen (tap-to-focus).

> While I don't necessarily
> reject this feature on principle, I first want to know more about the use
> case(s) before accepting it. If we end up needing it, we'll have to better
> document it, by clearly specifying what is allowed and what isn't (for
> instance, we might decide to allow setting control asynchronously only
when
> they're not simultaneously modified through a queued request), as well as
the
> exact behaviour that applications can expect in the allowed cases.

[snip]

> > +If ``request_fd`` is specified and ``which`` is set to
> > ``V4L2_CTRL_WHICH_REQUEST_VAL`` +during a call to
:ref:`VIDIOC_G_EXT_CTRLS
> > <VIDIOC_G_EXT_CTRLS>`, then the +returned values will be the values
> > currently set for the request (or the +hardware value if none is set)

> Do we really have a need for returning the hardware value ? That seems a
bit
> random to me, wouldn't it be better to return an error instead ?

As per my autofocus example above and also things like various statistics
from camera sensor that don't really depend on other state (e.g. absolute
light intensity), we want to read the values instantly, for example to
drive the userspace 3A loop.

[snip]

> > diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> > b/Documentation/media/uapi/v4l/vidioc-qbuf.rst index
> > 9e448a4aa3aa..c9f55d8340d1 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> > @@ -98,6 +98,13 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF
> > <VIDIOC_STREAMON>` or
> >  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
> >
> >  device is closed.
> >
> > +The ``request_fd`` field can be used when queuing to specify the file
> > +descriptor of a request, if requests are in use. Setting it means that
the
> > +buffer will not be passed to the driver until the request itself is
queued.
> > +Also, the driver will apply any setting associated with the request
before
> > +processing the buffer.

> I think we should be more precise with the wording, here and above in the
> documentation. From an API point of view, we need to guarantee that the
> settings from the request are used to process the image capture in the
buffer,
> or the image output from the buffer.

Making the API guarantee that would essentially eliminate usage of this API
from any hardware that can't guarantee 100% atomicity of all the state
within request, which I'd say would be actually most of existing hardware.

> Drivers don't process buffers other than
> queuing them to the hardware, so saying that the driver will apply
settings
> before processing the buffer is a bit vague in my opinion, and also
possibly
> not very accurate depending on the hardware.

The question is whether we can guarantee anything more precise.


> Saying that controls are applied right before the buffer is processed by
the
> driver is inaccurate : for example exposure time might need several
frames to
> take effect, and might thus need to be applied a few frames before the
buffer
> is queued to the hardware for capture.

I believe this would be typically accounted for the userspace queuing such
exposure setting several requests before. Hardware that would be able to
handle this on its own, if such exists, would be treated as 0 frame delay
of exposure setting. (We might need a way to report that for drivers,
though. Right now we can just have configuration files for userspace.)

> The other way around is possible too :
> the hardware might support a buffer queue but have no queue for controls.
> Controls would then need to be applied a few frames after the buffer is
queued
> to the hardware in order to take effect for the right buffer.

> We're specifying an API that carries very strong semantics across multiple
> components and multiple objects, so I think it's very important to be as
> precise as possible.

Or, do you just mean, s/before processing the buffer/before hardware starts
processing the buffer/?

Best regards,
Tomasz
