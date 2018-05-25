Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50096 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965284AbeEYJGm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 05:06:42 -0400
Subject: Re: [PATCH] media: v4l2-ioctl: prevent underflow in v4l_enumoutput()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20180517090550.GB4250@mwanda>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <054ede38-b194-d1f9-7961-851c8b1acd5f@xs4all.nl>
Date: Fri, 25 May 2018 11:06:33 +0200
MIME-Version: 1.0
In-Reply-To: <20180517090550.GB4250@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/05/18 11:05, Dan Carpenter wrote:
> My Smatch allmodconfig build only detects one function implementing
> vpbe_device_ops->enum_outputs and that's vpbe_enum_outputs().  The
> problem really happens in that function when we do:
> 
> 	int temp_index = output->index;
> 
> 	if (temp_index >= cfg->num_outputs)
> 		return -EINVAL;
> 
> Unfortunately, both temp_index and cfg->num_outputs are type int so we
> have a potential read before the start of the array if "temp_index" is
> negative.

Why not fix it in this driver? Make num_outputs unsigned, as it should be.

I really don't like having a random index check in the core. If we ever
want to do such things in the core, then it needs to be implemented
consistently for all ioctls that do something similar.

Regards,

	Hans

> 
> I could have fixed the bug in that function but it's more secure and
> future proof to block that bug earlier in a central place.  There is no
> one who need p->index to be more than INT_MAX.
> 
> Fixes: 66715cdc3224 ("[media] davinci vpbe: VPBE display driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index a40dbec271f1..115757ab8bc0 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1099,6 +1099,9 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
>  	if (is_valid_ioctl(vfd, VIDIOC_S_STD))
>  		p->capabilities |= V4L2_OUT_CAP_STD;
>  
> +	if (p->index > INT_MAX)
> +		return -EINVAL;
> +
>  	return ops->vidioc_enum_output(file, fh, p);
>  }
>  
> 
