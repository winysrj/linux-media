Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:60026 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049Ab2EIHmA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 03:42:00 -0400
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jiaquan Su <jqsu@marvell.com>, Angela Wan <jwan@marvell.com>,
	Bin Zhou <zhoub@marvell.com>
Date: Wed, 9 May 2012 00:39:50 -0700
Subject: RE: [PATCH 1/2] V4L: soc-camera: switch to using the existing
 .enum_framesizes()
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D015E3B3AD62@SC-VEXCH2.marvell.com>
References: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch! I am ok with it.

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
> Sent: Wednesday, May 09, 2012 5:01 AM
> To: Linux Media Mailing List
> Cc: Qing Xu
> Subject: [PATCH 1/2] V4L: soc-camera: switch to using the existing .enum_framesizes()
> 
> The recently introduced .enum_mbus_fsizes() v4l2-subdev video operation is
> a duplicate of the .enum_framesizes() operation, introduced earlier. Switch
> soc-camera over to using the original one.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Qing Xu <qingx@marvell.com>
> ---
>  drivers/media/video/soc_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index b08696f..6707df4 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -1259,7 +1259,7 @@ static int default_enum_framesizes(struct soc_camera_device *icd,
>  	/* map xlate-code to pixel_format, sensor only handle xlate-code*/
>  	fsize_mbus.pixel_format = xlate->code;
>  
> -	ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, &fsize_mbus);
> +	ret = v4l2_subdev_call(sd, video, enum_framesizes, &fsize_mbus);
>  	if (ret < 0)
>  		return ret;
>  
> -- 
> 1.7.2.5
