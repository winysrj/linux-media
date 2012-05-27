Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48401 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2E0VcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 17:32:19 -0400
Received: by obbtb18 with SMTP id tb18so4411798obb.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 14:32:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC12F82.6040705@gmail.com>
References: <201205261950.06022.hverkuil@xs4all.nl>
	<4FC12F82.6040705@gmail.com>
Date: Sun, 27 May 2012 18:32:18 -0300
Message-ID: <CALF0-+VPkbZ8sUbPmxNT46J5S8X_jwRH3Wc4yX7DUHXyjKmbEg@mail.gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@redhat.com,
	linux-media@vger.kernel.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, May 26, 2012 at 4:31 PM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>
> You can drop this line, it's overwritten with KERNEL_VERSION in v4l2-ioctl.c.
> Also I could imagine there might be better names, than "dev", for capabilities.
>

Yes, indeed. Starting with "cap".

>>> +    dev->capabilities =
>>> +            V4L2_CAP_VIDEO_CAPTURE |
>>> +            V4L2_CAP_STREAMING |
>>> +            V4L2_CAP_READWRITE;
>>> +    return 0;
>>> +    f->fmt.pix.width = dev->width;
>>> +    f->fmt.pix.height = dev->height;
>>> +    f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>>> +    f->fmt.pix.pixelformat = dev->fmt->fourcc;
>>> +    f->fmt.pix.bytesperline = dev->width<<  1;
>                                  ^^^^^^^^^^^^^^^^
> Probably better to just write: dev->width * 2.

I saw like that in a number of places and I tought it was "faster".
Guess, I was being truly naive.

>
> Could be also done as:
>
>        *buffers = clamp(*buffers, STK1160_MIN_VIDEO_BUFFERS,
>                         STK1160_MAX_VIDEO_BUFFERS);

Done.

>>> +    /*
>>> +     * videobuf2-vmalloc allocator is context-less so no need to set
>>> +     * alloc_ctxs array.
>>> +     */
>>> +
>>> +    if (v4l_fmt) {
>>> +            stk1160_info("selected format %d (%d)\n",
>>> +                    v4l_fmt->fmt.pix.pixelformat,
>>> +                    dev->fmt->fourcc);
>>> +    }
>
> This log is not exactly right. You just ignore v4l_fmt, so it is not selected
> anywhere. The *v4l_fmt argument is here for ioctls like VIDIOC_CREATE_BUFS,
> and in case you wanted to support this ioctl you would need to do something
> like:
>        pix = &v4l_fmt->fmt.pix;
>        sizes[0] = pix->width * pix->height * 2;
>
> Of course with any required sanity checks.
>
> But this driver does not implement vidioc_create_bufs/vidioc_prepare_buf ioctl
> callbacks are not, so the code is generally OK.

You're right, that was just legacy code from some early stages.

>>> +static int buffer_prepare(struct vb2_buffer *vb)
>>> +{
>>> +    struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>>> +    struct stk1160_buffer *buf =
>>> +                    container_of(vb, struct stk1160_buffer, vb);
>>> +
>>> +    /* If the device is disconnected, reject the buffer */
>>> +    if (!dev->udev)
>>> +            return -ENODEV;
>>> +
>>> +    buf->mem = vb2_plane_vaddr(vb, 0);
>>> +    buf->length = vb2_plane_size(vb, 0);
>
> Where do you check if the buffer you get from vb2 has correct parameters
> for your hardware (with current settings) to start writing data to it ?
>
> It seems that this driver supports just one pixel format and resolution,
> but still would be good to do such checks in buf_prepare().

You mean I should check buf->length?

>
> And initialization of buf->mem, buf->length is better done from
> buffer_queue() op. This way there would be no need to take dev->buf_lock
> spinlock also in buf_prepare() to protect the driver's buffer (queue),
> which isn't done but it should in buffer_prepare() btw.

Yes, I missed this spot.

>
>>> +    buf->bytesused = 0;
>>> +    buf->pos = 0;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int buffer_finish(struct vb2_buffer *vb)
>>> +{
>>> +    return 0;
>>> +}
>>> +
>>> +static void buffer_cleanup(struct vb2_buffer *vb)
>>> +{
>>> +}
>
> buf_init, buf_finish, buf_cleanup are optional callbacks, so if you
> don't use them they could be removed altogether.
>

Done.

>>> +
>>> +static void buffer_queue(struct vb2_buffer *vb)
>>> +{
>>> +    unsigned long flags = 0;
>>> +    struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>>> +    struct stk1160_buffer *buf =
>>> +            container_of(vb, struct stk1160_buffer, vb);
>>> +
>>> +    spin_lock_irqsave(&dev->buf_lock, flags);
>>> +    if (!dev->udev) {
>>> +            /*
>>> +             * If the device is disconnected return the buffer to userspace
>>> +             * directly. The next QBUF call will fail with -ENODEV.
>>> +             */
>>> +            vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>> +    } else {
>>> +            list_add_tail(&buf->list,&dev->avail_bufs);
>>> +    }
>>> +    spin_unlock_irqrestore(&dev->buf_lock, flags);
>>> +}
>
> --
> Regards,
> Sylwester

Thanks,
Ezequiel.
