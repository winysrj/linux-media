Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33404 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbeEVPxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 11:53:22 -0400
Message-ID: <8f6f585f4076e3a2de76ca6a4a0e99c0c6f29584.camel@collabora.com>
Subject: Re: [PATCH v10 11/16] vb2: add explicit fence user API
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Tue, 22 May 2018 12:51:54 -0300
In-Reply-To: <9a7d4128-571e-468c-8c03-9f35f610a87f@xs4all.nl>
References: <20180521165946.11778-1-ezequiel@collabora.com>
         <20180521165946.11778-12-ezequiel@collabora.com>
         <9a7d4128-571e-468c-8c03-9f35f610a87f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-05-22 at 14:05 +0200, Hans Verkuil wrote:
> On 21/05/18 18:59, Ezequiel Garcia wrote:
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
> > v8: return -1 if new flags are set.
> > v7: minor fixes on the Documentation (Hans Verkuil)
> > 
> > v6: big improvement on doc (Hans Verkuil)
> > 
> > v5: - keep using reserved2 field for cpia2
> >     - set fence_fd to 0 for now, for compat with userspace(Mauro)
> > 
> > v4: make it a union with reserved2 and fence_fd (Hans Verkuil)
> > 
> > v3: make the out_fence refer to the current buffer (Hans Verkuil)
> > 
> > v2: add documentation
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  Documentation/media/uapi/v4l/buffer.rst         | 48 ++++++++++++++++++++++---
> >  drivers/media/common/videobuf2/videobuf2-v4l2.c |  6 +++-
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  4 +--
> >  include/uapi/linux/videodev2.h                  |  8 ++++-
> >  4 files changed, 58 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> > index e2c85ddc990b..971b7453040c 100644
> > --- a/Documentation/media/uapi/v4l/buffer.rst
> > +++ b/Documentation/media/uapi/v4l/buffer.rst
> > @@ -300,11 +300,23 @@ struct v4l2_buffer
> >  	multi-planar API the application sets this to the number of
> >  	elements in the ``planes`` array. The driver will fill in the
> >  	actual number of valid elements in that array.
> > -    * - __u32
> > -      - ``reserved2``
> > +    * - __s32
> > +      - ``fence_fd``
> >        -
> > -      - A place holder for future extensions. Drivers and applications
> > -	must set this to 0.
> > +      - Used to communicate a fence file descriptor from userspace to kernel
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
> >      * - __u32
> >        - ``reserved``
> >        -
> > @@ -648,6 +660,34 @@ Buffer Flags
> >        - Start Of Exposure. The buffer timestamp has been taken when the
> >  	exposure of the frame has begun. This is only valid for the
> >  	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
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
> > +    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
> > +
> > +      - ``V4L2_BUF_FLAG_OUT_FENCE``
> > +      - 0x00400000
> > +      - Request for a fence to be attached to the buffer. The driver will fill
> > +	in the out-fence fd in the ``fence_fd`` field when :ref:`VIDIOC_QBUF
> > +	<VIDIOC_QBUF>` returns. This flag must be set before calling
> > +	``VIDIOC_QBUF``. This flag is only an input, and is not set by the kernel.
> > +
> > +        If the creation of the out-fence fails ``VIDIOC_QBUF`` returns an
> > +	error.
> > +
> > +        Note that it is valid to set both ``V4L2_BUF_FLAG_IN_FENCE`` and
> > +        `V4L2_BUF_FLAG_OUT_FENCE`` flags. In such case, the ``fence_fd``
> > +        field is used to both set the in-fence and return the out-fence.
> >  
> >  
> >  
> > diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > index 64503615d00b..8312f61adfa6 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > @@ -203,9 +203,13 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> >  	b->timestamp = ns_to_timeval(vb->timestamp);
> >  	b->timecode = vbuf->timecode;
> >  	b->sequence = vbuf->sequence;
> > -	b->reserved2 = 0;
> >  	b->reserved = 0;
> >  
> > +	if (b->flags & (V4L2_BUF_FLAG_IN_FENCE | V4L2_BUF_FLAG_OUT_FENCE))
> > +		b->fence_fd = -1;
> > +	else
> > +		b->fence_fd = 0;
> 
> I don't see why we can't just always set fence_fd to -1.
> 
> There is no need for backwards compatibility that I can see.
> 
> 

I thought we were trying to not break any users expecting reserved2
to be zeroed.

Unless that's silly?
