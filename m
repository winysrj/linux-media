Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2G2Nzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jul 2012 09:55:37 -0400
Date: Sun, 29 Jul 2012 15:55:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-media@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH, RESEND] ov9640: fix missing break
In-Reply-To: <20120724155032.4082.19950.stgit@bluebook>
Message-ID: <Pine.LNX.4.64.1207291553470.18471@axis700.grange>
References: <20120724155032.4082.19950.stgit@bluebook>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan

On Tue, 24 Jul 2012, Alan Cox wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> Without this rev2 ends up behaving as rev3
> 
> Reported-by: dcb314@hotmail.com
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44081
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Thanks, I'll push this for 3.6, and will ask Mauro to push this to stable 
too.

Thanks
Guennadi

> ---
> 
>  drivers/media/video/ov9640.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
> index 23412de..9ed4ba4 100644
> --- a/drivers/media/video/ov9640.c
> +++ b/drivers/media/video/ov9640.c
> @@ -605,6 +605,7 @@ static int ov9640_video_probe(struct i2c_client *client)
>  		devname		= "ov9640";
>  		priv->model	= V4L2_IDENT_OV9640;
>  		priv->revision	= 2;
> +		break;
>  	case OV9640_V3:
>  		devname		= "ov9640";
>  		priv->model	= V4L2_IDENT_OV9640;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
