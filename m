Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46075 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751686AbdBMMkP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 07:40:15 -0500
Subject: Re: [PATCH v3 3/7] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1486479757-32128-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <af2baebb-96af-728d-8801-5fe8e2eadca8@xs4all.nl>
Date: Mon, 13 Feb 2017 13:40:07 +0100
MIME-Version: 1.0
In-Reply-To: <1486479757-32128-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

A few little nitpicks:

On 02/07/2017 04:02 PM, Ramesh Shanmugasundaram wrote:
> This patch adds driver support for the MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  Documentation/media/v4l-drivers/index.rst   |    1 +
>  Documentation/media/v4l-drivers/max2175.rst |   60 ++
>  drivers/media/i2c/Kconfig                   |    4 +
>  drivers/media/i2c/Makefile                  |    2 +
>  drivers/media/i2c/max2175/Kconfig           |    8 +
>  drivers/media/i2c/max2175/Makefile          |    4 +
>  drivers/media/i2c/max2175/max2175.c         | 1438 +++++++++++++++++++++++++++
>  drivers/media/i2c/max2175/max2175.h         |  108 ++
>  8 files changed, 1625 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/max2175.rst
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
> 

<snip>

> +
> +static const struct v4l2_ctrl_config max2175_i2s_en = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_I2S_ENABLE,
> +	.name = "I2S Enable",
> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +	.def = 1,
> +};
> +
> +/*
> + * HSLS value control LO freq adjacent location configuration.
> + * Refer to Documentation/media/v4l-drivers/max2175 for more details.
> + */
> +static const struct v4l2_ctrl_config max2175_hsls = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_HSLS,
> +	.name = "HSLS above/below desired",

The convention is that the descriptions of controls follow the English 'title' rules
w.r.t. caps. See v4l2-ctrls.c.

This would become: "HSLS Above/Below Desired".

> +	.type = V4L2_CTRL_TYPE_INTEGER,

Shouldn't this be a boolean control?

> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +	.def = 1,
> +};
> +
> +/*
> + * Rx modes below are a set of preset configurations that decides the tuner's
> + * sck and sample rate of transmission. They are separate for EU & NA regions.
> + * Refer to Documentation/media/v4l-drivers/max2175 for more details.
> + */
> +static const char * const max2175_ctrl_eu_rx_modes[] = {
> +	[MAX2175_EU_FM_1_2]	= "EU FM 1.2",
> +	[MAX2175_DAB_1_2]	= "DAB 1.2",
> +};
> +
> +static const char * const max2175_ctrl_na_rx_modes[] = {
> +	[MAX2175_NA_FM_1_0]	= "NA FM 1.0",
> +	[MAX2175_NA_FM_2_0]	= "NA FM 2.0",
> +};
> +
> +static const struct v4l2_ctrl_config max2175_eu_rx_mode = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_RX_MODE,
> +	.name = "RX MODE",

MODE -> Mode.

> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = ARRAY_SIZE(max2175_ctrl_eu_rx_modes) - 1,
> +	.def = 0,
> +	.qmenu = max2175_ctrl_eu_rx_modes,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_na_rx_mode = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_RX_MODE,
> +	.name = "RX MODE",

Ditto.

> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = ARRAY_SIZE(max2175_ctrl_na_rx_modes) - 1,
> +	.def = 0,
> +	.qmenu = max2175_ctrl_na_rx_modes,
> +};
> +

Regards,

	Hans
