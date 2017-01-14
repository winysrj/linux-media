Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33223 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750901AbdANGml (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jan 2017 01:42:41 -0500
Received: by mail-qt0-f180.google.com with SMTP id v23so66345427qtb.0
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2017 22:42:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4891099.8VPSOPnGff@avalon>
References: <1482548666-25272-1-git-send-email-matt@ranostay.consulting> <4891099.8VPSOPnGff@avalon>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Fri, 13 Jan 2017 22:42:40 -0800
Message-ID: <CAJ_EiSRjsFLswbm970CePpfitx2P+SNd6Mn-UvgM2Hx8ef7Lmw@mail.gmail.com>
Subject: Re: [PATCH v5] media: video-i2c: add video-i2c driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>,
        Luca Barbato <lu_zero@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 13, 2017 at 3:47 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Matt,
>
> Thank you for the patch.
>
> On Friday 23 Dec 2016 19:04:26 Matt Ranostay wrote:
>> There are several thermal sensors that only have a low-speed bus
>> interface but output valid video data. This patchset enables support
>> for the AMG88xx "Grid-Eye" sensor family.
>>
>> Cc: Attila Kinali <attila@kinali.ch>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: Luca Barbato <lu_zero@gentoo.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
>> ---
>> Changes from v1:
>> * correct i2c_polling_remove() operations
>> * fixed delay calcuation in buffer_queue()
>> * add include linux/slab.h
>>
>> Changes from v2:
>> * fix build error due to typo in include of slab.h
>>
>> Changes from v3:
>> * switch data transport to a kthread to avoid to .buf_queue that can't sleep
>> * change naming from i2c-polling to video-i2c
>> * make the driver for single chipset under another uses the driver
>>
>> Changes from v4:
>> * fix wraparound issue with jiffies and schedule_timeout_interruptible()
>>
>>  drivers/media/i2c/Kconfig     |   9 +
>>  drivers/media/i2c/Makefile    |   1 +
>>  drivers/media/i2c/video-i2c.c | 569 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 579 insertions(+)
>>  create mode 100644 drivers/media/i2c/video-i2c.c
>
> [snip]
>
>> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
>> new file mode 100644
>> index 000000000000..9390560bd117
>> --- /dev/null
>> +++ b/drivers/media/i2c/video-i2c.c
>
> [snip]
>
>> +#include <linux/delay.h>
>> +#include <linux/freezer.h>
>> +#include <linux/i2c.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/videodev2.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-event.h>
>
> Alphabetical order please.
>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <media/videobuf2-vmalloc.h>
>
> [snip]
>
>> +static struct v4l2_fmtdesc amg88xx_format = {
>> +     .description = "12-bit Greyscale",
>
> If I'm not mistaken the V4L2 core fills that for you nowadays, you don't have
> to set it.
>
>> +     .pixelformat = V4L2_PIX_FMT_Y12,
>> +};
>> +
>> +static struct v4l2_frmsize_discrete amg88xx_size = {
>> +     .width = 8,
>> +     .height = 8,
>> +};
>> +
>> +struct video_i2c_chip {
>> +     /* video dimensions */
>> +     struct v4l2_fmtdesc *format;
>> +     struct v4l2_frmsize_discrete *size;
>
> You can make those two pointers (and the variables they point to) const.
>
>> +
>> +     /* max frames per second */
>> +     unsigned int max_fps;
>> +
>> +     /* pixel buffer size */
>> +     unsigned int buffer_size;
>> +
>> +     /* pixel size in bits */
>> +     unsigned int bpp;
>> +
>> +     /* xfer function */
>> +     int (*xfer)(struct video_i2c_data *data, char *buf);
>> +};
>
> [snip]
>
>> +static int video_i2c_thread_vid_cap(void *priv)
>> +{
>> +     struct video_i2c_data *data = priv;
>> +     struct video_i2c_buffer *vid_cap_buf = NULL;
>> +
>> +     set_freezable();
>> +
>> +     do {
>> +             unsigned int start_jiffies = jiffies;
>
> jiffies is an unsigned long.

Noted.
>
>> +             unsigned int delay = msecs_to_jiffies(1000 / data->chip-
>>max_fps);
>> +             int schedule_delay;
>> +
>> +             try_to_freeze();
>> +
>> +             mutex_lock(&data->lock);
>
> Why do you need the mutex here ?

Probably don't need the nested mutex and spinlock

>
>> +             spin_lock(&data->slock);
>> +
>> +             if (!list_empty(&data->vid_cap_active)) {
>> +                     vid_cap_buf = list_entry(data->vid_cap_active.next,
>> +                                              struct video_i2c_buffer,
> list);
>> +                     list_del(&vid_cap_buf->list);
>> +             }
>> +
>> +             if (vid_cap_buf) {
>
> vid_cap_buf will only be non-NULL in all but the first iteration of the loop,
> even if the list is empty. You should declare the variable inside the loop,
> not at the function level.
>

Noted

>> +                     struct vb2_buffer *vb2_buf = &vid_cap_buf->vb.vb2_buf;
>> +                     void *vbuf = vb2_plane_vaddr(vb2_buf, 0);
>> +                     int ret = data->chip->xfer(data, vbuf);
>> +
>> +                     vb2_buf->timestamp = ktime_get_ns();
>> +                     vb2_buffer_done(vb2_buf, ret ?
>> +                                     VB2_BUF_STATE_ERROR :
> VB2_BUF_STATE_DONE);
>> +             }
>> +
>> +             spin_unlock(&data->slock);
>
> The spinlock must be unlocked before data->chip->xfer. You can't hold it and
> sleep.
>
>> +             mutex_unlock(&data->lock);
>> +
>> +             schedule_delay = delay - (jiffies - start_jiffies);
>
> Does this still work when jiffies wraps around ?
>
>> +             if (schedule_delay < 0)
>> +                     schedule_delay = delay;
>> +
>> +             schedule_timeout_interruptible(schedule_delay);
>> +     } while (!kthread_should_stop());
>> +
>> +     return 0;
>> +}
>> +
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct video_i2c_data *data = vb2_get_drv_priv(vq);
>> +
>> +     if (data->kthread_vid_cap)
>> +             return 0;
>> +
>> +     data->kthread_vid_cap = kthread_run(video_i2c_thread_vid_cap, data,
>> +                                         "%s-vid-cap", data-
>>v4l2_dev.name);
>> +
>
> No need for a blank line here.
>
>> +     if (IS_ERR(data->kthread_vid_cap)) {
>> +             struct video_i2c_buffer *buf, *tmp;
>> +
>> +             list_for_each_entry_safe(buf, tmp, &data->vid_cap_active,
> list) {
>> +                     list_del(&buf->list);
>> +                     vb2_buffer_done(&buf->vb.vb2_buf,
>> +                                     VB2_BUF_STATE_QUEUED);
>> +             }
>
> Shouldn't you protect the whole loop with the data->slock spinlock ?
>
>> +
>> +             return PTR_ERR(data->kthread_vid_cap);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct video_i2c_data *data = vb2_get_drv_priv(vq);
>> +
>> +     if (data->kthread_vid_cap == NULL)
>> +             return;
>> +
>> +     mutex_lock(&data->lock);
>
> Do you need the mutex here ?
>
>> +     spin_lock(&data->slock);
>> +
>> +     while (!list_empty(&data->vid_cap_active)) {
>> +             struct video_i2c_buffer *buf;
>> +
>> +             buf = list_entry(data->vid_cap_active.next,
>> +                              struct video_i2c_buffer, list);
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +     }
>> +     spin_unlock(&data->slock);
>> +     mutex_unlock(&data->lock);
>> +
>> +     kthread_stop(data->kthread_vid_cap);
>
> Shouldn't you stop the thread first ?
>
>> +     data->kthread_vid_cap = NULL;
>> +}
>
> [snip]
>
>> +
>> +static int video_i2c_querycap(struct file *file, void  *priv,
>> +                             struct v4l2_capability *vcap)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +     struct i2c_client *client = data->client;
>> +
>> +     strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
>> +     strlcpy(vcap->card, "I2C Transport Video", sizeof(vcap->card));
>
> Shouldn't this include the I2C device name ?

Likely.

>
>> +
>> +     sprintf(vcap->bus_info, "I2C:%d-%d", client->adapter->nr, client-
>>addr);
>> +     return 0;
>> +}
>
> [snip]
>
>> +static int video_i2c_enum_frameintervals(struct file *file, void *priv,
>> +                                        struct v4l2_frmivalenum *fe)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +     struct v4l2_frmsize_discrete *size = data->chip->size;
>> +
>> +     if (fe->index > 0)
>> +             return -EINVAL;
>> +
>> +     if ((fe->width != size->width) || (fe->height != size->height))
>
> No need for the inner parentheses.
>
>> +             return -EINVAL;
>> +
>> +     fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>> +     fe->discrete.numerator = 1;
>> +     fe->discrete.denominator = data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>
> [snip]
>
>> +static int video_i2c_fmt_vid_cap(struct file *file, void *fh,
>> +                                  struct v4l2_format *fmt)
>
> Should you call the function video_i2c_s_fmt_vid_cap ?
>
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +     int ret = video_i2c_try_fmt_vid_cap(file, fh, fmt);
>> +
>> +     if (ret < 0)
>> +             return ret;
>
> video_i2c_try_fmt_vid_cap() always returns 0, so you can drop the check (and
> the ret variable).
>
>> +     if (vb2_is_busy(&data->vb_vidq))
>> +             return -EBUSY;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_g_parm(struct file *filp, void *priv,
>> +                           struct v4l2_streamparm *parm)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(filp);
>> +
>> +     if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +
>> +     parm->parm.capture.readbuffers = 1;
>> +     parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>> +     parm->parm.capture.timeperframe.numerator = 1;
>> +     parm->parm.capture.timeperframe.denominator = data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_s_parm(struct file *filp, void *priv,
>> +                           struct v4l2_streamparm *parm)
>> +{
>> +     if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +
>> +     return video_i2c_g_parm(filp, priv, parm);
>
> You can just use the video_i2c_g_parm() function as the .vidioc_s_parm
> handler, there's no need to declare a separate function.
>

Okay.
>> +}
>
> [snip]
>
>> +static int video_i2c_probe(struct i2c_client *client,
>> +                          const struct i2c_device_id *id)
>> +{
>> +     struct video_i2c_data *data;
>> +     struct v4l2_device *v4l2_dev;
>> +     struct vb2_queue *queue;
>> +     int ret;
>> +
>> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +
>> +     data->chip = &video_i2c_chip;
>> +     data->client = client;
>> +     v4l2_dev = &data->v4l2_dev;
>> +     strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
>> +
>> +     ret = v4l2_device_register(&client->dev, v4l2_dev);
>> +     if (ret < 0)
>> +             goto error_free_device;
>> +
>> +     mutex_init(&data->lock);
>> +     mutex_init(&data->queue_lock);
>> +
>> +     queue = &data->vb_vidq;
>> +     queue->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     queue->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>> +     queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC |
>> +                              V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
>> +     queue->drv_priv = data;
>> +     queue->buf_struct_size = sizeof(struct video_i2c_buffer);
>> +     queue->min_buffers_needed = 1;
>> +     queue->ops = &video_i2c_video_qops;
>> +     queue->mem_ops = &vb2_vmalloc_memops;
>> +
>> +     ret = vb2_queue_init(queue);
>> +     if (ret < 0)
>> +             goto error_free_device;
>
> This should be error_unregister_device.
>
>> +
>> +     data->vdev.queue = queue;
>> +     data->vdev.queue->lock = &data->queue_lock;
>> +
>> +     strlcpy(data->vdev.name, "I2C Transport Video", sizeof(data-
>>vdev.name));
>
> Shouldn't this be called after the I2C device name ?
>
>> +     data->vdev.v4l2_dev = v4l2_dev;
>> +     data->vdev.fops = &video_i2c_fops;
>> +     data->vdev.lock = &data->lock;
>> +     data->vdev.ioctl_ops = &video_i2c_ioctl_ops;
>> +     data->vdev.release = video_i2c_release;
>> +     data->vdev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
>> +                              V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> +
>> +     spin_lock_init(&data->slock);
>> +     INIT_LIST_HEAD(&data->vid_cap_active);
>> +
>> +     video_set_drvdata(&data->vdev, data);
>> +     i2c_set_clientdata(client, data);
>> +
>> +     ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
>> +     if (ret < 0)
>> +             goto error_unregister_device;
>> +
>> +     return 0;
>> +
>> +error_unregister_device:
>> +     v4l2_device_unregister(v4l2_dev);
>> +
>> +error_free_device:
>> +     kfree(data);
>> +
>> +     return ret;
>> +}
>> +
>> +static int video_i2c_remove(struct i2c_client *client).
>> +{
>> +     struct video_i2c_data *data = i2c_get_clientdata(client);
>> +
>> +     v4l2_device_unregister(&data->v4l2_dev);
>> +     video_unregister_device(&data->vdev);
>
> I believe you have to swap those two calls, as vdev references v4l2_dev.

Noted.
>
>> +
>> +     return 0;
>> +}
>
> [snip]
>
> --
> Regards,
>
> Laurent Pinchart
>
