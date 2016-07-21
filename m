Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:34807 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbcGUHay convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 03:30:54 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
Date: Thu, 21 Jul 2016 09:30:33 +0200
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
Message-ID: <57907A19.9000407@st.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
 <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl>
In-Reply-To: <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07/18/2016 01:45 PM, Hans Verkuil wrote:
> Hi Jean-Christophe,
>
> See my review comments below. Nothing really major, but I do need to know more
> about the g/s_parm and the restriction on the number of open()s has to be lifted.
> That's not allowed.
>

Hi Hans,

Thank you for your comments.
I've explained below why I would like to keep 'hva' as driver's name and why the
frame rate is needed (g/s_parm).
I've followed your advice for managing the hardware restriction with regards to
the number of codec instances (see also below).
Finally, I've taken into account all the other comments.
All these modifications will be reflected in the version 3.

Best regards,
Jean-Christophe.

> On 07/11/2016 05:14 PM, Jean-Christophe Trotin wrote:
>> This patch adds V4L2 HVA (Hardware Video Accelerator) video encoder
>> driver for STMicroelectronics SoC. It uses the V4L2 mem2mem framework.
>>
>> This patch only contains the core parts of the driver:
>> - the V4L2 interface with the userland (hva-v4l2.c)
>> - the hardware services (hva-hw.c)
>> - the memory management utilities (hva-mem.c)
>>
>> This patch doesn't include the support of specific codec (e.g. H.264)
>> video encoding: this support is part of subsequent patches.
>>
>> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
>> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
>> ---
>>   drivers/media/platform/Kconfig            |   14 +
>>   drivers/media/platform/Makefile           |    1 +
>>   drivers/media/platform/sti/hva/Makefile   |    2 +
>>   drivers/media/platform/sti/hva/hva-hw.c   |  534 ++++++++++++
>>   drivers/media/platform/sti/hva/hva-hw.h   |   42 +
>>   drivers/media/platform/sti/hva/hva-mem.c  |   60 ++
>>   drivers/media/platform/sti/hva/hva-mem.h  |   36 +
>>   drivers/media/platform/sti/hva/hva-v4l2.c | 1299 +++++++++++++++++++++++++++++
>>   drivers/media/platform/sti/hva/hva.h      |  284 +++++++
>>   9 files changed, 2272 insertions(+)
>>   create mode 100644 drivers/media/platform/sti/hva/Makefile
>>   create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
>>   create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
>>   create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
>>   create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
>>   create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
>>   create mode 100644 drivers/media/platform/sti/hva/hva.h
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 382f393..182d63f 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -227,6 +227,20 @@ config VIDEO_STI_BDISP
>>        help
>>          This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
>>
>> +config VIDEO_STI_HVA
>> +     tristate "STMicroelectronics STiH41x HVA multi-format video encoder V4L2 driver"
>> +     depends on VIDEO_DEV && VIDEO_V4L2
>> +     depends on ARCH_STI || COMPILE_TEST
>> +     select VIDEOBUF2_DMA_CONTIG
>> +     select V4L2_MEM2MEM_DEV
>> +     help
>> +       This V4L2 driver enables HVA multi-format video encoder of
>
> Please mention here what HVA stands for.
>

Done in version 3.
HVA stands for "Hardware Video Accelerator".

>> +       STMicroelectronics SoC STiH41x series, allowing hardware encoding of raw
>> +       uncompressed formats in various compressed video bitstreams format.
>> +
>> +       To compile this driver as a module, choose M here:
>> +       the module will be called hva.
>
> How about sti-hva as the module name? 'hva' is a bit too generic.
>

'hva' is a generic IP which could be used on different STMicroelectronics SoCs.
That's the reason why I would like to keep this name. It's not specific to  the
STiH41x series: thus, I've reworked the Kconfig's comment.

>> +
>>   config VIDEO_SH_VEU
>>        tristate "SuperH VEU mem2mem video processing driver"
>>        depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
>
> <snip>
>
>> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
>> new file mode 100644
>> index 0000000..bacc9ff
>> --- /dev/null
>> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
>> @@ -0,0 +1,1299 @@
>> +/*
>> + * Copyright (C) STMicroelectronics SA 2015
>> + * Authors: Yannick Fertre <yannick.fertre@st.com>
>> + *          Hugues Fruchet <hugues.fruchet@st.com>
>> + * License terms:  GNU General Public License (GPL), version 2
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include "hva.h"
>> +#include "hva-hw.h"
>> +
>> +#define HVA_NAME "hva"
>> +
>> +#define MIN_FRAMES   1
>> +#define MIN_STREAMS  1
>> +
>> +#define HVA_MIN_WIDTH        32
>> +#define HVA_MAX_WIDTH        1920
>> +#define HVA_MIN_HEIGHT       32
>> +#define HVA_MAX_HEIGHT       1920
>> +
>> +/* HVA requires a 16x16 pixels alignment for frames */
>> +#define HVA_WIDTH_ALIGNMENT  16
>> +#define HVA_HEIGHT_ALIGNMENT 16
>> +
>> +#define DEFAULT_WIDTH                HVA_MIN_WIDTH
>> +#define      DEFAULT_HEIGHT          HVA_MIN_HEIGHT
>> +#define DEFAULT_FRAME_NUM    1
>> +#define DEFAULT_FRAME_DEN    30
>> +
>> +#define to_type_str(type) (type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? \
>> +                        "frame" : "stream")
>> +
>> +#define fh_to_ctx(f)    (container_of(f, struct hva_ctx, fh))
>> +
>> +/* registry of available encoders */
>> +const struct hva_enc *hva_encoders[] = {
>> +};
>> +
>> +static inline int frame_size(u32 w, u32 h, u32 fmt)
>> +{
>> +     switch (fmt) {
>> +     case V4L2_PIX_FMT_NV12:
>> +     case V4L2_PIX_FMT_NV21:
>> +             return (w * h * 3) / 2;
>> +     default:
>> +             return 0;
>> +     }
>> +}
>> +
>> +static inline int frame_stride(u32 w, u32 fmt)
>> +{
>> +     switch (fmt) {
>> +     case V4L2_PIX_FMT_NV12:
>> +     case V4L2_PIX_FMT_NV21:
>> +             return w;
>> +     default:
>> +             return 0;
>> +     }
>> +}
>> +
>> +static inline int frame_alignment(u32 fmt)
>> +{
>> +     switch (fmt) {
>> +     case V4L2_PIX_FMT_NV12:
>> +     case V4L2_PIX_FMT_NV21:
>> +             /* multiple of 2 */
>> +             return 2;
>> +     default:
>> +             return 1;
>> +     }
>> +}
>> +
>> +static inline int estimated_stream_size(u32 w, u32 h)
>> +{
>> +     /*
>> +      * HVA only encodes in YUV420 format, whatever the frame format.
>> +      * A compression ratio of 2 is assumed: thus, the maximum size
>> +      * of a stream is estimated to ((width x height x 3 / 2) / 2)
>> +      */
>> +     return (w * h * 3) / 4;
>> +}
>> +
>> +static void set_default_params(struct hva_ctx *ctx)
>> +{
>> +     struct hva_frameinfo *frameinfo = &ctx->frameinfo;
>> +     struct hva_streaminfo *streaminfo = &ctx->streaminfo;
>> +
>> +     frameinfo->pixelformat = V4L2_PIX_FMT_NV12;
>> +     frameinfo->width = DEFAULT_WIDTH;
>> +     frameinfo->height = DEFAULT_HEIGHT;
>> +     frameinfo->aligned_width = DEFAULT_WIDTH;
>> +     frameinfo->aligned_height = DEFAULT_HEIGHT;
>> +     frameinfo->size = frame_size(frameinfo->aligned_width,
>> +                                  frameinfo->aligned_height,
>> +                                  frameinfo->pixelformat);
>> +
>> +     streaminfo->streamformat = V4L2_PIX_FMT_H264;
>> +     streaminfo->width = DEFAULT_WIDTH;
>> +     streaminfo->height = DEFAULT_HEIGHT;
>> +
>> +     ctx->max_stream_size = estimated_stream_size(streaminfo->width,
>> +                                                  streaminfo->height);
>> +}
>> +
>> +static const struct hva_enc *hva_find_encoder(struct hva_ctx *ctx,
>> +                                           u32 pixelformat,
>> +                                           u32 streamformat)
>> +{
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +     const struct hva_enc *enc;
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < hva->nb_of_encoders; i++) {
>> +             enc = hva->encoders[i];
>> +             if ((enc->pixelformat == pixelformat) &&
>> +                 (enc->streamformat == streamformat))
>> +                     return enc;
>> +     }
>> +
>> +     return NULL;
>> +}
>> +
>> +static void register_format(u32 format, u32 formats[], u32 *nb_of_formats)
>> +{
>> +     u32 i;
>> +     bool found = false;
>> +
>> +     for (i = 0; i < *nb_of_formats; i++) {
>> +             if (format == formats[i]) {
>> +                     found = true;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!found)
>> +             formats[(*nb_of_formats)++] = format;
>> +}
>> +
>> +static void register_formats(struct hva_dev *hva)
>> +{
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < hva->nb_of_encoders; i++) {
>> +             register_format(hva->encoders[i]->pixelformat,
>> +                             hva->pixelformats,
>> +                             &hva->nb_of_pixelformats);
>> +
>> +             register_format(hva->encoders[i]->streamformat,
>> +                             hva->streamformats,
>> +                             &hva->nb_of_streamformats);
>> +     }
>> +}
>> +
>> +static void register_encoders(struct hva_dev *hva)
>> +{
>> +     struct device *dev = hva_to_dev(hva);
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(hva_encoders); i++) {
>> +             if (hva->nb_of_encoders >= HVA_MAX_ENCODERS) {
>> +                     dev_dbg(dev,
>> +                             "%s failed to register encoder (%d maximum reached)\n",
>> +                             hva_encoders[i]->name, HVA_MAX_ENCODERS);
>> +                     return;
>> +             }
>> +
>> +             hva->encoders[hva->nb_of_encoders++] = hva_encoders[i];
>> +             dev_info(dev, "%s encoder registered\n", hva_encoders[i]->name);
>> +     }
>> +}
>> +
>> +static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
>> +                         u32 pixelformat, struct hva_enc **penc)
>> +{
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     struct hva_enc *enc;
>> +     unsigned int i;
>> +     int ret;
>> +     bool found = false;
>> +
>> +     /* find an encoder which can deal with these formats */
>> +     for (i = 0; i < hva->nb_of_encoders; i++) {
>> +             enc = (struct hva_enc *)hva->encoders[i];
>> +             if ((enc->streamformat == streamformat) &&
>> +                 (enc->pixelformat == pixelformat)) {
>> +                     found = true;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!found) {
>> +             dev_err(dev, "%s no encoder found matching %4.4s => %4.4s\n",
>> +                     ctx->name, (char *)&pixelformat, (char *)&streamformat);
>> +             return -EINVAL;
>> +     }
>> +
>> +     dev_dbg(dev, "%s one encoder matching %4.4s => %4.4s\n",
>> +             ctx->name, (char *)&pixelformat, (char *)&streamformat);
>> +
>> +     /* update instance name */
>> +     snprintf(ctx->name, sizeof(ctx->name), "[%3d:%4.4s]",
>> +              hva->instance_id, (char *)&streamformat);
>> +
>> +     /* open encoder instance */
>> +     ret = enc->open(ctx);
>> +     if (ret) {
>> +             dev_err(dev, "%s failed to open encoder instance (%d)\n",
>> +                     ctx->name, ret);
>> +             return ret;
>> +     }
>> +
>> +     dev_dbg(dev, "%s %s encoder opened\n", ctx->name, enc->name);
>> +
>> +     *penc = enc;
>> +
>> +     return ret;
>> +}
>> +
>> +/*
>> + * V4L2 ioctl operations
>> + */
>> +
>> +static int hva_querycap(struct file *file, void *priv,
>> +                     struct v4l2_capability *cap)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +
>> +     strlcpy(cap->driver, hva->pdev->name, sizeof(cap->driver));
>> +     strlcpy(cap->card, hva->pdev->name, sizeof(cap->card));
>> +     snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>> +              HVA_NAME);
>> +
>> +     cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
> Set the new device_caps field of struct video_device to
> V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M and drop these two lines.
>
> The v4l2 core will set device_caps and capabilities for you based on the
> video_device struct device_caps field. New drivers should use this.
>
> The advantage is that the v4l2 core now knows the caps of the video node.
>

Done in version 3.

>> +
>> +     return 0;
>> +}
>> +
>> +static int hva_enum_fmt_stream(struct file *file, void *priv,
>> +                            struct v4l2_fmtdesc *f)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +
>> +     if (unlikely(f->index >= hva->nb_of_streamformats))
>> +             return -EINVAL;
>> +
>> +     f->pixelformat = hva->streamformats[f->index];
>> +     snprintf(f->description, sizeof(f->description), "%4.4s",
>> +              (char *)&f->pixelformat);
>> +     f->flags = V4L2_FMT_FLAG_COMPRESSED;
>
> Drop these two lines. The v4l2 code fills in the description and flags for
> you.
>

Done in version 3.

>> +
>> +     return 0;
>> +}
>> +
>> +static int hva_enum_fmt_frame(struct file *file, void *priv,
>> +                           struct v4l2_fmtdesc *f)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +
>> +     if (unlikely(f->index >= hva->nb_of_pixelformats))
>> +             return -EINVAL;
>> +
>> +     f->pixelformat = hva->pixelformats[f->index];
>> +     snprintf(f->description, sizeof(f->description), "%4.4s",
>> +              (char *)&f->pixelformat);
>
> Ditto.
>

Done in version 3.

>> +
>> +     return 0;
>> +}
>> +
>> +static int hva_g_fmt_stream(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     struct hva_streaminfo *streaminfo = &ctx->streaminfo;
>> +
>> +     f->fmt.pix.width = streaminfo->width;
>> +     f->fmt.pix.height = streaminfo->height;
>> +     f->fmt.pix.field = V4L2_FIELD_NONE;
>> +     f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>
> This is a mem2mem device, so the colorspace comes from the colorspace that
> the application specified for the video output format. That's copied to the
> video capture format. See e.g. the vim2m.c example driver.
>
> The default colorspace should be REC709 as well, rather than SMPTE170M (that's
> for SDTV).
>
> I've added checks to v4l2-compliance to improve testing for this.
>
> See also the vim2m patch I just posted where I patch that m2m driver so it
> passes the compliance test.
>

Done in version 3.
I've aligned the code in version 3 on the colorspace management made in the
vim2m and mtk-vcodec drivers.

>> +     f->fmt.pix.pixelformat = streaminfo->streamformat;
>> +     f->fmt.pix.bytesperline = 0;
>> +     f->fmt.pix.sizeimage = ctx->max_stream_size;
>> +
>> +     dev_dbg(dev, "%s V4L2 G_FMT (CAPTURE): %dx%d fmt:%.4s size:%d\n",
>> +             ctx->name, f->fmt.pix.width, f->fmt.pix.height,
>> +             (u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
>
> No need for these debug messages. You can always debug the ioctls by:
>
> echo 2 >/sys/class/video4linux/video0/dev_debug.
>

Done in version 3 in hva_g_fmt_stream, hva_g_fmt_frame, hva_s_fmt_stream,
hva_s_fmt_frame, hva_s_parm and hva_g_parm functions.

>> +     return 0;
>> +}
>
> <snip>
>
>> +
>> +static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>> +
>> +     time_per_frame->numerator = sp->parm.capture.timeperframe.numerator;
>> +     time_per_frame->denominator =
>> +             sp->parm.capture.timeperframe.denominator;
>> +
>> +     dev_dbg(dev, "%s set parameters %d/%d\n", ctx->name,
>> +             time_per_frame->numerator, time_per_frame->denominator);
>> +
>> +     return 0;
>> +}
>> +
>> +static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>> +
>> +     sp->parm.capture.timeperframe.numerator = time_per_frame->numerator;
>> +     sp->parm.capture.timeperframe.denominator =
>> +             time_per_frame->denominator;
>> +
>> +     dev_dbg(dev, "%s get parameters %d/%d\n", ctx->name,
>> +             time_per_frame->numerator, time_per_frame->denominator);
>> +
>> +     return 0;
>> +}
>
> This is strange. Normally codecs don't need this. You give them a buffer and
> it will be encoded/decoded and then you give it the next one if it is available.
> There is normally no frame rate involved.
>
> How does this work in this SoC? I need to know a bit more about this to be
> certain there isn't a misunderstanding somewhere.
>

Among the parameters dimensioning its buffer model, the 'hva' HW IP needs to
calculate the depletion that is the quantity of bits at the output of the
encoder in each time slot, basically bitrate/framerate. That's the reason for
these 2 functions.
Furthermore, I've seen that mtk-vcodec and coda encoders also get the frame rate
to configure their HW IPs (vidioc_venc_s_parm & coda_s_parm).

>> +
>> +static int hva_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
>> +{
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +
>> +     if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>> +             /*
>> +              * depending on the targeted compressed video format, the
>> +              * capture buffer might contain headers (e.g. H.264 SPS/PPS)
>> +              * filled in by the driver client; the size of these data is
>> +              * copied from the bytesused field of the V4L2 buffer in the
>> +              * payload field of the hva stream buffer
>> +              */
>> +             struct vb2_queue *vq;
>> +             struct hva_stream *stream;
>> +
>> +             vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, buf->type);
>> +
>> +             if (buf->index >= vq->num_buffers) {
>> +                     dev_dbg(dev, "%s buffer index %d out of range (%d)\n",
>> +                             ctx->name, buf->index, vq->num_buffers);
>> +                     return -EINVAL;
>> +             }
>> +
>> +             stream = (struct hva_stream *)vq->bufs[buf->index];
>> +             stream->bytesused = buf->bytesused;
>> +     }
>> +
>> +     return v4l2_m2m_qbuf(file, ctx->fh.m2m_ctx, buf);
>> +}
>> +
>> +/* V4L2 ioctl ops */
>> +static const struct v4l2_ioctl_ops hva_ioctl_ops = {
>> +     .vidioc_querycap                = hva_querycap,
>> +     .vidioc_enum_fmt_vid_cap        = hva_enum_fmt_stream,
>> +     .vidioc_enum_fmt_vid_out        = hva_enum_fmt_frame,
>> +     .vidioc_g_fmt_vid_cap           = hva_g_fmt_stream,
>> +     .vidioc_g_fmt_vid_out           = hva_g_fmt_frame,
>> +     .vidioc_try_fmt_vid_cap         = hva_try_fmt_stream,
>> +     .vidioc_try_fmt_vid_out         = hva_try_fmt_frame,
>> +     .vidioc_s_fmt_vid_cap           = hva_s_fmt_stream,
>> +     .vidioc_s_fmt_vid_out           = hva_s_fmt_frame,
>> +     .vidioc_g_parm                  = hva_g_parm,
>> +     .vidioc_s_parm                  = hva_s_parm,
>> +     .vidioc_reqbufs                 = v4l2_m2m_ioctl_reqbufs,
>> +     .vidioc_create_bufs             = v4l2_m2m_ioctl_create_bufs,
>> +     .vidioc_querybuf                = v4l2_m2m_ioctl_querybuf,
>> +     .vidioc_expbuf                  = v4l2_m2m_ioctl_expbuf,
>> +     .vidioc_qbuf                    = hva_qbuf,
>> +     .vidioc_dqbuf                   = v4l2_m2m_ioctl_dqbuf,
>> +     .vidioc_streamon                = v4l2_m2m_ioctl_streamon,
>> +     .vidioc_streamoff               = v4l2_m2m_ioctl_streamoff,
>> +     .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>> +     .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>> +};
>> +
>> +/*
>> + * V4L2 control operations
>> + */
>> +
>> +static int hva_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +     struct hva_ctx *ctx = container_of(ctrl->handler, struct hva_ctx,
>> +                                        ctrl_handler);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +
>> +     dev_dbg(dev, "%s S_CTRL: id = %d, val = %d\n", ctx->name,
>> +             ctrl->id, ctrl->val);
>> +
>> +     switch (ctrl->id) {
>> +     case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
>> +             ctx->ctrls.bitrate_mode = ctrl->val;
>> +             break;
>> +     case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
>> +             ctx->ctrls.gop_size = ctrl->val;
>> +             break;
>> +     case V4L2_CID_MPEG_VIDEO_BITRATE:
>> +             ctx->ctrls.bitrate = ctrl->val;
>> +             break;
>> +     case V4L2_CID_MPEG_VIDEO_ASPECT:
>> +             ctx->ctrls.aspect = ctrl->val;
>> +             break;
>> +     default:
>> +             dev_dbg(dev, "%s S_CTRL: invalid control (id = %d)\n",
>> +                     ctx->name, ctrl->id);
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +/* V4L2 control ops */
>> +static const struct v4l2_ctrl_ops hva_ctrl_ops = {
>> +     .s_ctrl = hva_s_ctrl,
>> +};
>> +
>> +static int hva_ctrls_setup(struct hva_ctx *ctx)
>> +{
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     u64 mask;
>> +
>> +     v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
>> +
>> +     v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
>> +                            V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
>> +                            V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
>> +                            0,
>> +                            V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
>> +                       V4L2_CID_MPEG_VIDEO_GOP_SIZE,
>> +                       1, 60, 1, 16);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
>> +                       V4L2_CID_MPEG_VIDEO_BITRATE,
>> +                       1, 50000, 1, 20000);
>> +
>> +     mask = ~(1 << V4L2_MPEG_VIDEO_ASPECT_1x1);
>> +     v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
>> +                            V4L2_CID_MPEG_VIDEO_ASPECT,
>> +                            V4L2_MPEG_VIDEO_ASPECT_1x1,
>> +                            mask,
>> +                            V4L2_MPEG_VIDEO_ASPECT_1x1);
>> +
>> +     if (ctx->ctrl_handler.error) {
>> +             int err = ctx->ctrl_handler.error;
>> +
>> +             dev_dbg(dev, "%s controls setup failed (%d)\n",
>> +                     ctx->name, err);
>> +             v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>> +             return err;
>> +     }
>> +
>> +     v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
>> +
>> +     /* set default time per frame */
>> +     ctx->ctrls.time_per_frame.numerator = DEFAULT_FRAME_NUM;
>> +     ctx->ctrls.time_per_frame.denominator = DEFAULT_FRAME_DEN;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * mem-to-mem operations
>> + */
>> +
>> +static void hva_run_work(struct work_struct *work)
>> +{
>> +     struct hva_ctx *ctx = container_of(work, struct hva_ctx, run_work);
>> +     struct vb2_v4l2_buffer *src_buf, *dst_buf;
>> +     const struct hva_enc *enc = ctx->enc;
>> +     struct hva_frame *frame;
>> +     struct hva_stream *stream;
>> +     int ret;
>> +
>> +     /* protect instance against reentrancy */
>> +     mutex_lock(&ctx->lock);
>> +
>> +     src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>> +     dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>> +
>> +     frame = to_hva_frame(src_buf);
>> +     stream = to_hva_stream(dst_buf);
>> +     frame->vbuf.sequence = ctx->frame_num++;
>> +
>> +     ret = enc->encode(ctx, frame, stream);
>> +
>> +     if (ret) {
>> +             v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
>> +             v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
>> +     } else {
>> +             /* propagate frame timestamp */
>> +             dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
>> +             dst_buf->field = V4L2_FIELD_NONE;
>> +             dst_buf->sequence = ctx->stream_num - 1;
>> +
>> +             v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>> +             v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
>> +     }
>> +
>> +     mutex_unlock(&ctx->lock);
>> +
>> +     v4l2_m2m_job_finish(ctx->hva_dev->m2m_dev, ctx->fh.m2m_ctx);
>> +}
>> +
>> +static void hva_device_run(void *priv)
>> +{
>> +     struct hva_ctx *ctx = priv;
>> +     struct hva_dev *hva = ctx_to_hdev(ctx);
>> +
>> +     queue_work(hva->work_queue, &ctx->run_work);
>> +}
>> +
>> +static void hva_job_abort(void *priv)
>> +{
>> +     struct hva_ctx *ctx = priv;
>> +     struct device *dev = ctx_to_dev(ctx);
>> +
>> +     dev_dbg(dev, "%s aborting job\n", ctx->name);
>> +
>> +     ctx->aborting = true;
>> +}
>> +
>> +static int hva_job_ready(void *priv)
>> +{
>> +     struct hva_ctx *ctx = priv;
>> +     struct device *dev = ctx_to_dev(ctx);
>> +
>> +     if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx)) {
>> +             dev_dbg(dev, "%s job not ready: no frame buffers\n",
>> +                     ctx->name);
>> +             return 0;
>> +     }
>> +
>> +     if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
>> +             dev_dbg(dev, "%s job not ready: no stream buffers\n",
>> +                     ctx->name);
>> +             return 0;
>> +     }
>> +
>> +     if (ctx->aborting) {
>> +             dev_dbg(dev, "%s job not ready: aborting\n", ctx->name);
>> +             return 0;
>> +     }
>> +
>> +     return 1;
>> +}
>> +
>> +/* mem-to-mem ops */
>> +static const struct v4l2_m2m_ops hva_m2m_ops = {
>> +     .device_run     = hva_device_run,
>> +     .job_abort      = hva_job_abort,
>> +     .job_ready      = hva_job_ready,
>> +};
>> +
>> +/*
>> + * VB2 queue operations
>> + */
>> +
>> +static int hva_queue_setup(struct vb2_queue *vq,
>> +                        unsigned int *num_buffers, unsigned int *num_planes,
>> +                        unsigned int sizes[], void *alloc_ctxs[])
>
> This patch needs to be rebased: the way allocation contexts are set up has
> changed. You now set the new 'dev' field in vb2_queue to the struct device,
> and there is no longer any need to fill in alloc_ctxs here or init/free the
> allocation context. The prototype of this queue_setup function has
> changed as well.
>

I apologize for forgetting this rebase.
Done in version 3.

>> +{
>> +     struct hva_ctx *ctx = vb2_get_drv_priv(vq);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     unsigned int size;
>> +
>> +     dev_dbg(dev, "%s %s queue setup: num_buffers %d\n", ctx->name,
>> +             to_type_str(vq->type), *num_buffers);
>> +
>> +     size = vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ?
>> +             ctx->frameinfo.size : ctx->max_stream_size;
>> +
>> +     alloc_ctxs[0] = ctx->hva_dev->alloc_ctx;
>> +
>> +     if (*num_planes)
>> +             return sizes[0] < size ? -EINVAL : 0;
>> +
>> +     /* only one plane supported */
>> +     *num_planes = 1;
>> +     sizes[0] = size;
>> +
>> +     return 0;
>> +}
>> +
>> +static int hva_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +
>> +     if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>> +             struct hva_frame *frame = to_hva_frame(vbuf);
>> +
>> +             if (vbuf->field == V4L2_FIELD_ANY)
>> +                     vbuf->field = V4L2_FIELD_NONE;
>
> Anything other than FIELD_NONE should result in an error since no interlaced is supported.
> FIELD_ANY is an incorrect value as well.
>

These 2 lines are kept as discussed in a previous email.

>> +             if (vbuf->field != V4L2_FIELD_NONE) {
>> +                     dev_dbg(dev,
>> +                             "%s frame[%d] prepare: %d field not supported\n",
>> +                             ctx->name, vb->index, vbuf->field);
>> +                     return -EINVAL;
>> +             }
>> +
>> +             if (!frame->prepared) {
>> +                     /* get memory addresses */
>> +                     frame->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
>> +                     frame->paddr = vb2_dma_contig_plane_dma_addr(
>> +                                     &vbuf->vb2_buf, 0);
>> +                     frame->info = ctx->frameinfo;
>> +                     frame->prepared = true;
>> +
>> +                     dev_dbg(dev,
>> +                             "%s frame[%d] prepared; virt=%p, phy=%pad\n",
>> +                             ctx->name, vb->index,
>> +                             frame->vaddr, &frame->paddr);
>> +             }
>> +     } else {
>> +             struct hva_stream *stream = to_hva_stream(vbuf);
>> +
>> +             if (!stream->prepared) {
>> +                     /* get memory addresses */
>> +                     stream->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
>> +                     stream->paddr = vb2_dma_contig_plane_dma_addr(
>> +                                     &vbuf->vb2_buf, 0);
>> +                     stream->size = vb2_plane_size(&vbuf->vb2_buf, 0);
>> +                     stream->prepared = true;
>> +
>> +                     dev_dbg(dev,
>> +                             "%s stream[%d] prepared; virt=%p, phy=%pad\n",
>> +                             ctx->name, vb->index,
>> +                             stream->vaddr, &stream->paddr);
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void hva_buf_queue(struct vb2_buffer *vb)
>> +{
>> +     struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +
>> +     if (ctx->fh.m2m_ctx)
>> +             v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>> +}
>> +
>> +static int hva_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct hva_ctx *ctx = vb2_get_drv_priv(vq);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     int ret = 0;
>> +
>> +     dev_dbg(dev, "%s %s start streaming\n", ctx->name,
>> +             to_type_str(vq->type));
>> +
>> +     /* open encoder when both start_streaming have been called */
>> +     if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
>> +             if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->cap_q_ctx.q))
>> +                     return 0;
>> +     } else {
>> +             if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->out_q_ctx.q))
>> +                     return 0;
>> +     }
>> +
>> +     if (!ctx->enc)
>> +             ret = hva_open_encoder(ctx,
>> +                                    ctx->streaminfo.streamformat,
>> +                                    ctx->frameinfo.pixelformat,
>> +                                    &ctx->enc);
>
> On error all pending buffers for queue vq should be returned to vb2 in the QUEUED state.
> Similar to what happens in stop_streaming, but with state QUEUED instead of state ERROR.
>

Done in version 3.

>> +
>> +     return ret;
>> +}
>> +
>> +static void hva_stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct hva_ctx *ctx = vb2_get_drv_priv(vq);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +     const struct hva_enc *enc = ctx->enc;
>> +     struct vb2_v4l2_buffer *vbuf;
>> +
>> +     dev_dbg(dev, "%s %s stop streaming\n", ctx->name,
>> +             to_type_str(vq->type));
>> +
>> +     if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>> +             /* return of all pending buffers to vb2 (in error state) */
>> +             ctx->frame_num = 0;
>> +             while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
>> +                     v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>> +     } else {
>> +             /* return of all pending buffers to vb2 (in error state) */
>> +             ctx->stream_num = 0;
>> +             while ((vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
>> +                     v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>> +     }
>> +
>> +     if ((V4L2_TYPE_IS_OUTPUT(vq->type) &&
>> +          vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_ctx.q)) ||
>> +         (!V4L2_TYPE_IS_OUTPUT(vq->type) &&
>> +          vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_ctx.q))) {
>> +             dev_dbg(dev, "%s %s out=%d cap=%d\n",
>> +                     ctx->name, to_type_str(vq->type),
>> +                     vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_ctx.q),
>> +                     vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_ctx.q));
>> +             return;
>> +     }
>> +
>> +     /* close encoder when both stop_streaming have been called */
>> +     if (enc) {
>> +             dev_dbg(dev, "%s %s encoder closed\n", ctx->name, enc->name);
>> +             enc->close(ctx);
>> +             ctx->enc = NULL;
>> +     }
>> +
>> +     ctx->aborting = false;
>> +}
>> +
>> +/* VB2 queue ops */
>> +static const struct vb2_ops hva_qops = {
>> +     .queue_setup            = hva_queue_setup,
>> +     .buf_prepare            = hva_buf_prepare,
>> +     .buf_queue              = hva_buf_queue,
>> +     .start_streaming        = hva_start_streaming,
>> +     .stop_streaming         = hva_stop_streaming,
>> +     .wait_prepare           = vb2_ops_wait_prepare,
>> +     .wait_finish            = vb2_ops_wait_finish,
>> +};
>> +
>> +/*
>> + * V4L2 file operations
>> + */
>> +
>> +static int queue_init(struct hva_ctx *ctx, struct vb2_queue *vq)
>> +{
>> +     vq->io_modes = VB2_MMAP | VB2_DMABUF;
>> +     vq->drv_priv = ctx;
>> +     vq->ops = &hva_qops;
>> +     vq->mem_ops = &vb2_dma_contig_memops;
>> +     vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +     vq->lock = &ctx->hva_dev->lock;
>> +
>> +     return vb2_queue_init(vq);
>> +}
>> +
>> +static int hva_queue_init(void *priv, struct vb2_queue *src_vq,
>> +                       struct vb2_queue *dst_vq)
>> +{
>> +     struct hva_ctx *ctx = priv;
>> +     int ret;
>> +
>> +     src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +     src_vq->buf_struct_size = sizeof(struct hva_frame);
>> +     src_vq->min_buffers_needed = MIN_FRAMES;
>> +
>> +     ret = queue_init(ctx, src_vq);
>> +     if (ret)
>> +             return ret;
>> +
>> +     dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     dst_vq->buf_struct_size = sizeof(struct hva_stream);
>> +     dst_vq->min_buffers_needed = MIN_STREAMS;
>> +
>> +     return queue_init(ctx, dst_vq);
>> +}
>> +
>> +static int hva_open(struct file *file)
>> +{
>> +     struct hva_dev *hva = video_drvdata(file);
>> +     struct device *dev = hva_to_dev(hva);
>> +     struct hva_ctx *ctx;
>> +     int ret;
>> +     unsigned int i;
>> +     bool found = false;
>> +
>> +     ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +     if (!ctx) {
>> +             ret = -ENOMEM;
>> +             goto out;
>> +     }
>> +     ctx->hva_dev = hva;
>> +
>> +     mutex_lock(&hva->lock);
>> +
>> +     /* store the instance context in the instances array */
>> +     for (i = 0; i < HVA_MAX_INSTANCES; i++) {
>> +             if (!hva->instances[i]) {
>> +                     hva->instances[i] = ctx;
>> +                     /* save the context identifier in the context */
>> +                     ctx->id = i;
>> +                     found = true;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!found) {
>> +             dev_err(dev, "%s [x:x] maximum instances reached\n",
>> +                     HVA_PREFIX);
>> +             ret = -ENOMEM;
>> +             goto mem_ctx;
>> +     }
>
> This is wrong. It should always be possible to open the device node and
> e.g. query the format or control settings, or whatever.
>
> In this case there is apparently a hardware restriction with regards to
> the number of codec instances. It *is* a hardware restriction, right?
> If it is a driver restriction, then that's certainly wrong since there
> is normally no reason for that.
>
> Assuming it is a HW restriction, then this restriction is normally
> checked in start_streaming or in queue_setup. I.e. at the point where
> the HW resource reservation actually takes place.
>

I confirm that there's a hardware restriction with regards to the number of
codec instances. I agree with you that it shall be checked in start_streaming.
Done in version 3.

>> +
>> +     INIT_WORK(&ctx->run_work, hva_run_work);
>> +     v4l2_fh_init(&ctx->fh, video_devdata(file));
>> +     file->private_data = &ctx->fh;
>> +     v4l2_fh_add(&ctx->fh);
>> +
>> +     ret = hva_ctrls_setup(ctx);
>> +     if (ret) {
>> +             dev_err(dev, "%s [x:x] failed to setup controls\n",
>> +                     HVA_PREFIX);
>> +             goto err_fh;
>> +     }
>> +     ctx->fh.ctrl_handler = &ctx->ctrl_handler;
>> +
>> +     mutex_init(&ctx->lock);
>> +
>> +     ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(hva->m2m_dev, ctx,
>> +                                         &hva_queue_init);
>> +     if (IS_ERR(ctx->fh.m2m_ctx)) {
>> +             ret = PTR_ERR(ctx->fh.m2m_ctx);
>> +             dev_err(dev, "%s [x:x] failed to initialize m2m context (%d)\n",
>> +                     HVA_PREFIX, ret);
>> +             goto err_ctrls;
>> +     }
>> +
>> +     /* set the instance name */
>> +     hva->instance_id++;
>> +     snprintf(ctx->name, sizeof(ctx->name), "[%3d:----]",
>> +              hva->instance_id);
>> +
>> +     hva->nb_of_instances++;
>> +
>> +     mutex_unlock(&hva->lock);
>> +
>> +     /* default parameters for frame and stream */
>> +     set_default_params(ctx);
>> +
>> +     dev_info(dev, "%s encoder instance created (id %d)\n",
>> +              ctx->name, ctx->id);
>> +
>> +     return 0;
>> +
>> +err_ctrls:
>> +     v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>> +err_fh:
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +     hva->instances[ctx->id] = NULL;
>> +mem_ctx:
>> +     kfree(ctx);
>> +     mutex_unlock(&hva->lock);
>> +out:
>> +     return ret;
>> +}
>> +
>> +static int hva_release(struct file *file)
>> +{
>> +     struct hva_dev *hva = video_drvdata(file);
>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct device *dev = ctx_to_dev(ctx);
>> +
>> +     v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>> +
>> +     v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>> +
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +
>> +     mutex_lock(&hva->lock);
>> +
>> +     /* clear instance context in instances array */
>> +     hva->instances[ctx->id] = NULL;
>> +
>> +     hva->nb_of_instances--;
>> +
>> +     mutex_unlock(&hva->lock);
>> +
>> +     dev_info(dev, "%s encoder instance released (id %d)\n",
>> +              ctx->name, ctx->id);
>> +
>> +     kfree(ctx);
>> +
>> +     return 0;
>> +}
>> +
>> +/* V4L2 file ops */
>> +static const struct v4l2_file_operations hva_fops = {
>> +     .owner                  = THIS_MODULE,
>> +     .open                   = hva_open,
>> +     .release                = hva_release,
>> +     .unlocked_ioctl         = video_ioctl2,
>> +     .mmap                   = v4l2_m2m_fop_mmap,
>> +     .poll                   = v4l2_m2m_fop_poll,
>> +};
>> +
>> +/*
>> + * Platform device operations
>> + */
>> +
>> +static int hva_register_device(struct hva_dev *hva)
>> +{
>> +     int ret;
>> +     struct video_device *vdev;
>> +     struct device *dev;
>> +
>> +     if (!hva)
>> +             return -ENODEV;
>> +     dev = hva_to_dev(hva);
>> +
>> +     hva->m2m_dev = v4l2_m2m_init(&hva_m2m_ops);
>> +     if (IS_ERR(hva->m2m_dev)) {
>> +             dev_err(dev, "%s %s failed to initialize v4l2-m2m device\n",
>> +                     HVA_PREFIX, HVA_NAME);
>> +             ret = PTR_ERR(hva->m2m_dev);
>> +             goto err;
>> +     }
>> +
>> +     vdev = video_device_alloc();
>> +     if (!vdev) {
>> +             dev_err(dev, "%s %s failed to allocate video device\n",
>> +                     HVA_PREFIX, HVA_NAME);
>> +             ret = -ENOMEM;
>> +             goto err_m2m_release;
>> +     }
>> +
>> +     vdev->fops = &hva_fops;
>> +     vdev->ioctl_ops = &hva_ioctl_ops;
>> +     vdev->release = video_device_release;
>> +     vdev->lock = &hva->lock;
>> +     vdev->vfl_dir = VFL_DIR_M2M;
>> +     vdev->v4l2_dev = &hva->v4l2_dev;
>> +     snprintf(vdev->name, sizeof(vdev->name), "%s", HVA_NAME);
>> +
>> +     ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>> +     if (ret) {
>> +             dev_err(dev, "%s %s failed to register video device\n",
>> +                     HVA_PREFIX, HVA_NAME);
>> +             goto err_vdev_release;
>> +     }
>> +
>> +     hva->vdev = vdev;
>> +     video_set_drvdata(vdev, hva);
>> +     return 0;
>> +
>> +err_vdev_release:
>> +     video_device_release(vdev);
>> +err_m2m_release:
>> +     v4l2_m2m_release(hva->m2m_dev);
>> +err:
>> +     return ret;
>> +}
>> +
>> +static void hva_unregister_device(struct hva_dev *hva)
>> +{
>> +     if (!hva)
>> +             return;
>> +
>> +     if (hva->m2m_dev)
>> +             v4l2_m2m_release(hva->m2m_dev);
>> +
>> +     video_unregister_device(hva->vdev);
>> +}
>> +
>> +static int hva_probe(struct platform_device *pdev)
>> +{
>> +     struct hva_dev *hva;
>> +     struct device *dev = &pdev->dev;
>> +     int ret;
>> +
>> +     hva = devm_kzalloc(dev, sizeof(*hva), GFP_KERNEL);
>> +     if (!hva) {
>> +             ret = -ENOMEM;
>> +             goto err;
>> +     }
>> +
>> +     hva->dev = dev;
>> +     hva->pdev = pdev;
>> +     platform_set_drvdata(pdev, hva);
>> +
>> +     mutex_init(&hva->lock);
>> +
>> +     /* probe hardware */
>> +     ret = hva_hw_probe(pdev, hva);
>> +     if (ret)
>> +             goto err;
>> +
>> +     /* register all available encoders */
>> +     register_encoders(hva);
>> +
>> +     /* register all supported formats */
>> +     register_formats(hva);
>> +
>> +     /* register on V4L2 */
>> +     ret = v4l2_device_register(dev, &hva->v4l2_dev);
>> +     if (ret) {
>> +             dev_err(dev, "%s %s failed to register V4L2 device\n",
>> +                     HVA_PREFIX, HVA_NAME);
>> +             goto err_hw;
>> +     }
>> +
>> +     /* continuous memory allocator */
>> +     hva->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>> +     if (IS_ERR(hva->alloc_ctx)) {
>> +             ret = PTR_ERR(hva->alloc_ctx);
>> +             goto err_v4l2;
>> +     }
>> +
>> +     hva->work_queue = create_workqueue(HVA_NAME);
>> +     if (!hva->work_queue) {
>> +             dev_err(dev, "%s %s failed to allocate work queue\n",
>> +                     HVA_PREFIX, HVA_NAME);
>> +             ret = -ENOMEM;
>> +             goto err_vb2_dma;
>> +     }
>> +
>> +     /* register device */
>> +     ret = hva_register_device(hva);
>> +     if (ret)
>> +             goto err_work_queue;
>> +
>> +     dev_info(dev, "%s %s registered as /dev/video%d\n", HVA_PREFIX,
>> +              HVA_NAME, hva->vdev->num);
>> +
>> +     return 0;
>> +
>> +err_work_queue:
>> +     destroy_workqueue(hva->work_queue);
>> +err_vb2_dma:
>> +     vb2_dma_contig_cleanup_ctx(hva->alloc_ctx);
>> +err_v4l2:
>> +     v4l2_device_unregister(&hva->v4l2_dev);
>> +err_hw:
>> +     hva_hw_remove(hva);
>> +err:
>> +     return ret;
>> +}
>> +
>> +static int hva_remove(struct platform_device *pdev)
>> +{
>> +     struct hva_dev *hva = platform_get_drvdata(pdev);
>> +     struct device *dev = hva_to_dev(hva);
>> +
>> +     hva_unregister_device(hva);
>> +
>> +     destroy_workqueue(hva->work_queue);
>> +
>> +     vb2_dma_contig_cleanup_ctx(hva->alloc_ctx);
>> +
>> +     hva_hw_remove(hva);
>> +
>> +     v4l2_device_unregister(&hva->v4l2_dev);
>> +
>> +     dev_info(dev, "%s %s removed\n", HVA_PREFIX, pdev->name);
>> +
>> +     return 0;
>> +}
>> +
>> +/* PM ops */
>> +static const struct dev_pm_ops hva_pm_ops = {
>> +     .runtime_suspend        = hva_hw_runtime_suspend,
>> +     .runtime_resume         = hva_hw_runtime_resume,
>> +};
>> +
>> +static const struct of_device_id hva_match_types[] = {
>> +     {
>> +      .compatible = "st,sti-hva",
>> +     },
>> +     { /* end node */ }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, hva_match_types);
>> +
>> +struct platform_driver hva_driver = {
>> +     .probe  = hva_probe,
>> +     .remove = hva_remove,
>> +     .driver = {
>> +             .name           = HVA_NAME,
>> +             .owner          = THIS_MODULE,
>> +             .of_match_table = hva_match_types,
>> +             .pm             = &hva_pm_ops,
>> +             },
>
> Wrong indentation?
>

Done in version 3.

>> +};
>> +
>> +module_platform_driver(hva_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
>> +MODULE_DESCRIPTION("HVA video encoder V4L2 driver");
>
> Regards,
>
>          Hans
>
