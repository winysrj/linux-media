Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:46925 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755461AbdJIXlY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 19:41:24 -0400
Received: by mail-qt0-f169.google.com with SMTP id 1so6335641qtn.3
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 16:41:24 -0700 (PDT)
Message-ID: <1507592477.24615.4.camel@ndufresne.ca>
Subject: Re: [PATCH 2/2] media: venus: venc: fix bytesused v4l2_plane field
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 09 Oct 2017 19:41:17 -0400
In-Reply-To: <20171009122458.3053-2-stanimir.varbanov@linaro.org>
References: <20171009122458.3053-1-stanimir.varbanov@linaro.org>
         <20171009122458.3053-2-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I confirm this works properly now. This was tested with GStreamer with
the following command:

  gst-launch-1.0 videotestsrc ! v4l2vp8enc ! v4l2vp8dec ! kmssink

And the following patch, which is work in progress to implement
data_offset.

  https://gitlab.collabora.com/nicolas/gst-plugins-good/commit/aaedee9a37e396657568a70fc0110375e14fb4fa

Le lundi 09 octobre 2017 à 15:24 +0300, Stanimir Varbanov a écrit :
> This fixes wrongly filled bytesused field of v4l2_plane structure
> by include data_offset in the plane, Also fill data_offset and
> bytesused for capture type of buffers only.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

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
>  	} else {
>  		vbuf->sequence = inst->sequence_out++;
>  	}
