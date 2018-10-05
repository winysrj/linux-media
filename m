Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35366 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbeJERm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:42:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id o14-v6so11206636ljj.2
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 03:44:41 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 5 Oct 2018 12:44:39 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        snawrocki@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/11] v4l2-ioctl: add QUIRK_INVERTED_CROP
Message-ID: <20181005104439.GT24305@bigcity.dyn.berto.se>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <20181005074911.47574-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005074911.47574-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your patch.

On 2018-10-05 09:49:03 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some old Samsung drivers use the legacy crop API incorrectly:
> the crop and compose targets are swapped. Normally VIDIOC_G_CROP
> will return the CROP rectangle of a CAPTURE stream and the COMPOSE
> rectangle of an OUTPUT stream.
> 
> The Samsung drivers do the opposite. Note that these drivers predate
> the selection API.
> 
> If this 'QUIRK' flag is set, then the v4l2-ioctl core will swap
> the CROP and COMPOSE targets as well.
> 
> That way backwards compatibility is ensured and we can convert the
> Samsung drivers to the selection API.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I understand the need for this quirk but it make my head hurt :-)

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 17 ++++++++++++++++-
>  include/media/v4l2-dev.h             | 13 +++++++++++--
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 9c2370e4d05c..63a92285de39 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2200,6 +2200,7 @@ static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
>  static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> +	struct video_device *vfd = video_devdata(file);
>  	struct v4l2_crop *p = arg;
>  	struct v4l2_selection s = {
>  		.type = p->type,
> @@ -2216,6 +2217,10 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>  	else
>  		s.target = V4L2_SEL_TGT_CROP;
>  
> +	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
> +		s.target = s.target == V4L2_SEL_TGT_COMPOSE ?
> +			V4L2_SEL_TGT_CROP : V4L2_SEL_TGT_COMPOSE;
> +
>  	ret = v4l_g_selection(ops, file, fh, &s);
>  
>  	/* copying results to old structure on success */
> @@ -2227,6 +2232,7 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
>  static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> +	struct video_device *vfd = video_devdata(file);
>  	struct v4l2_crop *p = arg;
>  	struct v4l2_selection s = {
>  		.type = p->type,
> @@ -2243,12 +2249,17 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>  	else
>  		s.target = V4L2_SEL_TGT_CROP;
>  
> +	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
> +		s.target = s.target == V4L2_SEL_TGT_COMPOSE ?
> +			V4L2_SEL_TGT_CROP : V4L2_SEL_TGT_COMPOSE;
> +
>  	return v4l_s_selection(ops, file, fh, &s);
>  }
>  
>  static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> +	struct video_device *vfd = video_devdata(file);
>  	struct v4l2_cropcap *p = arg;
>  	struct v4l2_selection s = { .type = p->type };
>  	int ret = 0;
> @@ -2285,13 +2296,17 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>  	else
>  		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
>  
> +	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
> +		s.target = s.target == V4L2_SEL_TGT_COMPOSE_BOUNDS ?
> +			V4L2_SEL_TGT_CROP_BOUNDS : V4L2_SEL_TGT_COMPOSE_BOUNDS;
> +
>  	ret = v4l_g_selection(ops, file, fh, &s);
>  	if (ret)
>  		return ret;
>  	p->bounds = s.r;
>  
>  	/* obtaining defrect */
> -	if (V4L2_TYPE_IS_OUTPUT(p->type))
> +	if (s.target == V4L2_SEL_TGT_COMPOSE_BOUNDS)
>  		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
>  	else
>  		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 456ac13eca1d..48531e57cc5a 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -74,10 +74,19 @@ struct v4l2_ctrl_handler;
>   *	indicates that file->private_data points to &struct v4l2_fh.
>   *	This flag is set by the core when v4l2_fh_init() is called.
>   *	All new drivers should use it.
> + * @V4L2_FL_QUIRK_INVERTED_CROP:
> + *	some old M2M drivers use g/s_crop/cropcap incorrectly: crop and
> + *	compose are swapped. If this flag is set, then the selection
> + *	targets are swapped in the g/s_crop/cropcap functions in v4l2-ioctl.c.
> + *	This allows those drivers to correctly implement the selection API,
> + *	but the old crop API will still work as expected in order to preserve
> + *	backwards compatibility.
> + *	Never set this flag for new drivers.
>   */
>  enum v4l2_video_device_flags {
> -	V4L2_FL_REGISTERED	= 0,
> -	V4L2_FL_USES_V4L2_FH	= 1,
> +	V4L2_FL_REGISTERED		= 0,
> +	V4L2_FL_USES_V4L2_FH		= 1,
> +	V4L2_FL_QUIRK_INVERTED_CROP	= 2,
>  };
>  
>  /* Priority helper functions */
> -- 
> 2.18.0
> 

-- 
Regards,
Niklas Söderlund
