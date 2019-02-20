Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478CC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC94206B7
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEFX/Izq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfBTL0s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:26:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39269 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfBTL0s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:26:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so24444098wrw.6;
        Wed, 20 Feb 2019 03:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ewMAyHFgxegsNn8WJ7dm4gQ67b4uTuabOcJHl6cUDf4=;
        b=fEFX/IzqwgPCi82p9xBdYypdx4rDrslSD8YTyWemO/fovVk8dYU3g+P/DTiV/GSWld
         cWjj1FhbFh8OylfXH5PrHIIWlsrokZxtdUA+oBz0LxLfGST2n/46Jb1UqlOMzjNVi+aJ
         DngOERlP9ufeiSEuz9mBxJn4d8RL/CXktxJY0czbnu7xobjFG+MzXz5HId+U+HqVpk9v
         Sk96+jyzyDh5JLMQw1PLtdObzmMQJsxRWIorMlrG5hUTIFN45KF2tFExl6zAnFwGMnkE
         jpsVk8Db1YQk4BH7QdYD4lpjafV7s/QxdFtfpSzM1jPlifh3KQvA7Yigmcm6lwqkYjOx
         Djhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ewMAyHFgxegsNn8WJ7dm4gQ67b4uTuabOcJHl6cUDf4=;
        b=BLiVpbp+j8Tb6pyjg4aBe3D3YqO3VOm2TaqiHAZnZFvuxyfzJNe+DVGbX8ikJWZjLO
         6a96GAt/T+OFkNIRbqBRUPGncWbffyKVSI1UoXRR9ZFyQ/sYptjTrFKWOMaeURG/8w54
         TIDBSbtd/l5+jNf6Q0K5QL6BA1H3GerUCj1rGldC1KKMIh5mWjG4A3wJFBY7G4O1gnKP
         rJf+b/B4XBhVcZ+aKQwoP1HjmQFYPPQeNqhjhvj8yWsits0Y960HDJ5GlABu6UhdADhA
         aCC311ie3E/Yijkgw+TCI/8PJYcvxpM2TDkhrNnOgG+juE/HUi/VDLcpG5XQkIq+psda
         7GDA==
X-Gm-Message-State: AHQUAuYeOZEAlv2/fppfujGp7/Ie6W0k9XL46a3VbicKoRqVv8IVhKph
        WFskAh/jbeuAregEIY3FlWhDSDjKlsKpAw==
X-Google-Smtp-Source: AHgI3IadDJJ/+Ii+rKJMv36mT28Ybb0PXDfKLAVufABI4GBa7+GBh9kQYnhzLRjIG6nMiwqAPlEXMQ==
X-Received: by 2002:adf:b601:: with SMTP id f1mr10602010wre.158.1550662005926;
        Wed, 20 Feb 2019 03:26:45 -0800 (PST)
Received: from arch-late ([87.196.73.87])
        by smtp.gmail.com with ESMTPSA id b4sm8608716wmj.3.2019.02.20.03.26.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 03:26:45 -0800 (PST)
References: <20190206151328.21629-1-rui.silva@linaro.org> <20190206151328.21629-6-rui.silva@linaro.org> <6c6c0e29-d65b-3796-578c-2e3e6f742d11@xs4all.nl>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v14 05/13] media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
In-reply-to: <6c6c0e29-d65b-3796-578c-2e3e6f742d11@xs4all.nl>
Date:   Wed, 20 Feb 2019 11:26:42 +0000
Message-ID: <m35zteu2dp.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,
On Wed 20 Feb 2019 at 08:56, Hans Verkuil wrote:
> On 2/6/19 4:13 PM, Rui Miguel Silva wrote:
>> Adds MIPI CSI-2 subdev for i.MX7 to connect with sensors with a 
>> MIPI
>> CSI-2 interface.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/staging/media/imx/Makefile         |    1 +
>>  drivers/staging/media/imx/imx7-mipi-csis.c | 1186 
>>  ++++++++++++++++++++
>>  2 files changed, 1187 insertions(+)
>>  create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c
>> 
>> diff --git a/drivers/staging/media/imx/Makefile 
>> b/drivers/staging/media/imx/Makefile
>> index 074f016d3519..d2d909a36239 100644
>> --- a/drivers/staging/media/imx/Makefile
>> +++ b/drivers/staging/media/imx/Makefile
>> @@ -14,3 +14,4 @@ obj-$(CONFIG_VIDEO_IMX_CSI) += 
>> imx-media-csi.o
>>  obj-$(CONFIG_VIDEO_IMX_CSI) += imx6-mipi-csi2.o
>>  
>>  obj-$(CONFIG_VIDEO_IMX7_CSI) += imx7-media-csi.o
>> +obj-$(CONFIG_VIDEO_IMX7_CSI) += imx7-mipi-csis.o
>> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c 
>> b/drivers/staging/media/imx/imx7-mipi-csis.c
>> new file mode 100644
>> index 000000000000..516d308dc44b
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
>> @@ -0,0 +1,1186 @@
>
> <snip>
>
>> +static int mipi_csi_registered(struct v4l2_subdev *mipi_sd)
>> +{
>> +	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < CSIS_PADS_NUM; i++) {
>> +		state->pads[i].flags = (i == CSIS_PAD_SINK) ?
>> +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
>> +	}
>> +
>> +	/* set a default mbus format  */
>> +	ret = imx_media_init_mbus_fmt(&state->format_mbus,
>> +				      MIPI_CSIS_DEF_PIX_HEIGHT,
>> +				      MIPI_CSIS_DEF_PIX_WIDTH, 0,
>> +				      V4L2_FIELD_NONE, NULL);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return media_entity_pads_init(&mipi_sd->entity, 
>> CSIS_PADS_NUM,
>> +				      state->pads);
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops mipi_csis_core_ops = 
>> {
>> +	.log_status	= mipi_csis_log_status,
>> +};
>> +
>> +static const struct media_entity_operations 
>> mipi_csis_entity_ops = {
>> +	.link_setup	= mipi_csis_link_setup,
>> +	.link_validate	= v4l2_subdev_link_validate,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops mipi_csis_video_ops 
>> = {
>> +	.s_stream	= mipi_csis_s_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops mipi_csis_pad_ops = {
>> +	.init_cfg		= mipi_csis_init_cfg,
>> +	.get_fmt		= mipi_csis_get_fmt,
>> +	.set_fmt		= mipi_csis_set_fmt,
>> +};
>> +
>> +static const struct v4l2_subdev_ops mipi_csis_subdev_ops = {
>> +	.core	= &mipi_csis_core_ops,
>> +	.video	= &mipi_csis_video_ops,
>> +	.pad	= &mipi_csis_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops 
>> mipi_csis_internal_ops = {
>> +	.registered = mipi_csi_registered,
>> +};
>
> This struct is not used, and therefor mipi_csi_registered() is 
> never called
> either. Should it be called or can this be removed?

Good question :), I will get back to you on this one later.

---
Cheers,
	Rui

