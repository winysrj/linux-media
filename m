Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45254 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbKIVCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 16:02:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ravinder Atla <rednivaralat@gmail.com>
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
	hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	s.nawrocki@samsung.com, mahfouz.saif.elyazal@gmail.com,
	boris.brezillon@free-electrons.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	navyasri.tech@gmail.com
Subject: Re: [PATCH] /media/davinci_vpfe/dm365_resizer.c:Bug containing more than 80 characters  in a line is fixed.
Date: Mon, 09 Nov 2015 23:02:55 +0200
Message-ID: <4372933.SL7MiC5krz@avalon>
In-Reply-To: <1439999096-3496-1-git-send-email-rednivaralat@gmail.com>
References: <1439999096-3496-1-git-send-email-rednivaralat@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ravinder,

Thank you for the patch.

I'm afraid the patch doesn't apply on top of the mainline kernel.

On Wednesday 19 August 2015 21:14:56 Ravinder Atla wrote:
> Signed-off-by: Ravinder Atla <rednivaralat@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> b/drivers/staging/media/davinci_vpfe/dm365_resizer.c index 6218230..273aea3
> 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -1393,8 +1393,8 @@ resizer_try_format(struct v4l2_subdev *sd, struct
> v4l2_subdev_pad_config *cfg, * return -EINVAL or zero on success
>   */
>  static int resizer_set_format(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *
> -					fmt)
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *fmt)
>  {
>  	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
>  	struct v4l2_mbus_framefmt *format;
> @@ -1454,8 +1454,8 @@ static int resizer_set_format(struct v4l2_subdev *sd,
>   * return -EINVAL or zero on success
>   */
>  static int resizer_get_format(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *
> -				fmt)
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *fmt)
>  {
>  	struct v4l2_mbus_framefmt *format;

-- 
Regards,

Laurent Pinchart

