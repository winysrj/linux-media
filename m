Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34802 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752312AbdGCLY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 07:24:59 -0400
Subject: Re: [PATCH v2 09/19] media: camms: Add core files
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-10-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20c81ca2-09f4-b0c9-a72a-1e39f861cfb5@xs4all.nl>
Date: Mon, 3 Jul 2017 13:24:54 +0200
MIME-Version: 1.0
In-Reply-To: <1497883719-12410-10-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 04:48 PM, Todor Tomov wrote:
> These files implement the platform driver code.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>   drivers/media/platform/qcom/camss-8x16/camss.c | 630 +++++++++++++++++++++++++
>   drivers/media/platform/qcom/camss-8x16/camss.h |  96 ++++
>   2 files changed, 726 insertions(+)
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
> new file mode 100644
> index 0000000..a8798d1
> --- /dev/null
> +++ b/drivers/media/platform/qcom/camss-8x16/camss.c
> @@ -0,0 +1,630 @@
> +/*
> + * camss.c
> + *
> + * Qualcomm MSM Camera Subsystem - Core
> + *
> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + * Copyright (C) 2015-2016 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/clk.h>
> +#include <linux/media-bus-format.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +
> +#include <media/media-device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mc.h>
> +#include <media/v4l2-of.h>

v4l2-of.h has been replaced by v4l2-fwnode.h. You need to rebase.

Regards,

	Hans
