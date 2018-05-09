Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56400 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964950AbeEIPxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 11:53:50 -0400
Message-ID: <e52f72ea1fdf491dd10a9a40bbced6d3bad66f7b.camel@collabora.com>
Subject: Re: [PATCH v9 10/15] vb2: add explicit fence user API
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Wed, 09 May 2018 12:52:26 -0300
In-Reply-To: <20180509103353.GA39838@e107564-lin.cambridge.arm.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
         <20180504200612.8763-11-ezequiel@collabora.com>
         <20180509103353.GA39838@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-05-09 at 11:33 +0100, Brian Starkey wrote:
> Hi Ezequiel,
> 
> On Fri, May 04, 2018 at 05:06:07PM -0300, Ezequiel Garcia wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Turn the reserved2 field into fence_fd that we will use to send
> > an in-fence to the kernel or return an out-fence from the kernel to
> > userspace.
> > 
> > Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
> > when sending an in-fence to the kernel to be waited on, and
> > V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.
> > 
> > v7: minor fixes on the Documentation (Hans Verkuil)
> > 
> > v6: big improvement on doc (Hans Verkuil)
> > 
> > v5: - keep using reserved2 field for cpia2
> >    - set fence_fd to 0 for now, for compat with userspace(Mauro)
> > 
> > v4: make it a union with reserved2 and fence_fd (Hans Verkuil)
> > 
> > v3: make the out_fence refer to the current buffer (Hans Verkuil)
> > 
> > v2: add documentation
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> > Documentation/media/uapi/v4l/buffer.rst         | 45 +++++++++++++++++++++++--
> > drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 +-
> > drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  4 +--
> > include/uapi/linux/videodev2.h                  |  8 ++++-
> > 4 files changed, 52 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> > index e2c85ddc990b..be9719cf5745 100644
> > --- a/Documentation/media/uapi/v4l/buffer.rst
> > +++ b/Documentation/media/uapi/v4l/buffer.rst
> > @@ -301,10 +301,22 @@ struct v4l2_buffer
> > 	elements in the ``planes`` array. The driver will fill in the
> > 	actual number of valid elements in that array.
> >     * - __u32
> > -      - ``reserved2``
> > +      - ``fence_fd``
> >       -
> > -      - A place holder for future extensions. Drivers and applications
> > -	must set this to 0.
> > +      - Used to communicate a fence file descriptors from userspace to kernel
> > +	and vice-versa. On :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` when sending
> > +	an in-fence for V4L2 to wait on, the ``V4L2_BUF_FLAG_IN_FENCE`` flag must
> > +	be used and this field set to the fence file descriptor of the in-fence.
> > +	If the in-fence is not valid ` VIDIOC_QBUF`` returns an error.
> > +
> > +        To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE``
> > +	must be set, the kernel will return the out-fence file descriptor in
> > +	this field. If it fails to create the out-fence ``VIDIOC_QBUF` returns
> > +        an error.
> > +
> > +	For all other ioctls V4L2 sets this field to -1 if
> > +	``V4L2_BUF_FLAG_IN_FENCE`` and/or ``V4L2_BUF_FLAG_OUT_FENCE`` are set,
> > +	otherwise this field is set to 0 for backward compatibility.
> >     * - __u32
> >       - ``reserved``
> >       -
> > @@ -648,6 +660,33 @@ Buffer Flags
> >       - Start Of Exposure. The buffer timestamp has been taken when the
> > 	exposure of the frame has begun. This is only valid for the
> > 	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
> > +    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
> > +
> > +      - ``V4L2_BUF_FLAG_IN_FENCE``
> > +      - 0x00200000
> > +      - Ask V4L2 to wait on the fence passed in the ``fence_fd`` field. The
> > +	buffer won't be queued to the driver until the fence signals. The order
> > +	in which buffers are queued is guaranteed to be preserved, so any
> > +	buffers queued after this buffer will also be blocked until this fence
> > +	signals. This flag must be set before calling ``VIDIOC_QBUF``. For
> > +	other ioctls the driver just reports the value of the flag.
> > +
> > +        If the fence signals the flag is cleared and not reported anymore.
> > +	If the fence is not valid ``VIDIOC_QBUF`` returns an error.
> > +
> > +
> > +    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
> > +
> > +      - ``V4L2_BUF_FLAG_OUT_FENCE``
> > +      - 0x00400000
> > +      - Request for a fence to be attached to the buffer. The driver will fill
> > +	in the out-fence fd in the ``fence_fd`` field when :ref:`VIDIOC_QBUF
> > +	<VIDIOC_QBUF>` returns. This flag must be set before calling
> > +	``VIDIOC_QBUF``. For other ioctls the driver just reports the value of
> > +	the flag.
> > +
> > +        If the creation of the out-fence fails ``VIDIOC_QBUF`` returns an
> > +	error.
> > 
> 
> I commented similarly on some of the old patch-sets, and it's a minor
> thing, but I still think the ordering of this series is off. It's
> strange/wrong to me document all this behaviour, and expose the flags
> to userspace, when the functionality isn't implemented yet.
> 
> If I apply this patch to the kernel, then the kernel doesn't do what
> the (newly added) kernel-doc says it will.
> 

This has never been a problem, and it has always been the canonical
way of doing things.

First the required macros, stubs, documentation and interfaces are added,
and then they are implemented.

I see no reason to go berserk here, unless you see an actual problem?
Or something actually broken?

The only thing I can think of is that we should return fence_fd -1
if the flags are set. We could do it on this patch, and be consistent
with userspace.

Regards,
Eze
