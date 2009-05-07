Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34243 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZEGSxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 14:53:55 -0400
Received: by fxm2 with SMTP id 2so975636fxm.37
        for <linux-media@vger.kernel.org>; Thu, 07 May 2009 11:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090507202831.81bb324b.ospite@studenti.unina.it>
References: <200903262049.10425.vasily@scopicsoftware.com>
	 <200904270422.59186.vasily@scopicsoftware.com>
	 <200905070254.00939.vasily@scopicsoftware.com>
	 <20090507202831.81bb324b.ospite@studenti.unina.it>
Date: Thu, 7 May 2009 21:53:53 +0300
Message-ID: <36c518800905071153h1a972970v5cb12ab0c9a3e9b@mail.gmail.com>
Subject: Re: [REVIEW] v4l2 loopback
From: vasaka@gmail.com
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Vasily <vasily@scopicsoftware.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 7, 2009 at 9:28 PM, Antonio Ospite <ospite@studenti.unina.it> wrote:
> On Thu, 7 May 2009 02:54:00 +0300
> Vasily <vasaka@gmail.com> wrote:
>
>> This patch introduces v4l2 loopback module
>>
>
> Hi Vasily, next time it would be useful to summarize what you changed
> from the previous version, and  put a revision number in the Subject,
> like [PATCH v2] [PATCH v3], etc.
ok
>
> Also, the patch has some style problems reported by checkpatch.pl,
> please fix those. Even if the driver wouldn't go mainline you do want to
> follow the style guidelines.
I have checked it with make commit in v4l-dvb tree, and it did not complain,
I'll look into that.
>
> And some more typos I spotted, see inlined comments.
> I am not a native English speaker either, so I learned to use spell
> checkers even in source code comments :)
>
> Anyhow, finally I tested the driver, and I have only a question as a
> user: couldn't it be possible to make a default input enabled by
> default? This way, if a writer knows the format to use it doesn't have
> to setup the device format on its own, and can treat the device as a
> normal file.

I think it is a good improvement, but what format should be default?
and even if I'll do so user will have to make syscalls to change format.

Also please exclude scopic addres from recipients when you answering
this message,
I added this addres by mistake

Thanks,
  Vasily
>
> Thanks,
>   Antonio
>
>> From: Vasily Levin <vasaka@gmail.com>
>>
>> This is v4l2 loopback driver which can be used to make available any userspace
>> video as v4l2 device. Initialy it was written to make videoeffects available
>
> Typo: Initialy -> Initially
>
>> to Skype, but in fact it have many more uses.
>>
>> Priority: normal
>>
>> Signed-off-by: Vasily Levin <vasaka@gmail.com>
>>
>> diff -uprN v4l-dvb.orig/linux/drivers/media/video/Kconfig v4l-dvb.my/linux/drivers/media/video/Kconfig
>> --- v4l-dvb.orig/linux/drivers/media/video/Kconfig    2009-04-25 04:41:20.000000000 +0300
>> +++ v4l-dvb.my/linux/drivers/media/video/Kconfig      2009-05-07 01:49:38.000000000 +0300
>> @@ -479,6 +479,17 @@ config VIDEO_VIVI
>>         Say Y here if you want to test video apps or debug V4L devices.
>>         In doubt, say N.
>>
>> +config VIDEO_V4L2_LOOPBACK
>> +     tristate "v4l2 loopback driver"
>> +     depends on VIDEO_V4L2 && VIDEO_DEV
>> +     help
>> +       Say Y if you want to use v4l2 loopback driver.
>> +       Looback driver allows it's user to present any userspace
>
> typo: it's -> its
>
>> +       video as a v4l2 device that can be handy for tesring purpose,
>
> typo: tesring -> testing
>
>> +       or for fixing bugs like upside down image, or for adding
>> +       nice effects to videochats
>> +       This driver can be compiled as a module, called v4l2loopback.
>> +
>>  source "drivers/media/video/bt8xx/Kconfig"
>>
>>  config VIDEO_PMS
>> diff -uprN v4l-dvb.orig/linux/drivers/media/video/Makefile v4l-dvb.my/linux/drivers/media/video/Makefile
>> --- v4l-dvb.orig/linux/drivers/media/video/Makefile   2009-05-07 01:31:32.000000000 +0300
>> +++ v4l-dvb.my/linux/drivers/media/video/Makefile     2009-05-07 01:50:11.000000000 +0300
>> @@ -132,6 +132,7 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv/
>>  obj-$(CONFIG_VIDEO_CX18) += cx18/
>>
>>  obj-$(CONFIG_VIDEO_VIVI) += vivi.o
>> +obj-$(CONFIG_VIDEO_V4L2_LOOPBACK) += v4l2loopback.o
>>  obj-$(CONFIG_VIDEO_CX23885) += cx23885/
>>
>>  obj-$(CONFIG_VIDEO_OMAP2)            += omap2cam.o
>> diff -uprN v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.c v4l-dvb.my/linux/drivers/media/video/v4l2loopback.c
>> --- v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.c     1970-01-01 03:00:00.000000000 +0300
>> +++ v4l-dvb.my/linux/drivers/media/video/v4l2loopback.c       2009-05-07 02:30:08.000000000 +0300
>> @@ -0,0 +1,775 @@
>> +/*
>> + * v4l2loopback.c  --  video 4 linux loopback driver
>> + *
>> + * Copyright (C) 2005-2009
>> + * Vasily Levin (vasaka@gmail.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + */
>> +#include <linux/version.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/mm.h>
>> +#include <linux/time.h>
>> +#include <linux/module.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <linux/videodev2.h>
>> +#include <media/v4l2-common.h>
>> +
>
> Usually the includes with the same prefix come all near one another,
> you could move #include <linux/videodev2.h> one line up.
>
>> +#define YAVLD_STREAMING
>> +
>> +MODULE_DESCRIPTION("V4L2 loopback video device");
>> +MODULE_VERSION("0.1.1");
>> +MODULE_AUTHOR("Vasily Levin");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* module structures */
>> +/* TODO(vasaka) use typenames which are common to kernel, but first find out if
>> + * it is needed */
>> +/* struct keeping state and settings of loopback device */
>> +struct v4l2_loopback_device {
>> +     struct video_device *vdev;
>> +     /* pixel and stream format */
>> +     struct v4l2_pix_format pix_format;
>> +     struct v4l2_captureparm capture_param;
>> +     /* buffers stuff */
>> +     u8 *image;         /* pointer to actual buffers data */
>> +     int buffers_number;  /* should not be big, 4 is a good choice */
>> +     struct v4l2_buffer *buffers;    /* inner driver buffers */
>> +     int write_position; /* number of last written frame + 1 */
>> +     long buffer_size;
>> +     /* sync stuff */
>> +     atomic_t open_count;
>> +     int ready_for_capture;/* set to true when at least one writer opened
>> +                           * device and negotiated format */
>> +     wait_queue_head_t read_event;
>> +};
>> +
>> +/* types of opener shows what opener wants to do with loopback */
>> +enum opener_type {
>> +     UNNEGOTIATED = 0,
>> +     READER = 1,
>> +     WRITER = 2,
>> +};
>> +
>> +/* struct keeping state and type of opener */
>> +struct v4l2_loopback_opener {
>> +     enum opener_type type;
>> +     int buffers_number;
>> +     int position; /* number of last processed frame + 1 or
>> +                    * write_position - 1 if reader went out of sync */
>> +     struct v4l2_buffer *buffers;
>> +};
>> +
>> +/* module parameters */
>> +static int debug = 0;
>> +module_param(debug, int, 0);
>> +MODULE_PARM_DESC(debug,"if debug output is enabled, values are 0, 1 or 2");
>> +
>> +static int max_buffers_number = 4;
>> +module_param(max_buffers_number, int, 0);
>> +MODULE_PARM_DESC(max_buffers_number,"how many buffers should be allocated");
>> +
>> +static int max_openers = 10;
>> +module_param(max_openers, int, 0);
>> +MODULE_PARM_DESC(max_openers,"how many users can open loopback device");
>> +
>> +/* module constants */
>> +#define MAX_MMAP_BUFFERS 100 /* max buffers that can be mmaped, actuale they
>
> typo in comment: mmaped -> mapped (or mmapped?); actuale -> actually?
>
>> +                             * are all mapped to max_buffers_number buffers*/
>> +
>> +#define dprintk(fmt, args...)\
>> +     if (debug) {\
>> +             printk(KERN_INFO "v4l2-loopback: " fmt, ##args);\
>> +     }
>> +
>> +
>> +#define dprintkrw(fmt, args...)\
>> +     if (debug > 1) {\
>> +             printk(KERN_INFO "v4l2-loopback: " fmt, ##args);\
>> +     }
>> +
>> +/* global module data */
>> +struct v4l2_loopback_device *dev;
>> +/* forward declarations */
>> +static void init_buffers(int buffer_size);
>> +static int allocate_buffers(void);
>> +static const struct v4l2_file_operations v4l2_loopback_fops;
>> +static const struct v4l2_ioctl_ops v4l2_loopback_ioctl_ops;
>> +/* Queue helpers */
>> +/* next functions sets buffer flags and adjusts counters accordingly */
>> +static inline void set_done(struct v4l2_buffer *buffer)
>> +{
>> +     buffer->flags &= ~V4L2_BUF_FLAG_QUEUED;
>> +     buffer->flags |= V4L2_BUF_FLAG_DONE;
>> +}
>> +
>> +static inline void set_queued(struct v4l2_buffer *buffer)
>> +{
>> +     buffer->flags &= ~V4L2_BUF_FLAG_DONE;
>> +     buffer->flags |= V4L2_BUF_FLAG_QUEUED;
>> +}
>> +
>> +static inline void unset_all(struct v4l2_buffer *buffer)
>> +{
>> +     buffer->flags &= ~V4L2_BUF_FLAG_QUEUED;
>> +     buffer->flags &= ~V4L2_BUF_FLAG_DONE;
>> +}
>
> rename uset_all() to unset_flags()? And maybe this could become:
> buffer->flags &= ~(V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE);
> but it isn't very important.
>
>> +/* V4L2 ioctl caps and params calls */
>> +/* returns device capabilities, called on VIDIOC_QUERYCAP ioctl*/
>> +static int vidioc_querycap(struct file *file,
>> +                        void *priv, struct v4l2_capability *cap)
>> +{
>> +     strlcpy(cap->driver, "v4l2 loopback", sizeof(cap->driver));
>> +     strlcpy(cap->card, "Dummy video device", sizeof(cap->card));
>> +     cap->version = 1;
>> +     cap->capabilities =
>> +         V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
>> +         V4L2_CAP_READWRITE
>> +#ifdef YAVLD_STREAMING
>> +         | V4L2_CAP_STREAMING
>> +#endif
>> +         ;
>> +     return 0;
>> +}
>> +
>> +/* returns device formats, called on VIDIOC_ENUM_FMT ioctl*/
>> +static int vidioc_enum_fmt_cap(struct file *file, void *fh,
>> +                            struct v4l2_fmtdesc *f)
>> +{
>> +     if (dev->ready_for_capture == 0)
>> +             return -EINVAL;
>> +     if (f->index)
>> +             return -EINVAL;
>> +     strlcpy(f->description, "current format", sizeof(f->description));
>> +     f->pixelformat = dev->pix_format.pixelformat;
>> +     return 0;
>> +};
>> +
>> +/* returns current video format format fmt, called on VIDIOC_G_FMT ioctl */
>> +static int vidioc_g_fmt_cap(struct file *file,
>> +                         void *priv, struct v4l2_format *fmt)
>> +{
>> +     if (dev->ready_for_capture == 0)
>> +             return -EINVAL;
>> +     fmt->fmt.pix = dev->pix_format;
>> +     return 0;
>> +}
>> +
>> +/* checks if it is OK to change to format fmt, called on VIDIOC_TRY_FMT ioctl
>> + * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_CAPTURE
>> + * actual check is done by inner_try_fmt_cap
>> + * just checking that pixelformat is OK and set other parameters, app should
>> + * obey this decision */
>> +static int vidioc_try_fmt_cap(struct file *file,
>> +                           void *priv, struct v4l2_format *fmt)
>> +{
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +
>> +     opener->type = READER;
>> +     if (dev->ready_for_capture == 0)
>> +             return -EINVAL;
>> +     if (fmt->fmt.pix.pixelformat != dev->pix_format.pixelformat)
>> +             return -EINVAL;
>> +     fmt->fmt.pix = dev->pix_format;
>> +     return 0;
>> +}
>> +
>> +/* checks if it is OK to change to format fmt, called on VIDIOC_TRY_FMT ioctl
>> + * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_OUTPUT
>> + * if format is negotiated do not change it */
>> +static int vidioc_try_fmt_video_output(struct file *file,
>> +                                    void *priv, struct v4l2_format *fmt)
>> +{
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +
>> +     opener->type = WRITER;
>> +     /* TODO(vasaka) loopback does not care about formats writer want to set,
>> +      * maybe it is a good idea to restrict format somehow */
>> +     if (dev->ready_for_capture) {
>> +             fmt->fmt.pix = dev->pix_format;
>> +     } else {
>> +             if (fmt->fmt.pix.sizeimage == 0)
>> +                     return -1;
>> +             dev->pix_format = fmt->fmt.pix;
>> +     }
>> +     return 0;
>> +};
>> +
>> +/* sets new output format, if possible, called on VIDIOC_S_FMT ioctl
>> + * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_CAPTURE
>> + * actually format is set  by input and we even do not check it, just return
>> + * current one, but it is possible to set subregions of input TODO(vasaka) */
>> +static int vidioc_s_fmt_cap(struct file *file,
>> +                         void *priv, struct v4l2_format *fmt)
>> +{
>> +     return vidioc_try_fmt_cap(file, priv, fmt);
>> +}
>> +
>> +/* sets new output format, if possible, called on VIDIOC_S_FMT ioctl
>> + * with v4l2_buf_type set to V4L2_BUF_TYPE_VIDEO_OUTPUT
>> + * allocate data here because we do not know if it will be streaming or
>> + * read/write IO */
>> +static int vidioc_s_fmt_video_output(struct file *file,
>> +                                  void *priv, struct v4l2_format *fmt)
>> +{
>> +     int ret = vidioc_try_fmt_video_output(file, priv, fmt);
>> +
>> +     if (ret < 0)
>> +             return ret;
>> +     if (dev->ready_for_capture == 0) {
>> +             dev->buffer_size = PAGE_ALIGN(dev->pix_format.sizeimage);
>> +             fmt->fmt.pix.sizeimage = dev->buffer_size;
>> +     }
>> +     return ret;
>> +}
>> +
>> +/* get some data flaw parameters, only capability, fps and readbuffers has effect
>> + * on this driver, called on VIDIOC_G_PARM*/
>> +static int vidioc_g_parm(struct file *file, void *priv,
>> +                      struct v4l2_streamparm *parm)
>> +{
>> +     /* do not care about type of opener, hope this enums would always be
>> +      * compatible */
>> +     parm->parm.capture = dev->capture_param;
>> +     return 0;
>> +}
>> +
>> +/* get some data flaw parameters, only capability, fps and readbuffers has effect
>> + * on this driver, called on VIDIOC_S_PARM */
>> +static int vidioc_s_parm(struct file *file, void *priv,
>> +                      struct v4l2_streamparm *parm)
>> +{
>> +     dprintk("vidioc_s_parm called frate=%d/%d\n",
>> +            parm->parm.capture.timeperframe.numerator,
>> +            parm->parm.capture.timeperframe.denominator);
>> +     switch (parm->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             parm->parm.capture = dev->capture_param;
>> +             return 0;
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             /* TODO(vasaka) do nothing now, but should set fps if
>> +              * needed */
>> +             parm->parm.capture = dev->capture_param;
>> +             return 0;
>> +     default:
>> +             return -1;
>> +     }
>> +}
>> +
>> +/* sets a tv standard, actually we do not need to handle this any special way
>> + * added to support effecttv, can not be inline as I need pointer to it */
>> +static int vidioc_s_std(struct file *file, void *private_data,
>> +                     v4l2_std_id *norm)
>> +{
>> +     return 0;
>> +}
>> +
>> +/* returns set of device inputs, in our case there is only one, but later I may
>> + * add more, called on VIDIOC_ENUMINPUT */
>> +static int vidioc_enum_input(struct file *file, void *fh,
>> +                          struct v4l2_input *inp)
>> +{
>> +     if (dev->ready_for_capture == 0)
>> +             return -EINVAL;
>> +     if (inp->index == 0) {
>> +             strlcpy(inp->name, "loopback", sizeof(inp->name));
>> +             inp->type = V4L2_INPUT_TYPE_CAMERA;
>> +             inp->audioset = 0;
>> +             inp->tuner = 0;
>> +             inp->std = V4L2_STD_ALL;
>> +             inp->status = 0;
>> +             return 0;
>> +     }
>> +     return -EINVAL;
>> +}
>> +
>> +/* which input is currently active, called on VIDIOC_G_INPUT */
>> +int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
>> +{
>> +     *i = 0;
>> +     return 0;
>> +}
>> +
>> +/* set input, can make sense if we have more than one video src,
>> + * called on VIDIOC_S_INPUT */
>> +int vidioc_s_input(struct file *file, void *fh, unsigned int i)
>> +{
>> +     if (i == 0)
>> +             return 0;
>> +     return -EINVAL;
>> +}
>> +
>> +/* V4L2 ioctl buffer related calls */
>> +/* negotiate buffer type, called on VIDIOC_REQBUFS
>> + * only mmap streaming supported */
>> +static int vidioc_reqbufs(struct file *file, void *fh,
>> +                       struct v4l2_requestbuffers *b)
>> +{
>> +     switch (b->memory) {
>> +     case V4L2_MEMORY_MMAP:
>> +             /* do nothing here, buffers are always allocated*/
>> +             if (b->count == 0)
>> +                     return 0;
>> +             b->count = dev->buffers_number;
>> +             return 0;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +}
>> +
>> +/* returns buffer asked for, called on VIDIOC_QUERYBUF
>> +   give app as many buffers as it wants, if it less than MAX,
>> +   but map them in our inner buffers */
>> +static int vidioc_querybuf(struct file *file, void *fh,
>> +                        struct v4l2_buffer *b)
>> +{
>> +     enum v4l2_buf_type type = b->type;
>> +     int index = b->index;
>> +
>> +     if ((b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +         (b->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)) {
>> +             return -EINVAL;
>> +     }
>> +     if (b->index > MAX_MMAP_BUFFERS)
>> +             return -EINVAL;
>> +     *b = dev->buffers[b->index % dev->buffers_number];
>> +     b->type = type;
>> +     b->index = index;
>> +     return 0;
>> +}
>> +
>> +/* put buffer to queue, called on VIDIOC_QBUF */
>> +static int vidioc_qbuf(struct file *file, void *private_data,
>> +                    struct v4l2_buffer *buf)
>> +{
>> +     int index = buf->index % dev->buffers_number;
>> +
>> +     if (buf->index > MAX_MMAP_BUFFERS)
>> +             return -EINVAL;
>> +     switch (buf->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             set_queued(&dev->buffers[index]);
>> +             return 0;
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             do_gettimeofday(&dev->buffers[index].timestamp);
>> +             set_done(&dev->buffers[index]);
>> +             wake_up_all(&dev->read_event);
>> +             return 0;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +}
>> +
>> +/* put buffer to dequeue, called on VIDIOC_DQBUF */
>> +static int vidioc_dqbuf(struct file *file, void *private_data,
>> +                     struct v4l2_buffer *buf)
>> +{
>> +     int index;
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +
>> +     switch (buf->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             if ((dev->write_position <= opener->position) &&
>> +                     (file->f_flags&O_NONBLOCK))
>> +                     return -EAGAIN;
>> +             wait_event_interruptible(dev->read_event, (dev->write_position >
>> +                                      opener->position));
>> +             if (dev->write_position > opener->position+2)
>> +                     opener->position = dev->write_position - 1;
>> +             index = opener->position % dev->buffers_number;
>> +             if (!(dev->buffers[index].flags&V4L2_BUF_FLAG_MAPPED)) {
>> +                     printk(KERN_INFO "v4l2-loopback: "
>> +                            "trying to g\return not mapped buf\n");
>
> typo: g\return ?
>
>> +                     return -EINVAL;
>> +             }
>> +             ++opener->position;
>> +             unset_all(&dev->buffers[index]);
>> +             *buf = dev->buffers[index];
>> +             return 0;
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             index = dev->write_position % dev->buffers_number;
>> +             unset_all(&dev->buffers[index]);
>> +             *buf = dev->buffers[index];
>> +             ++dev->write_position;
>> +             return 0;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +}
>> +
>> +static int vidioc_streamon(struct file *file, void *private_data,
>> +                        enum v4l2_buf_type type)
>> +{
>> +     int ret;
>> +     switch (type) {
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             if (dev->ready_for_capture == 0) {
>> +                     ret = allocate_buffers();
>> +                     if (ret < 0)
>> +                             return ret;
>> +                     init_buffers(dev->buffer_size);
>> +                     dev->ready_for_capture = 1;
>> +             }
>> +             return 0;
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             if (dev->ready_for_capture == 0)
>> +                     return -EIO;
>> +             return 0;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +}
>> +
>> +static int vidioc_streamoff(struct file *file, void *private_data,
>> +                         enum v4l2_buf_type type)
>> +{
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
>> +int vidiocgmbuf(struct file *file, void *fh, struct video_mbuf *p)
>> +{
>> +     p->frames = dev->buffers_number;
>> +     p->offsets[0] = 0;
>> +     p->offsets[1] = 0;
>> +     p->size = dev->buffer_size;
>> +     return 0;
>> +}
>> +#endif
>> +/* file operations */
>> +static void vm_open(struct vm_area_struct *vma)
>> +{
>> +     /* TODO(vasaka) do open counter here */
>> +}
>> +
>> +static void vm_close(struct vm_area_struct *vma)
>> +{
>> +     /* TODO(vasaka) do open counter here */
>> +}
>> +
>> +static struct vm_operations_struct vm_ops = {
>> +     .open = vm_open,
>> +     .close = vm_close,
>> +};
>> +
>> +static int v4l2_loopback_mmap(struct file *file,
>> +                           struct vm_area_struct *vma)
>> +{
>> +
>> +     struct page *page = NULL;
>> +     unsigned long addr;
>> +     unsigned long start = (unsigned long) vma->vm_start;
>> +     unsigned long size = (unsigned long) (vma->vm_end - vma->vm_start);
>> +
>> +     dprintk("entering v4l_mmap(), offset: %lu\n", vma->vm_pgoff);
>> +     if (size > dev->buffer_size) {
>> +             printk(KERN_INFO "v4l2-loopback: "
>> +                    "userspace tries to mmap to much, fail\n");
>> +             return -EINVAL;
>> +     }
>> +     if ((vma->vm_pgoff << PAGE_SHIFT) >
>> +         dev->buffer_size * (dev->buffers_number - 1)) {
>> +             printk(KERN_INFO "v4l2-loopback: "
>> +                    "userspace tries to mmap to far, fail\n");
>> +             return -EINVAL;
>> +     }
>> +     addr = (unsigned long) dev->image + (vma->vm_pgoff << PAGE_SHIFT);
>> +
>> +     while (size > 0) {
>> +             page = (void *) vmalloc_to_page((void *) addr);
>> +
>> +             if (vm_insert_page(vma, start, page) < 0)
>> +                     return -EAGAIN;
>> +
>> +             start += PAGE_SIZE;
>> +             addr += PAGE_SIZE;
>> +             size -= PAGE_SIZE;
>> +     }
>> +
>> +     vma->vm_ops = &vm_ops;
>> +     vma->vm_private_data = 0;
>> +     dev->buffers[(vma->vm_pgoff<<PAGE_SHIFT)/dev->buffer_size].flags |=
>> +             V4L2_BUF_FLAG_MAPPED;
>> +
>> +     vm_open(vma);
>> +
>> +     dprintk("leaving v4l_mmap()\n");
>> +
>> +     return 0;
>> +}
>> +
>> +static unsigned int v4l2_loopback_poll(struct file *file,
>> +                                    struct poll_table_struct *pts)
>> +{
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +     int ret_mask = 0;
>> +
>> +     switch (opener->type) {
>> +     case WRITER:
>> +             ret_mask = POLLOUT | POLLWRNORM;
>> +             break;
>> +     case READER:
>> +             poll_wait(file, &dev->read_event, pts);
>> +             if (dev->write_position > opener->position)
>> +                     ret_mask =  POLLIN | POLLRDNORM;
>> +             break;
>> +     default:
>> +             ret_mask = -POLLERR;
>> +     }
>> +     return ret_mask;
>> +}
>> +
>> +/* do not want to limit device opens, it can be as many readers as user want,
>> + * writers are limited by means of setting writer field */
>> +static int v4l_loopback_open(struct file *file)
>> +{
>> +     struct v4l2_loopback_opener *opener;
>> +
>> +     dprintk("entering v4l_open()\n");
>> +     if (dev->open_count.counter == max_openers)
>> +             return -EBUSY;
>> +     /* kfree on close */
>> +     opener = kzalloc(sizeof(*opener), GFP_KERNEL);
>> +     if (opener == NULL)
>> +             return -ENOMEM;
>> +     file->private_data = opener;
>> +     atomic_inc(&dev->open_count);
>> +     return 0;
>> +}
>> +
>> +static int v4l_loopback_close(struct file *file)
>> +{
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +
>> +     dprintk("entering v4l_close()\n");
>> +     atomic_dec(&dev->open_count);
>> +     /* TODO(vasaka) does the closed file means that mmaped buffers are
>> +      * no more valid and one can free data? */
>> +     if (dev->open_count.counter == 0) {
>> +             vfree(dev->image);
>> +             dev->image = NULL;
>> +             dev->ready_for_capture = 0;
>> +             dev->buffer_size = 0;
>> +     }
>> +     kfree(opener);
>> +     return 0;
>> +}
>> +
>> +static ssize_t v4l_loopback_read(struct file *file, char __user *buf,
>> +                              size_t count, loff_t *ppos)
>> +{
>> +     int read_index;
>> +     struct v4l2_loopback_opener *opener = file->private_data;
>> +
>> +     if ((dev->write_position <= opener->position) &&
>> +             (file->f_flags&O_NONBLOCK)) {
>> +             return -EAGAIN;
>> +     }
>> +     wait_event_interruptible(dev->read_event,
>> +                              (dev->write_position > opener->position));
>> +     if (count > dev->buffer_size)
>> +             count = dev->buffer_size;
>> +     if (dev->write_position > opener->position+2)
>> +             opener->position = dev->write_position - 1;
>> +     read_index = opener->position % dev->buffers_number;
>> +     if (copy_to_user((void *) buf, (void *) (dev->image +
>> +                      dev->buffers[read_index].m.offset), count)) {
>> +             printk(KERN_INFO "v4l2-loopback: "
>> +                     "failed copy_from_user() in write buf\n");
>> +             return -EFAULT;
>> +     }
>> +     ++opener->position;
>> +     dprintkrw("leave v4l2_loopback_read()\n");
>> +     return count;
>> +}
>> +
>> +static ssize_t v4l_loopback_write(struct file *file,
>> +                               const char __user *buf, size_t count,
>> +                               loff_t *ppos)
>> +{
>> +     int write_index = dev->write_position % dev->buffers_number;
>> +     int ret;
>> +
>> +     if (dev->ready_for_capture == 0) {
>> +             ret = allocate_buffers();
>> +             if (ret < 0)
>> +                     return ret;
>> +             init_buffers(dev->buffer_size);
>> +             dev->ready_for_capture = 1;
>> +     }
>> +     dprintkrw("v4l2_loopback_write() trying to write %d bytes\n", count);
>> +     if (count > dev->buffer_size)
>> +             count = dev->buffer_size;
>> +     if (copy_from_user(
>> +                (void *) (dev->image + dev->buffers[write_index].m.offset),
>> +                (void *) buf, count)) {
>> +             printk(KERN_INFO "v4l2-loopback: "
>> +                "failed copy_from_user() in write buf, could not write %d\n",
>> +                count);
>
> error messages can be marked KERN_ERR.
>
>> +             return -EFAULT;
>> +     }
>> +     do_gettimeofday(&dev->buffers[write_index].timestamp);
>> +     dev->buffers[write_index].sequence = dev->write_position++;
>> +     wake_up_all(&dev->read_event);
>> +     dprintkrw("leave v4l2_loopback_write()\n");
>> +     return count;
>> +}
>> +
>> +/* init functions */
>> +/* allocates buffers, if buffer_size is set */
>> +static int allocate_buffers(void)
>> +{
>> +     /* vfree on close file operation in case no open handles left */
>> +     if (dev->buffer_size == 0)
>> +             return -EINVAL;
>> +     dev->image = vmalloc(dev->buffer_size * dev->buffers_number);
>> +     if (dev->image == NULL)
>> +             return -ENOMEM;
>> +     dprintk("vmallocated %ld bytes\n",
>> +             dev->buffer_size * dev->buffers_number);
>> +     return 0;
>> +}
>> +/* init inner buffers, they are capture mode and flags are set as
>> + * for capture mod buffers */
>> +static void init_buffers(int buffer_size)
>> +{
>> +     int i;
>> +     for (i = 0; i < dev->buffers_number; ++i) {
>> +             dev->buffers[i].bytesused         = buffer_size;
>> +             dev->buffers[i].length            = buffer_size;
>> +             dev->buffers[i].field             = V4L2_FIELD_NONE;
>> +             dev->buffers[i].flags             = 0;
>> +             dev->buffers[i].index             = i;
>> +             dev->buffers[i].input             = 0;
>> +             dev->buffers[i].m.offset          = i * buffer_size;
>> +             dev->buffers[i].memory            = V4L2_MEMORY_MMAP;
>> +             dev->buffers[i].sequence          = 0;
>> +             dev->buffers[i].timestamp.tv_sec  = 0;
>> +             dev->buffers[i].timestamp.tv_usec = 0;
>> +             dev->buffers[i].type              = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     }
>> +     dev->write_position = 0;
>> +}
>> +
>> +/* fills and register video device */
>> +static void init_vdev(struct video_device *vdev)
>> +{
>> +     strlcpy(vdev->name, "Loopback video device", sizeof(vdev->name));
>> +     vdev->tvnorms      = V4L2_STD_ALL;
>> +     vdev->current_norm = V4L2_STD_ALL,
>> +     vdev->vfl_type     = VFL_TYPE_GRABBER;
>> +     vdev->fops         = &v4l2_loopback_fops;
>> +     vdev->ioctl_ops    = &v4l2_loopback_ioctl_ops;
>> +     vdev->release      = &video_device_release;
>> +     vdev->minor        = -1;
>> +#ifdef DEBUG
>> +     vdev->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
>> +#endif
>> +}
>> +
>> +/* init default capture parameters, only fps may be changed in future */
>> +static void init_capture_param(struct v4l2_captureparm *capture_param)
>> +{
>> +     capture_param->capability               = 0;
>> +     capture_param->capturemode              = 0;
>> +     capture_param->extendedmode             = 0;
>> +     capture_param->readbuffers              = max_buffers_number;
>> +     capture_param->timeperframe.numerator   = 1;
>> +     capture_param->timeperframe.denominator = 30;
>> +}
>> +
>> +/* init loopback main structure */
>> +static int v4l2_loopback_init(struct v4l2_loopback_device *dev)
>> +{
>> +     dev->vdev = video_device_alloc();
>> +     if (dev->vdev == NULL)
>> +             return -ENOMEM;
>> +     init_vdev(dev->vdev);
>> +     init_capture_param(&dev->capture_param);
>> +     dev->buffers_number = max_buffers_number;
>> +     atomic_set(&dev->open_count, 0);
>> +     dev->ready_for_capture = 0;
>> +     dev->buffer_size = 0;
>> +     dev->image = NULL;
>> +     /* kfree on module release */
>> +     dev->buffers =
>> +         kzalloc(sizeof(*dev->buffers) * dev->buffers_number,
>> +                 GFP_KERNEL);
>> +     if (dev->buffers == NULL)
>> +             return -ENOMEM;
>> +     init_waitqueue_head(&dev->read_event);
>> +     return 0;
>> +};
>> +
>> +/* LINUX KERNEL */
>> +static const struct v4l2_file_operations v4l2_loopback_fops = {
>> +      .owner   = THIS_MODULE,
>> +      .open    = v4l_loopback_open,
>> +      .release = v4l_loopback_close,
>> +      .read    = v4l_loopback_read,
>> +      .write   = v4l_loopback_write,
>> +      .poll    = v4l2_loopback_poll,
>> +      .mmap    = v4l2_loopback_mmap,
>> +      .ioctl   = video_ioctl2,
>> +};
>> +
>> +static const struct v4l2_ioctl_ops v4l2_loopback_ioctl_ops = {
>> +     .vidioc_querycap         = &vidioc_querycap,
>> +     .vidioc_enum_fmt_vid_cap = &vidioc_enum_fmt_cap,
>> +     .vidioc_enum_input       = &vidioc_enum_input,
>> +     .vidioc_g_input          = &vidioc_g_input,
>> +     .vidioc_s_input          = &vidioc_s_input,
>> +     .vidioc_g_fmt_vid_cap    = &vidioc_g_fmt_cap,
>> +     .vidioc_s_fmt_vid_cap    = &vidioc_s_fmt_cap,
>> +     .vidioc_s_fmt_vid_out    = &vidioc_s_fmt_video_output,
>> +     .vidioc_try_fmt_vid_cap  = &vidioc_try_fmt_cap,
>> +     .vidioc_try_fmt_vid_out  = &vidioc_try_fmt_video_output,
>> +     .vidioc_s_std            = &vidioc_s_std,
>> +     .vidioc_g_parm           = &vidioc_g_parm,
>> +     .vidioc_s_parm           = &vidioc_s_parm,
>> +     .vidioc_reqbufs          = &vidioc_reqbufs,
>> +     .vidioc_querybuf         = &vidioc_querybuf,
>> +     .vidioc_qbuf             = &vidioc_qbuf,
>> +     .vidioc_dqbuf            = &vidioc_dqbuf,
>> +     .vidioc_streamon         = &vidioc_streamon,
>> +     .vidioc_streamoff        = &vidioc_streamoff,
>> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
>> +     .vidiocgmbuf             = &vidiocgmbuf,
>> +#endif
>> +};
>> +
>> +int __init init_module()
>> +{
>> +     int ret;
>> +
>> +     dprintk("entering init_module()\n");
>> +     /* kfree on module release */
>> +     dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>> +     if (dev == NULL)
>> +             return -ENOMEM;
>> +     ret = v4l2_loopback_init(dev);
>> +     if (ret < 0)
>> +             return ret;
>> +     /* register the device -> it creates /dev/video* */
>> +     if (video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1) < 0) {
>> +             video_device_release(dev->vdev);
>> +             printk(KERN_INFO "failed video_register_device()\n");
>> +             return -EFAULT;
>> +     }
>> +     printk(KERN_INFO "v4l2-loopback module installed\n");
>> +     return 0;
>> +}
>> +
>> +void __exit cleanup_module()
>> +{
>> +     dprintk("entering cleanup_module()\n");
>> +     /* unregister the device -> it deletes /dev/video* */
>> +     video_unregister_device(dev->vdev);
>> +     kfree(dev->buffers);
>> +     kfree(dev);
>> +     printk(KERN_INFO "v4l2-loopback module removed\n");
>> +}
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
>  Web site: http://www.studenti.unina.it/~ospite
> Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc
>
