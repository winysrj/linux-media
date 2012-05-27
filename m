Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45707 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2E0VUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 17:20:22 -0400
Received: by obbtb18 with SMTP id tb18so4399892obb.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 14:20:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205261905.25626.hverkuil@xs4all.nl>
References: <1338050460-5902-1-git-send-email-elezegarcia@gmail.com>
	<201205261905.25626.hverkuil@xs4all.nl>
Date: Sun, 27 May 2012 18:20:21 -0300
Message-ID: <CALF0-+XFR4jnDCatk3vu2tB=iA-p=Ai_bwwgOZGTzNNrsicxfA@mail.gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com, snjw23@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, May 26, 2012 at 2:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Always test your driver using the v4l2-compliance test tool that it part of
> v4l-utils! If it passes that, then your code will be in really good shape!

You're right. I'll add v4l2-compliance output in the next patch.

>
> On Sat May 26 2012 18:41:00 Ezequiel Garcia wrote:
>> This driver adds support for stk1160 usb bridge as used in some
>> video/audio usb capture devices.
>> It is a complete rewrite of staging/media/easycap driver and
>> it's expected as a future replacement.
>>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>> As of today testing has been performed using both vlc and mplayer
>> on a gentoo machine, including hot unplug and on-the-fly standard
>> change using a device with 1-cvs and 1-audio output.
>> However more testing is underway with another device and/or another
>> distribution.
>>
>> Alsa sound support is a missing feature (work in progress).
>>
>> As this is my first complete driver, the patch is (obviously) intended as RFC only.
>> Any comments/reviews of *any* kind will be greatly appreciated.
>> ---
>>  drivers/media/video/Kconfig                 |    2 +
>>  drivers/media/video/Makefile                |    1 +
>>  drivers/media/video/stk1160/Kconfig         |   11 +
>>  drivers/media/video/stk1160/Makefile        |    6 +
>>  drivers/media/video/stk1160/stk1160-core.c  |  399 +++++++++++++
>>  drivers/media/video/stk1160/stk1160-i2c.c   |  304 ++++++++++
>>  drivers/media/video/stk1160/stk1160-reg.h   |   78 +++
>>  drivers/media/video/stk1160/stk1160-v4l.c   |  846 +++++++++++++++++++++++++++
>>  drivers/media/video/stk1160/stk1160-video.c |  506 ++++++++++++++++
>>  drivers/media/video/stk1160/stk1160.h       |  183 ++++++
>>  10 files changed, 2336 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/stk1160/Kconfig
>>  create mode 100644 drivers/media/video/stk1160/Makefile
>>  create mode 100644 drivers/media/video/stk1160/stk1160-core.c
>>  create mode 100644 drivers/media/video/stk1160/stk1160-i2c.c
>>  create mode 100644 drivers/media/video/stk1160/stk1160-reg.h
>>  create mode 100644 drivers/media/video/stk1160/stk1160-v4l.c
>>  create mode 100644 drivers/media/video/stk1160/stk1160-video.c
>>  create mode 100644 drivers/media/video/stk1160/stk1160.h
>>
>> +
>> +     /*
>> +      * We take the lock just before device registration,
>> +      * to prevent someone (probably udev) from opening us
>> +      * before we finish initialization
>> +      */
>> +     mutex_init(&dev->mutex);
>> +     mutex_lock(&dev->mutex);
>> +
>> +     rc = stk1160_video_register(dev);
>
> It's usually better to register the video node as the very last thing
> in probe(). That way when the node appears it's ready for udev to use.
> No need to lock the mutex in that case.

Done.

>> +     /*
>> +      * Wait until all current v4l2 operation are finished
>> +      * then deallocate resources
>> +      */
>> +     mutex_lock(&dev->mutex);
>> +
>> +     /* Since saa7115 is no longer present, it's better to unregister it */
>> +     v4l2_device_unregister_subdev(dev->sd_saa7115);
>> +
>> +     stk1160_stop_streaming(dev);
>> +
>> +     v4l2_device_disconnect(&dev->v4l2_dev);
>> +
>> +     /* This way current users can detect device is gone */
>> +     dev->udev = NULL;
>> +
>> +     mutex_unlock(&dev->mutex);
>> +
>> +     stk1160_i2c_unregister(dev);
>> +     stk1160_video_unregister(dev);
>
> I recommend that you use the same approach as I did in media/radio/dsbr100.c:
> use the v4l2_dev->release callback to handle the final cleanup. That is a safe
> method that does all the refcounting for you.

I'm sorry but I don't really see the difference.
Right now I'm having video_device release function to handle the final cleanup.
I don't do the refcounting myself either. See my other comment below.

>
> ...
>
>> diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
>> new file mode 100644
>> index 0000000..a7a012b
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/stk1160-v4l.c
>
> ...
>
>> +static int stk1160_open(struct file *filp)
>> +{
>> +     struct stk1160 *dev = video_drvdata(filp);
>> +
>> +     dev->users++;
>
> Why the users field? You shouldn't need it.

Done.

>
>> +
>> +     stk1160_info("opened: users=%d\n", dev->users);
>> +
>> +     return v4l2_fh_open(filp);
>> +}
>> +
>> +static int stk1160_close(struct file *file)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +
>> +     dev->users--;
>> +
>> +     stk1160_info("closed: users=%d\n", dev->users);
>> +
>> +     /*
>> +      * If this is the last fh remaining open, then we
>> +      * stop streaming and free/dequeue all buffers.
>> +      * This prevents device from streaming without
>> +      * any opened filehandles.
>> +      */
>> +     if (v4l2_fh_is_singular_file(file))
>> +             vb2_queue_release(&dev->vb_vidq);
>
> No. You should keep track of which filehandle started streaming (actually
> the filehandle that called REQBUFS is the owner of the queue) and release
> the queue when that particular filehandle is closed (or it calls REQBUFS
> with a count of 0).

Ah. I gave much thought to this issue. I liked the way uvc managed
"privileged" handles,
but I wasn't sure if this was better or not
(I'm thinking on "policy vs mechanism" stuff, sounds a bit silly, right?).

So, I'll implement an owner filehandle, which is able to start/stop streaming.
Also set format? Or just start/stop streaming? How about the
non-owners filehandles?
Are they only capable of changing controls and such?
Is this documented in media api?


>> +
>> +static int vidioc_queryctrl(struct file *file, void *priv,
>> +                             struct v4l2_queryctrl *qc)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     int id = qc->id;
>> +
>> +     memset(qc, 0, sizeof(*qc));
>> +     qc->id = id;
>> +
>> +     /* enumerate V4L2 device controls */
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, qc);
>> +     if (qc->type)
>> +             return 0;
>> +     else
>> +             return -EINVAL;
>> +}
>
> Use the control framework. I won't accept any new drivers that do not use it.
>
> In your case it is very simple: create a v4l2_ctrl_handler, initialize it and
> let v4l2_dev->ctrl_handler point to it. When the subdev is added it will add its
> controls to your handler.

Done.

>
>> +
>> +static int vidioc_g_ctrl(struct file *file, void *priv,
>> +                             struct v4l2_control *ctrl)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);
>> +     return 0;
>> +}
>> +
>> +static int vidioc_s_ctrl(struct file *file, void *priv,
>> +                             struct v4l2_control *ctrl)
>> +{
>> +     struct stk1160 *dev = video_drvdata(file);
>> +     v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
>> +     return 0;
>> +}
>> +
>> +static int vidioc_enum_framesizes(struct file *file, void *fh,
>> +                              struct v4l2_frmsizeenum *fsize)
>> +{
>> +     /* TODO: Is this needed? */
>> +     return -EINVAL;
>> +}
>> +
>> +static int vidioc_enum_frameintervals(struct file *file, void *fh,
>> +                               struct v4l2_frmivalenum *fival)
>> +{
>> +     /* TODO: Is this needed? */
>> +     return -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
>> +     .vidioc_querycap      = vidioc_querycap,
>> +     .vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
>> +     .vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
>> +     .vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
>> +     .vidioc_reqbufs       = vidioc_reqbufs,
>> +     .vidioc_querybuf      = vidioc_querybuf,
>> +     .vidioc_qbuf          = vidioc_qbuf,
>> +     .vidioc_dqbuf         = vidioc_dqbuf,
>> +     .vidioc_querystd      = vidioc_querystd,
>> +     .vidioc_g_std         = NULL, /* don't worry v4l handles this */
>> +     .vidioc_s_std         = vidioc_s_std,
>> +     .vidioc_enum_input    = vidioc_enum_input,
>> +     .vidioc_g_input       = vidioc_g_input,
>> +     .vidioc_s_input       = vidioc_s_input,
>> +     .vidioc_queryctrl     = vidioc_queryctrl,
>> +     .vidioc_g_ctrl        = vidioc_g_ctrl,
>> +     .vidioc_s_ctrl        = vidioc_s_ctrl,
>> +     .vidioc_enum_framesizes = vidioc_enum_framesizes,
>> +     .vidioc_enum_frameintervals = vidioc_enum_frameintervals,
>> +     .vidioc_streamon      = vidioc_streamon,
>> +     .vidioc_streamoff     = vidioc_streamoff,
>> +};
>> +
>> +/********************************************************************/
>> +
>> +/*
>> + * Videobuf2 operations
>> + */
>> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
>> +                             unsigned int *nbuffers, unsigned int *nplanes,
>> +                             unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +     unsigned long size;
>> +
>> +     size = dev->width * dev->height * 2;
>> +
>> +     /*
>> +      * Here we can change the number of buffers being requested.
>> +      * For instance, we could set a minimum and a maximum,
>> +      * like this:
>> +      */
>> +     if (*nbuffers < STK1160_MIN_VIDEO_BUFFERS)
>> +             *nbuffers = STK1160_MIN_VIDEO_BUFFERS;
>> +     else if (*nbuffers > STK1160_MAX_VIDEO_BUFFERS)
>> +             *nbuffers = STK1160_MAX_VIDEO_BUFFERS;
>> +
>> +     /* This means a packed colorformat */
>> +     *nplanes = 1;
>> +
>> +     sizes[0] = size;
>> +
>> +     /*
>> +      * videobuf2-vmalloc allocator is context-less so no need to set
>> +      * alloc_ctxs array.
>> +      */
>> +
>> +     if (v4l_fmt) {
>> +             stk1160_info("selected format %d (%d)\n",
>> +                     v4l_fmt->fmt.pix.pixelformat,
>> +                     dev->fmt->fourcc);
>> +     }
>> +
>> +     stk1160_info("%s: buffer count %d, each %ld bytes\n",
>> +                     __func__, *nbuffers, size);
>> +
>> +     return 0;
>> +}
>> +
>> +static int buffer_init(struct vb2_buffer *vb)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct stk1160_buffer *buf =
>> +                     container_of(vb, struct stk1160_buffer, vb);
>> +
>> +     /* If the device is disconnected, reject the buffer */
>> +     if (!dev->udev)
>> +             return -ENODEV;
>> +
>> +     buf->mem = vb2_plane_vaddr(vb, 0);
>> +     buf->length = vb2_plane_size(vb, 0);
>> +     buf->bytesused = 0;
>> +     buf->pos = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int buffer_finish(struct vb2_buffer *vb)
>> +{
>> +     return 0;
>> +}
>> +
>> +static void buffer_cleanup(struct vb2_buffer *vb)
>> +{
>> +}
>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     unsigned long flags = 0;
>> +     struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct stk1160_buffer *buf =
>> +             container_of(vb, struct stk1160_buffer, vb);
>> +
>> +     spin_lock_irqsave(&dev->buf_lock, flags);
>> +     if (!dev->udev) {
>> +             /*
>> +              * If the device is disconnected return the buffer to userspace
>> +              * directly. The next QBUF call will fail with -ENODEV.
>> +              */
>> +             vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +     } else {
>> +             list_add_tail(&buf->list, &dev->avail_bufs);
>> +     }
>> +     spin_unlock_irqrestore(&dev->buf_lock, flags);
>> +}
>> +
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +     return stk1160_start_streaming(dev);
>> +}
>> +
>> +/* abort streaming and wait for last buffer */
>> +static int stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +     return stk1160_stop_streaming(dev);
>> +}
>> +
>> +static void stk1160_lock(struct vb2_queue *vq)
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +     mutex_lock(&dev->mutex);
>> +}
>> +
>> +static void stk1160_unlock(struct vb2_queue *vq)
>> +{
>> +     struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +     mutex_unlock(&dev->mutex);
>> +}
>> +
>> +static void stk1160_release(struct video_device *vd)
>> +{
>> +     struct stk1160 *dev = video_get_drvdata(vd);
>> +
>> +     stk1160_info("releasing all resources\n");
>> +
>> +     video_set_drvdata(vd, NULL);
>> +     video_device_release(vd);
>> +     v4l2_device_unregister(&dev->v4l2_dev);
>> +
>> +     kfree(dev->alt_max_pkt_size);
>> +     kfree(dev);
>> +}
>> +
>> +static struct vb2_ops stk1160_video_qops = {
>> +     .queue_setup            = queue_setup,
>> +     .buf_init               = buffer_init,
>> +     .buf_prepare            = buffer_prepare,
>> +     .buf_finish             = buffer_finish,
>> +     .buf_cleanup            = buffer_cleanup,
>> +     .buf_queue              = buffer_queue,
>> +     .start_streaming        = start_streaming,
>> +     .stop_streaming         = stop_streaming,
>> +     .wait_prepare           = stk1160_unlock,
>> +     .wait_finish            = stk1160_lock,
>> +};
>> +
>> +static struct video_device v4l_template = {
>> +     .name = "stk1160",
>> +     .tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50,
>> +     .current_norm = V4L2_STD_NTSC,
>> +     .fops = &stk1160_fops,
>> +     .ioctl_ops = &stk1160_ioctl_ops,
>> +     .release = stk1160_release,
>> +};
>> +
>> +/********************************************************************/
>> +
>> +int stk1160_vb2_setup(struct stk1160 *dev)
>> +{
>> +     int rc;
>> +     struct vb2_queue *q;
>> +
>> +     q = &dev->vb_vidq;
>> +     memset(q, 0, sizeof(dev->vb_vidq));
>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
>> +     q->drv_priv = dev;
>> +     q->buf_struct_size = sizeof(struct stk1160_buffer);
>> +     q->ops = &stk1160_video_qops;
>> +     q->mem_ops = &vb2_vmalloc_memops;
>> +
>> +     rc = vb2_queue_init(q);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* initialize video dma queue */
>> +     INIT_LIST_HEAD(&dev->avail_bufs);
>> +
>> +     return 0;
>> +}
>> +
>> +int stk1160_video_register(struct stk1160 *dev)
>> +{
>> +     int rc = -ENOMEM;
>> +
>> +     /* There is no need to set the name if we give a device struct */
>> +     rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
>> +     if (rc) {
>> +             stk1160_err("v4l2_device_register failed (%d)\n", rc);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     dev->vdev = video_device_alloc();
>
> I recommend that vdev is not a pointer but the struct video_device itself
> embedded in the struct stk1160. The release callback can be video_device_release_empty
> in that case. stk1160_release should be set as the release callback of v4l2_dev.

Mmm, I agree with you about the embedded struct part.
But, as I already said, I don't really see why I can't keep
video_device release as the final cleanup release.
It's not to argue you, I'm just trying to understand your point.

Maybe it's cleaner through v4l2_device release. I'll give a try.
I'm still trying to get a clear picture on the differences of
v4l2_device and video_device.

>
>> +     if (!dev->vdev) {
>> +             stk1160_err("video_device_alloc failed (%d)\n", rc);
>> +             goto unreg;
>> +     }
>> +
>> +     /* Initialize video_device with a template structure */
>> +     *dev->vdev = v4l_template;
>> +     dev->vdev->debug = vidioc_debug;
>> +
>> +     /*
>> +      * Provide a mutex to v4l2 core.
>> +      * It will be used to protect all fops and v4l2 ioctls.
>> +      */
>> +     dev->vdev->lock = &dev->mutex;
>
> Please note: we made a change for 3.5 where this lock is only used for
> ioctls, not for other file operations. You will have to review your code
> whether or not to take the lock explicitly for those other file operations.

Ok, I missed that change.

>
>> +
>> +     /* This will be used to set video_device parent */
>> +     dev->vdev->v4l2_dev = &dev->v4l2_dev;
>> +
>> +     /* It is safer to set this before registering with v4l2 */
>> +     video_set_drvdata(dev->vdev, dev);
>> +
>> +     rc = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
>
> Do this as the last thing in this function.

Done.

>
>> +     if (rc < 0) {
>> +             stk1160_err("video_register_device failed (%d)\n", rc);
>> +             goto release;
>> +     }
>> +

Thanks!
Ezequiel.
