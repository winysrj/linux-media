Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45868 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751184AbdJIMbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 08:31:40 -0400
Subject: Re: [PATCH 2/2] media: venus: venc: fix bytesused v4l2_plane field
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <20171009122458.3053-1-stanimir.varbanov@linaro.org>
 <20171009122458.3053-2-stanimir.varbanov@linaro.org>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5dbda669-6415-6fc5-43d3-37f14ce900c5@xs4all.nl>
Date: Mon, 9 Oct 2017 14:31:37 +0200
MIME-Version: 1.0
In-Reply-To: <20171009122458.3053-2-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 14:24, Stanimir Varbanov wrote:
> This fixes wrongly filled bytesused field of v4l2_plane structure
> by include data_offset in the plane, Also fill data_offset and
> bytesused for capture type of buffers only.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 6f123a387cf9..9445ad492966 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -963,15 +963,16 @@ static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  	if (!vbuf)
>  		return;
>  
> -	vb = &vbuf->vb2_buf;
> -	vb->planes[0].bytesused = bytesused;
> -	vb->planes[0].data_offset = data_offset;
> -
>  	vbuf->flags = flags;
>  
>  	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		vb = &vbuf->vb2_buf;
> +		vb2_set_plane_payload(vb, 0, bytesused + data_offset);
> +		vb->planes[0].data_offset = data_offset;
>  		vb->timestamp = timestamp_us * NSEC_PER_USEC;
>  		vbuf->sequence = inst->sequence_cap++;
> +
> +		WARN_ON(vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0));

It's good to have this, but this really should never happen. Because if it is,
then you'll have a memory overwrite. I hope the DMA engine will prevent this?

Just wondering how this works.

The patch looks good otherwise, but that WARN_ON is a bit scary.

Regards,

	Hans

>  	} else {
>  		vbuf->sequence = inst->sequence_out++;
>  	}
> 
