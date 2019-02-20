Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B153C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EB12147A
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfBTI4c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:56:32 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33670 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfBTI4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 03:56:31 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wNg0gqGbyLMwIwNg3gt5Yi; Wed, 20 Feb 2019 09:56:29 +0100
Subject: Re: [PATCH v14 05/13] media: staging/imx7: add MIPI CSI-2 receiver
 subdev for i.MX7
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
 <20190206151328.21629-6-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6c6c0e29-d65b-3796-578c-2e3e6f742d11@xs4all.nl>
Date:   Wed, 20 Feb 2019 09:56:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190206151328.21629-6-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOpf2xG0nWqaZ41Erg9+obfNGohpWnKiciWmYG+7CMi19cmCH4gRuLTZSFAjm+BZfvLYYAUiWml+KzTu7MeFZZgXjle3a4ujUVOqPAClgap/xODZOo2L
 7SYbvGLplV4uriZ45XuUcp8DdSGxIG2wzTXQJhzdt/p4aZ2R87UrCRq8+MeJj0uXHhqyYFQDN+Vg8lk7PFTFGDGy5EER7Whttbf11bbbQU1NGcQQF0X9mf8L
 S7xchk6Zmk0qA/liJUFCF15gDX4cKQCzNXsTbskyDc7CxEv0ZgsA6SrqjSElfMN2jNFrrS3FUNN6WG+5bFZgzklVme9ixyIBx5zDzppcamsVxz1MB+HFfu8t
 jwo5cUx575YBjrLhNkBwV8p7Y9+nrpw6U0yz6Oqe4C1hcqKMiOyhLpf1CP+VLEZuW2hAmGD7w3ZsHQwSBsKi+iZF9//4KA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/6/19 4:13 PM, Rui Miguel Silva wrote:
> Adds MIPI CSI-2 subdev for i.MX7 to connect with sensors with a MIPI
> CSI-2 interface.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/Makefile         |    1 +
>  drivers/staging/media/imx/imx7-mipi-csis.c | 1186 ++++++++++++++++++++
>  2 files changed, 1187 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 074f016d3519..d2d909a36239 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -14,3 +14,4 @@ obj-$(CONFIG_VIDEO_IMX_CSI) += imx-media-csi.o
>  obj-$(CONFIG_VIDEO_IMX_CSI) += imx6-mipi-csi2.o
>  
>  obj-$(CONFIG_VIDEO_IMX7_CSI) += imx7-media-csi.o
> +obj-$(CONFIG_VIDEO_IMX7_CSI) += imx7-mipi-csis.o
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
> new file mode 100644
> index 000000000000..516d308dc44b
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -0,0 +1,1186 @@

<snip>

> +static int mipi_csi_registered(struct v4l2_subdev *mipi_sd)
> +{
> +	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < CSIS_PADS_NUM; i++) {
> +		state->pads[i].flags = (i == CSIS_PAD_SINK) ?
> +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +	}
> +
> +	/* set a default mbus format  */
> +	ret = imx_media_init_mbus_fmt(&state->format_mbus,
> +				      MIPI_CSIS_DEF_PIX_HEIGHT,
> +				      MIPI_CSIS_DEF_PIX_WIDTH, 0,
> +				      V4L2_FIELD_NONE, NULL);
> +	if (ret)
> +		return ret;
> +
> +	return media_entity_pads_init(&mipi_sd->entity, CSIS_PADS_NUM,
> +				      state->pads);
> +}
> +
> +static const struct v4l2_subdev_core_ops mipi_csis_core_ops = {
> +	.log_status	= mipi_csis_log_status,
> +};
> +
> +static const struct media_entity_operations mipi_csis_entity_ops = {
> +	.link_setup	= mipi_csis_link_setup,
> +	.link_validate	= v4l2_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_video_ops mipi_csis_video_ops = {
> +	.s_stream	= mipi_csis_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops mipi_csis_pad_ops = {
> +	.init_cfg		= mipi_csis_init_cfg,
> +	.get_fmt		= mipi_csis_get_fmt,
> +	.set_fmt		= mipi_csis_set_fmt,
> +};
> +
> +static const struct v4l2_subdev_ops mipi_csis_subdev_ops = {
> +	.core	= &mipi_csis_core_ops,
> +	.video	= &mipi_csis_video_ops,
> +	.pad	= &mipi_csis_pad_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops mipi_csis_internal_ops = {
> +	.registered = mipi_csi_registered,
> +};

This struct is not used, and therefor mipi_csi_registered() is never called
either. Should it be called or can this be removed?

Regards,

	Hans
