Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:56460 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754077AbdCTOS4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:18:56 -0400
Subject: Re: [PATCH v10 2/2] media: i2c: Add support for OV5647 sensor.
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1488798062.git.roliveir@synopsys.com>
 <67b5055a198316f74c5c1339e14a9f18a4106e69.1488798062.git.roliveir@synopsys.com>
CC: <CARLOS.PALMINHA@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <c6cb6827-e52d-0e6f-4e73-0b0c51522043@mentor.com>
Date: Mon, 20 Mar 2017 16:16:12 +0200
MIME-Version: 1.0
In-Reply-To: <67b5055a198316f74c5c1339e14a9f18a4106e69.1488798062.git.roliveir@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On 03/06/2017 01:16 PM, Ramiro Oliveira wrote:
> The OV5647 sensor from Omnivision supports up to 2592x1944 @ 15 fps, RAW 8
> and RAW 10 output formats, and MIPI CSI-2 interface.
> 
> The driver adds support for 640x480 RAW 8.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>

All updates are fine, thank you. Feel free to add my

Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

> ---
>  MAINTAINERS                |   7 +
>  drivers/media/i2c/Kconfig  |  11 +
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/ov5647.c | 636 +++++++++++++++++++++++++++++++++++++++++++++

I see this version has 100 LoC less in comparison to v8, good result.

[snip]

> +
> +static const struct v4l2_subdev_pad_ops ov5647_subdev_pad_ops = {
> +	.enum_mbus_code =	ov5647_enum_mbus_code,

Nitpicking, above it's better to swap tab and space symbols around '='.

> +};
> +
> +static const struct v4l2_subdev_ops ov5647_subdev_ops = {
> +	.core		= &ov5647_subdev_core_ops,
> +	.video		= &ov5647_subdev_video_ops,
> +	.pad		= &ov5647_subdev_pad_ops,
> +};
> +

--
With best wishes,
Vladimir
