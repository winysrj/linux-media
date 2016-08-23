Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35001 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbcHWDZw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 23:25:52 -0400
Received: by mail-pa0-f51.google.com with SMTP id hb8so25003816pac.2
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 20:25:52 -0700 (PDT)
Date: Mon, 22 Aug 2016 20:25:48 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 5/8] media: vidc: add Host Firmware Interface (HFI)
Message-ID: <20160823032548.GA26240@tuxbot>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-6-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471871619-25873-6-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 22 Aug 06:13 PDT 2016, Stanimir Varbanov wrote:

> This is the implementation of HFI. It is loaded with the
> responsibility to comunicate with the firmware through an
> interface commands and messages.
> 
>  - hfi.c has interface functions used by the core, decoder
> and encoder parts to comunicate with the firmware. For example
> there are functions for session and core initialisation.
> 

I can't help feeling that the split between core.c and hfi.c is a
remnant of a vidc driver supporting both HFI and pre-HFI with the same
v4l code.

What do you think about merging vidc_core with hfi_core and vidc_inst
with hfi_inst? Both seems to be in a 1:1 relationship.

>  - hfi_cmds has packetization operations which preparing
> packets to be send from host to firmware.
> 
>  - hfi_msgs takes care of messages sent from firmware to the
> host.
> 
[..]
> diff --git a/drivers/media/platform/qcom/vidc/hfi_cmds.c b/drivers/media/platform/qcom/vidc/hfi_cmds.c
[..]
> +
> +static const struct hfi_packetization_ops hfi_default = {
> +	.sys_init = pkt_sys_init,
> +	.sys_pc_prep = pkt_sys_pc_prep,
> +	.sys_idle_indicator = pkt_sys_idle_indicator,
> +	.sys_power_control = pkt_sys_power_control,
> +	.sys_set_resource = pkt_sys_set_resource,
> +	.sys_release_resource = pkt_sys_unset_resource,
> +	.sys_debug_config = pkt_sys_debug_config,
> +	.sys_coverage_config = pkt_sys_coverage_config,
> +	.sys_ping = pkt_sys_ping,
> +	.sys_image_version = pkt_sys_image_version,
> +	.ssr_cmd = pkt_ssr_cmd,
> +	.session_init = pkt_session_init,
> +	.session_cmd = pkt_session_cmd,
> +	.session_set_buffers = pkt_session_set_buffers,
> +	.session_release_buffers = pkt_session_release_buffers,
> +	.session_etb_decoder = pkt_session_etb_decoder,
> +	.session_etb_encoder = pkt_session_etb_encoder,
> +	.session_ftb = pkt_session_ftb,
> +	.session_parse_seq_header = pkt_session_parse_seq_header,
> +	.session_get_seq_hdr = pkt_session_get_seq_hdr,
> +	.session_flush = pkt_session_flush,
> +	.session_get_property = pkt_session_get_property,
> +	.session_set_property = pkt_session_set_property,
> +};
> +
> +static const struct hfi_packetization_ops *get_3xx_ops(void)
> +{
> +	static struct hfi_packetization_ops hfi_3xx;
> +
> +	hfi_3xx = hfi_default;
> +	hfi_3xx.session_set_property = pkt_session_set_property_3xx;
> +
> +	return &hfi_3xx;
> +}
> +
> +const struct hfi_packetization_ops *
> +hfi_get_pkt_ops(enum hfi_packetization_type type)

The only reasonable argument I can come up with for not just exposing
these as global functions would be that there are 23 of them... Can we
skip the jump table?

> +{
> +	switch (type) {
> +	case HFI_PACKETIZATION_LEGACY:
> +		return &hfi_default;
> +	case HFI_PACKETIZATION_3XX:
> +		return get_3xx_ops();
> +	}
> +
> +	return NULL;
> +}

Regards,
Bjorn
