Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35508 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751437AbcKUOIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:08:11 -0500
Subject: Re: [PATCH v2 10/10] [media] st-delta: debug: trace stream/frame
 information & summary
To: Hugues Fruchet <hugues.fruchet@st.com>, linux-media@vger.kernel.org
References: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
 <1479468336-26199-11-git-send-email-hugues.fruchet@st.com>
Cc: kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e515152-0f70-432e-fe25-c676ad0f5869@xs4all.nl>
Date: Mon, 21 Nov 2016 15:08:08 +0100
MIME-Version: 1.0
In-Reply-To: <1479468336-26199-11-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/11/16 12:25, Hugues Fruchet wrote:
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/sti/delta/Makefile      |  2 +-
>  drivers/media/platform/sti/delta/delta-debug.c | 72 ++++++++++++++++++++++++++
>  drivers/media/platform/sti/delta/delta-debug.h | 18 +++++++
>  drivers/media/platform/sti/delta/delta-v4l2.c  | 29 +++++++++--
>  4 files changed, 116 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/media/platform/sti/delta/delta-debug.c
>  create mode 100644 drivers/media/platform/sti/delta/delta-debug.h
>
> diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
> index 663be70..f95580e 100644
> --- a/drivers/media/platform/sti/delta/Makefile
> +++ b/drivers/media/platform/sti/delta/Makefile
> @@ -1,5 +1,5 @@
>  obj-$(CONFIG_VIDEO_STI_DELTA) := st-delta.o
> -st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o
> +st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o delta-debug.o
>
>  # MJPEG support
>  st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-hdr.o
> diff --git a/drivers/media/platform/sti/delta/delta-debug.c b/drivers/media/platform/sti/delta/delta-debug.c
> new file mode 100644
> index 0000000..f1bc64e
> --- /dev/null
> +++ b/drivers/media/platform/sti/delta/delta-debug.c
> @@ -0,0 +1,72 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Hugues Fruchet <hugues.fruchet@st.com>
> + *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include "delta.h"
> +#include "delta-debug.h"
> +
> +char *delta_streaminfo_str(struct delta_streaminfo *s, char *str,
> +			   unsigned int len)
> +{
> +	if (!s)
> +		return NULL;
> +
> +	snprintf(str, len,
> +		 "%4.4s %dx%d %s %s dpb=%d %s %s %s%dx%d@(%d,%d) %s%d/%d",
> +		 (char *)&s->streamformat, s->width, s->height,
> +		 s->profile, s->level, s->dpb,
> +		 (s->field == V4L2_FIELD_NONE) ? "progressive" : "interlaced",
> +		 s->other,
> +		 s->flags & DELTA_STREAMINFO_FLAG_CROP ? "crop=" : "",
> +		 s->crop.width, s->crop.height,
> +		 s->crop.left, s->crop.top,
> +		 s->flags & DELTA_STREAMINFO_FLAG_PIXELASPECT ? "par=" : "",
> +		 s->pixelaspect.numerator,
> +		 s->pixelaspect.denominator);
> +
> +	return str;
> +}
> +
> +char *delta_frameinfo_str(struct delta_frameinfo *f, char *str,
> +			  unsigned int len)
> +{
> +	if (!f)
> +		return NULL;
> +
> +	snprintf(str, len,
> +		 "%4.4s %dx%d aligned %dx%d %s %s%dx%d@(%d,%d) %s%d/%d",
> +		 (char *)&f->pixelformat, f->width, f->height,
> +		 f->aligned_width, f->aligned_height,
> +		 (f->field == V4L2_FIELD_NONE) ? "progressive" : "interlaced",
> +		 f->flags & DELTA_STREAMINFO_FLAG_CROP ? "crop=" : "",
> +		 f->crop.width, f->crop.height,
> +		 f->crop.left, f->crop.top,
> +		 f->flags & DELTA_STREAMINFO_FLAG_PIXELASPECT ? "par=" : "",
> +		 f->pixelaspect.numerator,
> +		 f->pixelaspect.denominator);
> +
> +	return str;
> +}
> +
> +void delta_trace_summary(struct delta_ctx *ctx)
> +{
> +	struct delta_dev *delta = ctx->dev;
> +	struct delta_streaminfo *s = &ctx->streaminfo;
> +	unsigned char str[100] = "";
> +
> +	if (!(ctx->flags & DELTA_FLAG_STREAMINFO))
> +		return;
> +
> +	dev_info(delta->dev, "%s %s, %d frames decoded, %d frames output, %d frames dropped, %d stream errors, %d decode errors",
> +		 ctx->name,
> +		 delta_streaminfo_str(s, str, sizeof(str)),
> +		 ctx->decoded_frames,
> +		 ctx->output_frames,
> +		 ctx->dropped_frames,
> +		 ctx->stream_errors,
> +		 ctx->decode_errors);
> +}
> diff --git a/drivers/media/platform/sti/delta/delta-debug.h b/drivers/media/platform/sti/delta/delta-debug.h
> new file mode 100644
> index 0000000..955c158
> --- /dev/null
> +++ b/drivers/media/platform/sti/delta/delta-debug.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Hugues Fruchet <hugues.fruchet@st.com>
> + *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef DELTA_DEBUG_H
> +#define DELTA_DEBUG_H
> +
> +char *delta_streaminfo_str(struct delta_streaminfo *s, char *str,
> +			   unsigned int len);
> +char *delta_frameinfo_str(struct delta_frameinfo *f, char *str,
> +			  unsigned int len);
> +void delta_trace_summary(struct delta_ctx *ctx);
> +
> +#endif /* DELTA_DEBUG_H */
> diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
> index 93a0f90..5586a97 100644
> --- a/drivers/media/platform/sti/delta/delta-v4l2.c
> +++ b/drivers/media/platform/sti/delta/delta-v4l2.c
> @@ -17,6 +17,7 @@
>  #include <media/videobuf2-dma-contig.h>
>
>  #include "delta.h"
> +#include "delta-debug.h"
>  #include "delta-ipc.h"
>
>  #define DELTA_NAME	"st-delta"
> @@ -438,11 +439,13 @@ static int delta_g_fmt_stream(struct file *file, void *fh,
>  	struct delta_dev *delta = ctx->dev;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
> +	unsigned char str[100] = "";
>
>  	if (!(ctx->flags & DELTA_FLAG_STREAMINFO))
>  		dev_dbg(delta->dev,
> -			"%s V4L2 GET_FMT (OUTPUT): no stream information available, using default\n",
> -			ctx->name);
> +			"%s V4L2 GET_FMT (OUTPUT): no stream information available, default to %s\n",
> +			ctx->name,
> +			delta_streaminfo_str(streaminfo, str, sizeof(str)));
>
>  	pix->pixelformat = streaminfo->streamformat;
>  	pix->width = streaminfo->width;
> @@ -465,11 +468,13 @@ static int delta_g_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
>  	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
> +	unsigned char str[100] = "";
>
>  	if (!(ctx->flags & DELTA_FLAG_FRAMEINFO))
>  		dev_dbg(delta->dev,
> -			"%s V4L2 GET_FMT (CAPTURE): no frame information available, using default\n",
> -			ctx->name);
> +			"%s V4L2 GET_FMT (CAPTURE): no frame information available, default to %s\n",
> +			ctx->name,
> +			delta_frameinfo_str(frameinfo, str, sizeof(str)));
>
>  	pix->pixelformat = frameinfo->pixelformat;
>  	pix->width = frameinfo->aligned_width;
> @@ -652,6 +657,7 @@ static int delta_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
>  	const struct delta_dec *dec = ctx->dec;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct delta_frameinfo frameinfo;
> +	unsigned char str[100] = "";
>  	struct vb2_queue *vq;
>  	int ret;
>
> @@ -703,6 +709,10 @@ static int delta_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
>
>  	ctx->flags |= DELTA_FLAG_FRAMEINFO;
>  	ctx->frameinfo = frameinfo;
> +	dev_dbg(delta->dev,
> +		"%s V4L2 SET_FMT (CAPTURE): frameinfo updated to %s\n",
> +		ctx->name,
> +		delta_frameinfo_str(&frameinfo, str, sizeof(str)));
>
>  	pix->pixelformat = frameinfo.pixelformat;
>  	pix->width = frameinfo.aligned_width;
> @@ -1321,10 +1331,12 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
>  	struct delta_dev *delta = ctx->dev;
>  	const struct delta_dec *dec = ctx->dec;
>  	struct delta_au *au;
> +	unsigned char str2[100] = "";
>  	int ret = 0;
>  	struct vb2_v4l2_buffer *vbuf = NULL;
>  	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
>  	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
> +	unsigned char str[100] = "";

That's a bit weird that 'str2' comes before 'str'. I suggest grouping 
them together
and renaming 'str' to 'str1'.

>
>  	if ((ctx->state != DELTA_STATE_WF_FORMAT) &&
>  	    (ctx->state != DELTA_STATE_WF_STREAMINFO))
> @@ -1385,6 +1397,10 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
>
>  	ctx->state = DELTA_STATE_READY;
>
> +	dev_info(delta->dev, "%s %s => %s\n", ctx->name,
> +		 delta_streaminfo_str(streaminfo, str, sizeof(str)),
> +		 delta_frameinfo_str(frameinfo, str2, sizeof(str2)));
> +
>  	delta_au_done(ctx, au, ret);
>  	return 0;
>
> @@ -1705,6 +1721,11 @@ static int delta_release(struct file *file)
>  	/* close decoder */
>  	call_dec_op(dec, close, ctx);
>
> +	/* trace a summary of instance
> +	 * before closing (debug purpose)
> +	 */
> +	delta_trace_summary(ctx);
> +
>  	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>
>  	v4l2_fh_del(&ctx->fh);
>

Looks good otherwise!

	Hans
