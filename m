Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32982 "EHLO
        mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753091AbcHWDff (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 23:35:35 -0400
Received: by mail-pa0-f52.google.com with SMTP id ti13so43673677pac.0
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 20:35:34 -0700 (PDT)
Date: Mon, 22 Aug 2016 20:35:31 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 6/8] media: vidc: add Venus HFI files
Message-ID: <20160823033531.GB26240@tuxbot>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-7-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471871619-25873-7-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 22 Aug 06:13 PDT 2016, Stanimir Varbanov wrote:

> Here is the implementation of Venus video accelerator low-level
> functionality. It contanins code which setup the registers and
> startup uthe processor, allocate and manipulates with the shared
> memory used for sending commands and receiving messages.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/vidc/hfi_venus.c    | 1539 +++++++++++++++++++++++
>  drivers/media/platform/qcom/vidc/hfi_venus.h    |   25 +
>  drivers/media/platform/qcom/vidc/hfi_venus_io.h |   98 ++
>  3 files changed, 1662 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.c
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus.h
>  create mode 100644 drivers/media/platform/qcom/vidc/hfi_venus_io.h
> 
> diff --git a/drivers/media/platform/qcom/vidc/hfi_venus.c b/drivers/media/platform/qcom/vidc/hfi_venus.c
[..]
> +
> +static const struct hfi_ops venus_hfi_ops = {
> +	.core_init			= venus_hfi_core_init,
> +	.core_deinit			= venus_hfi_core_deinit,
> +	.core_ping			= venus_hfi_core_ping,
> +	.core_trigger_ssr		= venus_hfi_core_trigger_ssr,
> +
> +	.session_init			= venus_hfi_session_init,
> +	.session_end			= venus_hfi_session_end,
> +	.session_abort			= venus_hfi_session_abort,
> +	.session_flush			= venus_hfi_session_flush,
> +	.session_start			= venus_hfi_session_start,
> +	.session_stop			= venus_hfi_session_stop,
> +	.session_etb			= venus_hfi_session_etb,
> +	.session_ftb			= venus_hfi_session_ftb,
> +	.session_set_buffers		= venus_hfi_session_set_buffers,
> +	.session_release_buffers	= venus_hfi_session_release_buffers,
> +	.session_load_res		= venus_hfi_session_load_res,
> +	.session_release_res		= venus_hfi_session_release_res,
> +	.session_parse_seq_hdr		= venus_hfi_session_parse_seq_hdr,
> +	.session_get_seq_hdr		= venus_hfi_session_get_seq_hdr,
> +	.session_set_property		= venus_hfi_session_set_property,
> +	.session_get_property		= venus_hfi_session_get_property,
> +
> +	.resume				= venus_hfi_resume,
> +	.suspend			= venus_hfi_suspend,
> +
> +	.isr				= venus_isr,
> +	.isr_thread			= venus_isr_thread,
> +};
> +
> +void venus_hfi_destroy(struct hfi_core *hfi)
> +{
> +	struct venus_hfi_device *hdev = to_hfi_priv(hfi);
> +
> +	venus_interface_queues_release(hdev);
> +	mutex_destroy(&hdev->lock);
> +	kfree(hdev);
> +}
> +
> +int venus_hfi_create(struct hfi_core *hfi, const struct vidc_resources *res,
> +		     void __iomem *base)
> +{

Rather than having the core figure out which *_hfi_create() to call I
think this should be the probe() entry point, calling into the core
registering the venus_hfi_ops - a common-probe() in the hfi/vidc core
could still do most of the heavy lifting.

Probing the driver up from the transport rather than for the highest
logical layer allows us to inject a separate hfi_ops for the apr tal
case.

> +	struct venus_hfi_device *hdev;
> +	int ret;
> +
> +	hdev = kzalloc(sizeof(*hdev), GFP_KERNEL);
> +	if (!hdev)
> +		return -ENOMEM;
> +
> +	mutex_init(&hdev->lock);
> +
> +	hdev->res = res;
> +	hdev->pkt_ops = hfi->pkt_ops;
> +	hdev->packetization_type = HFI_PACKETIZATION_LEGACY;
> +	hdev->base = base;
> +	hdev->dev = hfi->dev;
> +	hdev->suspended = true;
> +
> +	hfi->priv = hdev;
> +	hfi->ops = &venus_hfi_ops;
> +	hfi->core_caps = VIDC_ENC_ROTATION_CAPABILITY |
> +			 VIDC_ENC_SCALING_CAPABILITY |
> +			 VIDC_ENC_DEINTERLACE_CAPABILITY |
> +			 VIDC_DEC_MULTI_STREAM_CAPABILITY;
> +
> +	ret = venus_interface_queues_init(hdev);
> +	if (ret)
> +		goto err_kfree;
> +
> +	return 0;
> +
> +err_kfree:
> +	kfree(hdev);
> +	hfi->priv = NULL;
> +	hfi->ops = NULL;
> +	return ret;
> +}

I'll try to find some time to do a more detailed review of the
implementation.

Regards,
Bjorn
