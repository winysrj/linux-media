Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36144 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbcKNMiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 07:38:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/2] media: Add a driver for the ov5645 camera sensor.
Date: Mon, 14 Nov 2016 14:38:02 +0200
Message-ID: <5871917.9Xm98D97nL@avalon>
In-Reply-To: <1479119076-26363-3-git-send-email-todor.tomov@linaro.org>
References: <1479119076-26363-1-git-send-email-todor.tomov@linaro.org> <1479119076-26363-3-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Thank you for the patch.

On Monday 14 Nov 2016 12:24:36 Todor Tomov wrote:
> The ov5645 sensor from Omnivision supports up to 2592x1944
> and CSI2 interface.
> 
> The driver adds support for the following modes:
> - 1280x960
> - 1920x1080
> - 2592x1944
> 
> Output format is packed 8bit UYVY.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/i2c/Kconfig  |   12 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/ov5645.c | 1352 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1365 insertions(+)
>  create mode 100644 drivers/media/i2c/ov5645.c

[snip]

> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> new file mode 100644
> index 0000000..2b33bc6
> --- /dev/null
> +++ b/drivers/media/i2c/ov5645.c

[snip]

> +static const struct ov5645_mode_info *
> +ov5645_find_nearest_mode(unsigned int width, unsigned int height)
> +{
> +       unsigned int i;
> +
> +       for (i = ARRAY_SIZE(ov5645_mode_info_data) - 1; i >= 0; i--) {
> +               if (ov5645_mode_info_data[i].width <= width &&
> +                   ov5645_mode_info_data[i].height <= height)
> +                       break;
> +       }
> +
> +       if (i < 0)

i needs to be int for this condition to be true.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +               i = 0;
> +
> +       return &ov5645_mode_info_data[i];
> +}

-- 
Regards,

Laurent Pinchart

