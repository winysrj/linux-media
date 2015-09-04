Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38211 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832AbbIDLhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 07:37:03 -0400
Message-ID: <55E98220.1080801@xs4all.nl>
Date: Fri, 04 Sep 2015 13:36:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/3] rcar_vin: call g_std() instead of querystd()
References: <6015647.cjLjRfTWc7@wasted.cogentembedded.com> <2719391.j5OZOaG8ai@wasted.cogentembedded.com>
In-Reply-To: <2719391.j5OZOaG8ai@wasted.cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2015 01:18 AM, Sergei Shtylyov wrote:
> Hans Verkuil says: "The only place querystd can be called  is in the QUERYSTD
> ioctl, all other ioctls should use the last set standard." So call the g_std()
> subdevice method instead of querystd() in the driver's set_fmt() method.
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1589,8 +1589,8 @@ static int rcar_vin_set_fmt(struct soc_c
>  		field = pix->field;
>  		break;
>  	case V4L2_FIELD_INTERLACED:
> -		/* Query for standard if not explicitly mentioned _TB/_BT */
> -		ret = v4l2_subdev_call(sd, video, querystd, &std);
> +		/* Get the last standard if not explicitly mentioned _TB/_BT */
> +		ret = v4l2_subdev_call(sd, video, g_std, &std);
>  		if (ret == -ENOIOCTLCMD) {
>  			field = V4L2_FIELD_NONE;
>  		} else if (ret < 0) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

