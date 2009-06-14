Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3306 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbZFNOYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 10:24:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 8/10 - v2] DM6446 platform changes for vpfe capture driver
Date: Sun, 14 Jun 2009 16:24:04 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <1244739649-27466-8-git-send-email-m-karicheri2@ti.com> <1244739649-27466-9-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244739649-27466-9-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141624.04999.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009 19:00:47 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> 
> DM644x platform and board setup
> 
> This adds plarform and board setup changes required to support
> vpfe capture driver on DM644x
> 
> Added registration of vpss platform driver based on last comment
> 
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to Davinci GIT Tree
> 
>  arch/arm/mach-davinci/board-dm644x-evm.c    |   68 ++++++++++++++++++++++++++-
>  arch/arm/mach-davinci/dm644x.c              |   56 ++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/dm644x.h |    2 +
>  3 files changed, 124 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index d9d4045..13b73a7 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -28,7 +28,8 @@
>  #include <linux/io.h>
>  #include <linux/phy.h>
>  #include <linux/clk.h>
> -
> +#include <linux/videodev2.h>
> +#include <media/tvp514x.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  
> @@ -195,6 +196,57 @@ static struct platform_device davinci_fb_device = {
>  	.num_resources = 0,
>  };
>  
> +#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
> +/* Inputs available at the TVP5146 */
> +static struct v4l2_input tvp5146_inputs[] = {
> +	{
> +		.index = 0,
> +		.name = "COMPOSITE",
> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +		.std = TVP514X_STD_ALL,
> +	},
> +	{
> +		.index = 1,
> +		.name = "SVIDEO",
> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +		.std = TVP514X_STD_ALL,
> +	},

No all-caps.

> +};
> +
> +/*
> + * this is the route info for connecting each input to decoder
> + * ouput that goes to vpfe. There is a one to one correspondence
> + * with tvp5146_inputs
> + */
> +static struct v4l2_routing tvp5146_routes[] = {
> +	{
> +		.input = INPUT_CVBS_VI2B,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +	{
> +		.input = INPUT_SVIDEO_VI2C_VI1C,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +};
> +
> +static struct vpfe_subdev_info vpfe_sub_devs[] = {
> +	{
> +		.name = "tvp5146",
> +		.grp_id = 0,
> +		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
> +		.inputs = tvp5146_inputs,
> +		.routes = tvp5146_routes,
> +		.can_route = 1,
> +	},
> +};

Same remark as for patch 7: suggest using a separate input array.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
