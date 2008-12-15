Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFAPAoT009505
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:25:10 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBFAOujw032447
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:24:57 -0500
Date: Mon, 15 Dec 2008 11:25:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ufxkpvjbp.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812151120130.4416@axis700.grange>
References: <ufxkpvjbp.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add new enum_input function on soc_camera
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

On Mon, 15 Dec 2008, Kuninori Morimoto wrote:

> This patch presents new method to be able to select V4L2 input type
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/soc_camera.c |   17 +++++++++++++----
>  include/media/soc_camera.h       |    1 +
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 36ee55b..758c310 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -93,14 +93,23 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
>  static int soc_camera_enum_input(struct file *file, void *priv,
>  				 struct v4l2_input *inp)
>  {
> +	struct soc_camera_file *icf = file->private_data;
> +	struct soc_camera_device *icd = icf->icd;
> +	int ret = 0;
> +
>  	if (inp->index != 0)
>  		return -EINVAL;
>  

Yeah... this is enough as long as we don't have clients with more than 1 
input... But to support > 1 input we'd also have to modify 
soc_camera_s_input and soc_camera_g_input, so, I'd say we leave it at 1 
input for now, agree?

> -	inp->type = V4L2_INPUT_TYPE_CAMERA;
> -	inp->std = V4L2_STD_UNKNOWN;
> -	strcpy(inp->name, "Camera");
> +	if (icd->ops->enum_input)
> +		ret = icd->ops->enum_input(icd, inp);
> +	else {

I think, CodingStyle requires braces before and after else, if at least 
one of them has them, but checkpatch.pl doesn't complain, so, we just 
leave it. Or I fix it when committing - if I remember to.

> +		/* default is camera */
> +		inp->type = V4L2_INPUT_TYPE_CAMERA;
> +		inp->std  = V4L2_STD_UNKNOWN;
> +		strcpy(inp->name, "Camera");
> +	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index f1fe91d..0ee34f8 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -164,6 +164,7 @@ struct soc_camera_ops {
>  	int (*get_chip_id)(struct soc_camera_device *,
>  			   struct v4l2_chip_ident *);
>  	int (*set_std)(struct soc_camera_device *, v4l2_std_id *);
> +	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	int (*get_register)(struct soc_camera_device *, struct v4l2_register *);
>  	int (*set_register)(struct soc_camera_device *, struct v4l2_register *);
> -- 
> 1.5.6.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
