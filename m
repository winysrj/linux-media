Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:46463 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbeBPCLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 21:11:49 -0500
Received: by mail-io0-f195.google.com with SMTP id p78so2751535iod.13
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 18:11:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7309bded-fa0b-3cb9-5150-1fa3354b1978@xs4all.nl>
References: <20180113035747.8935-1-matt.ranostay@konsulko.com> <7309bded-fa0b-3cb9-5150-1fa3354b1978@xs4all.nl>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Thu, 15 Feb 2018 18:11:48 -0800
Message-ID: <CAJCx=gk_d7RtXtqSyCntWSFZ6ewEaOWOP4o4h_wqMCD7r+Z4WQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] media: video-i2c: add video-i2c driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Luca Barbato <lu_zero@gentoo.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 15, 2018 at 7:49 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Matt,
>
> Here is a quick review. Apologies for the delay, it has been very busy for
> the last few weeks.
>
> On 13/01/18 04:57, Matt Ranostay wrote:
>> There are several thermal sensors that only have a low-speed bus
>> interface but output valid video data. This patchset enables support
>> for the AMG88xx "Grid-Eye" sensor family.
>>
>> Cc: Luca Barbato <lu_zero@gentoo.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
>> ---
>>  drivers/media/i2c/Kconfig     |   9 +
>>  drivers/media/i2c/Makefile    |   1 +
>>  drivers/media/i2c/video-i2c.c | 556 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 566 insertions(+)
>>  create mode 100644 drivers/media/i2c/video-i2c.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 9f18cd296841..549f1e9fc01e 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -908,6 +908,15 @@ config VIDEO_M52790
>>
>>        To compile this driver as a module, choose M here: the
>>        module will be called m52790.
>> +
>> +config VIDEO_I2C
>> +     tristate "I2C transport video support"
>> +     depends on VIDEO_V4L2 && I2C
>> +     select VIDEOBUF2_VMALLOC
>> +     ---help---
>> +       Enable the I2C transport video support which supports the
>> +       following:
>> +        * Panasonic AMG88xx Grid-Eye Sensors
>>  endmenu
>>
>>  menu "Sensors used on soc_camera driver"
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index c0f94cd8d56d..5ca4c98a4bea 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -90,6 +90,7 @@ obj-$(CONFIG_VIDEO_LM3646)  += lm3646.o
>>  obj-$(CONFIG_VIDEO_SMIAPP_PLL)       += smiapp-pll.o
>>  obj-$(CONFIG_VIDEO_AK881X)           += ak881x.o
>>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>> +obj-$(CONFIG_VIDEO_I2C)              += video-i2c.o
>>  obj-$(CONFIG_VIDEO_ML86V7667)        += ml86v7667.o
>>  obj-$(CONFIG_VIDEO_OV2659)   += ov2659.o
>>  obj-$(CONFIG_VIDEO_TC358743) += tc358743.o
>> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
>> new file mode 100644
>> index 000000000000..9df9b5ebd156
>> --- /dev/null
>> +++ b/drivers/media/i2c/video-i2c.c
>> @@ -0,0 +1,556 @@
>> +/*
>> + * video-i2c.c - Support for I2C transport video devices
>> + *
>> + * Copyright (C) 2018 Matt Ranostay <matt.ranostay@konsulko.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>
> Please use the SPDX tags instead of this license text. See
> https://git.linuxtv.org/media_tree.git/tree/Documentation/process/license-rules.rst
>
>> + *
>> + * Supported:
>> + * - Panasonic AMG88xx Grid-Eye Sensors
>> + */
>> +
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
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +
>> +#define VIDEO_I2C_DRIVER     "video-i2c"
>> +#define MAX_BUFFER_SIZE              128
>> +
>> +struct video_i2c_chip;
>> +
>> +struct video_i2c_buffer {
>> +     struct vb2_v4l2_buffer vb;
>> +     struct list_head list;
>> +};
>> +
>> +struct video_i2c_data {
>> +     struct i2c_client *client;
>> +     const struct video_i2c_chip *chip;
>> +     struct mutex lock;
>> +     spinlock_t slock;
>> +     struct mutex queue_lock;
>> +
>> +     struct v4l2_device v4l2_dev;
>> +     struct video_device vdev;
>> +     struct vb2_queue vb_vidq;
>> +
>> +     struct task_struct *kthread_vid_cap;
>> +     struct list_head vid_cap_active;
>> +};
>> +
>> +static struct v4l2_fmtdesc amg88xx_format = {
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
>> +     const struct v4l2_fmtdesc *format;
>> +     const struct v4l2_frmsize_discrete *size;
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
>> +
>> +static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>> +{
>> +     struct i2c_client *client = data->client;
>> +     struct i2c_msg msg[2];
>> +     u8 reg = 0x80;
>> +     int ret;
>> +
>> +     msg[0].addr = client->addr;
>> +     msg[0].flags = 0;
>> +     msg[0].len = 1;
>> +     msg[0].buf  = (char *) &reg;
>> +
>> +     msg[1].addr = client->addr;
>> +     msg[1].flags = I2C_M_RD;
>> +     msg[1].len = data->chip->buffer_size;
>> +     msg[1].buf = (char *) buf;
>> +
>> +     ret = i2c_transfer(client->adapter, msg, 2);
>> +
>> +     return (ret == 2) ? 0 : -EIO;
>> +}
>> +
>> +static const struct video_i2c_chip video_i2c_chip = {
>> +     .size           = &amg88xx_size,
>> +     .format         = &amg88xx_format,
>> +     .max_fps        = 10,
>> +     .buffer_size    = 128,
>> +     .bpp            = 16,
>> +     .xfer           = &amg88xx_xfer,
>> +};
>> +
>> +static const struct v4l2_file_operations video_i2c_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = v4l2_fh_open,
>> +     .release        = vb2_fop_release,
>> +     .poll           = vb2_fop_poll,
>> +     .read           = vb2_fop_read,
>> +     .mmap           = vb2_fop_mmap,
>> +     .unlocked_ioctl = video_ioctl2,
>> +};
>> +
>> +static int queue_setup(struct vb2_queue *vq,
>> +                    unsigned int *nbuffers, unsigned int *nplanes,
>> +                    unsigned int sizes[], struct device *alloc_devs[])
>> +{
>> +     struct video_i2c_data *data = vb2_get_drv_priv(vq);
>> +     unsigned int size = data->chip->buffer_size;
>> +
>> +     if (vq->num_buffers + *nbuffers < 2)
>> +             *nbuffers = 2;
>> +
>> +     if (*nplanes)
>> +             return sizes[0] < size ? -EINVAL : 0;
>> +
>> +     *nplanes = 1;
>> +     sizes[0] = size;
>> +
>> +     return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct video_i2c_data *data = vb2_get_drv_priv(vb->vb2_queue);
>> +     unsigned int size = data->chip->buffer_size;
>> +
>> +     if (vb2_plane_size(vb, 0) < size)
>> +             return -EINVAL;
>> +
>> +     vb2_set_plane_payload(vb, 0, size);
>> +
>> +     return 0;
>> +}
>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +     struct video_i2c_data *data = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct video_i2c_buffer *buf =
>> +                     container_of(vbuf, struct video_i2c_buffer, vb);
>> +
>> +     spin_lock(&data->slock);
>> +     list_add_tail(&buf->list, &data->vid_cap_active);
>> +     spin_unlock(&data->slock);
>> +}
>> +
>> +static int video_i2c_thread_vid_cap(void *priv)
>> +{
>> +     struct video_i2c_data *data = priv;
>> +
>> +     set_freezable();
>> +
>> +     do {
>> +             unsigned long start_jiffies = jiffies;
>> +             unsigned int delay = msecs_to_jiffies(1000 / data->chip->max_fps);
>> +             struct video_i2c_buffer *vid_cap_buf = NULL;
>> +             int schedule_delay;
>> +
>> +             try_to_freeze();
>> +
>> +             spin_lock(&data->slock);
>> +
>> +             if (!list_empty(&data->vid_cap_active)) {
>> +                     vid_cap_buf = list_entry(data->vid_cap_active.next,
>> +                                              struct video_i2c_buffer, list);
>> +                     list_del(&vid_cap_buf->list);
>> +             }
>> +
>> +             spin_unlock(&data->slock);
>> +
>> +             if (vid_cap_buf) {
>> +                     struct vb2_buffer *vb2_buf = &vid_cap_buf->vb.vb2_buf;
>> +                     void *vbuf = vb2_plane_vaddr(vb2_buf, 0);
>> +                     int ret = data->chip->xfer(data, vbuf);
>> +
>> +                     vb2_buf->timestamp = ktime_get_ns();
>> +                     vb2_buffer_done(vb2_buf, ret ?
>> +                                     VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>> +             }
>> +
>> +             schedule_delay = delay - (jiffies - start_jiffies);
>> +
>> +             if (time_after(jiffies, start_jiffies + delay))
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
>> +                                         "%s-vid-cap", data->v4l2_dev.name);
>> +     if (IS_ERR(data->kthread_vid_cap)) {
>
> Change this to:
>
>         if (!IS_ERR(data->kthread_vid_cap))
>                 return 0;
>
> Then do the cleanup for the error case.

Noted.
>
>> +             struct video_i2c_buffer *buf, *tmp;
>> +
>> +             spin_lock(&data->slock);
>> +
>> +             list_for_each_entry_safe(buf, tmp, &data->vid_cap_active, list) {
>> +                     list_del(&buf->list);
>> +                     vb2_buffer_done(&buf->vb.vb2_buf,
>> +                                     VB2_BUF_STATE_QUEUED);
>> +             }
>> +
>> +             spin_unlock(&data->slock);
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
>> +     kthread_stop(data->kthread_vid_cap);
>> +
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
>> +
>> +     data->kthread_vid_cap = NULL;
>> +}
>> +
>> +static struct vb2_ops video_i2c_video_qops = {
>> +     .queue_setup            = queue_setup,
>> +     .buf_prepare            = buffer_prepare,
>> +     .buf_queue              = buffer_queue,
>> +     .start_streaming        = start_streaming,
>> +     .stop_streaming         = stop_streaming,
>> +     .wait_prepare           = vb2_ops_wait_prepare,
>> +     .wait_finish            = vb2_ops_wait_finish,
>> +};
>> +
>> +static int video_i2c_querycap(struct file *file, void  *priv,
>> +                             struct v4l2_capability *vcap)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +     struct i2c_client *client = data->client;
>> +
>> +     strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
>> +     sprintf(vcap->card, "I2C %d-%d Transport Video",
>> +                                          client->adapter->nr, client->addr);
>> +
>> +     sprintf(vcap->bus_info, "I2C:%d-%d", client->adapter->nr, client->addr);
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_g_input(struct file *file, void *fh, unsigned int *inp)
>> +{
>> +     *inp = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_s_input(struct file *file, void *fh, unsigned int inp)
>> +{
>> +     return (inp > 0) ? -EINVAL : 0;
>> +}
>> +
>> +static int video_i2c_enum_input(struct file *file, void *fh,
>> +                               struct v4l2_input *vin)
>> +{
>> +     if (vin->index > 0)
>> +             return -EINVAL;
>> +
>> +     strlcpy(vin->name, "Camera", sizeof(vin->name));
>> +
>> +     vin->type = V4L2_INPUT_TYPE_CAMERA;
>> +     vin->audioset = 0;
>> +     vin->tuner = 0;
>> +     vin->std = 0;
>> +     vin->status = 0;
>
> No need to zero this, it's done for you in v4l2-ioctl.c via the INFO_FL_CLEAR
> flag.
>

Noted.

>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_fmt_vid_cap(struct file *file, void *fh,
>> +                                     struct v4l2_fmtdesc *fmt)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +     enum v4l2_buf_type type = fmt->type;
>> +
>> +     if (fmt->index > 0)
>> +             return -EINVAL;
>> +
>> +     *fmt = *data->chip->format;
>> +     fmt->type = type;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_framesizes(struct file *file, void *fh,
>> +                                    struct v4l2_frmsizeenum *fsize)
>> +{
>> +     const struct video_i2c_data *data = video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size = data->chip->size;
>> +
>> +     /* currently only one frame size is allowed */
>> +     if (fsize->index > 0)
>> +             return -EINVAL;
>> +
>> +     if (fsize->pixel_format != data->chip->format->pixelformat)
>> +             return -EINVAL;
>> +
>> +     fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>> +     fsize->discrete.width = size->width;
>> +     fsize->discrete.height = size->height;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_frameintervals(struct file *file, void *priv,
>> +                                        struct v4l2_frmivalenum *fe)
>> +{
>> +     const struct video_i2c_data *data = video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size = data->chip->size;
>> +
>> +     if (fe->index > 0)
>> +             return -EINVAL;
>> +
>> +     if (fe->width != size->width || fe->height != size->height)
>> +             return -EINVAL;
>> +
>> +     fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>> +     fe->discrete.numerator = 1;
>> +     fe->discrete.denominator = data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_try_fmt_vid_cap(struct file *file, void *fh,
>> +                                    struct v4l2_format *fmt)
>> +{
>> +     const struct video_i2c_data *data = video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size = data->chip->size;
>> +     struct v4l2_pix_format *pix = &fmt->fmt.pix;
>> +     unsigned int bpp = data->chip->bpp / 8;
>> +
>> +     pix->width = size->width;
>> +     pix->height = size->height;
>> +     pix->pixelformat = data->chip->format->pixelformat;
>> +     pix->field = V4L2_FIELD_NONE;
>> +     pix->bytesperline = pix->width * bpp;
>> +     pix->sizeimage = pix->width * pix->height * bpp;
>> +     pix->colorspace = V4L2_COLORSPACE_RAW;
>> +     pix->priv = 0;
>
> No need to set priv.
>

Noted

>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_s_fmt_vid_cap(struct file *file, void *fh,
>> +                                  struct v4l2_format *fmt)
>> +{
>> +     struct video_i2c_data *data = video_drvdata(file);
>> +
>
> You need to call video_i2c_try_fmt_vid_cap first, otherwise the format
> is never updated.

Noted.
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
>> +static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>> +     .vidioc_querycap                = video_i2c_querycap,
>> +     .vidioc_g_input                 = video_i2c_g_input,
>> +     .vidioc_s_input                 = video_i2c_s_input,
>> +     .vidioc_enum_input              = video_i2c_enum_input,
>> +     .vidioc_enum_fmt_vid_cap        = video_i2c_enum_fmt_vid_cap,
>> +     .vidioc_enum_framesizes         = video_i2c_enum_framesizes,
>> +     .vidioc_enum_frameintervals     = video_i2c_enum_frameintervals,
>> +     .vidioc_g_fmt_vid_cap           = video_i2c_try_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap           = video_i2c_s_fmt_vid_cap,
>> +     .vidioc_g_parm                  = video_i2c_g_parm,
>> +     .vidioc_s_parm                  = video_i2c_g_parm,
>> +     .vidioc_try_fmt_vid_cap         = video_i2c_try_fmt_vid_cap,
>> +     .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>> +     .vidioc_create_bufs             = vb2_ioctl_create_bufs,
>> +     .vidioc_prepare_buf             = vb2_ioctl_prepare_buf,
>> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
>> +     .vidioc_streamon                = vb2_ioctl_streamon,
>> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
>> +};
>> +
>> +static void video_i2c_release(struct video_device *vdev)
>> +{
>> +     kfree(video_get_drvdata(vdev));
>> +}
>> +
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
>
> V4L2_BUF_FLAG_TSTAMP_SRC_EOF == 0, so you can drop it.
>
>> +     queue->drv_priv = data;
>> +     queue->buf_struct_size = sizeof(struct video_i2c_buffer);
>> +     queue->min_buffers_needed = 1;
>> +     queue->ops = &video_i2c_video_qops;
>> +     queue->mem_ops = &vb2_vmalloc_memops;
>> +
>> +     ret = vb2_queue_init(queue);
>> +     if (ret < 0)
>> +             goto error_unregister_device;
>> +
>> +     data->vdev.queue = queue;
>> +     data->vdev.queue->lock = &data->queue_lock;
>> +
>> +     sprintf(data->vdev.name, "I2C %d-%d Transport Video",
>> +                              client->adapter->nr, client->addr);
>> +
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
>> +static int video_i2c_remove(struct i2c_client *client)
>> +{
>> +     struct video_i2c_data *data = i2c_get_clientdata(client);
>> +
>> +     video_unregister_device(&data->vdev);
>> +     v4l2_device_unregister(&data->v4l2_dev);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct i2c_device_id video_i2c_id_table[] = {
>> +     { "amg88xx", 0 },
>
> It makes more sense if you pass the chip info as argument here. It makes it
> easier to add new devices. See e.g. adv7604.c.
>

Well there is only one chip at the moment. So I could go either way
and wouldn't be hard for someone to add later

> There is no static const struct of_device_id []? Wouldn't it make sense to
> add device tree support?
>

Ok sure. Isn't hard to add.

>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, video_i2c_id_table);
>> +
>> +static struct i2c_driver video_i2c_driver = {
>> +     .driver = {
>> +             .name   = VIDEO_I2C_DRIVER,
>> +     },
>> +     .probe          = video_i2c_probe,
>> +     .remove         = video_i2c_remove,
>> +     .id_table       = video_i2c_id_table,
>> +};
>> +
>> +module_i2c_driver(video_i2c_driver);
>> +
>> +MODULE_AUTHOR("Matt Ranostay <matt.ranostay@konsulko.com>");
>> +MODULE_DESCRIPTION("I2C transport video support");
>> +MODULE_LICENSE("GPL");
>>
>
> Regards,
>
>         Hans
