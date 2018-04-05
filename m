Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36202 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752639AbeDEThS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 15:37:18 -0400
Received: by mail-it0-f67.google.com with SMTP id 15-v6so5629177itl.1
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 12:37:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405073948.4ujeavrfegln6orf@valkosipuli.retiisi.org.uk>
References: <20180401005926.18203-1-matt.ranostay@konsulko.com>
 <20180401005926.18203-3-matt.ranostay@konsulko.com> <20180405073948.4ujeavrfegln6orf@valkosipuli.retiisi.org.uk>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Thu, 5 Apr 2018 12:37:17 -0700
Message-ID: <CAJCx=gny13AOXqOW7RC03DFBfZjGqkgLRjU_6He9M3_RUdoHnA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: video-i2c: add video-i2c driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 5, 2018 at 12:39 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Matt,
>
> Thanks for the patch. It's a very nicely written, small driver. :-)
>
> Please see more comments below.
>
> On Sat, Mar 31, 2018 at 05:59:26PM -0700, Matt Ranostay wrote:
>> There are several thermal sensors that only have a low-speed bus
>> interface but output valid video data. This patchset enables support
>> for the AMG88xx "Grid-Eye" sensor family.
>>
>> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
>
> Are there plans to implement support for more of these chips?
>

Nothing on my end. But there are other low resolution thermal cameras
that output i2c that could easily be added.

>> ---
>>  MAINTAINERS                   |   6 +
>>  drivers/media/i2c/Kconfig     |   9 +
>>  drivers/media/i2c/Makefile    |   1 +
>>  drivers/media/i2c/video-i2c.c | 562 +++++++++++++++++++++++++++++++++++=
+++++++
>>  4 files changed, 578 insertions(+)
>>  create mode 100644 drivers/media/i2c/video-i2c.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 49236216a871..f0262b751d5b 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14863,6 +14863,12 @@ L:   linux-media@vger.kernel.org
>>  S:   Maintained
>>  F:   drivers/media/platform/video-mux.c
>>
>> +VIDEO I2C POLLING DRIVER
>> +M:   Matt Ranostay <matt.ranostay@konsulko.com>
>> +L:   linux-media@vger.kernel.org
>> +S:   Maintained
>> +F:   drivers/media/i2c/video-i2c.c
>> +
>>  VIDEOBUF2 FRAMEWORK
>>  M:   Pawel Osciak <pawel@osciak.com>
>>  M:   Marek Szyprowski <m.szyprowski@samsung.com>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 541f0d28afd8..122e5047a01e 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -974,6 +974,15 @@ config VIDEO_M52790
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
>
> You could add the name of the module here if it's compiled as a module.
>

Ok

>>  endmenu
>>
>>  menu "Sensors used on soc_camera driver"
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index ea34aee1a85a..84cc472238ef 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -96,6 +96,7 @@ obj-$(CONFIG_VIDEO_LM3646)  +=3D lm3646.o
>>  obj-$(CONFIG_VIDEO_SMIAPP_PLL)       +=3D smiapp-pll.o
>>  obj-$(CONFIG_VIDEO_AK881X)           +=3D ak881x.o
>>  obj-$(CONFIG_VIDEO_IR_I2C)  +=3D ir-kbd-i2c.o
>> +obj-$(CONFIG_VIDEO_I2C)              +=3D video-i2c.o
>>  obj-$(CONFIG_VIDEO_ML86V7667)        +=3D ml86v7667.o
>>  obj-$(CONFIG_VIDEO_OV2659)   +=3D ov2659.o
>>  obj-$(CONFIG_VIDEO_TC358743) +=3D tc358743.o
>> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c=
.c
>> new file mode 100644
>> index 000000000000..9fba8a2767c5
>> --- /dev/null
>> +++ b/drivers/media/i2c/video-i2c.c
>> @@ -0,0 +1,562 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * video-i2c.c - Support for I2C transport video devices
>> + *
>> + * Copyright (C) 2018 Matt Ranostay <matt.ranostay@konsulko.com>
>> + *
>> + * Supported:
>> + * - Panasonic AMG88xx Grid-Eye Sensors
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/freezer.h>
>> +#include <linux/kthread.h>
>> +#include <linux/i2c.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/of_device.h>
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
>> +     unsigned int sequence;
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
>> +static struct v4l2_fmtdesc amg88xx_format =3D {
>> +     .pixelformat =3D V4L2_PIX_FMT_Y12,
>> +};
>> +
>> +static struct v4l2_frmsize_discrete amg88xx_size =3D {
>> +     .width =3D 8,
>> +     .height =3D 8,
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
>> +     struct i2c_client *client =3D data->client;
>> +     struct i2c_msg msg[2];
>> +     u8 reg =3D 0x80;
>> +     int ret;
>> +
>> +     msg[0].addr =3D client->addr;
>> +     msg[0].flags =3D 0;
>> +     msg[0].len =3D 1;
>> +     msg[0].buf  =3D (char *) &reg;
>> +
>> +     msg[1].addr =3D client->addr;
>> +     msg[1].flags =3D I2C_M_RD;
>> +     msg[1].len =3D data->chip->buffer_size;
>> +     msg[1].buf =3D (char *) buf;
>
> No space before "buf" (nor "&reg" above).
>

Ok. Personally I like a space between casting the pointer, but I don't
really care either way so will fix.

>> +
>> +     ret =3D i2c_transfer(client->adapter, msg, 2);
>> +
>> +     return (ret =3D=3D 2) ? 0 : -EIO;
>> +}
>> +
>> +#define AMG88XX              0
>> +
>> +static const struct video_i2c_chip video_i2c_chip[] =3D {
>> +     [AMG88XX] =3D {
>> +             .size           =3D &amg88xx_size,
>> +             .format         =3D &amg88xx_format,
>> +             .max_fps        =3D 10,
>> +             .buffer_size    =3D 128,
>> +             .bpp            =3D 16,
>> +             .xfer           =3D &amg88xx_xfer,
>> +     },
>> +};
>> +
>> +static const struct v4l2_file_operations video_i2c_fops =3D {
>> +     .owner          =3D THIS_MODULE,
>> +     .open           =3D v4l2_fh_open,
>> +     .release        =3D vb2_fop_release,
>> +     .poll           =3D vb2_fop_poll,
>> +     .read           =3D vb2_fop_read,
>> +     .mmap           =3D vb2_fop_mmap,
>> +     .unlocked_ioctl =3D video_ioctl2,
>> +};
>> +
>> +static int queue_setup(struct vb2_queue *vq,
>> +                    unsigned int *nbuffers, unsigned int *nplanes,
>> +                    unsigned int sizes[], struct device *alloc_devs[])
>> +{
>> +     struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
>> +     unsigned int size =3D data->chip->buffer_size;
>> +
>> +     if (vq->num_buffers + *nbuffers < 2)
>> +             *nbuffers =3D 2;
>> +
>> +     if (*nplanes)
>> +             return sizes[0] < size ? -EINVAL : 0;
>> +
>> +     *nplanes =3D 1;
>> +     sizes[0] =3D size;
>> +
>> +     return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
>> +     struct video_i2c_data *data =3D vb2_get_drv_priv(vb->vb2_queue);
>> +     unsigned int size =3D data->chip->buffer_size;
>> +
>> +     if (vb2_plane_size(vb, 0) < size)
>> +             return -EINVAL;
>> +
>> +     vbuf->field =3D V4L2_FIELD_NONE;
>> +     vb2_set_plane_payload(vb, 0, size);
>> +
>> +     return 0;
>> +}
>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
>> +     struct video_i2c_data *data =3D vb2_get_drv_priv(vb->vb2_queue);
>> +     struct video_i2c_buffer *buf =3D
>> +                     container_of(vbuf, struct video_i2c_buffer, vb);
>> +
>> +     spin_lock(&data->slock);
>> +     list_add_tail(&buf->list, &data->vid_cap_active);
>> +     spin_unlock(&data->slock);
>> +}
>> +
>> +static int video_i2c_thread_vid_cap(void *priv)
>> +{
>> +     struct video_i2c_data *data =3D priv;
>> +
>> +     set_freezable();
>> +
>> +     do {
>> +             unsigned long start_jiffies =3D jiffies;
>> +             unsigned int delay =3D msecs_to_jiffies(1000 / data->chip-=
>max_fps);
>> +             struct video_i2c_buffer *vid_cap_buf =3D NULL;
>> +             int schedule_delay;
>> +
>> +             try_to_freeze();
>> +
>> +             spin_lock(&data->slock);
>> +
>> +             if (!list_empty(&data->vid_cap_active)) {
>> +                     vid_cap_buf =3D list_entry(data->vid_cap_active.ne=
xt,
>> +                                              struct video_i2c_buffer, =
list);
>> +                     list_del(&vid_cap_buf->list);
>> +             }
>> +
>> +             spin_unlock(&data->slock);
>> +
>> +             if (vid_cap_buf) {
>> +                     struct vb2_buffer *vb2_buf =3D &vid_cap_buf->vb.vb=
2_buf;
>> +                     void *vbuf =3D vb2_plane_vaddr(vb2_buf, 0);
>> +                     int ret =3D data->chip->xfer(data, vbuf);
>> +
>> +                     vb2_buf->timestamp =3D ktime_get_ns();
>> +                     vid_cap_buf->vb.sequence =3D data->sequence++;
>> +                     vb2_buffer_done(vb2_buf, ret ?
>> +                                     VB2_BUF_STATE_ERROR : VB2_BUF_STAT=
E_DONE);
>> +             }
>> +
>> +             schedule_delay =3D delay - (jiffies - start_jiffies);
>> +
>> +             if (time_after(jiffies, start_jiffies + delay))
>> +                     schedule_delay =3D delay;
>> +
>> +             schedule_timeout_interruptible(schedule_delay);
>> +     } while (!kthread_should_stop());
>> +
>> +     return 0;
>> +}
>> +
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
>> +     struct video_i2c_buffer *buf, *tmp;
>> +
>> +     if (data->kthread_vid_cap)
>> +             return 0;
>> +
>> +     data->sequence =3D 0;
>> +     data->kthread_vid_cap =3D kthread_run(video_i2c_thread_vid_cap, da=
ta,
>> +                                         "%s-vid-cap", data->v4l2_dev.n=
ame);
>> +     if (!IS_ERR(data->kthread_vid_cap))
>> +             return 0;
>> +
>> +     spin_lock(&data->slock);
>> +
>> +     list_for_each_entry_safe(buf, tmp, &data->vid_cap_active, list) {
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb.vb2_buf,
>> +                             VB2_BUF_STATE_QUEUED);
>
> What's the purpose of this?
>
>> +     }
>> +
>> +     spin_unlock(&data->slock);
>> +
>> +     return PTR_ERR(data->kthread_vid_cap);
>
> How about 0 instead?
>
>> +}
>> +
>> +static void stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
>> +
>> +     if (data->kthread_vid_cap =3D=3D NULL)
>> +             return;
>> +
>> +     kthread_stop(data->kthread_vid_cap);
>> +
>> +     spin_lock(&data->slock);
>> +
>> +     while (!list_empty(&data->vid_cap_active)) {
>> +             struct video_i2c_buffer *buf;
>> +
>> +             buf =3D list_entry(data->vid_cap_active.next,
>
> list_last_entry(&data->vid_cap_active, ...)?
>

Yeah that is probably cleaner than touching the next point directly.

>> +                              struct video_i2c_buffer, list);
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +     }
>> +     spin_unlock(&data->slock);
>> +
>> +     data->kthread_vid_cap =3D NULL;
>
> How about moving the assignment right after kthread_stop()? The pointer i=
s
> no longer valid after that anyway.

Ok makes sense.

>
>> +}
>> +
>> +static struct vb2_ops video_i2c_video_qops =3D {
>> +     .queue_setup            =3D queue_setup,
>> +     .buf_prepare            =3D buffer_prepare,
>> +     .buf_queue              =3D buffer_queue,
>> +     .start_streaming        =3D start_streaming,
>> +     .stop_streaming         =3D stop_streaming,
>> +     .wait_prepare           =3D vb2_ops_wait_prepare,
>> +     .wait_finish            =3D vb2_ops_wait_finish,
>> +};
>> +
>> +static int video_i2c_querycap(struct file *file, void  *priv,
>> +                             struct v4l2_capability *vcap)
>> +{
>> +     struct video_i2c_data *data =3D video_drvdata(file);
>> +     struct i2c_client *client =3D data->client;
>> +
>> +     strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
>> +     sprintf(vcap->card, "I2C %d-%d Transport Video",
>> +                                          client->adapter->nr, client->=
addr);
>
> I wonder if the chip name would be nice here. Up to you.
>
>> +
>> +     sprintf(vcap->bus_info, "I2C:%d-%d", client->adapter->nr, client->=
addr);
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_g_input(struct file *file, void *fh, unsigned int =
*inp)
>> +{
>> +     *inp =3D 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_s_input(struct file *file, void *fh, unsigned int =
inp)
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
>> +     vin->type =3D V4L2_INPUT_TYPE_CAMERA;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_fmt_vid_cap(struct file *file, void *fh,
>> +                                     struct v4l2_fmtdesc *fmt)
>> +{
>> +     struct video_i2c_data *data =3D video_drvdata(file);
>> +     enum v4l2_buf_type type =3D fmt->type;
>> +
>> +     if (fmt->index > 0)
>> +             return -EINVAL;
>> +
>> +     *fmt =3D *data->chip->format;
>> +     fmt->type =3D type;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_framesizes(struct file *file, void *fh,
>> +                                    struct v4l2_frmsizeenum *fsize)
>> +{
>> +     const struct video_i2c_data *data =3D video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size =3D data->chip->size;
>> +
>> +     /* currently only one frame size is allowed */
>> +     if (fsize->index > 0)
>> +             return -EINVAL;
>> +
>> +     if (fsize->pixel_format !=3D data->chip->format->pixelformat)
>> +             return -EINVAL;
>> +
>> +     fsize->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
>> +     fsize->discrete.width =3D size->width;
>> +     fsize->discrete.height =3D size->height;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_enum_frameintervals(struct file *file, void *priv,
>> +                                        struct v4l2_frmivalenum *fe)
>> +{
>> +     const struct video_i2c_data *data =3D video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size =3D data->chip->size;
>> +
>> +     if (fe->index > 0)
>> +             return -EINVAL;
>> +
>> +     if (fe->width !=3D size->width || fe->height !=3D size->height)
>> +             return -EINVAL;
>> +
>> +     fe->type =3D V4L2_FRMIVAL_TYPE_DISCRETE;
>> +     fe->discrete.numerator =3D 1;
>> +     fe->discrete.denominator =3D data->chip->max_fps;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_try_fmt_vid_cap(struct file *file, void *fh,
>> +                                    struct v4l2_format *fmt)
>> +{
>> +     const struct video_i2c_data *data =3D video_drvdata(file);
>> +     const struct v4l2_frmsize_discrete *size =3D data->chip->size;
>> +     struct v4l2_pix_format *pix =3D &fmt->fmt.pix;
>> +     unsigned int bpp =3D data->chip->bpp / 8;
>> +
>> +     pix->width =3D size->width;
>> +     pix->height =3D size->height;
>> +     pix->pixelformat =3D data->chip->format->pixelformat;
>> +     pix->field =3D V4L2_FIELD_NONE;
>> +     pix->bytesperline =3D pix->width * bpp;
>> +     pix->sizeimage =3D pix->bytesperline * pix->height;
>> +     pix->colorspace =3D V4L2_COLORSPACE_RAW;
>> +
>> +     return 0;
>> +}
>> +
>> +static int video_i2c_s_fmt_vid_cap(struct file *file, void *fh,
>> +                                  struct v4l2_format *fmt)
>> +{
>> +     struct video_i2c_data *data =3D video_drvdata(file);
>> +
>> +     if (vb2_is_busy(&data->vb_vidq))
>> +             return -EBUSY;
>> +
>> +     return video_i2c_try_fmt_vid_cap(file, fh, fmt);
>> +}
>> +
>> +static int video_i2c_g_parm(struct file *filp, void *priv,
>> +                           struct v4l2_streamparm *parm)
>> +{
>> +     struct video_i2c_data *data =3D video_drvdata(filp);
>> +
>> +     if (parm->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +
>> +     parm->parm.capture.readbuffers =3D 1;
>> +     parm->parm.capture.capability =3D V4L2_CAP_TIMEPERFRAME;
>> +     parm->parm.capture.timeperframe.numerator =3D 1;
>> +     parm->parm.capture.timeperframe.denominator =3D data->chip->max_fp=
s;
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops video_i2c_ioctl_ops =3D {
>> +     .vidioc_querycap                =3D video_i2c_querycap,
>> +     .vidioc_g_input                 =3D video_i2c_g_input,
>> +     .vidioc_s_input                 =3D video_i2c_s_input,
>> +     .vidioc_enum_input              =3D video_i2c_enum_input,
>> +     .vidioc_enum_fmt_vid_cap        =3D video_i2c_enum_fmt_vid_cap,
>> +     .vidioc_enum_framesizes         =3D video_i2c_enum_framesizes,
>> +     .vidioc_enum_frameintervals     =3D video_i2c_enum_frameintervals,
>> +     .vidioc_g_fmt_vid_cap           =3D video_i2c_try_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap           =3D video_i2c_s_fmt_vid_cap,
>> +     .vidioc_g_parm                  =3D video_i2c_g_parm,
>> +     .vidioc_s_parm                  =3D video_i2c_g_parm,
>> +     .vidioc_try_fmt_vid_cap         =3D video_i2c_try_fmt_vid_cap,
>> +     .vidioc_reqbufs                 =3D vb2_ioctl_reqbufs,
>> +     .vidioc_create_bufs             =3D vb2_ioctl_create_bufs,
>> +     .vidioc_prepare_buf             =3D vb2_ioctl_prepare_buf,
>> +     .vidioc_querybuf                =3D vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    =3D vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   =3D vb2_ioctl_dqbuf,
>> +     .vidioc_streamon                =3D vb2_ioctl_streamon,
>> +     .vidioc_streamoff               =3D vb2_ioctl_streamoff,
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
>> +     int chip_id, ret;
>> +
>> +     data =3D kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +
>> +     if (client->dev.of_node)
>> +             chip_id =3D (long) of_device_get_match_data(&client->dev);
>
> We now have device_get_match_data(). Please use that instead. It's also
> safe for NULL:

Ah another API change that is new to me :)
>
> chip_id =3D device_get_match_data(&client->dev);
> if (!chip_id)
>         chip_id =3D id->driver_data;
>
> I wonder if it'd be actually cleaner (and easier to maintain) if you used
> pointer to the chip specific struct here instead of giving the chips
> special IDs. You could omit the chip IDs altogether.
>
>> +     else
>> +             chip_id =3D id->driver_data;
>
> Do you need to support the non-OF case? If not, you could switch to
> .probe_new callback and omit the I=E6=B6=8E ID table.
>

Actually one way I use the device is instantiating with the i2c sysfs
new_device functionality

>> +
>> +     data->chip =3D &video_i2c_chip[chip_id];
>> +     data->client =3D client;
>> +     v4l2_dev =3D &data->v4l2_dev;
>> +     strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
>> +
>> +     ret =3D v4l2_device_register(&client->dev, v4l2_dev);
>> +     if (ret < 0)
>> +             goto error_free_device;
>> +
>> +     mutex_init(&data->lock);
>> +     mutex_init(&data->queue_lock);
>> +
>> +     queue =3D &data->vb_vidq;
>> +     queue->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     queue->io_modes =3D VB2_DMABUF | VB2_MMAP | VB2_USERPTR | VB2_READ=
;
>> +     queue->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +     queue->drv_priv =3D data;
>> +     queue->buf_struct_size =3D sizeof(struct video_i2c_buffer);
>> +     queue->min_buffers_needed =3D 1;
>> +     queue->ops =3D &video_i2c_video_qops;
>> +     queue->mem_ops =3D &vb2_vmalloc_memops;
>> +
>> +     ret =3D vb2_queue_init(queue);
>> +     if (ret < 0)
>> +             goto error_unregister_device;
>> +
>> +     data->vdev.queue =3D queue;
>> +     data->vdev.queue->lock =3D &data->queue_lock;
>> +
>> +     snprintf(data->vdev.name, sizeof(data->vdev.name),
>> +                              "I2C %d-%d Transport Video",
>> +                              client->adapter->nr, client->addr);
>
> You could use this string in querycap implementation as it's the same.
>
>> +
>> +     data->vdev.v4l2_dev =3D v4l2_dev;
>> +     data->vdev.fops =3D &video_i2c_fops;
>> +     data->vdev.lock =3D &data->lock;
>> +     data->vdev.ioctl_ops =3D &video_i2c_ioctl_ops;
>> +     data->vdev.release =3D video_i2c_release;
>> +     data->vdev.device_caps =3D V4L2_CAP_VIDEO_CAPTURE |
>> +                              V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> +
>> +     spin_lock_init(&data->slock);
>> +     INIT_LIST_HEAD(&data->vid_cap_active);
>> +
>> +     video_set_drvdata(&data->vdev, data);
>> +     i2c_set_clientdata(client, data);
>> +
>> +     ret =3D video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
>> +     if (ret < 0)
>> +             goto error_unregister_device;
>> +
>> +     return 0;
>> +
>> +error_unregister_device:
>> +     v4l2_device_unregister(v4l2_dev);
>
> mutex_destroy() for both mutexes. Same in remove below.
>
>> +
>> +error_free_device:
>> +     kfree(data);
>> +
>> +     return ret;
>> +}
>> +
>> +static int video_i2c_remove(struct i2c_client *client)
>> +{
>> +     struct video_i2c_data *data =3D i2c_get_clientdata(client);
>> +
>> +     video_unregister_device(&data->vdev);
>> +     v4l2_device_unregister(&data->v4l2_dev);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct i2c_device_id video_i2c_id_table[] =3D {
>> +     { "amg88xx", AMG88XX },
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, video_i2c_id_table);
>> +
>> +static const struct of_device_id video_i2c_of_match[] =3D {
>> +     { .compatible =3D "panasonic,amg88xx", .data =3D (void *) AMG88XX =
},
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(of, video_i2c_of_match);
>> +
>> +static struct i2c_driver video_i2c_driver =3D {
>> +     .driver =3D {
>> +             .name   =3D VIDEO_I2C_DRIVER,
>> +             .of_match_table =3D of_match_ptr(video_i2c_of_match),
>
> No need to use of_match_ptr macro, a direct assignment will do.
>
>> +     },
>> +     .probe          =3D video_i2c_probe,
>> +     .remove         =3D video_i2c_remove,
>> +     .id_table       =3D video_i2c_id_table,
>> +};
>> +
>> +module_i2c_driver(video_i2c_driver);
>> +
>> +MODULE_AUTHOR("Matt Ranostay <matt.ranostay@konsulko.com>");
>> +MODULE_DESCRIPTION("I2C transport video support");
>> +MODULE_LICENSE("GPL");
>
> "GPL v2"? Or adjust the SPDX header accordingly.

Will adjust this to GPL v2
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
