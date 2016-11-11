Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38295 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754782AbcKKLnp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 06:43:45 -0500
Subject: Re: [PATCH v3 5/9] media: venus: venc: add video encoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-6-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5e918c07-c3fb-262a-5c9e-11014cdb0eb0@xs4all.nl>
Date: Fri, 11 Nov 2016 12:43:39 +0100
MIME-Version: 1.0
In-Reply-To: <1478540043-24558-6-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments I made before about start_streaming and the use of struct venus_ctrl
apply here as well and I won't repeat them.

On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
> This adds encoder part of the driver plus encoder controls.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c       | 1212 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/venc.h       |   32 +
>  drivers/media/platform/qcom/venus/venc_ctrls.c |  396 ++++++++
>  3 files changed, 1640 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/venus/venc.c
>  create mode 100644 drivers/media/platform/qcom/venus/venc.h
>  create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> new file mode 100644
> index 000000000000..35572eaffb9e
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/venc.c

<snip>

> +static int
> +venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
> +{
> +	struct venus_inst *inst = to_inst(file);
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		if (s->r.width != inst->out_width ||
> +		    s->r.height != inst->out_height ||
> +		    s->r.top != 0 || s->r.left != 0)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

Why implement s_selection if I can't change the selection?

> +
> +static int
> +venc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
> +{
> +	struct vb2_queue *queue = to_vb2q(file, b->type);
> +
> +	if (!queue)
> +		return -EINVAL;
> +
> +	return vb2_reqbufs(queue, b);
> +}

Use the m2m helpers if at all possible.

Regards,

	Hans
