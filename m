Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34053 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJERRY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:17:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10-v6so8979816lfj.1
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 03:19:16 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 5 Oct 2018 12:19:14 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        snawrocki@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 01/11] v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE
Message-ID: <20181005101913.GR24305@bigcity.dyn.berto.se>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <20181005074911.47574-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005074911.47574-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your work.

On 2018-10-05 09:49:01 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Drop the deprecated _ACTIVE part.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 7de041bae84f..9c2370e4d05c 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2212,9 +2212,9 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>  
>  	/* crop means compose for output devices */
>  	if (V4L2_TYPE_IS_OUTPUT(p->type))
> -		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> +		s.target = V4L2_SEL_TGT_COMPOSE;
>  	else
> -		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> +		s.target = V4L2_SEL_TGT_CROP;
>  
>  	ret = v4l_g_selection(ops, file, fh, &s);
>  
> @@ -2239,9 +2239,9 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>  
>  	/* crop means compose for output devices */
>  	if (V4L2_TYPE_IS_OUTPUT(p->type))
> -		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> +		s.target = V4L2_SEL_TGT_COMPOSE;
>  	else
> -		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> +		s.target = V4L2_SEL_TGT_CROP;
>  
>  	return v4l_s_selection(ops, file, fh, &s);
>  }
> -- 
> 2.18.0
> 

-- 
Regards,
Niklas Söderlund
