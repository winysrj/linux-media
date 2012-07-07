Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2GGL54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 07:57:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
Date: Sat, 07 Jul 2012 13:58 +0200
Message-ID: <3936973.6L0tjEgaF6@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FAA6331E5@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com> <2099637.B2epIePqJp@avalon> <D5ECB3C7A6F99444980976A8C6D896384FAA6331E5@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Tuesday 03 July 2012 23:42:59 Bhupesh SHARMA wrote:
> Hi Laurent,
> 
> Thanks for your review and sorry for being late with my replies.
> I have a lot on my plate these days :)

No worries, I'm no less busy anyway :-)

> On Tuesday, June 19, 2012 4:19 AM Laurent Pinchart wrote:
> > On Friday 01 June 2012 15:08:57 Bhupesh Sharma wrote:

[snip]

> > > diff --git a/drivers/usb/gadget/uvc_queue.c
> > > b/drivers/usb/gadget/uvc_queue.c
> > > index 0cdf89d..907ece8 100644
> > > --- a/drivers/usb/gadget/uvc_queue.c
> > > +++ b/drivers/usb/gadget/uvc_queue.c

[snip]

> > > +static int uvc_buffer_prepare(struct vb2_buffer *vb)
> > >  {

[snip]

> > > +   buf->state = UVC_BUF_STATE_QUEUED;
> > > +   buf->mem = vb2_plane_vaddr(vb, 0);
> > > +   buf->length = vb2_plane_size(vb, 0);
> > > +   if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > > +           buf->bytesused = 0;
> > > +   else
> > > +           buf->bytesused = vb2_get_plane_payload(vb, 0);
> > 
> > The driver doesn't support the capture type at the moment so this might be
> > a bit overkill, but I think it's a good idea to support capture in the
> > queue imeplementation. I plan to try and merge the uvcvideo and uvcgadget
> > queue implementations at some point.
> 
> I am thinking now whether we really need to support UVC as a capture type
> video device. The use cases that I can think of now, UVC always seems to be
> a output device.
> 
> Any use-case where you think UVC can be a capture device?

It could be useful for video output devices. I know of at least one UVC output 
device (albeit not Linux-based), which I used to implement and test video 
output in the UVC host driver. As the host driver supports video output 
devices, supporting them in the gadget driver can be useful as well.

> > > +   return 0;
> > > +}

[snip]

> > >  static struct uvc_buffer *
> > >  uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer
> > > *buf)

[snip]

> > > -   buf->buf.sequence = queue->sequence++;
> > > -   do_gettimeofday(&buf->buf.timestamp);
> > 
> > videobuf2 doesn't fill the sequence number or timestamp fields, so you
> > either need to keep this here or move it to the caller.
> 
> Yes I think these fields are only valid for video capture devices.
> As my use-case was only an output UVC video device, I didn't add the same.
> 
> Please let me know your views on the same.

Good point. The spec isn't clear about this, so I'd rather keep these two 
lines for now.

> > > +   vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
> > > +   vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> > > 
> > > -   wake_up(&buf->wait);
> > > 
> > >     return nextbuf;
> > >  }

[snip]

> > > diff --git a/drivers/usb/gadget/uvc_v4l2.c
> > b/drivers/usb/gadget/uvc_v4l2.c
> > > index f6e083b..9c2b45b 100644
> > > --- a/drivers/usb/gadget/uvc_v4l2.c
> > > +++ b/drivers/usb/gadget/uvc_v4l2.c
> > > @@ -144,20 +144,23 @@ uvc_v4l2_release(struct file *file)
> > > 
> > >     struct uvc_device *uvc = video_get_drvdata(vdev);
> > >     struct uvc_file_handle *handle = to_uvc_file_handle(file-
> > >
> > >private_data);
> > >
> > >     struct uvc_video *video = handle->device;
> > > 
> > > +   int ret;
> > > 
> > >     uvc_function_disconnect(uvc);
> > > 
> > > -   uvc_video_enable(video, 0);
> > > -   mutex_lock(&video->queue.mutex);
> > > -   if (uvc_free_buffers(&video->queue) < 0)
> > > -           printk(KERN_ERR "uvc_v4l2_release: Unable to free "
> > > -                           "buffers.\n");
> > > -   mutex_unlock(&video->queue.mutex);
> > > +   ret = uvc_video_enable(video, 0);
> > > +   if (ret < 0) {
> > > +           printk(KERN_ERR "uvc_v4l2_release: uvc video disable
> > 
> > failed\n");
> > 
> > > +           return ret;
> > > +   }
> > 
> > This shouldn't prevent uvc_v4l2_release() from succeeding. In practive
> > uvc_video_enable(0) will never fail, so you can remove the error check.
> 
> To be honest, I saw once the 'uvc_video_enable(0)' failing that's why I
> added this check. I don't remember the exact instance of the failure, but
> I can try to check again and then will come back on the same.

The only reason I see for uvc_video_enable(video, 0) to fail is if the video 
endpoint hasn't been allocated. As the V4L2 device node is registered after 
allocating the endpoint, I'm surprised to hear that you saw it failing. If you 
can reproduce the problem I'd be curious to have more information.

> > > +
> > > +   uvc_free_buffers(&video->queue);
> > > 
> > >     file->private_data = NULL;
> > >     v4l2_fh_del(&handle->vfh);
> > >     v4l2_fh_exit(&handle->vfh);
> > >     kfree(handle);
> > > +
> > >     return 0;
> > >  }

[snip]

> > > diff --git a/drivers/usb/gadget/uvc_video.c
> > > b/drivers/usb/gadget/uvc_video.c
> > > index b0e53a8..195bbb6 100644
> > > --- a/drivers/usb/gadget/uvc_video.c
> > > +++ b/drivers/usb/gadget/uvc_video.c
> > 
> > [snip]
> > 
> > > @@ -161,6 +161,7 @@ static void
> > > 
> > >  uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
> > >  {
> > >     struct uvc_video *video = req->context;
> > > +   struct uvc_video_queue *queue = &video->queue;
> > >     struct uvc_buffer *buf;
> > >     unsigned long flags;
> > >     int ret;
> > > @@ -169,13 +170,15 @@ uvc_video_complete(struct usb_ep *ep, struct
> > > usb_request *req) case 0:
> > >             break;
> > > 
> > > -   case -ESHUTDOWN:
> > > +   case -ESHUTDOWN:        /* disconnect from host. */
> > >             printk(KERN_INFO "VS request cancelled.\n");
> > > +           uvc_queue_cancel(queue, 1);
> > >             goto requeue;
> > >     
> > >     default:
> > >             printk(KERN_INFO "VS request completed with status %d.\n",
> > >                     req->status);
> > > 
> > > +           uvc_queue_cancel(queue, 0);
> > 
> > I wonder why there was no uvc_queue_cancel() here already, it makes me
> > a bit suspicious :-) Have you double-checked this ?
> > 
> > >             goto requeue;
> 
> Added only after burning my hands :)
> In case the buffer was queued at the UVC gadget and the USB cable was
> disconnected in the middle of frame transfer, I saw that the buffer was
> never dequeued with error and the user-space application kept waiting for
> this buffer transfer to be completed.

Good catch, thank you.

-- 
Regards,

Laurent Pinchart

