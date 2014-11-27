Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55170 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0TK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 14:10:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Takanari Hayama <taki@igel.co.jp>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 1/2] v4l: vsp1: Reset VSP1 RPF source address
Date: Thu, 27 Nov 2014 21:11:24 +0200
Message-ID: <2583371.5EOVSDHmFc@avalon>
In-Reply-To: <1417051502-30169-2-git-send-email-taki@igel.co.jp>
References: <1417051502-30169-1-git-send-email-taki@igel.co.jp> <1417051502-30169-2-git-send-email-taki@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hayama-san,

Thank you for the patch.

On Thursday 27 November 2014 10:25:01 Takanari Hayama wrote:
> Source address of VSP1 RPF needs to be reset whenever crop offsets are
> recalculated.
> 
> This correctly reflects a crop setting even VIDIOC_QBUF is called
> before VIDIOIC_STREAMON is called.
> 
> Signed-off-by: Takanari Hayama <taki@igel.co.jp>
> ---
>  drivers/media/platform/vsp1/vsp1_rpf.c  | 15 +++++++++++++++
>  drivers/media/platform/vsp1/vsp1_rwpf.h |  2 ++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index d14d26b..79c0db8 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -106,11 +106,22 @@ static int rpf_s_stream(struct v4l2_subdev *subdev,
> int enable) + crop->left * fmtinfo->bpp[0] / 8;
>  	pstride = format->plane_fmt[0].bytesperline
>  		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
> +
> +	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
> +		       rpf->buf_addr[0] + rpf->offsets[0]);
> +
>  	if (format->num_planes > 1) {
>  		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
>  				+ crop->left * fmtinfo->bpp[1] / 8;
>  		pstride |= format->plane_fmt[1].bytesperline
>  			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
> +
> +		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
> +			       rpf->buf_addr[1] + rpf->offsets[1]);
> +
> +		if (format->num_planes > 2)
> +			vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
> +				       rpf->buf_addr[2] + rpf->offsets[1]);
>  	}
> 
>  	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
> @@ -179,6 +190,10 @@ static void rpf_vdev_queue(struct vsp1_video *video,
>  			   struct vsp1_video_buffer *buf)
>  {
>  	struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
> +	int i;

Nitpicking, i is always positive and should be unsigned int.

> +
> +	for (i = 0; i < 3; i++)
> +		rpf->buf_addr[i] = buf->addr[i];

How about adding

        if (!vsp1_entity_is_streaming(&rpf->entity))
                return;

here to avoid configuring the hardware with random offsets if s_stream hasn't 
been called yet ?

If you're fine with those changes I'll modify the patch when applying, there's 
no need to resubmit.

>  	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
>  		       buf->addr[0] + rpf->offsets[0]);
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h
> b/drivers/media/platform/vsp1/vsp1_rwpf.h index 28dd9e7..1c793bc 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -39,6 +39,8 @@ struct vsp1_rwpf {
>  	struct v4l2_rect crop;
> 
>  	unsigned int offsets[2];
> +
> +	dma_addr_t buf_addr[3];
>  };
> 
>  static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)

-- 
Regards,

Laurent Pinchart

