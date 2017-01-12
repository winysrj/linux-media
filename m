Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:54458 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdALRns (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 12:43:48 -0500
Subject: Re: [PATCH v2 2/2] Support for DW CSI-2 Host IPK
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>, <mchehab@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
References: <cover.1481548484.git.roliveir@synopsys.com>
 <bf2f0a6730e4a74d64e04575859d6b195f65b368.1481554324.git.roliveir@synopsys.com>
 <eb89af79-f868-ceba-ac69-558bac77613d@xs4all.nl>
CC: <davem@davemloft.net>, <gregkh@linuxfoundation.org>,
        <geert+renesas@glider.be>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <laurent.pinchart+renesas@ideasonboard.com>,
        <arnd@arndb.de>, <sudipm.mukherjee@gmail.com>,
        <tiffany.lin@mediatek.com>, <minghsiu.tsai@mediatek.com>,
        <jean-christophe.trotin@st.com>, <andrew-ct.chen@mediatek.com>,
        <simon.horman@netronome.com>, <songjun.wu@microchip.com>,
        <bparrot@ti.com>, <CARLOS.PALMINHA@synopsys.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <8823670a-8456-87d0-3265-cb427e3445eb@synopsys.com>
Date: Thu, 12 Jan 2017 17:43:23 +0000
MIME-Version: 1.0
In-Reply-To: <eb89af79-f868-ceba-ac69-558bac77613d@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your feedback.

On 1/11/2017 11:54 AM, Hans Verkuil wrote:
> Hi Ramiro,
> 
> See my review comments below:
> 
> On 12/12/16 16:00, Ramiro Oliveira wrote:
>> Add support for the DesignWare CSI-2 Host IP Prototyping Kit
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>

[snip]

>> +static int
>> +dw_mipi_csi_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
>> +            struct v4l2_subdev_format *fmt)
>> +{
>> +    struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
>> +    struct mipi_fmt const *dev_fmt;
>> +    struct v4l2_mbus_framefmt *mf;
>> +    unsigned int i = 0;
>> +    const struct v4l2_bt_timings *bt_r = &v4l2_dv_timings_presets[0].bt;
>> +
>> +    mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
>> +
>> +    dev_fmt = dw_mipi_csi_try_format(&fmt->format);
>> +    if (dev_fmt) {
>> +        *mf = fmt->format;
>> +        if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +            dev->fmt = dev_fmt;
>> +        dw_mipi_csi_set_ipi_fmt(dev);
>> +    }
>> +    while (v4l2_dv_timings_presets[i].bt.width) {
>> +        const struct v4l2_bt_timings *bt =
>> +            &v4l2_dv_timings_presets[i].bt;
>> +        if (mf->width == bt->width && mf->height == bt->width) {
>> +            __dw_mipi_csi_fill_timings(dev, bt);
>> +            return 0;
>> +        }
>> +        i++;
>> +    }
>> +
>> +    __dw_mipi_csi_fill_timings(dev, bt_r);
> 
> This code is weird. The video source can be either from a sensor or from an
> HDMI input, right?
> 
> But if it is from a sensor, then using v4l2_dv_timings_presets since that's for
> an HDMI input. Sensors will typically not follow these preset timings.
> 
> For HDMI input I expect that this driver supports the s_dv_timings op and will
> just use the timings set there and override the width/height in v4l2_subdev_format.
> 
> For sensors I am actually not quite certain how this is done. I've CC-ed Sakari
> since he'll know. But let us know first whether it is indeed the intention that
> this should also work with a sensor.
> 

Actually the video source, at the moment, can only be from a sensor. I'm using
v4l2_dv_timings_presets as a reference since we usually use this setup with a
Test Equipment in which we can configure every parameter.

I'll wait for Sakari to answer, and change it to what he recommends.

>> +    return 0;
>> +
>> +}
>> +
>> +static int
>> +dw_mipi_csi_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
>> +            struct v4l2_subdev_format *fmt)
>> +{
>> +    struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
>> +    struct v4l2_mbus_framefmt *mf;
>> +
>> +    mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
>> +    if (!mf)
>> +        return -EINVAL;
>> +
>> +    mutex_lock(&dev->lock);
>> +    fmt->format = *mf;
>> +    mutex_unlock(&dev->lock);
>> +    return 0;
>> +}
>> +
>> +static int
>> +dw_mipi_csi_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +    struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
>> +
>> +    if (on) {
>> +        dw_mipi_csi_hw_stdby(dev);
>> +        dw_mipi_csi_start(dev);
>> +    } else {
>> +        dw_mipi_csi_mask_irq_power_off(dev);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int
>> +dw_mipi_csi_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +    struct v4l2_mbus_framefmt *format =
>> +        v4l2_subdev_get_try_format(sd, fh->pad, 0);
>> +
>> +    format->colorspace = V4L2_COLORSPACE_SRGB;
>> +    format->code = dw_mipi_csi_formats[0].code;
>> +    format->width = MIN_WIDTH;
>> +    format->height = MIN_HEIGHT;
>> +    format->field = V4L2_FIELD_NONE;
> 
> Don't do this. Instead implement the init_cfg pad op and initialize this there.
> 
> You can then drop this function.
> 

I'll do that.

>> +
>> +    return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_internal_ops dw_mipi_csi_sd_internal_ops = {
>> +    .open = dw_mipi_csi_open,
>> +};
>> +
>> +static struct v4l2_subdev_core_ops dw_mipi_csi_core_ops = {
>> +    .s_power = dw_mipi_csi_s_power,
>> +};
>> +
>> +static struct v4l2_subdev_pad_ops dw_mipi_csi_pad_ops = {
>> +    .enum_mbus_code = dw_mipi_csi_enum_mbus_code,
>> +    .get_fmt = dw_mipi_csi_get_fmt,
>> +    .set_fmt = dw_mipi_csi_set_fmt,
>> +};
>> +
>> +static struct v4l2_subdev_ops dw_mipi_csi_subdev_ops = {
>> +    .core = &dw_mipi_csi_core_ops,
>> +    .pad = &dw_mipi_csi_pad_ops,
>> +};
>> +
>> +static irqreturn_t
>> +dw_mipi_csi_irq1(int irq, void *dev_id)
>> +{
>> +    struct mipi_csi_dev *csi_dev = dev_id;
>> +    u32 global_int_status, i_sts;
>> +    unsigned long flags;
>> +    struct device *dev = &csi_dev->pdev->dev;
>> +
>> +    global_int_status = dw_mipi_csi_read(csi_dev, R_CSI2_INTERRUPT);
>> +    spin_lock_irqsave(&csi_dev->slock, flags);
>> +
>> +    if (global_int_status & CSI2_INT_PHY_FATAL) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY_FATAL);
>> +        dev_dbg_ratelimited(dev, "CSI INT PHY FATAL: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_PKT_FATAL) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT_FATAL);
>> +        dev_dbg_ratelimited(dev, "CSI INT PKT FATAL: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_FRAME_FATAL) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_FRAME_FATAL);
>> +        dev_dbg_ratelimited(dev, "CSI INT FRAME FATAL: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_PHY) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY);
>> +        dev_dbg_ratelimited(dev, "CSI INT PHY: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_PKT) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT);
>> +        dev_dbg_ratelimited(dev, "CSI INT PKT: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_LINE) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_LINE);
>> +        dev_dbg_ratelimited(dev, "CSI INT LINE: %08X\n", i_sts);
>> +    }
>> +
>> +    if (global_int_status & CSI2_INT_IPI) {
>> +        i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_IPI);
>> +        dev_dbg_ratelimited(dev, "CSI INT IPI: %08X\n", i_sts);
>> +    }
>> +    spin_unlock_irqrestore(&csi_dev->slock, flags);
>> +    return IRQ_HANDLED;
>> +}
>> +
>> +static int
>> +dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
>> +{
>> +    struct device_node *node = pdev->dev.of_node;
>> +    int reg;
>> +    int ret = 0;
>> +
>> +    /* Device tree information */
> 
> I would expect to see a call to v4l2_of_parse_endpoint here.
> 

You're right. I'll add it.

>> +    ret = of_property_read_u32(node, "data-lanes", &dev->hw.num_lanes);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read data-lanes\n");
>> +        return ret;
>> +    }
>> +
>> +    ret = of_property_read_u32(node, "output-type", &dev->hw.output_type);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read output-type\n");
>> +        return ret;
>> +    }
>> +
>> +    ret = of_property_read_u32(node, "ipi-mode", &dev->hw.ipi_mode);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read ipi-mode\n");
>> +        return ret;
>> +    }
>> +
>> +    ret =
>> +        of_property_read_u32(node, "ipi-auto-flush",
>> +                 &dev->hw.ipi_auto_flush);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read ipi-auto-flush\n");
>> +        return ret;
>> +    }
>> +
>> +    ret =
>> +        of_property_read_u32(node, "ipi-color-mode",
>> +                 &dev->hw.ipi_color_mode);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read ipi-color-mode\n");
>> +        return ret;
>> +    }
>> +
>> +    ret =
>> +        of_property_read_u32(node, "virtual-channel", &dev->hw.virtual_ch);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read virtual-channel\n");
>> +        return ret;
>> +    }
>> +
>> +    node = of_get_child_by_name(node, "port");
>> +    if (!node)
>> +        return -EINVAL;
>> +
>> +    ret = of_property_read_u32(node, "reg", &reg);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Couldn't read reg value\n");
>> +        return ret;
>> +    }
>> +    dev->index = reg - 1;
>> +
>> +    if (dev->index >= CSI_MAX_ENTITIES)
>> +        return -ENXIO;
>> +
>> +    return 0;
>> +}
>> +

[snip]

>> diff --git a/drivers/media/platform/dwc/plat_ipk.c
>> b/drivers/media/platform/dwc/plat_ipk.c
>> new file mode 100644
>> index 0000000..02dcf36
>> --- /dev/null
>> +++ b/drivers/media/platform/dwc/plat_ipk.c
>> @@ -0,0 +1,818 @@
>> +/**
>> + * DWC MIPI CSI-2 Host IPK platform device driver
> 
> What does IPK stand for?
> 

IPK stands for IP Prototyping Kit. However any reference to this will probably
disappear in the next patchset.

[snip]


>> +
>> +static const struct plat_ipk_fmt *
>> +vid_dev_find_format(struct v4l2_format *f, int index)
>> +{
>> +    const struct plat_ipk_fmt *fmt = NULL;
>> +    unsigned int i;
>> +
>> +    if (index >= (int) ARRAY_SIZE(vid_dev_formats))
>> +        return NULL;
> 
> ???
> 
> What's the purpose of the index argument? I get the feeling it is
> a left-over from older code.
> 

Yes. It's a left-over. I'll remove it.

>> +
>> +    for (i = 0; i < ARRAY_SIZE(vid_dev_formats); ++i) {
>> +        fmt = &vid_dev_formats[i];
>> +        if (fmt->fourcc == f->fmt.pix.pixelformat)
>> +            return fmt;
>> +    }
>> +    return NULL;
>> +}
>> +
>> +/*
>> + * Video node ioctl operations
>> + */
>> +static int
>> +vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
>> +{
>> +    struct video_device_dev *vid_dev = video_drvdata(file);
>> +
>> +    strlcpy(cap->driver, VIDEO_DEVICE_NAME, sizeof(cap->driver));
>> +    strlcpy(cap->card, VIDEO_DEVICE_NAME, sizeof(cap->card));
>> +    snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>> +         dev_name(&vid_dev->pdev->dev));
>> +
>> +    cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +    cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Set the device_caps in struct video_device and drop these two lines.
> The core will fill those in for you.
> 

I'll change them to where I configure the struct video_device.

>> +    return 0;
>> +}
>> +
>> +static int
>> +vidioc_enum_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fmtdesc *f)
>> +{
>> +    const struct plat_ipk_fmt *p_fmt;
>> +
>> +    if (f->index >= ARRAY_SIZE(vid_dev_formats))
>> +        return -EINVAL;
>> +
>> +    p_fmt = &vid_dev_formats[f->index];
>> +
>> +    strlcpy(f->description, p_fmt->name, sizeof(f->description));
> 
> Don't set the description, the core will do that for you.
> 

OK.

>> +    f->pixelformat = p_fmt->fourcc;
>> +
>> +    return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +                    struct v4l2_format *f)
>> +{
>> +    struct video_device_dev *dev = video_drvdata(file);
>> +
>> +    memcpy(&f->fmt.pix, &dev->format.fmt.pix,
>> +           sizeof(struct v4l2_pix_format));
> 
> Use f->fmt.pix = dev->format.fmt.pix;
> 

I'll do that

>> +
>> +    return 0;
>> +}
>> +
>> +static int
>> +vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
>> +{
>> +    const struct plat_ipk_fmt *fmt;
>> +
>> +    fmt = vid_dev_find_format(f, -1);
>> +    if (!fmt) {
>> +        f->fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
>> +        fmt = vid_dev_find_format(f, -1);
>> +    }
>> +
>> +    f->fmt.pix.field = V4L2_FIELD_NONE;
>> +    v4l_bound_align_image(&f->fmt.pix.width, 48, MAX_WIDTH, 2,
>> +                  &f->fmt.pix.height, 32, MAX_HEIGHT, 0, 0);
>> +
>> +    f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
>> +    f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>> +    f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +    return 0;
>> +}
>> +
>> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>> +                    struct v4l2_format *f)
>> +{
>> +    struct video_device_dev *dev = video_drvdata(file);
>> +    int ret;
>> +    struct v4l2_subdev_format fmt;
>> +    struct v4l2_pix_format *dev_fmt_pix = &dev->format.fmt.pix;
>> +
>> +    if (vb2_is_busy(&dev->vb_queue))
>> +        return -EBUSY;
>> +
>> +    ret = vidioc_try_fmt_vid_cap(file, dev, f);
>> +    if (ret)
>> +        return ret;
>> +
>> +    dev->fmt = vid_dev_find_format(f, -1);
>> +    dev_fmt_pix->pixelformat = f->fmt.pix.pixelformat;
>> +    dev_fmt_pix->width = f->fmt.pix.width;
>> +    dev_fmt_pix->height  = f->fmt.pix.height;
>> +    dev_fmt_pix->bytesperline = dev_fmt_pix->width * (dev->fmt->depth / 8);
>> +    dev_fmt_pix->sizeimage =
>> +            dev_fmt_pix->height * dev_fmt_pix->bytesperline;
>> +
>> +    fmt.format.colorspace = V4L2_COLORSPACE_SRGB;
>> +    fmt.format.code = dev->fmt->mbus_code;
>> +
>> +    fmt.format.width = dev_fmt_pix->width;
>> +    fmt.format.height = dev_fmt_pix->height;
>> +
>> +    ret = plat_ipk_pipeline_call(&dev->ve, set_format, &fmt);
>> +
>> +    return 0;
>> +}
>> +
>> +static int vidioc_enum_framesizes(struct file *file, void *fh,
>> +               struct v4l2_frmsizeenum *fsize)
>> +{
>> +    static const struct v4l2_frmsize_stepwise sizes = {
>> +        48, MAX_WIDTH, 4,
>> +        32, MAX_HEIGHT, 1
>> +    };
>> +    int i;
>> +
>> +    if (fsize->index)
>> +        return -EINVAL;
>> +    for (i = 0; i < ARRAY_SIZE(vid_dev_formats); i++)
>> +        if (vid_dev_formats[i].fourcc == fsize->pixel_format)
>> +            break;
>> +    if (i == ARRAY_SIZE(vid_dev_formats))
>> +        return -EINVAL;
>> +    fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
>> +    fsize->stepwise = sizes;
>> +    return 0;
>> +}
>> +
>> +static int vidioc_enum_input(struct file *file, void *priv,
>> +            struct v4l2_input *input)
>> +{
>> +    if (input->index != 0)
>> +        return -EINVAL;
>> +
>> +    input->type = V4L2_INPUT_TYPE_CAMERA;
>> +    input->std = V4L2_STD_ALL;    /* Not sure what should go here */
> 
> Set this to 0, or just drop the line.
> 

Thanks.

>> +    strcpy(input->name, "Camera");
>> +    return 0;
>> +}
>> +

[snip]

>> +
>> +static int vid_dev_subdev_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +    return 0;
>> +}
> 
> Just drop this empty function, shouldn't be needed.
> 

When I start my system I'm hoping all the subdevs have s_power registered. If it
doesn't exist should I change the way I handle it, or will the core handle it
for me?

>> +
>> +static int vid_dev_subdev_registered(struct v4l2_subdev *sd)
>> +{
>> +    struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
>> +    struct vb2_queue *q = &vid_dev->vb_queue;
>> +    struct video_device *vfd = &vid_dev->ve.vdev;
>> +    int ret;
>> +
>> +    memset(vfd, 0, sizeof(*vfd));
>> +
>> +    strlcpy(vfd->name, VIDEO_DEVICE_NAME, sizeof(vfd->name));
>> +
>> +    vfd->fops = &vid_dev_fops;
>> +    vfd->ioctl_ops = &vid_dev_ioctl_ops;
>> +    vfd->v4l2_dev = sd->v4l2_dev;
>> +    vfd->minor = -1;
>> +    vfd->release = video_device_release_empty;
>> +    vfd->queue = q;
>> +
>> +    INIT_LIST_HEAD(&vid_dev->vidq.active);
>> +    init_waitqueue_head(&vid_dev->vidq.wq);
>> +    memset(q, 0, sizeof(*q));
>> +    q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +    q->io_modes = VB2_MMAP | VB2_USERPTR;
> 
> Add VB2_DMABUF and VB2_READ.
> 

I'll add them, but I'm not using them, is it standard procedure to add them all
even if they aren't used?

>> +    q->ops = &vb2_video_qops;
>> +    q->mem_ops = &vb2_vmalloc_memops;
> 
> Why is vmalloc used? Can't you use dma_contig or dma_sg and avoid having to copy
> the image data? That's a really bad design given the amount of video data that
> you have to copy.
> 

When I started development, the arch I was using (ARC) didn't support
dma_contig, so I was forced to use vmalloc.

Since then things have changed and I'm already using dma_contig, however it
wasn't included in this patch. I'll add it to the next patch.

>> +    q->buf_struct_size = sizeof(struct rx_buffer);
>> +    q->drv_priv = vid_dev;
>> +    q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +    q->lock = &vid_dev->lock;
>> +
>> +    ret = vb2_queue_init(q);
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    vid_dev->vd_pad.flags = MEDIA_PAD_FL_SINK;
>> +    ret = media_entity_pads_init(&vfd->entity, 1, &vid_dev->vd_pad);
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    video_set_drvdata(vfd, vid_dev);
>> +    vid_dev->ve.pipe = v4l2_get_subdev_hostdata(sd);
>> +
>> +    ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
>> +    if (ret < 0) {
>> +        media_entity_cleanup(&vfd->entity);
>> +        vid_dev->ve.pipe = NULL;
>> +        return ret;
>> +    }
>> +
>> +    v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
>> +          vfd->name, video_device_node_name(vfd));
>> +    return 0;
>> +}
>> +

[snip]

> 
> Regards,
> 
>     Hans

BRs,
Ramiro
