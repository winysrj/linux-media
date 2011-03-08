Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56691 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1CHKJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 05:09:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
Date: Tue, 8 Mar 2011 11:09:26 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <201103011154.19883.laurent.pinchart@ideasonboard.com> <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
In-Reply-To: <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103081109.27355.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel,

On Monday 07 March 2011 00:20:36 Pawel Osciak wrote:
> On Tue, Mar 1, 2011 at 02:54, Laurent Pinchart wrote:
> > On Monday 28 February 2011 16:44:38 Pawel Osciak wrote:
> >> Hi Laurent,
> >> A few questions from me below. I feel we need to talk about this
> >> change a bit more, it introduces some recovery and consistency
> >> problems, unless I'm missing something.
> >> 
> >> On Sun, Feb 27, 2011 at 10:12, Laurent Pinchart wrote:
> >> > videobuf2 expects drivers to check buffer in the buf_prepare operation
> >> > and to return success only if the buffer can queued without any issue.
> >> > 
> >> > For hot-pluggable devices, disconnection events need to be handled at
> >> > buf_queue time. Checking the disconnected flag and adding the buffer
> >> > to the driver queue need to be performed without releasing the driver
> >> > spinlock, otherwise race conditions can occur in which the driver
> >> > could still allow a buffer to be queued after the disconnected flag
> >> > has been set, resulting in a hang during the next DQBUF operation.
> >> > 
> >> > This problem can be solved either in the videobuf2 core or in the
> >> > device drivers. To avoid adding a spinlock to videobuf2, make
> >> > buf_queue return an int and handle buf_queue failures in videobuf2.
> >> > Drivers must not return an error in buf_queue if the condition
> >> > leading to the error can be caught in buf_prepare.
> >> > 
> >> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> > ---
> >> >  drivers/media/video/videobuf2-core.c |   32
> >> > ++++++++++++++++++++++++++------ include/media/videobuf2-core.h      
> >> > | 2 +-
> >> >  2 files changed, 27 insertions(+), 7 deletions(-)
> >> > 
> >> > diff --git a/drivers/media/video/videobuf2-core.c
> >> > b/drivers/media/video/videobuf2-core.c index cc7ab0a..1d81536 100644
> >> > --- a/drivers/media/video/videobuf2-core.c
> >> > +++ b/drivers/media/video/videobuf2-core.c
> >> > @@ -798,13 +798,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb,
> >> > struct v4l2_buffer *b) /**
> >> >  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for
> >> > processing */
> >> > -static void __enqueue_in_driver(struct vb2_buffer *vb)
> >> > +static int __enqueue_in_driver(struct vb2_buffer *vb)
> >> >  {
> >> >        struct vb2_queue *q = vb->vb2_queue;
> >> > +       int ret;
> >> > 
> >> >        vb->state = VB2_BUF_STATE_ACTIVE;
> >> >        atomic_inc(&q->queued_count);
> >> > -       q->ops->buf_queue(vb);
> >> > +       ret = q->ops->buf_queue(vb);
> >> > +       if (ret == 0)
> >> > +               return 0;
> >> > +
> >> > +       vb->state = VB2_BUF_STATE_ERROR;
> >> > +       atomic_dec(&q->queued_count);
> >> > +       wake_up_all(&q->done_wq);
> >> > +
> >> > +       return ret;
> >> 
> >> Unless I am missing something, when this happens for an n-th buffer,
> >> we wake up all, but only one buffer will have the ERROR state, all the
> >> other will be in QUEUED state. This will mess up return values from
> >> dqbuf (if this happens on streamon) for other buffers, they will have
> >> their V4L2_BUF_FLAG_QUEUED set after dqbuf. Also, returning 0 from
> >> DQBUF and the V4L2_BUF_FLAG_ERROR for the failed buffer suggests that
> >> streaming may continue.
> > 
> > Actually not quite, as the driver is expected to mark all buffers as
> > erroneous and wake up userspace when the disconnection event is
> > received. Subsequent calls to VIDIOC_QBUF (or VIDIOC_STREAMON) need to
> > return an error. I'm not sure if we need to wake up userspace then, as
> > applications shouldn't sleep on VIDIOC_DQBUF or select() after
> > VIDIOC_QBUF or VIDIOC_STREAMON returned an error.
> 
> Ok, but what do you mean by driver marking them as erroneous? By
> issuing vb2_buffer_done with *_ERROR as parameter?

Yes.

> Also, you meant that vb2 should be waking userspace, right?

Yes. If an application is sleeping on a DQBUF or poll() call, it needs to be 
woken up when the device is disconnected.

> I believe we should aim for a solution that would require the driver to do
> as little as possible and move everything to vb2.

I totally agree with this. All drivers should implement the same disconnect 
behaviour, and the required locking is not trivial, so it should be moved to 
vb2.

> vb2_dqbuf will return EINVAL and poll()/select() should fail because
> they check for streaming state. As long as the disconnection event
> (e.g. failed qbuf) disables streaming flag in vb2, we should be ok.

What I'm concerned about is race conditions. Please see below for 
explanations.

> >> So how do we recover from this disconnection event? What is the
> >> general idea? If buf_queue fails, can we restart from some point (i.e.
> >> reuse the buffers later) or do we have to clean up completely (i.e.
> >> deallocate, etc.)? Right now we are staying in an undefined state.
> >> If we cannot recover, we shouldn't be setting V4L2_BUF_FLAG_ERROR, but
> >> returning a stronger error instead and maybe clean up the rest, which
> >> is not waited for somehow. If we can recover on the other hand, we
> >> shouldn't be probably waking up all sleepers or at least giving them
> >> meaningful errors.
> > 
> > I think a disconnection is pretty fatal. If the user unplugs the webcam,
> > there's not much that can be done anymore. Userspace needs to be woken up
> > with all buffers marked as erroneous, and the next QBUF call needs to
> > return an error without queuing any buffer. We need to define the
> > expected behaviour in the V4L2 spec, so that applications can rely on it
> > and implement it properly. I would also like to handle this inside
> > videobuf2 if possible (something like vb2_disconnect() ?) to ensure that
> > all drivers behave correctly, but I'm not sure if that will be possible
> > without messing locking up.
> 
> I definitely agree that videbuf2 should handle as much as possible and
> it shouldn't be left up to drivers. Although I'm not an expert in USB,
> shouldn't a disconnection event cause a removal of the device node?

Yes it should (and probably already does for most drivers), but you can't 
prevent applications from issuing calls on the already opened instances of the 
device node.

> Could you explain how does that work for USB devices in general?

USB drivers are notified of device disconnection by a callback. In a nutshell, 
the callback usually calls video_unregister_device() which removes the device 
node, and decrements a reference count. When the reference count reaches 0, 
all driver-allocated objects are freed. The same reference count is used in 
the open() and release() handlers, guaranteeing that nothing will be freed 
while an application still keeps the device node open.

In parallel, another callback (namely the URB completion handler that is 
called by the USB core when a URB has been transmitted) is called with a error 
status that signals a disconnection. This happens a bit before the 
disconnect() callback. The driver then needs to mark all buffers as erroneous 
and return them to userspace, waking up userspace in the process. Further QBUF 
calls must fail, and further DQBUF and poll() calls must return immediately 
(which shouldn't be an issue, as DQBUF and poll() will return immediately if 
all buffers have been returned to userspace).

> If not, we may need a more general state in vb2, something like "device
> inoperable". Not only qbuf should fail then, but almost everything
> should.

That's correct.

> And memory should be freed.

Memory will be freed the usual way when the application will eventually call 
REQBUFS(0) or just close the file handle.

> I feel there will be the locking problems as well.
>
> I definitely agree that we need to add this to the V4L2 spec. So could
> we start from that point? Could we maybe start with a general flow and
> expected behavior for a disconnection event? I guess we both have some
> ideas in mind, but first I'd like to establish what will happen in
> linux driver/USB core when a device is disconnected. My understanding
> is that the driver is removed and module is unloaded,

Beside the disconnect() callback and completion handlers being called, the 
device reference count is decreased, and the device will be deleted when the 
reference count reaches 0. The module is not unloaded, it just gets unbound 
from the device.

> but how does that happen if we are in the middle of something? Could you
> give an example of what happens after a disconnect a camera? Then we could
> start designing a general approach, beginning with the API point of view.

See my explanation above. As code is usually better understood than English, 
here's how the uvcvideo driver handles it :-)

static void uvc_disconnect(struct usb_interface *intf)
{
        struct uvc_device *dev = usb_get_intfdata(intf);

        /* Set the USB interface data to NULL. This can be done outside the
         * lock, as there's no other reader.
         */
        usb_set_intfdata(intf, NULL);

        if (intf->cur_altsetting->desc.bInterfaceSubClass ==
            UVC_SC_VIDEOSTREAMING)
                return;

        dev->state |= UVC_DEV_DISCONNECTED;

        uvc_unregister_video(dev);
}

As you can see, the disconnect callback more or less calls 
uvc_unregister_video(), which does

static void uvc_unregister_video(struct uvc_device *dev)
{
        struct uvc_streaming *stream;

        /* Unregistering all video devices might result in uvc_delete() being
         *called from inside the loop if there's no open file handle. To avoid
         * that, increment the stream count before iterating over the streams
         * and decrement it when done.
         */
        atomic_inc(&dev->nstreams);

        list_for_each_entry(stream, &dev->streams, list) {
                if (stream->vdev == NULL)
                        continue;

                video_unregister_device(stream->vdev);
                stream->vdev = NULL;
        }

        /* Decrement the stream count and call uvc_delete explicitly if there
         * are no stream left.
         */
        if (atomic_dec_and_test(&dev->nstreams))
                uvc_delete(dev);
}

This calls video_unregister_device() for all video nodes registered by the 
uvcvideo driver, and then calls uvc_delete() if the uvc device reference count 
reaches 0:

static void uvc_delete(struct uvc_device *dev)
{
        struct list_head *p, *n;

        usb_put_intf(dev->intf);
        usb_put_dev(dev->udev);

        uvc_status_cleanup(dev);
        uvc_ctrl_cleanup_device(dev);

        list_for_each_safe(p, n, &dev->chains) {
                struct uvc_video_chain *chain;
                chain = list_entry(p, struct uvc_video_chain, list);
                kfree(chain);
        }
        ...
}

uvc_delete() decrements the reference count on the USB interface and device 
(usb_put_intf() and usb_put_dev() calls), which results in the USB device 
being freed if nothing else uses it, and starts cleaning up by freeing 
everything it has allocated.

On the URB completion handler side, the completion handler calls 
uvc_queue_cancel() when it gets called with a status that indicates a 
disconnection (or any other fatal error):

void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
{
        struct uvc_buffer *buf;
        unsigned long flags;

        spin_lock_irqsave(&queue->irqlock, flags);
        while (!list_empty(&queue->irqqueue)) {
                buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
                                       queue);
                list_del(&buf->queue);
                buf->state = UVC_BUF_STATE_ERROR;
                wake_up(&buf->wait);
        }
        /* This must be protected by the irqlock spinlock to avoid race
         *conditions between uvc_queue_buffer and the disconnection event that
         * could result in an interruptible wait in uvc_dequeue_buffer. Do not
         * blindly replace this logic by checking for the UVC_DEV_DISCONNECTED
         * state outside the queue code.
         */
        if (disconnect)
                queue->flags |= UVC_QUEUE_DISCONNECTED;
        spin_unlock_irqrestore(&queue->irqlock, flags);
}

The UVC_QUEUE_DISCONNECT flag is checked in the QBUF handler:

        spin_lock_irqsave(&queue->irqlock, flags);
        if (queue->flags & UVC_QUEUE_DISCONNECTED) {
                spin_unlock_irqrestore(&queue->irqlock, flags);
                ret = -ENODEV;
                goto done;
        }
        buf->state = UVC_BUF_STATE_QUEUED;
        if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
                buf->buf.bytesused = 0;
        else
                buf->buf.bytesused = v4l2_buf->bytesused;

        list_add_tail(&buf->stream, &queue->mainqueue);
        list_add_tail(&buf->queue, &queue->irqqueue);
        spin_unlock_irqrestore(&queue->irqlock, flags);

This is the logic I would like to replicate in vb2.

> >> >  }
> >> >  /**
> >> > @@ -890,8 +899,13 @@ int vb2_qbuf(struct vb2_queue *q, struct
> >> > v4l2_buffer *b) * If already streaming, give the buffer to driver for
> >> > processing. * If not, the buffer will be given to driver on next
> >> > streamon. */ -       if (q->streaming)
> >> > -               __enqueue_in_driver(vb);
> >> > +       if (q->streaming) {
> >> > +               ret = __enqueue_in_driver(vb);
> >> > +               if (ret < 0) {
> >> > +                       dprintk(1, "qbuf: buffer queue failed\n");
> >> > +                       return ret;
> >> > +               }
> >> > +       }
> >> 
> >> What errors can be allowed to be returned from driver here? EIO? Also,
> >> isn't returning an error here to userspace suggesting that qbuf didn't
> >> happen? But it actually did happen, we put the buffer onto vb2 list
> >> and set it state to QUEUED. From the point of view of vb2, the buffer
> >> is on its queue, but the userspace may not think so.
> > 
> > You're right, that's an issue. The buffer shouldn't be queued at all.
> 
> By the way, I'm beginning to think that the simplest way would maybe
> be adding a new flag to vb2_buffer_done... The problem however is of
> course that there might be a parallel qbuf going on... I really,
> really would prefer not putting locks around buf_queue back...

So would I, but I'm not sure if it's possible to solve the issue without a 
lock around it.
 
> > Regarding error codes, I would return -ENXIO (No such device or address -
> > POSIX.1) to tell that the device has been disconnected. -ENODEV is
> > misleading, it's short description is "No such device", but it means
> > that the device doesn't support the requested operation.
> 
> I have no preference here, I guess both should be ok.
> 
> To sum up, it'd be great if we could design a comprehensive solution
> please, starting on the abstract level, i.e. what happens during the
> disconnect and how we want to react from the point of view of the API.
> Could you describe what happens during a disconnect?

Sure. See above :-)

-- 
Regards,

Laurent Pinchart
