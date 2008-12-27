Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBRIa91s014877
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 13:36:09 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBRIZtt7031057
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 13:35:55 -0500
Date: Sat, 27 Dec 2008 19:36:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <umyejiigq.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812271820480.4409@axis700.grange>
References: <umyejiigq.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] fix try_fmt calculation method for ov772x driver
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

On Thu, 25 Dec 2008, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

For patches touching more than about 3 lines, a description is very 
helpful (which doesn't mean, of course, that anything below 4 lines needs 
no description:-)). Yes, I understand what you're fixing here, but saying 
something like

Don't modify driver's state in try_fmt, just verify format acceptability 
or adjust it to driver's capabilities.

Would help. If you agree with the above description, please, just ack it 
and I'll insert it for you in the patch. Or you can certainly suggest your 
own description.

Thanks
Guennadi

> ---
>  drivers/media/video/ov772x.c |   55 ++++++++++++++++++++++++++---------------
>  1 files changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index c11be56..380df93 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -767,6 +767,27 @@ static int ov772x_set_register(struct soc_camera_device *icd,
>  }
>  #endif
>  
> +static const struct ov772x_win_size*
> +ov772x_select_win(u32 width, u32 height)
> +{
> +	__u32 diff;
> +	const struct ov772x_win_size *win;
> +
> +	/* default is QVGA */
> +	diff = abs(width - ov772x_win_qvga.width) +
> +		abs(height - ov772x_win_qvga.height);
> +	win = &ov772x_win_qvga;
> +
> +	/* VGA */
> +	if (diff >
> +	    abs(width  - ov772x_win_vga.width) +
> +	    abs(height - ov772x_win_vga.height))
> +		win = &ov772x_win_vga;
> +
> +	return win;
> +}
> +
> +
>  static int ov772x_set_fmt(struct soc_camera_device *icd,
>  			  __u32                     pixfmt,
>  			  struct v4l2_rect         *rect)
> @@ -787,34 +808,28 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
>  		}
>  	}
>  
> +	/*
> +	 * select win
> +	 */
> +	priv->win = ov772x_select_win(rect->width, rect->height);
> +
>  	return ret;
>  }
>  
>  static int ov772x_try_fmt(struct soc_camera_device *icd,
>  			  struct v4l2_format       *f)
>  {
> -	struct v4l2_pix_format *pix  = &f->fmt.pix;
> -	struct ov772x_priv     *priv;
> -
> -	priv = container_of(icd, struct ov772x_priv, icd);
> -
> -	/* QVGA */
> -	if (pix->width  <= ov772x_win_qvga.width ||
> -	    pix->height <= ov772x_win_qvga.height) {
> -		priv->win   = &ov772x_win_qvga;
> -		pix->width  =  ov772x_win_qvga.width;
> -		pix->height =  ov772x_win_qvga.height;
> -	}
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	const struct ov772x_win_size *win;
>  
> -	/* VGA */
> -	else if (pix->width  <= ov772x_win_vga.width ||
> -		 pix->height <= ov772x_win_vga.height) {
> -		priv->win   = &ov772x_win_vga;
> -		pix->width  =  ov772x_win_vga.width;
> -		pix->height =  ov772x_win_vga.height;
> -	}
> +	/*
> +	 * select suitable win
> +	 */
> +	win = ov772x_select_win(pix->width, pix->height);
>  
> -	pix->field = V4L2_FIELD_NONE;
> +	pix->width  = win->width;
> +	pix->height = win->height;
> +	pix->field  = V4L2_FIELD_NONE;
>  
>  	return 0;
>  }
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
