Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37985 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752711AbcISKPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 06:15:06 -0400
Subject: Re: [PATCH v2 4/8] media: vidc: encoder: add video encoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-5-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <18374b1c-f3b3-4eda-6c05-cf364b1bef81@xs4all.nl>
Date: Mon, 19 Sep 2016 12:15:01 +0200
MIME-Version: 1.0
In-Reply-To: <1473248229-5540-5-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many of my review comments for the decoder apply to the encoder as well,
so I won't repeat those.

On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
> This adds encoder part of the driver plus encoder controls.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/vidc/venc.c       | 1252 +++++++++++++++++++++++++
>  drivers/media/platform/qcom/vidc/venc.h       |   29 +
>  drivers/media/platform/qcom/vidc/venc_ctrls.c |  396 ++++++++
>  drivers/media/platform/qcom/vidc/venc_ctrls.h |   23 +
>  4 files changed, 1700 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/vidc/venc.c
>  create mode 100644 drivers/media/platform/qcom/vidc/venc.h
>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.h
> 
> diff --git a/drivers/media/platform/qcom/vidc/venc.c b/drivers/media/platform/qcom/vidc/venc.c
> new file mode 100644
> index 000000000000..3b65f851a807
> --- /dev/null
> +++ b/drivers/media/platform/qcom/vidc/venc.c
> @@ -0,0 +1,1252 @@

<snip>

> +static int venc_s_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	return -EINVAL;
> +}

Huh? Either remove this, or implement this correctly.

<snip>

> +static int venc_subscribe_event(struct v4l2_fh *fh,
> +				const struct  v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_EOS:
> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subscribe(fh, sub);

These two events aren't used in this driver AFAICT, so this can be dropped.

Since that leaves just V4L2_EVENT_CTRL this function can be replaced by
v4l2_ctrl_subscribe_event().

Regards,

	Hans


> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subscribe_event(fh, sub);
> +	default:
> +		return -EINVAL;
> +	}
> +}

