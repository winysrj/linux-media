Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45000 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab3D3RgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 13:36:10 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so379853eek.19
        for <linux-media@vger.kernel.org>; Tue, 30 Apr 2013 10:36:08 -0700 (PDT)
Message-ID: <518000EE.40502@cogentembedded.com>
Date: Tue, 30 Apr 2013 20:35:42 +0300
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v2 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201304200231.31802.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1304201201370.10520@axis700.grange> <517D7195.1020301@cogentembedded.com>
In-Reply-To: <517D7195.1020301@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi,

Thank you for the review!

Sergei Shtylyov wrote:
>
>> I also strongly suspent some #include <media/v4l2-*.h> headers are 
>> missing
>> above.
>
>    Hm, I wonder which. I'm certainly not V4L2 expert...
added following:
#include <media/v4l2-common.h>
#include <media/v4l2-dev.h>
#include <media/v4l2-device.h>
#include <media/v4l2-mediabus.h>
#include <media/v4l2-subdev.h>

>>> +    alloc_ctxs[0] = priv->alloc_ctx;
>>> +
>>> +    if (!vq->num_buffers)
>>> +        priv->sequence = 0;
>>> +
>>> +    if (!*count)
>>> +        *count = 2;
>>> +    priv->vb_count = *count;
>>> +
>>> +    *num_planes = 1;
>>> +
>>> +    /* Number of hardware slots */
>>> +    if (priv->vb_count > MAX_BUFFER_NUM)
>>> +        priv->nr_hw_slots = MAX_BUFFER_NUM;
>>> +    else
>>> +        priv->nr_hw_slots = 1;
>
>> Is this really correct: with up to 3 buffers only one HW slot is used?
>
>    Probably not.
After replacing (priv->vb_count > MAX_BUFFER_NUM)  with 
is_continuous_transfer(priv) the logic becomes clear.

>>> +        break;
>>> +    default:
>>> +        vnmc = VNMC_IM_ODD;
>>> +        break;
>>> +    }
>>> +
>>> +    /* input interface */
>>> +    switch (icd->current_fmt->code) {
>>> +    case V4L2_MBUS_FMT_YUYV8_1X16:
>>> +        /* BT.601/BT.1358 16bit YCbCr422 */
>>> +        vnmc |= VNMC_INF_YUV16;
>>> +        input_is_yuv = 1;
>>> +        break;
>>> +    case V4L2_MBUS_FMT_YUYV8_2X8:
>>> +        input_is_yuv = 1;
>>> +        /* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>>> +        vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>>> +            VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>
>> Let's clarify this. By BT.656 you mean embedded synchronisation 
>> patterns,
>> right? In that case HSYNC and VSYNC signals aren't used.
>
>    Probably so, at least I know for sure HSYNC/VSYNC aren't used.
Yes, it is.
BT.656 uses embedded synchronization and HSYNC/VSYNC are not used for 
this type of interface.
The BT.601 is a so-called by soc-camera layer MBUS_PARALLEL.
>
>> But in your
>> .set_bus_param() method you only support V4L2_MBUS_PARALLEL and not
>> V4L2_MBUS_BT656. And what do you call BT601? A bus with sync signals 
>> used?
>    Yeah, judging from the manual, HSYNC, VSYNC, FIELD are used in BT.601.
The name ITUR BT601 YCbCr  that comes from specification is a 
MBUS_PARALLEL name per soc-camera layer naming.
The BT601 is expected to use h/w sync signals.

I've removed the pre initialization of v4l2_mbus_config .type filed in 
favour of getting it from camera/decoder subdevice.
Thx for pointing to this.
>>> +        }
>>> +    }
>>> +    spin_unlock_irq(&priv->lock);
>>> +
>>> +    pm_runtime_put_sync(ici->v4l2_dev.dev);
>
>> Do you really need the _sync version above?
>
>    I'm not runtime PM expert, to be honest...
replaced with pm_runtime_put().
thx for pointing to this.
>
>>> +static u16 calc_scale(unsigned int src, unsigned int *dst)
>>> +{
>>> +    u16 scale;
>>> +
>>> +    if (src == *dst)
>>> +        return 0;
>>> +
>>> +    scale = (src * 4096 / *dst) & ~7;
>>> +
>>> +    while (scale > 4096 && size_dst(src, scale) < *dst)
>>> +        scale -= 8;
>>> +
>>> +    *dst = size_dst(src, scale);
>>> +
>>> +    return scale;
>
>> return value of this function is unused by the caller. Generally, 
>> your use
>> of these two functions is different than on CEU, you might want to 
>> get rid
>> of them completely.
I'd prefer to leave this function and provide fixes after scaling is 
fully tested.


>>> +    /* Set Start/End Pixel/Line Pre-Clip */
>>> +    iowrite32(left_offset << dsize, priv->base + VNSPPRC_REG);
>>> +    iowrite32((left_offset + cam->width - 1) << dsize,
>>> +          priv->base + VNEPPRC_REG);
>
>> Do you have to shift for all 32-bit formats, not only for RGB32? I
>> understand this is related to the fact, that you don't support
>> pass-through...
>
>    At least the manual says to program an even number to VnSPPrC...
The driver explicitly says that V4L2_PIX_FMT_RGB32 is the only 32bit 
format supported.

>>> +static void capture_stop_preserve(struct rcar_vin_priv *priv, u32 
>>> *vnmc)
>>> +{
>>> +    *vnmc = ioread32(priv->base + VNMC_REG);
>>> +    /* module disable */
>>> +    iowrite32(*vnmc & ~VNMC_ME, priv->base + VNMC_REG);
>>> +}
>>> +
>>> +static void capture_restore(struct rcar_vin_priv *priv, u32 vnmc)
>>> +{
>>> +    unsigned long timeout = jiffies + 10 * HZ;
>>> +
>>> +    if (!(vnmc & ~VNMC_ME))
>>> +        /* Nothing to restore */
>>> +        return;
>
>> And you don't have to wait for a frame end?
>
>    If the module wasn't active, there's probably no point... however, 
> let's
> defer it to Vladimir.
Right. Thx for catching this.
>>> +    },
>>> +    {
>>> +        .fourcc            = V4L2_PIX_FMT_YUYV,
>>> +        .name            = "YUYV",
>>> +        .bits_per_sample    = 16,
>>> +        .packing        = SOC_MBUS_PACKING_NONE,
>>> +        .order            = SOC_MBUS_ORDER_LE,
>
>> This conversion block is identical to the respective one in
>> soc_mediabus.c, which suggests to me, that no conversion is taking place
>> here. Then this mode should be usable for generic 8- or 16-bit
>> pass-through?
>
>    Let's defer this question to Vladimir.
Will add pass-through. Thank you.

>>> +    switch (code) {
>>> +    case V4L2_MBUS_FMT_YUYV8_1X16:
>>> +    case V4L2_MBUS_FMT_YUYV8_2X8:
>>> +        if (cam->extra_fmt)
>>> +            break;
>>> +
>>> +        /* Add all our formats that can be generated by VIN */
>>> +        cam->extra_fmt = rcar_vin_formats;
>>> +
>>> +        n = ARRAY_SIZE(rcar_vin_formats);
>>> +        formats += n;
>>> +        for (k = 0; xlate && k < n; k++, xlate++) {
>>> +            xlate->host_fmt = &rcar_vin_formats[k];
>>> +            xlate->code = code;
>>> +            dev_dbg(dev, "Providing format %s using code %d\n",
>>> +                rcar_vin_formats[k].name, code);
>>> +        }
>>> +        break;
>>> +    default:
>>> +        return 0;
>
>> The above tells me, that VIN (or at least this driver) can only capture
>> YUYV8 either over an 8- or a 16-bit bus. Isn't it possible to provide a
>> pass-through mode?
>
>    10/12-bit bus is also possible in UYUV format and 20/24-bit bus in 
> 10/12 bits (Y) + 10/12 bits (CbCr) format on R-Car H1 VIN0/1. Not all 
> VIN interfaces are created equal in capabilities even within one 
> SoC... VIN2 indeed only supports 8 or 16 bits, and VIN3 only supports 
> 8-bit bus.
Ditto
>>> +/* Similar to set_crop multistage iterative algorithm */
>>> +static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>>> +                struct v4l2_format *f)
>>> +{
>>> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>>> +    struct rcar_vin_priv *priv = ici->priv;
>>> +    struct rcar_vin_cam *cam = icd->host_priv;
>>> +    struct v4l2_pix_format *pix = &f->fmt.pix;
>>> +    struct v4l2_mbus_framefmt mf;
>>> +    struct device *dev = icd->parent;
>>> +    __u32 pixfmt = pix->pixelformat;
>>> +    const struct soc_camera_format_xlate *xlate;
>>> +    unsigned int vin_sub_width = 0, vin_sub_height = 0;
>>> +    u16 scale_v, scale_h;
>>> +    int ret;
>>> +    bool can_scale;
>>> +    bool data_through;
>
>> What exactly does data_through mean? I thought it meant a pass-through
>> mode, but it is set to true for a YUYV->RGB32 conversion, which isn't
>> pass-through obviously.
>
>    Maybe it's just bset incorrectly. As I said, data through should 
> only be supported on R-Car E1 IIRC.
the data_through is removed per prev request and added just the check 
for RGB32 FMT in order to use a shift.
>
> [...]
>>> +    data_through = pixfmt == V4L2_PIX_FMT_RGB32;
>
>> What is "data_through" and why is RGB32 so special?
>
>    DIIK, to be honest. :-)
We will provide all detailed info once E1 will be up. Unfortunately, the 
E1 is not up but it is on the schedule.
>> VIN can scale _everything_ except NV16 and RGB32?
>
Depends on SOC ..... RGB32 and NV16 are applicable to E1 only .... we'll 
make the VIN module differentiation depending on SoC (H/M/E ...)

>>> +static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
>>> +                   struct soc_camera_device *icd)
>>> +{
>>> +    vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +    vq->io_modes = VB2_MMAP | VB2_USERPTR;
>>> +    vq->drv_priv = icd;
>>> +    vq->ops = &rcar_vin_vb2_ops;
>>> +    vq->mem_ops = &vb2_dma_contig_memops;
>>> +    vq->buf_struct_size = sizeof(struct rcar_vin_buffer);
>
>> Please, add
>
>>     vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>
There is not such field in "struct vb2_queue".


All other parts of review are reworked per suggestions.

Regards,
Vladimir
