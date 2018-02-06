Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:10004 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753267AbeBFWTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 17:19:45 -0500
Date: Wed, 7 Feb 2018 00:19:37 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/8] v4l2: document the request API interface
Message-ID: <20180206221937.2o4pns6vqxycsq3i@kekkonen.localdomain>
References: <20180126060216.147918-1-acourbot@chromium.org>
 <20180126060216.147918-7-acourbot@chromium.org>
 <eab05349-30ac-f023-75b1-4bb5512cb892@xs4all.nl>
 <CAPBb6MU5kXQqBO62N0XFR65gHcekCdMA2wmR+MBOr3B_bK-ecQ@mail.gmail.com>
 <b2dbe582-46d1-58fc-907a-2ce6a08cd1c1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2dbe582-46d1-58fc-907a-2ce6a08cd1c1@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Alexandre,

On Wed, Jan 31, 2018 at 09:26:10AM +0100, Hans Verkuil wrote:
> On 01/30/2018 07:31 AM, Alexandre Courbot wrote:
> > On Tue, Jan 30, 2018 at 1:03 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> On 01/26/2018 07:02 AM, Alexandre Courbot wrote:

...

> >>> +Recycling and Destruction
> >>> +-------------------------
> >>> +
> >>> +Finally, completed request can either be discarded or be reused. Calling
> >>> +``close()`` on a request FD will make that FD unusable, freeing the request if
> >>> +it is not referenced elsewhere. The ``MEDIA_REQ_CMD_REINIT`` command will clear
> >>> +a request's state and make it available again. No state is retained by this
> >>> +operation: the request is as if it had just been allocated via
> >>> +``MEDIA_REQ_CMD_ALLOC``.
> >>> +
> >>> +RFC Note: Since requests are represented by FDs themselves, the
> >>> +``MEDIA_REQ_CMD_SUBMIT`` and ``MEDIA_REQ_CMD_REININT`` commands can be performed
> >>> +on the request FD instead of the media device. This means the media device would
> >>> +only need to manage ``MEDIA_REQ_CMD_ALLOC``, which could be turned into an
> >>> +ioctl, while ``MEDIA_REQ_CMD_SUBMIT`` and ``MEDIA_REQ_CMD_REININT`` would
> >>> +become ioctls on the request itself. This has the advantage of allowing
> >>> +receivers of a request FD to submit the request, and also decouples requests
> >>> +from the media device - a scenario that makes sense for stateless codecs where
> >>> +the media device is not really useful.
> >>
> >> I think allowing SUBMIT/REINIT to operate directly on the request fd makes sense.
> >>
> >> A few questions that I haven't seen answered here:
> >>
> >> - can I reinit a request if it hasn't yet been submitted? Or can this only be
> >>   done on completed requests?
> > 
> > Interesting question. Right now this is possible, but the behavior may
> > be not well defined.
> > 
> > It is easy to cancel applying the controls of the request, since they
> > only exist within it. Otherwise, we cannot say the same about queued
> > buffers. Should be dequeue them, or let them proceed without any
> > request associated? I suppose dequeuing would make the most sense
> > here.
> 
> Related to this: what happens if I close the request fd having already set
> values and queued buffers, but not yet submitted the request.

It's painful. The request will be gone so all resources related to it must
be released. That means the buffer must be returned to the user, with the
error flag set.

It'd be great if this would be fully managed with videobuf2 / MC request
frameworks.

> 
> It's a similar situation to calling REINIT, but this scenario is very real
> since an application can always do this, you can't prevent it.
> 
> So since you need to implement and define this close(request_fd) scenario
> regardless, I think REINIT can just use this.
> 
> > 
> >> - can I reinit (or perhaps also alloc) a request based on an existing request?
> >>   (sort of a clone operation). I can't remember what we decided in the Prague
> >>   meeting, sorry about that.
> > 
> > Not at the moment. IIRC we decided this was out of scope as the
> > correct behavior in that case is hard to define (do we clone the whole
> > state? only the state that has explicitly been set? how about queued
> > buffers?). We would need to discuss that in more detail if we want
> > such a feature.
> > 
> >> - a request effectively contains the things you want to change, so anything not
> >>   explicitly set in the request will have what value? This should be the current
> >>   hardware value with any changes specified in preceding requests on top.
> > 
> > That's what we agreed on, yes. I need to check whether your patchset
> > does exactly that, but it should be possible to adapt it in case it
> > doesn't yet.
> 
> I don't believe this first version does that. I'm waiting for working code
> that I can use to implement this. I need something to test with :-)
> 
> I remember that I had a good idea on how to implement this. I hope I can still
> remember what it was exactly when I start working on this :-)
> 
> > 
> >> - add an RFC note that requests do not have to complete in the same order that they
> >>   were queued. A codec driver can (at least in theory) hold on to a buffer
> >>   containing a key frame until that frame is no longer needed. But this also
> >>   relates to the fences support, so let's keep this an RFC for now until that
> >>   patch series has been merged.
> > 
> > Good point, agreed.
> > 
> >> - how do we know that the request API is supported by a driver? I think we
> >>   wanted a new capability for that?
> > 
> > For video devices, I think it may be more flexible if we can make it
> > part of the format. It would also allow us to specify more coarsely
> > the extend to which requests are acceptable (e.g. for codec drivers,
> > the OUTPUT queue would accept them, but not the CAPTURE queue).
> 
> I'd say, make a proposal and we can discuss this further.
> 
> In general I always felt that we are missing capabilities that tell userspace
> what a DMA queue can do (e.g. which of the MMAP, USERPTR and DMA_BUF streaming
> modes are supported, is the state per-filehandle or global, can it support the
> request API). It would be nice to have a solution that takes this higher level
> view into account.
> 
> > I am not sure whether media devices have capabilities of some sort? Or
> > maybe we can just rely on MEDIA_REQ_CMD_ALLOC returning -ENOSYS to
> > detect that?
> 
> It's not a MC capability IMHO. Other than that if the MC cannot allocate
> requests the MEDIA_REQ_CMD_ALLOC ioctl would return -ENOTTY.

You could use other request commands, too, without side effects such as
allocating a request. The error code would tell you (-ENOTTY vs. something
else such as -EINVAL).

> 
> > 
> >> - it is allowed to query the values of a submitted request, or will that return
> >>   -EBUSY while it is not completed? I see no reason not to allow it.
> > 
> > As of know this is working and will return either the hardware value
> > if a control is not set by the request, or the value set in the
> > request if it is.
> 
> To be precise: it should return the value from the last queued request that
> sets it, or from the hardware if there is no such request.
> 
> > 
> >> - what happens when a value inside a request can't be applied? (e.g. due to a
> >>   hardware error or some other unusual situation).
> > 
> > I need to give this more thought, but I suppose the buffers should be
> > returned as usual when a failure happens. Maybe we need a way to
> > signal the error through the request too, and another to cancel
> > operation on the whole pipeline when an error occurs somewhere.
> 
> I think we definitely should have a way to signal the error through the
> request.

The release fop may return an error, too. I just find this a bit funny way
to tell there's been an error --- it's little and there's hardly a
possibility of making it more verbose than that.

The MC events would be another option. We'll need them anyway but that's
far, far ahead in the future (when all request related information could go
through MC).

> 
> > 
> >>
> >>> +
> >>> +Example for a Codec Device
> >>> +--------------------------
> >>> +
> >>> +Codecs are single-node V4L2 devices providing one OUTPUT queue (for user-space
> >>> +to provide input buffers) and one CAPTURE queue (to retrieve processed data).
> >>> +
> >>> +In this use-case, request API is used to associate specific controls to be
> >>> +applied by the driver before processing a buffer from the OUTPUT queue. When
> >>> +retrieving a buffer from a capture queue, user-space can then identify which
> >>> +request, if any, produced it by looking at the request_fd field of the dequeued
> >>> +v4l2_buffer.
> >>
> >> I'd start with the code to allocate a request.
> > 
> > Will fix that.
> > 
> >>
> >>> +Put into code, after obtaining a request, user-space can assign controls and one
> >>> +OUTPUT buffer to it:
> >>> +
> >>> +     struct v4l2_buf buf;
> >>> +     struct v4l2_ext_controls ctrls;
> >>> +     ...
> >>> +     ctrls.request_fd = req_fd;
> >>> +     ...
> >>> +     ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> >>> +     ...
> >>> +     buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> >>> +     buf.request_fd = req_fd;
> >>> +     ioctl(codec_fd, VIDIOC_QBUF, &buf);
> >>> +
> >>> +Note that request_fd shall not be specified for CAPTURE buffers.
> >>
> >> I know why, but the less experienced reader won't. So this needs some additional
> >> explanation.
> > 
> > Sure.
> > 
> >>
> >>> +
> >>> +Once the request is fully prepared, it can be submitted to the driver:
> >>> +
> >>> +     struct media_request_cmd cmd;
> >>> +
> >>> +     memset(&cmd, 0, sizeof(cmd));
> >>> +     cmd.cmd = MEDIA_REQ_CMD_SUBMIT;
> >>> +     cmd.fd = request_fd;
> >>> +     ioctl(media_fd, MEDIA_IOC_REQUEST_CMD, &cmd);
> >>> +
> >>> +User-space can then lookup the request_fd field of dequeued capture buffers to
> >>> +confirm which one has been produced by the request.
> >>> +
> >>> +     struct v4l2_buf buf;
> >>> +
> >>> +     memset(&buf, 0, sizeof(buf));
> >>> +     buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >>> +     ioctl(codec_fd, VIDIOC_DQBUF, &buf);
> >>> +
> >>> +     if (buf.request_fd == request_fd)
> >>> +             ...
> >>> +
> >>
> >> I'm not sure this is correct. You set the request for the OUTPUT buffer, so when
> >> you dequeue the OUTPUT buffer, then the request_fd is set to the original request.
> >> But this is the CAPTURE buffer, and that has no requests at all.
> > 
> > This is not a mistake actually. The idea is to allow user-space to
> > know which request produced a given capture buffer. One output buffer
> > can in theory produce several or no capture buffers, and I think this
> > is the only reliable way to associate them with their producing
> > request.
> 
> You can't do this. There is no reason why the CAPTURE queue can't use requests
> as well (the queues are independent). Although for the codec use-case it is unlikely
> to happen, other use-cases may want requests for both OUTPUT and CAPTURE.

I'd say it must use requests. I doubt there are any valid use cases in
mixing request and non-request based operations on a device simultaneously;
having to support both at the same time adds complexity, and there should
be a reason for that.

> 
> Being able to tell which output buffer was the origin of a capture buffer is
> an unrelated problem. We never clearly defined how this should be done.
> 
> The reality is that none of the existing options (using the sequence number or
> the timestamp) are satisfactory IMHO. What you want is a new field for this.
> The problem with that is that struct v4l2_buffer is full, so a new API is needed.
> It's something I've been working on (see link below), but it's on hold until
> we have the fence and request API merged. Otherwise too many people are messing
> with the same structs...
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3
> 
> > 
> >>
> >> BTW, you also want to show an example of getting the control once the request is
> >> completed (e.g. status information), probably with a polling example as well.
> > 
> > True.
> > 
> >>
> >>> +Example for a Simple Capture Device
> >>> +-----------------------------------
> >>> +
> >>> +With a simple capture device, requests can be used to specify controls to apply
> >>> +to a given CAPTURE buffer. The driver will apply these controls before producing
> >>> +the marked CAPTURE buffer.
> >>> +
> >>> +     struct v4l2_buf buf;
> >>> +     struct v4l2_ext_controls ctrls;
> >>> +     ...
> >>> +     ctrls.request_fd = req_fd;
> >>> +     ...
> >>> +     ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> >>> +     ...
> >>> +     buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >>> +     buf.request_fd = req_fd;
> >>> +     ioctl(camera_fd, VIDIOC_QBUF, &buf);
> >>> +
> >>> +Once the request is fully prepared, it can be submitted to the driver:
> >>> +
> >>> +     struct media_request_cmd cmd;
> >>> +
> >>> +     memset(&cmd, 0, sizeof(cmd));
> >>> +     cmd.cmd = MEDIA_REQ_CMD_SUBMIT;
> >>> +     cmd.fd = request_fd;
> >>> +     ioctl(media_fd, MEDIA_IOC_REQUEST_CMD, &cmd);
> >>> +
> >>> +User-space can then lookup the request_fd field of dequeued capture buffers to
> >>> +confirm which one has been produced by the request.
> >>> +
> >>> +     struct v4l2_buf buf;
> >>> +
> >>> +     memset(&buf, 0, sizeof(buf));
> >>> +     buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >>> +     ioctl(camera_fd, VIDIOC_DQBUF, &buf);
> >>> +
> >>> +     if (buf.request_fd == request_fd)
> >>> +             ...
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >>> index 9e448a4aa3aa..0cd596bd4cde 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >>> @@ -98,6 +98,12 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
> >>>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
> >>>  device is closed.
> >>>
> >>> +For all buffer types, the ``request_fd`` field can be used when enqueing
> >>> +to specify the file descriptor of a request, if requests are in use.
> >>> +Setting it means that the buffer will not be passed to the driver until
> >>> +the request itself is submitted. Also, the driver will apply any setting
> >>> +associated with the request before processing the buffer.
> >>> +
> >>>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
> >>>  (capturing) or displayed (output) buffer from the driver's outgoing
> >>>  queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
> >>> @@ -115,6 +121,21 @@ queue. When the ``O_NONBLOCK`` flag was given to the
> >>>  :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
> >>>  immediately with an ``EAGAIN`` error code when no buffer is available.
> >>>
> >>> +If a dequeued buffer was produced as the result of a request, then the
> >>> +``request_fd`` field of :c:type:`v4l2_buffer` will be set to the file
> >>> +descriptor of the request, regardless of whether the buffer was initially
> >>> +queued with a request associated to it or not.
> >>> +
> >>> +RFC note: a request can be referenced by several FDs, especially if the
> >>> +request is shared between different processes. Also a FD can be closed
> >>> +after a request is submitted. In that case the FD does not make much sense.
> >>> +Maybe it would be better to define request fd as
> >>> +
> >>> +    union { u32 request_fd; u32 request_id; }
> >>> +
> >>> +and use request_id when communicating a request to userspace so they can be
> >>> +unambiguously referenced?
> >>
> >> I don't think this is a problem. At least we never had this issue with e.g.
> >> dmabuf either. The request_fd must be a valid request fd for the process that
> >> calls the ioctl. If not the ioctl will return an error. If process A has a
> >> request fd 10 and process B calls the ioctl with request_fd set to 10 but it
> >> didn't actually allocate the request or receive the fd from process A (there
> >> is a mechanism for that, although I've forgotten the details).
> > 
> > For user-to-kernel communication this is true. What I had in mind was
> > the other way around: kernel trying to specify an already-allocated
> > request to userspace, like the above example of the capture buffer
> > that is marked with the request that produced it.
> > 
> > At that time, the FD of the request may have been closed, or may have
> > been passed to another process (which references the request using a
> > different ID). That's what FDs are not reliable here.
> > 
> 
> The capture example is wrong in any case as I explained above.
> 
> But I really don't think this is an issue if the request fds are properly
> refcounted. It's never been an issue with dma-buf, and I think that's the
> example that you should follow.
> 
> Yes, if a request_fd is returned that is closed, then trying to use it
> will fail. But that's an application bug.
> 
> Regards,
> 
> 	Hans

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
