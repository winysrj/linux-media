Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33932 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbbDXGoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 02:44:03 -0400
Message-ID: <5539E615.4090902@xs4all.nl>
Date: Fri, 24 Apr 2015 08:43:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] vivid: add 1080p capture at 2 fps and 5 fps to
 webcam emulation
References: <1429797174-32474-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1429797174-32474-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch, but I have one question:

On 04/23/2015 03:52 PM, Philipp Zabel wrote:
> Use the VIVID_WEBCAM_SIZES constant where appropriate and add a 1920x1080 pixel
> frame size setting with frame rates of 2 fps and 5 fps.

Why add both 2 and 5 fps? Is there a reason why you want both of those fps values?

Just wondering.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 867a29a..468b8b5 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -60,7 +60,7 @@ static const struct vivid_fmt formats_ovl[] = {
>  };
>  
>  /* The number of discrete webcam framesizes */
> -#define VIVID_WEBCAM_SIZES 3
> +#define VIVID_WEBCAM_SIZES 4
>  /* The number of discrete webcam frameintervals */
>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>  
> @@ -69,6 +69,7 @@ static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>  	{  320, 180 },
>  	{  640, 360 },
>  	{ 1280, 720 },
> +	{ 1920, 1080 },
>  };
>  
>  /*
> @@ -76,6 +77,8 @@ static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>   * elements in this array as there are in webcam_sizes.
>   */
>  static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
> +	{  1, 2 },
> +	{  1, 5 },
>  	{  1, 10 },
>  	{  1, 15 },
>  	{  1, 25 },
> @@ -715,8 +718,8 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
>  					webcam_sizes[i].height == mp->height)
>  				break;
>  		dev->webcam_size_idx = i;
> -		if (dev->webcam_ival_idx >= 2 * (3 - i))
> -			dev->webcam_ival_idx = 2 * (3 - i) - 1;
> +		if (dev->webcam_ival_idx >= 2 * (VIVID_WEBCAM_SIZES - i))
> +			dev->webcam_ival_idx = 2 * (VIVID_WEBCAM_SIZES - i) - 1;
>  		vivid_update_format_cap(dev, false);
>  	} else {
>  		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
> @@ -1684,7 +1687,7 @@ int vidioc_enum_frameintervals(struct file *file, void *priv,
>  			break;
>  	if (i == ARRAY_SIZE(webcam_sizes))
>  		return -EINVAL;
> -	if (fival->index >= 2 * (3 - i))
> +	if (fival->index >= 2 * (VIVID_WEBCAM_SIZES - i))
>  		return -EINVAL;
>  	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>  	fival->discrete = webcam_intervals[fival->index];
> @@ -1714,7 +1717,7 @@ int vivid_vid_cap_s_parm(struct file *file, void *priv,
>  			  struct v4l2_streamparm *parm)
>  {
>  	struct vivid_dev *dev = video_drvdata(file);
> -	unsigned ival_sz = 2 * (3 - dev->webcam_size_idx);
> +	unsigned ival_sz = 2 * (VIVID_WEBCAM_SIZES - dev->webcam_size_idx);
>  	struct v4l2_fract tpf;
>  	unsigned i;
>  
> 

