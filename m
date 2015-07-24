Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33759 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbbGXOPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:15:37 -0400
Message-ID: <55B24840.5000508@xs4all.nl>
Date: Fri, 24 Jul 2015 16:14:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 09/13] media: soc_camera: soc_scale_crop: Use correct
 pad number in try_fmt
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-10-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-10-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> Fix calls to subdev try_fmt function to use valid pad numbers, fixing
> the case where subdevs (eg. ADV7612) have valid pad numbers that are
> non-zero.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/soc_camera/soc_scale_crop.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
> index bda29bc..2772215 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -225,6 +225,7 @@ static int client_set_fmt(struct soc_camera_device *icd,
>  	bool host_1to1;
>  	int ret;
>  
> +	format->pad = icd->src_pad_idx;
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					 soc_camera_grp_id(icd), pad,
>  					 set_fmt, NULL, format);
> 

