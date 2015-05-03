Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50098 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbbECKVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 06:21:44 -0400
Message-ID: <5545F6AE.1000607@xs4all.nl>
Date: Sun, 03 May 2015 12:21:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com
CC: laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

Thank you for the patch!

I have one high-level comment: please rename the source to r-car-jpu.c. It's
good practice to start with the SoC name since 'jpu' by itself is not very
descriptive.

I have a few more comments (mostly easy ones) below:

On 04/29/2015 11:53 PM, Mikhail Ulyanov wrote:
> Here's the the driver for the Renesas R-Car JPEG processing unit driver.
> 
> The driver is implemented within the V4L2 framework as a mem-to-mem device.  It
> presents two video nodes to userspace, one for the encoding part, and one for
> the decoding part.
> 
> It was found that the only working mode for encoding is no markers output, so we
> generate it with software. In current version of driver we also use software
> JPEG header parsing because with hardware parsing performance is lower then
> desired.
> 
> From a userspace point of view the encoding process is typical (S_FMT, REQBUF,
> optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
> queues. The decoding process requires that the source queue performs S_FMT,
> REQBUF, (QUERYBUF), QBUF and STREAMON. After STREAMON on the source queue, it is
> possible to perform G_FMT on the destination queue to find out the processed
> image width and height in order to be able to allocate an appropriate buffer -
> it is assumed that the user does not pass the compressed image width and height
> but instead this information is parsed from the JPEG input. This is done in
> kernel. Then REQBUF, QBUF and STREAMON on the destination queue complete the
> decoding and it is possible to DQBUF from both queues and finish the operation.
> 
> During encoding the available formats are: V4L2_PIX_FMT_NV12M and
> V4L2_PIX_FMT_NV16M for source and V4L2_PIX_FMT_JPEG for destination.
> 
> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
> V4L2_PIX_FMT_NV12M and V4L2_PIX_FMT_NV16M for destination.
> 
> Performance of current version:
> 1280x800 NV12 image encoding/decoding
> 	decoding ~121 FPS
> 	encoding ~190 FPS
> 
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
> Changes since v2:
>     - Kconfig entry reordered
>     - unnecessary clk_disable_unprepare(jpu->clk) removed
>     - ref_count fixed in jpu_resume
>     - enable DMABUF in src_vq->io_modes
>     - remove jpu_s_priority jpu_g_priority
>     - jpu_g_selection fixed
>     - timeout in jpu_reset added and hardware reset reworked
>     - remove unused macros
>     - JPEG header parsing now is software because of performance issues
>       based on s5p-jpu code
>     - JPEG header generation redesigned:
>       JPEG header(s) pre-generated and memcpy'ed on encoding
>       we only fill the necessary fields
>       more "transparent" header format description
>     - S_FMT, G_FMT and TRY_FMT hooks redesigned
>       partially inspired by VSP1 driver code
>     - some code was reformatted
>     - image formats handling redesigned
>     - multi-planar V4L2 API now in use
>     - now passes v4l2-compliance tool check
> 
> Cnanges since v1:
>     - s/g_fmt function simplified
>     - default format for queues added
>     - dumb vidioc functions added to be in compliance with standard api:
>         jpu_s_priority, jpu_g_priority
>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>       now in use by the same reason
> 
>  drivers/media/platform/Kconfig  |   11 +
>  drivers/media/platform/Makefile |    1 +
>  drivers/media/platform/jpu.c    | 1724 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1736 insertions(+)
>  create mode 100644 drivers/media/platform/jpu.c
> 

<snip>

> diff --git a/drivers/media/platform/jpu.c b/drivers/media/platform/jpu.c
> new file mode 100644
> index 0000000..6c658cc
> --- /dev/null
> +++ b/drivers/media/platform/jpu.c

<snip>

> +/**
> + * struct jpu - JPEG IP abstraction
> + * @mutex: the mutex protecting this structure
> + * @lock: spinlock protecting the device contexts
> + * @v4l2_dev: v4l2 device for mem2mem mode
> + * @vfd_encoder: video device node for encoder mem2mem mode
> + * @vfd_decoder: video device node for decoder mem2mem mode
> + * @m2m_dev: v4l2 mem2mem device data
> + * @regs: JPEG IP registers mapping
> + * @irq: JPEG IP irq
> + * @clk: JPEG IP clock
> + * @dev: JPEG IP struct device
> + * @alloc_ctx: videobuf2 memory allocator's context
> + * @ref_counter: reference counter
> + */
> +struct jpu {
> +	struct mutex	mutex;
> +	spinlock_t	lock;
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd_encoder;
> +	struct video_device	*vfd_decoder;

Please just embed these video_device structs (so remove the '*'). This means
that the release callback of each video_device should be set to
video_device_release_empty() and that the video_device_alloc/release can be
removed.

The use of video_device_alloc/release is deprecated and will eventually
disappear.

> +	struct v4l2_m2m_dev	*m2m_dev;
> +
> +	void __iomem		*regs;
> +	unsigned int		irq;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	void			*alloc_ctx;
> +	int			ref_count;
> +};
> +

<snip>

> +static struct jpu_fmt jpu_formats[] = {
> +	{ "JPEG JFIF", V4L2_PIX_FMT_JPEG, V4L2_COLORSPACE_JPEG,
> +	  {0, 0}, 0, 0, 0, 1, JPU_ENC_CAPTURE | JPU_DEC_OUTPUT },
> +	{ "YUV 4:2:2 planar, Y/CbCr", V4L2_PIX_FMT_NV16M, V4L2_COLORSPACE_SRGB,
> +	  {8, 16}, 2, 2, JPU_JPEG_422, 2, JPU_ENC_OUTPUT | JPU_DEC_CAPTURE },
> +	{ "YUV 4:2:0 planar, Y/CbCr", V4L2_PIX_FMT_NV12M, V4L2_COLORSPACE_SRGB,
> +	  {8, 16}, 2, 2, JPU_JPEG_420, 2, JPU_ENC_OUTPUT | JPU_DEC_CAPTURE }
> +};

Drop the 'name' field: the v4l2 core will now fill in the format description
based on the fourcc value. This change was merged a few days ago in the media_tree
repo.

<snip>

> +static int jpu_enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> +{
> +	unsigned int i, num = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(jpu_formats); ++i) {
> +		if (jpu_formats[i].types & type) {
> +			if (num == f->index)
> +				break;
> +			++num;
> +		}
> +	}
> +
> +	if (i >= ARRAY_SIZE(jpu_formats))
> +		return -EINVAL;
> +
> +	strlcpy(f->description, jpu_formats[i].name, sizeof(f->description));

So this line can be dropped as well.

> +	f->pixelformat = jpu_formats[i].fourcc;
> +
> +	return 0;
> +}

<snip>

> +static int jpu_g_selection(struct file *file, void *priv,
> +			   struct v4l2_selection *s)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.width = ctx->out_q.format.width;
> +		s->r.height = ctx->out_q.format.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r.width = ctx->cap_q.format.width;
> +		s->r.height = ctx->cap_q.format.height;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	s->r.left = 0;
> +	s->r.top = 0;
> +	return 0;
> +}

Why do you implement g_selection? You cannot crop or compose, so what's the point?

The code is wrong anyway since it does not check s->type. CROP for a CAPTURE vs an
OUTPUT buffer should result in different values.

<snip>

> +static int jpu_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	return 0;
> +}
> +
> +static void jpu_stop_streaming(struct vb2_queue *q)
> +{
> +}

You can drop these empty start/stop functions.

> +
> +static struct vb2_ops jpu_qops = {
> +	.queue_setup		= jpu_queue_setup,
> +	.buf_prepare		= jpu_buf_prepare,
> +	.buf_queue		= jpu_buf_queue,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +	.start_streaming	= jpu_start_streaming,
> +	.stop_streaming		= jpu_stop_streaming,
> +};
> +

<snip>

Regards,

	Hans
