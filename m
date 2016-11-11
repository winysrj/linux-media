Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60630 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755938AbcKKLjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 06:39:16 -0500
Subject: Re: [PATCH v3 4/9] media: venus: vdec: add video decoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <63a91a5a-a97b-f3df-d16d-c8f76bf20c30@xs4all.nl>
Date: Fri, 11 Nov 2016 12:39:11 +0100
MIME-Version: 1.0
In-Reply-To: <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I made some comments about start_streaming in my review of patch 3/9, so
I am not going to repeat that here.

On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
> This consists of video decoder implementation plus decoder
> controls.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c       | 1108 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/vdec.h       |   32 +
>  drivers/media/platform/qcom/venus/vdec_ctrls.c |  197 +++++
>  3 files changed, 1337 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.c
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.h
>  create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> new file mode 100644
> index 000000000000..3f0eba7e31dc
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/vdec.c

<snip>

> +static int
> +vdec_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
> +{
> +	struct venus_inst *inst = to_inst(file);
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP:
> +		return -EINVAL;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		return -EINVAL;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		s->r.width = inst->out_width;
> +		s->r.height = inst->out_height;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	s->r.top = 0;
> +	s->r.left = 0;
> +
> +	return 0;
> +}

This can be simplified to just:

	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
	    s->target != V4L2_SEL_TGT_COMPOSE)
		return -EINVAL;

	// handle the remaining capture compose case

> +
> +static int
> +vdec_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
> +{
> +	struct vb2_queue *queue = to_vb2q(file, b->type);
> +
> +	if (!queue)
> +		return -EINVAL;
> +
> +	return vb2_reqbufs(queue, b);
> +}

Is there any reason why the v4l2_m2m_ioctl_reqbufs et al helper functions
can't be used? I strongly recommend that, unless there is a specific reason
why that won't work.

<snip>

Regards,

	Hans
