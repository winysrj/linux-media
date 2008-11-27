Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARN0XZx017487
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 18:00:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mARN0Kkr032185
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 18:00:20 -0500
Date: Fri, 28 Nov 2008 00:00:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1227554928-25471-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811272343480.8230@axis700.grange>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
	<1227554928-25471-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2] pxa_camera: use the new translation structure
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 24 Nov 2008, Robert Jarzmik wrote:

> The new translation structure enables to build the format
> list with buswidth, depth, host format and camera format
> checked, so that it's not done anymore on try_fmt nor
> set_fmt.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Ok, this one looks good to me. Only two small nitpicks, the first one was 
actually my mistake in the beginning:

>  static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
> -				  const struct soc_camera_data_format **fmt)
> +				  struct soc_camera_format_xlate *xlate)
>  {
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> -	struct pxa_camera_dev *pcdev = ici->priv;
> -	int formats = 0;
> +	int formats = 0, buswidth, ret;
> +
> +	buswidth = required_buswidth(icd->formats + idx);
> +
> +	if (!depth_supported(icd, buswidth))

I think, this function would be better named buswicth_supported().

>  		}
>  	}
>  
>  	return formats;
>  }
>  
> +
>  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  			      __u32 pixfmt, struct v4l2_rect *rect)
>  {
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);

Let's stay at one blank line between functions:-)


So, just please revert the current_fmt change and submit these two patches 
integrating mine into them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
