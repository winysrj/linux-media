Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33633 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbcKXGb0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 01:31:26 -0500
Received: by mail-qk0-f177.google.com with SMTP id x190so40036099qkb.0
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 22:31:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2379913.pFkGVXK2x8@avalon>
References: <1479863920-14708-1-git-send-email-matt@ranostay.consulting> <2379913.pFkGVXK2x8@avalon>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Wed, 23 Nov 2016 22:31:24 -0800
Message-ID: <CAJ_EiSSjjf9KDVzA=Qyd0BqXC30Hb89UgcJ7Oinr8bWCN=JmHg@mail.gmail.com>
Subject: Re: [PATCH v3] media: i2c-polling: add i2c-polling driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>,
        Luca Barbato <lu_zero@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 8:30 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Matt,
>
> Thank you for the patch.
>
> On Tuesday 22 Nov 2016 17:18:40 Matt Ranostay wrote:
>> There are several thermal sensors that only have a low-speed bus
>> interface but output valid video data. This patchset enables support
>> for the AMG88xx "Grid-Eye" sensor family.
>>
>> Cc: Attila Kinali <attila@kinali.ch>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: Luca Barbato <lu_zero@gentoo.org>
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
>>  drivers/media/i2c/Kconfig       |   8 +
>>  drivers/media/i2c/Makefile      |   1 +
>>  drivers/media/i2c/i2c-polling.c | 469 +++++++++++++++++++++++++++++++++++++
>
> Just looking at the driver name I believe a rename is needed. i2c-polling is a
> very generic name and would mislead many people into thinking about an I2C
> subsystem core feature instead of a video driver. "video-i2c" is one option,
> I'm open to other ideas.
>
>>  3 files changed, 478 insertions(+)
>>  create mode 100644 drivers/media/i2c/i2c-polling.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index b31fa6fae009..d840e7be0036 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -768,6 +768,14 @@ config VIDEO_M52790
>>
>>        To compile this driver as a module, choose M here: the
>>        module will be called m52790.
>> +
>> +config VIDEO_I2C_POLLING
>> +     tristate "I2C polling video support"
>> +     depends on VIDEO_V4L2 && I2C
>> +     select VIDEOBUF2_VMALLOC
>> +     ---help---
>> +       Enable the I2C polling video support which supports the following:
>> +        * Panasonic AMG88xx Grid-Eye Sensors
>>  endmenu
>>
>>  menu "Sensors used on soc_camera driver"
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 92773b2e6225..8182ec9f66b9 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -79,6 +79,7 @@ obj-$(CONFIG_VIDEO_LM3646)  += lm3646.o
>>  obj-$(CONFIG_VIDEO_SMIAPP_PLL)       += smiapp-pll.o
>>  obj-$(CONFIG_VIDEO_AK881X)           += ak881x.o
>>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>> +obj-$(CONFIG_VIDEO_I2C_POLLING)      += i2c-polling.o
>>  obj-$(CONFIG_VIDEO_ML86V7667)        += ml86v7667.o
>>  obj-$(CONFIG_VIDEO_OV2659)   += ov2659.o
>>  obj-$(CONFIG_VIDEO_TC358743) += tc358743.o
>> diff --git a/drivers/media/i2c/i2c-polling.c
>> b/drivers/media/i2c/i2c-polling.c new file mode 100644
>> index 000000000000..46a4eecde2d2
>> --- /dev/null
>> +++ b/drivers/media/i2c/i2c-polling.c
>> @@ -0,0 +1,469 @@
>> +/*
>> + * i2c_polling.c - Support for polling I2C video devices
>> + *
>> + * Copyright (C) 2016 Matt Ranostay <mranostay@ranostay.consulting>
>> + *
>> + * Based on the orginal work drivers/media/parport/bw-qcam.c
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
>> + *
>> + * Supported:
>> + * - Panasonic AMG88xx Grid-Eye Sensors
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>
> I don't think you implement device tree support, is linux/of.h needed ? Or
> maybe you could implement device tree support ;-)
>
>> +#include <linux/delay.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>
> You don't implement any control, you can drop support for control events as
> well.
>
>> +#include <media/videobuf2-vmalloc.h>
>
> Please sort includes alphabetically, it makes it easier to locate duplicates.
>
>> +#define I2C_POLLING_DRIVER   "i2c-polling"
>> +
>> +struct i2c_polling_chip;
>> +
>> +struct i2c_polling_data {
>> +     struct i2c_client *client;
>> +     const struct i2c_polling_chip *chip;
>> +     struct mutex lock;
>> +     struct mutex queue_lock;
>> +     unsigned int last_update;
>> +
>> +     struct v4l2_device v4l2_dev;
>> +     struct video_device vdev;
>> +     struct vb2_queue vb_vidq;
>> +};
>> +
>> +static struct v4l2_fmtdesc amg88xx_format = {
>> +     .description = "12-bit Greyscale",
>> +     .pixelformat = V4L2_PIX_FMT_Y12,
>> +};
>> +
>> +static struct v4l2_frmsize_discrete amg88xx_size = {
>> +     .width = 8,
>> +     .height = 8,
>> +};
>> +
>> +struct i2c_polling_chip {
>> +     /* video dimensions */
>> +     struct v4l2_fmtdesc *format;
>> +     struct v4l2_frmsize_discrete *size;
>> +
>> +     /* max frames per second */
>> +     unsigned int max_fps;
>> +
>> +     /* pixel buffer size */
>> +     unsigned int buffer_size;
>> +
>> +     /* xfer function */
>> +     int (*xfer)(struct i2c_polling_data *data, char *buf);
>> +};
>> +
>> +enum {
>> +     AMG88XX = 0,
>> +     I2C_POLLING_CHIP_CNT,
>> +};
>> +
>> +static int amg88xx_xfer(struct i2c_polling_data *data, char *buf)
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
>> +static const struct i2c_polling_chip
>> i2c_polling_chips[I2C_POLLING_CHIP_CNT] = {
>> +     [AMG88XX] = {
>> +             .size           = &amg88xx_size,
>> +             .format         = &amg88xx_format,
>> +             .max_fps        = 10,
>> +             .buffer_size    = 128,
>> +             .xfer           = &amg88xx_xfer,
>> +     },
>> +};
>> +
>> +static const struct v4l2_file_operations i2c_polling_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = v4l2_fh_open,
>> +     .release        = vb2_fop_release,
>> +     .poll           = vb2_fop_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .read           = vb2_fop_read,
>> +     .mmap           = vb2_fop_mmap,
>> +};
>> +
>> +static int queue_setup(struct vb2_queue *vq,
>> +                    unsigned int *nbuffers, unsigned int *nplanes,
>> +                    unsigned int sizes[], struct device *alloc_devs[])
>> +{
>> +     struct i2c_polling_data *data = vb2_get_drv_priv(vq);
>> +
>> +     if (!(*nbuffers))
>> +             *nbuffers = 3;
>> +
>> +     *nplanes = 1;
>> +     sizes[0] = data->chip->buffer_size;
>> +
>> +     return 0;
>> +}
>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     struct i2c_polling_data *data = vb2_get_drv_priv(vb->vb2_queue);
>> +     unsigned int delay = 1000 / data->chip->max_fps;
>> +     int delta;
>> +
>> +     mutex_lock(&data->lock);
>> +
>> +     delta = jiffies - data->last_update;
>> +
>> +     if (delta < msecs_to_jiffies(delay)) {
>> +             int tmp = (delay - jiffies_to_msecs(delta)) * 1000;
>> +
>> +             usleep_range(tmp, tmp + 1000);
>> +     }
>> +     data->last_update = jiffies;
>> +
>> +     mutex_unlock(&data->lock);
>> +
>> +     vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +}
>> +
>> +static void buffer_finish(struct vb2_buffer *vb)
>> +{
>> +     struct i2c_polling_data *data = vb2_get_drv_priv(vb->vb2_queue);
>> +     void *vbuf = vb2_plane_vaddr(vb, 0);
>> +     int size = vb2_plane_size(vb, 0);
>> +     int ret;
>> +
>> +     mutex_lock(&data->lock);
>> +
>> +     ret = data->chip->xfer(data, vbuf);
>> +     if (ret < 0)
>> +             vb->state = VB2_BUF_STATE_ERROR;
>
> That's not nice, the status should be set through vb2_buffer_done().
>
> You can't transfer data in the buffer_queue handler is that function can't
> sleep. Instead, I'm wondering whether it would make sense to perform transfers
> in a workqueue, to making timings less dependent on userspace.


About the workqueue how would one signal to that the buffer is written
to buffer_queue/buffer_finish?


>
>> +     mutex_unlock(&data->lock);
>> +
>> +     vb->timestamp = ktime_get_ns();
>> +     vb2_set_plane_payload(vb, 0, ret ? 0 : size);
>> +}
>> +
>> +static struct vb2_ops i2c_polling_video_qops = {
>> +     .queue_setup    = queue_setup,
>> +     .buf_queue      = buffer_queue,
>> +     .buf_finish     = buffer_finish,
>> +     .wait_prepare   = vb2_ops_wait_prepare,
>> +     .wait_finish    = vb2_ops_wait_finish,
>> +};
>> +
>> +static int i2c_polling_querycap(struct file *file, void  *priv,
>> +                             struct v4l2_capability *vcap)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
>> +
>> +     strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
>> +     strlcpy(vcap->card, "I2C Polling Video", sizeof(vcap->card));
>> +
>> +     strlcpy(vcap->bus_info, "I2C:i2c-polling", sizeof(vcap->bus_info));
>
> The bus_info field should contain information to locate the device in the
> system. It correctly starts with I2C:, but should then be followed by the I2C
> bus number and the device address.
>
>> +     vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
>> +                         V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> +     vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
> You can set device_caps in the video_device structure instead, the code will
> fill vcap->device_caps and vcap->capabilities for you.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_g_input(struct file *file, void *fh, unsigned int
>> *inp)
>> +{
>> +     *inp = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_s_input(struct file *file, void *fh, unsigned int
>> inp)
>> +{
>> +     return (inp > 0) ? -EINVAL : 0;
>> +}
>> +
>> +static int i2c_polling_enum_input(struct file *file, void *fh,
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
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_enum_fmt_vid_cap(struct file *file, void *fh,
>> +                                     struct v4l2_fmtdesc *fmt)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
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
>> +static int i2c_polling_enum_framesizes(struct file *file, void *fh,
>> +                                    struct v4l2_frmsizeenum *fsize)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
>> +     struct v4l2_frmsize_discrete *size = data->chip->size;
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
>> +static int i2c_polling_enum_frameintervals(struct file *file, void *priv,
>> +                                        struct v4l2_frmivalenum *fe)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
>> +     struct v4l2_frmsize_discrete *size = data->chip->size;
>> +
>> +     if (fe->index > 0)
>> +             return -EINVAL;
>> +
>> +     if ((fe->width != size->width) || (fe->height != size->height))
>> +             return -EINVAL;
>
> No need for the extra inner parentheses.
>
>> +
>> +     fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>> +     fe->discrete.numerator = 1;
>> +     fe->discrete.denominator = data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_try_fmt_vid_cap(struct file *file, void *fh,
>> +                                    struct v4l2_format *fmt)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
>> +     struct v4l2_pix_format *pix = &fmt->fmt.pix;
>> +     struct v4l2_frmsize_discrete *size = data->chip->size;
>> +
>> +     pix->width = size->width;
>> +     pix->height = size->height;
>> +     pix->pixelformat = data->chip->format->pixelformat;
>> +     pix->field = V4L2_FIELD_NONE;
>> +     pix->bytesperline = pix->width * 2;
>> +     pix->sizeimage = pix->width * pix->height * 2;
>
> The bytesperline and sizeimage values depend on the format. If you make the
> format chip-specific, the computation should be generic as well.
>
> It's very hard at this time to know how much genericity should be expected
> from similar sensors. Unless you have more information about that, I would be
> tempted to make a device-specific driver for now, and then refactor it later
> to support more devices if the need arises (and if possible in a clean way).
>
>> +     pix->colorspace = V4L2_COLORSPACE_SRGB;
>> +     pix->priv = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_fmt_vid_cap(struct file *file, void *fh,
>> +                                  struct v4l2_format *fmt)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(file);
>> +     int ret = i2c_polling_try_fmt_vid_cap(file, fh, fmt);
>> +
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (vb2_is_busy(&data->vb_vidq))
>> +             return -EBUSY;
>
> A get format operation should be allowed even if the queue is busy, only set
> format should return -EBUSY.
>
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_g_parm(struct file *filp, void *priv,
>> +                           struct v4l2_streamparm *parm)
>> +{
>> +     struct i2c_polling_data *data = video_drvdata(filp);
>> +
>> +     if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +
>> +     parm->parm.capture.readbuffers = 3;
>> +     parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>> +     parm->parm.capture.timeperframe.numerator = 1;
>> +     parm->parm.capture.timeperframe.denominator = data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2c_polling_s_parm(struct file *filp, void *priv,
>> +                           struct v4l2_streamparm *parm)
>> +{
>> +     if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +
>> +     return i2c_polling_g_parm(filp, priv, parm);
>> +}
>> +
>> +static const struct v4l2_ioctl_ops i2c_polling_ioctl_ops = {
>> +     .vidioc_querycap                = i2c_polling_querycap,
>> +     .vidioc_g_input                 = i2c_polling_g_input,
>> +     .vidioc_s_input                 = i2c_polling_s_input,
>> +     .vidioc_enum_input              = i2c_polling_enum_input,
>> +     .vidioc_enum_fmt_vid_cap        = i2c_polling_enum_fmt_vid_cap,
>> +     .vidioc_enum_framesizes         = i2c_polling_enum_framesizes,
>> +     .vidioc_enum_frameintervals     = i2c_polling_enum_frameintervals,
>> +     .vidioc_g_fmt_vid_cap           = i2c_polling_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap           = i2c_polling_fmt_vid_cap,
>> +     .vidioc_g_parm                  = i2c_polling_g_parm,
>> +     .vidioc_s_parm                  = i2c_polling_s_parm,
>> +     .vidioc_try_fmt_vid_cap         = i2c_polling_try_fmt_vid_cap,
>> +     .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>> +     .vidioc_create_bufs             = vb2_ioctl_create_bufs,
>> +     .vidioc_prepare_buf             = vb2_ioctl_prepare_buf,
>> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
>> +     .vidioc_streamon                = vb2_ioctl_streamon,
>> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
>
> No need to set the buffer-related .vidioc_* pointers to vb2_ioctl_*
> explicitly, the core will use vb2 if the fields are left unset.
>
>> +     .vidioc_log_status              = v4l2_ctrl_log_status,
>> +     .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>> +     .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>> +};
>> +
>> +static int i2c_polling_probe(struct i2c_client *client,
>> +                          const struct i2c_device_id *id)
>> +{
>> +     struct i2c_polling_data *data;
>> +     struct v4l2_device *v4l2_dev;
>> +     struct vb2_queue *queue;
>> +     int ret;
>> +
>> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +
>> +     data->chip = &i2c_polling_chips[id->driver_data];
>> +     data->client = client;
>> +     data->last_update = jiffies;
>> +     v4l2_dev = &data->v4l2_dev;
>> +     strlcpy(v4l2_dev->name, I2C_POLLING_DRIVER, sizeof(v4l2_dev->name));
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
>> +     queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>
> Please also set one of V4L2_BUF_FLAG_TSTAMP_SRC_SOF or
> V4L2_BUF_FLAG_TSTAMP_SRC_EOF.
>
>> +     queue->drv_priv = data;
>> +     queue->ops = &i2c_polling_video_qops;
>> +     queue->mem_ops = &vb2_vmalloc_memops;
>> +
>> +     ret = vb2_queue_init(queue);
>> +     if (ret < 0)
>> +             goto error_free_device;
>> +
>> +     data->vdev.queue = queue;
>> +     data->vdev.queue->lock = &data->queue_lock;
>> +
>> +     strlcpy(data->vdev.name, "I2C Polling Video", sizeof(data-
>>vdev.name));
>> +
>> +     data->vdev.v4l2_dev = v4l2_dev;
>> +     data->vdev.fops = &i2c_polling_fops;
>> +     data->vdev.lock = &data->lock;
>> +     data->vdev.ioctl_ops = &i2c_polling_ioctl_ops;
>> +     data->vdev.release = video_device_release_empty;
>
> You should implement a release function and free the data structure there.
> Freeing data in the remove operation is a bad idea, as your driver will crash
> if the device is unbound from the driver during video streaming.
> Unregistration of the v4l2_device instance can also happen in the release
> callback. The video_device instance obviously has to be unregistered in the
> remove operation as done now.
>
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
>> +static int i2c_polling_remove(struct i2c_client *client)
>> +{
>> +     struct i2c_polling_data *data = i2c_get_clientdata(client);
>> +
>> +     v4l2_device_unregister(&data->v4l2_dev);
>> +     video_unregister_device(&data->vdev);
>> +     kfree(data);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct i2c_device_id i2c_polling_id_table[] = {
>> +     { "amg88xx", AMG88XX },
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, i2c_polling_id_table);
>> +
>> +static struct i2c_driver i2c_polling_driver = {
>> +     .driver = {
>> +             .name   = I2C_POLLING_DRIVER,
>> +     },
>> +     .probe          = i2c_polling_probe,
>> +     .remove         = i2c_polling_remove,
>> +     .id_table       = i2c_polling_id_table,
>> +};
>> +
>> +module_i2c_driver(i2c_polling_driver);
>> +
>> +MODULE_AUTHOR("Matt Ranostay <mranostay@ranostay.consulting>");
>> +MODULE_DESCRIPTION("I2C polling video support");
>> +MODULE_LICENSE("GPL");
>
> --
> Regards,
>
> Laurent Pinchart
>
