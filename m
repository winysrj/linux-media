Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38021 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750864AbdE2KJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 06:09:03 -0400
Subject: Re: [PATCH v2 1/2] v4l: async: check for v4l2_dev in
 v4l2_async_notifier_register()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20170524000727.12936-1-niklas.soderlund@ragnatech.se>
 <20170524000727.12936-2-niklas.soderlund@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6ed1abd-7028-377d-ea94-2e26e00abf4c@xs4all.nl>
Date: Mon, 29 May 2017 12:08:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170524000727.12936-2-niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2017 02:07 AM, Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Add a check for v4l2_dev to v4l2_async_notifier_register() as to fail as
> early as possible since this will fail later in v4l2_async_test_notify().
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>   drivers/media/v4l2-core/v4l2-async.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index cbd919d4edd27e17..c16200c88417b151 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -148,7 +148,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>   	struct v4l2_async_subdev *asd;
>   	int i;
>   
> -	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> +	if (!v4l2_dev || !notifier->num_subdevs ||
> +	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>   		return -EINVAL;
>   
>   	notifier->v4l2_dev = v4l2_dev;
> 
