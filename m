Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55210 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759585AbcISKMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 06:12:53 -0400
Subject: Re: [PATCH v2 3/8] media: vidc: decoder: add video decoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-4-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <92676ec7-ff83-5216-afd7-c9bfd8005d9d@xs4all.nl>
Date: Mon, 19 Sep 2016 12:12:43 +0200
MIME-Version: 1.0
In-Reply-To: <1473248229-5540-4-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
> This consists of video decoder implementation plus decoder
> controls.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/vidc/vdec.c       | 1091 +++++++++++++++++++++++++
>  drivers/media/platform/qcom/vidc/vdec.h       |   29 +
>  drivers/media/platform/qcom/vidc/vdec_ctrls.c |  200 +++++
>  drivers/media/platform/qcom/vidc/vdec_ctrls.h |   21 +
>  4 files changed, 1341 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.c
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.h
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.h
> 

<snip>

> +static int vdec_event_notify(struct hfi_inst *hfi_inst, u32 event,
> +			     struct hfi_event_data *data)
> +{
> +	struct vidc_inst *inst = hfi_inst->ops_priv;
> +	struct device *dev = inst->core->dev;
> +	const struct v4l2_event ev = { .type = V4L2_EVENT_SOURCE_CHANGE };

1) this can be static
2) set the u.src_change.changes as well.

<snip>
