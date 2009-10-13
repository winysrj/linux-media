Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58806 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZJMP23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:28:29 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DFRnYx022530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:27:51 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9DFRmJ2022056
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 20:57:48 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 13 Oct 2009 20:57:46 +0530
Subject: RE: [PATCH 5/6] Davinci VPFE Capture: Add support for Control ioctls
Message-ID: <19F8576C6E063C45BE387C64729E73940436DB2130@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255446614-16847-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255446614-16847-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Tuesday, October 13, 2009 8:40 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 5/6] Davinci VPFE Capture: Add support for Control
> ioctls
> 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Added support for Control IOCTL,
> 	- s_ctrl
> 	- g_ctrl
> 	- queryctrl
> 
[Hiremath, Vaibhav] I am in the process of cleaning up of support for AM3517 Capture driver, which is almost same as DM6446 CCDC. Then I would want to finish up with OMAP3 Display driver part before moving to Media Controller support for MEM-to-MEM (like, Resizer).

Just FYI, I will be going for vacation for 1 & 1/2 week starting from coming Friday. But I will make sure that I will submit patches for Display (OMAP3 & AM3517) and AM3517 Capture driver before that.

Thanks,
Vaibhav
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/davinci/vpfe_capture.c |   43
> ++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c
> b/drivers/media/video/davinci/vpfe_capture.c
> index abe21e4..f77d99b 100644
> --- a/drivers/media/video/davinci/vpfe_capture.c
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -1368,6 +1368,46 @@ static int vpfe_g_std(struct file *file, void
> *priv, v4l2_std_id *std_id)
>  	return 0;
>  }
> 
> +static int vpfe_queryctrl(struct file *file, void *priv,
> +		struct v4l2_queryctrl *qctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +	int ret = 0;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >grp_id,
> +					 core, queryctrl, qctrl);
> +
> +	if (ret)
> +		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
> +
> +	return 0;
> +}
> +
> +static int vpfe_g_ctrl(struct file *file, void *priv, struct
> v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >grp_id,
> +					 core, g_ctrl, ctrl);
> +}
> +
> +static int vpfe_s_ctrl(struct file *file, void *priv, struct
> v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >grp_id,
> +					 core, s_ctrl, ctrl);
> +}
> +
>  /*
>   *  Videobuf operations
>   */
> @@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops
> vpfe_ioctl_ops = {
>  	.vidioc_querystd	 = vpfe_querystd,
>  	.vidioc_s_std		 = vpfe_s_std,
>  	.vidioc_g_std		 = vpfe_g_std,
> +	.vidioc_queryctrl	 = vpfe_queryctrl,
> +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
>  	.vidioc_reqbufs		 = vpfe_reqbufs,
>  	.vidioc_querybuf	 = vpfe_querybuf,
>  	.vidioc_qbuf		 = vpfe_qbuf,
> --
> 1.6.2.4

