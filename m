Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47314 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755503AbdLOOWK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:22:10 -0500
Subject: Re: [PATCH 2/2] media: coda: Add i.MX51 (CodaHx4) support
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
 <20171213140918.22500-2-p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e26f7f6a-afa6-c55c-d94e-095df27c19ae@xs4all.nl>
Date: Fri, 15 Dec 2017 15:22:07 +0100
MIME-Version: 1.0
In-Reply-To: <20171213140918.22500-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 13/12/17 15:09, Philipp Zabel wrote:
> Add support for the CodaHx4 VPU used on i.MX51.
> 
> Decoding h.264, MPEG-4, and MPEG-2 video works, as well as encoding
> h.264. MPEG-4 encoding is not enabled, it currently produces visual
> artifacts.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-bit.c    | 45 ++++++++++++++++++++++---------
>  drivers/media/platform/coda/coda-common.c | 44 +++++++++++++++++++++++++++---
>  drivers/media/platform/coda/coda.h        |  1 +
>  3 files changed, 74 insertions(+), 16 deletions(-)
> 

<snip>

> +	[CODA_IMX51] = {
> +		.firmware     = {
> +			"vpu_fw_imx51.bin",
> +			"vpu/vpu_fw_imx51.bin",
> +			"v4l-codahx4-imx51.bin"
> +		},
> +		.product      = CODA_HX4,
> +		.codecs       = codahx4_codecs,
> +		.num_codecs   = ARRAY_SIZE(codahx4_codecs),
> +		.vdevs        = codahx4_video_devices,
> +		.num_vdevs    = ARRAY_SIZE(codahx4_video_devices),
> +		.workbuf_size = 128 * 1024,
> +		.tempbuf_size = 304 * 1024,
> +		.iram_size    = 0x14000,
> +	},

What's the status of the firmware? Is it going to be available in some firmware
repository? I remember when testing other imx devices that it was a bit tricky
to get hold of the firmware. And googling v4l-codahx4-imx51.bin doesn't find
anything other than this patch.

Regards,

	Hans
