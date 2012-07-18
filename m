Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43945 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2GRMmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 08:42:01 -0400
Received: by wibhm11 with SMTP id hm11so4731200wib.1
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 05:42:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207181300.05519.hverkuil@xs4all.nl>
References: <1342606895-9028-1-git-send-email-javier.martin@vista-silicon.com>
	<201207181300.05519.hverkuil@xs4all.nl>
Date: Wed, 18 Jul 2012 14:42:00 +0200
Message-ID: <CACKLOr1L0Z1L8cfX3AVnJacERWHq4YTtWxLebfJY3bhFj-bF0A@mail.gmail.com>
Subject: Re: [PATCH v4] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	rob.herring@calxeda.com, grant.likely@secretlab.ca,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
thank you for your review.

On 18 July 2012 13:00, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Javier!
>
> On Wed 18 July 2012 12:21:35 Javier Martin wrote:
>> Coda is a range of video codecs from Chips&Media that
>> support H.264, H.263, MPEG4 and other video standards.
>>
>> Currently only support for the codadx6 included in the
>> i.MX27 SoC is added. H.264 and MPEG4 video encoding
>> are the only supported capabilities by now.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> I have a few comments, see below.
>
>> ---
>> Changes since v3:
>>  - s/CODA7_STREAM_BUF_/CODA_STREAM_BUF/
>>  - Fix bytesused in vidioc_try_fmt()
>>  - Fix MODULE_DEVICE_TABLE for device tree
>>  - Fix 'coda_remove' for rmmod/insmod
>> ---
>>  drivers/media/video/Kconfig  |    9 +
>>  drivers/media/video/Makefile |    1 +
>>  drivers/media/video/coda.c   | 1852 ++++++++++++++++++++++++++++++++++++++++++
>>  drivers/media/video/coda.h   |  212 +++++
>>  4 files changed, 2074 insertions(+)
>>  create mode 100644 drivers/media/video/coda.c
>>  create mode 100644 drivers/media/video/coda.h
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 99937c9..9cebf7b 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -1179,6 +1179,15 @@ config VIDEO_MEM2MEM_TESTDEV
>>         This is a virtual test device for the memory-to-memory driver
>>         framework.
>>
>> +config VIDEO_CODA
>> +     tristate "Chips&Media Coda multi-standard codec IP"
>> +     depends on VIDEO_DEV && VIDEO_V4L2
>> +     select VIDEOBUF2_DMA_CONTIG
>> +     select V4L2_MEM2MEM_DEV
>> +     ---help---
>> +        Coda is a range of video codec IPs that supports
>> +        H.264, MPEG-4, and other video formats.
>> +
>>  config VIDEO_SAMSUNG_S5P_G2D
>>       tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
>>       depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index d209de0..a04c307 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -187,6 +187,7 @@ obj-$(CONFIG_VIDEO_OMAP1)         += omap1_camera.o
>>  obj-$(CONFIG_VIDEO_ATMEL_ISI)                += atmel-isi.o
>>
>>  obj-$(CONFIG_VIDEO_MX2_EMMAPRP)              += mx2_emmaprp.o
>> +obj-$(CONFIG_VIDEO_CODA)                     += coda.o
>>
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC)         += s5p-fimc/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg/
>> diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
>> new file mode 100644
>> index 0000000..9df712f
>> --- /dev/null
>> +++ b/drivers/media/video/coda.c
>> @@ -0,0 +1,1852 @@
>> +/*
>> + * Coda multi-standard codec IP
[snip]
>> + * V4L2 ioctl() operations.
>> + */
>> +static int vidioc_querycap(struct file *file, void *priv,
>> +                        struct v4l2_capability *cap)
>> +{
>> +     strncpy(cap->driver, CODA_NAME, sizeof(cap->driver) - 1);
>> +     strncpy(cap->card, CODA_NAME, sizeof(cap->card) - 1);
>> +     cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
>> +                       | V4L2_CAP_STREAMING;
>
> Please also set cap->device_caps. The code should be:
>
>         cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
>                           | V4L2_CAP_STREAMING;
>         cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

OK, I will change that.

>> +
>> +     return 0;
>> +}
>> +
>> +static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>> +                     enum coda_fmt_type type)
>> +{
>> +     struct coda_ctx *ctx = fh_to_ctx(priv);
>> +     struct coda_dev *dev = ctx->dev;
>> +     struct coda_fmt *formats = dev->devtype->formats;
>> +     struct coda_fmt *fmt;
>> +     int num_formats = dev->devtype->num_formats;
>> +     int i, num = 0;
>> +
>> +     for (i = 0; i < num_formats; i++) {
>> +             if (formats[i].type == type) {
>> +                     if (num == f->index)
>> +                             break;
>> +                     ++num;
>> +             }
>> +     }
>> +
>> +     if (i < num_formats) {
>> +             fmt = &formats[i];
>> +             strlcpy(f->description, fmt->name, sizeof(f->description) - 1);
>> +             f->pixelformat = fmt->fourcc;
>> +             return 0;
>> +     }
>> +
>> +     /* Format not found */
>> +     return -EINVAL;
>> +}
>> +
>> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>> +                                struct v4l2_fmtdesc *f)
>> +{
>> +     return enum_fmt(priv, f, CODA_FMT_ENC);
>> +}
>> +
>> +static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
>> +                                struct v4l2_fmtdesc *f)
>> +{
>> +     return enum_fmt(priv, f, CODA_FMT_RAW);
>> +}
>> +
>> +static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
>> +{
>> +     struct vb2_queue *vq;
>> +     struct coda_q_data *q_data;
>> +
>> +     vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +     if (!vq)
>> +             return -EINVAL;
>> +
>> +     q_data = get_q_data(ctx, f->type);
>> +
>> +     f->fmt.pix.field        = V4L2_FIELD_NONE;
>> +     f->fmt.pix.pixelformat  = q_data->fmt->fourcc;
>> +     if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +             f->fmt.pix.width        = q_data->width;
>> +             f->fmt.pix.height       = q_data->height;
>> +             f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
>> +     } else { /* encoded formats h.264/mpeg4 */
>> +             f->fmt.pix.width        = 0;
>> +             f->fmt.pix.height       = 0;
>> +             f->fmt.pix.bytesperline = 0;
>> +     }
>> +     f->fmt.pix.sizeimage    = q_data->sizeimage;
>
> colorspace isn't filled in.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     return vidioc_g_fmt(fh_to_ctx(priv), f);
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     return vidioc_g_fmt(fh_to_ctx(priv), f);
>> +}
>> +
>> +static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
>> +{
>> +     enum v4l2_field field;
>> +
>> +     if (!find_format(dev, f))
>> +             return -EINVAL;
>> +
>> +     field = f->fmt.pix.field;
>> +     if (field == V4L2_FIELD_ANY)
>> +             field = V4L2_FIELD_NONE;
>> +     else if (V4L2_FIELD_NONE != field)
>> +             return -EINVAL;
>> +
>> +     /* V4L2 specification suggests the driver corrects the format struct
>> +      * if any of the dimensions is unsupported */
>> +     f->fmt.pix.field = field;
>> +
>> +     if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +             v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
>> +                                   W_ALIGN, &f->fmt.pix.height,
>> +                                   MIN_H, MAX_H, H_ALIGN, S_ALIGN);
>> +             f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
>> +             f->fmt.pix.sizeimage = f->fmt.pix.height *
>> +                                     f->fmt.pix.bytesperline;
>> +     } else { /*encoded formats h.264/mpeg4 */
>> +             f->fmt.pix.bytesperline = 0;
>> +             f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
>> +     }
>
> Colorspace.

But I don't know how to handle colorspace in this driver. Video
encoder from samsung
(http://lxr.linux.no/#linux+v3.4.5/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L844
) does not handle it either.
This is a video encoder which gets an input video streaming (with its
specific colorspace) and encodes it. I understand the sense of this
field for a video source but for an encoder?

>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct coda_fmt *fmt;
>> +     struct coda_ctx *ctx = fh_to_ctx(priv);
>> +
>> +     fmt = find_format(ctx->dev, f);
>> +     /*
>> +      * Since decoding support is not implemented yet do not allow
>> +      * CODA_FMT_RAW formats in the capture interface.
>> +      */
>> +     if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
>> +             v4l2_err(&ctx->dev->v4l2_dev,
[snip]
>> +static void coda_fw_callback(const struct firmware *fw, void *context)
>> +{
>> +     struct coda_dev *dev = context;
>> +     struct platform_device *pdev = dev->plat_dev;
>> +     struct video_device *vfd;
>> +     int ret;
>> +
>> +     if (!fw) {
>> +             v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
>> +             return;
>> +     }
>> +
>> +     /* allocate auxiliary per-device code buffer for the BIT processor */
>> +     dev->codebuf_size = fw->size;
>> +     dev->codebuf.vaddr = dma_alloc_coherent(&pdev->dev, fw->size,
>> +                                                 &dev->codebuf.paddr,
>> +                                                 GFP_KERNEL);
>> +     if (!dev->codebuf.vaddr) {
>> +             dev_err(&pdev->dev, "failed to allocate code buffer\n");
>> +             return;
>> +     }
>> +
>> +     ret = coda_hw_init(dev, fw);
>> +     if (ret) {
>> +             v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
>> +             return;
>> +     }
>> +
>> +     vfd = video_device_alloc();
>
> Rather than allocating it I recommend embedding it in struct code_dev. It's
> actually easier that way as it avoids a null pointer test as you do below.
>
>> +     if (!vfd) {
>> +             v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
>> +             return;
>> +     }
>> +
>> +     vfd->fops       = &coda_fops,
>> +     vfd->ioctl_ops  = &coda_ioctl_ops;
>> +     vfd->release    = video_device_release,
>
> And if you embed video_device, then this release function should be set to
> video_device_release_empty.

Seems reasonable. Will do.

> One final comment: the v4l-utils.git repository (http://git.linuxtv.org/) contains
> a utility called v4l2-compliance. You should run that and go through the errors and
> warnings. Note that it will also give an error due to the lack of VIDIOC_G/S_PRIORITY
> support: I have to review that test as it may not be valid for mem2mem devices.
> As every filehandle gets its own context the priority level is irrelevant, and so
> are the checks v4l2-compliance does.

OK. I'll take a look at this utility.


Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
