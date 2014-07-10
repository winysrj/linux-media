Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46630 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaGJOQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 10:16:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3.1 3/3] smiapp: Implement the test pattern control
Date: Thu, 10 Jul 2014 16:16:34 +0200
Message-ID: <5511635.TPPjsMejby@avalon>
In-Reply-To: <1401376614-7525-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-4-git-send-email-sakari.ailus@linux.intel.com> <1401376614-7525-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 29 May 2014 18:16:54 Sakari Ailus wrote:
> Add support for the V4L2_CID_TEST_PATTERN control. When the solid colour
> mode is selected, additional controls become available for setting the
> solid four solid colour components.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Please see below for a minor comment.

> ---
> since v3:
> - Remove redundant definition of smiapp_ctrl_ops.
> 
> - Initialise min, max and default in control creation time.
> 
>  drivers/media/i2c/smiapp/smiapp-core.c | 75 +++++++++++++++++++++++++++++--
>  drivers/media/i2c/smiapp/smiapp.h      |  4 ++
>  2 files changed, 75 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 446c82c..4ac7780 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c

[snip]

> @@ -535,6 +572,19 @@ static int smiapp_init_controls(struct smiapp_sensor
> *sensor) &sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
>  		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
> 
> +	v4l2_ctrl_new_std_menu_items(&sensor->pixel_array->ctrl_handler,
> +				     &smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(smiapp_test_patterns) - 1,
> +				     0, 0, smiapp_test_patterns);
> +
> +	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
> +		sensor->test_data[i] =
> +			v4l2_ctrl_new_std(
> +				&sensor->pixel_array->ctrl_handler,
> +				&smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN_RED + i,
> +				0, (1 << sensor->csi_format->width) - 1, 1,
> +				(1 << sensor->csi_format->width) - 1);

I would have used a local variable assigned to (1 << sensor->csi_format-
>width) - 1 outside of the loop.

> +
>  	if (sensor->pixel_array->ctrl_handler.error) {
>  		dev_err(&client->dev,
>  			"pixel array controls initialization failed (%d)\n",

-- 
Regards,

Laurent Pinchart

