Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:40555 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdLUUgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 15:36:48 -0500
Date: Thu, 21 Dec 2017 18:36:41 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v6 3/6] [media] vb2: add explicit fence user API
Message-ID: <20171221203641.GC12003@jade>
References: <20171211182741.29712-1-gustavo@padovan.org>
 <20171211182741.29712-4-gustavo@padovan.org>
 <20171221165215.46dc86a5@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221165215.46dc86a5@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-12-21 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Mon, 11 Dec 2017 16:27:38 -0200
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Turn the reserved2 field into fence_fd that we will use to send
> > an in-fence to the kernel and return an out-fence from the kernel to
> > userspace.
> > 
> > Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
> > when sending a fence to the kernel to be waited on, and
> > V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.
> > 
> > v4:
> > 	- make it a union with reserved2 and fence_fd (Hans Verkuil)
> > 
> > v3:
> > 	- make the out_fence refer to the current buffer (Hans Verkuil)
> > 
> > v2: add documentation
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  Documentation/media/uapi/v4l/buffer.rst       | 15 +++++++++++++++
> >  drivers/media/usb/cpia2/cpia2_v4l.c           |  2 +-
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++--
> >  drivers/media/v4l2-core/videobuf2-v4l2.c      |  2 +-
> >  include/uapi/linux/videodev2.h                |  7 ++++++-
> >  5 files changed, 25 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> > index ae6ee73f151c..eeefbd2547e7 100644
> > --- a/Documentation/media/uapi/v4l/buffer.rst
> > +++ b/Documentation/media/uapi/v4l/buffer.rst
> > @@ -648,6 +648,21 @@ Buffer Flags
> >        - Start Of Exposure. The buffer timestamp has been taken when the
> >  	exposure of the frame has begun. This is only valid for the
> >  	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
> > +    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
> > +
> > +      - ``V4L2_BUF_FLAG_IN_FENCE``
> > +      - 0x00200000
> > +      - Ask V4L2 to wait on fence passed in ``fence_fd`` field. The buffer
> > +	won't be queued to the driver until the fence signals.
> > +
> > +    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
> > +
> > +      - ``V4L2_BUF_FLAG_OUT_FENCE``
> > +      - 0x00400000
> > +      - Request a fence to be attached to the buffer. The ``fence_fd``
> > +	field on
> > +	:ref:`VIDIOC_QBUF` is used as a return argument to send the out-fence
> > +	fd to userspace.
> >  
> >  
> >  
> > diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
> > index a1c59f19cf2d..7d7459fa2077 100644
> > --- a/drivers/media/usb/cpia2/cpia2_v4l.c
> > +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
> > @@ -948,7 +948,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> >  	buf->sequence = cam->buffers[buf->index].seq;
> >  	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
> >  	buf->length = cam->frame_size;
> > -	buf->reserved2 = 0;
> > +	buf->fence_fd = -1;
> >  	buf->reserved = 0;
> >  	memset(&buf->timecode, 0, sizeof(buf->timecode));
> >  
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index 821f2aa299ae..3a31d318df2a 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -370,7 +370,7 @@ struct v4l2_buffer32 {
> >  		__s32		fd;
> >  	} m;
> >  	__u32			length;
> > -	__u32			reserved2;
> > +	__s32			fence_fd;
> >  	__u32			reserved;
> >  };
> >  
> > @@ -533,7 +533,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
> >  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
> >  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
> >  		put_user(kp->sequence, &up->sequence) ||
> > -		put_user(kp->reserved2, &up->reserved2) ||
> > +		put_user(kp->fence_fd, &up->fence_fd) ||
> >  		put_user(kp->reserved, &up->reserved) ||
> >  		put_user(kp->length, &up->length))
> >  			return -EFAULT;
> > diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > index 4075314a6989..4a5244ee2c58 100644
> > --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> > +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > @@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> >  	b->timestamp = ns_to_timeval(vb->timestamp);
> >  	b->timecode = vbuf->timecode;
> >  	b->sequence = vbuf->sequence;
> > -	b->reserved2 = 0;
> > +	b->fence_fd = -1;
> 
> The patch itself looks ok. I'm just in doubt here, but it is probably
> ok to change its default to -1.

Right. What we can do is return 0 if the OUT_FENCE flag is not set.

Gustavo
