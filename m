Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAB1QnBA005799
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 20:26:49 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAB1QIFH021311
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 20:26:18 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 11 Nov 2008 00:11:18 +0100
In-Reply-To: <Pine.LNX.4.64.0811101335170.4248@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	10 Nov 2008 13\:37\:00 +0100 \(CET\)")
Message-ID: <874p2fkwh5.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
	synthesized formats
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> @@ -901,15 +1042,33 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  			      __u32 pixfmt, struct v4l2_rect *rect)
snip
> -	/*
> -	 * TODO: find a suitable supported by the SoC output format, check
> -	 * whether the sensor supports one of acceptable input formats.
> -	 */
>  	if (pixfmt) {
> -		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> +		struct camera_data *cam_data = icd->host_priv;
> +		int i;
> +
> +		/* First check camera native formats */
> +		for (i = 0; i < cam_data->camera_formats_num; i++)
> +			if (cam_data->camera_formats[i]->fourcc == pixfmt) {
> +				cam_fmt = cam_data->camera_formats[i];
> +				break;
> +			}
> +
> +		/* Next, if failed, check synthesized formats */
> +		if (!cam_fmt)
> +			for (i = 0; i < cam_data->extra_formats_num; i++)
> +				if (cam_data->extra_formats[i].fourcc ==
> +				    pixfmt) {
> +					cam_fmt = cam_data->extra_formats + i;
> +					/* TODO: synthesize... */
> +					dev_err(&icd->dev,
> +						"Cannot provide format 0x%x\n",
> +						pixfmt);
> +					return -EOPNOTSUPP;
> +				}
> +
>  		if (!cam_fmt)
>  			return -EINVAL;
>  	}

> @@ -924,18 +1083,31 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
snip
> -	/*
> -	 * TODO: find a suitable supported by the SoC output format, check
> -	 * whether the sensor supports one of acceptable input formats.
> -	 */
> -	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
> +	/* First check camera native formats */
> +	for (i = 0; i < cam_data->camera_formats_num; i++)
> +		if (cam_data->camera_formats[i]->fourcc == pixfmt) {
> +			cam_fmt = cam_data->camera_formats[i];
> +			break;
> +		}
> +
> +	/* Next, if failed, check synthesized formats */
> +	if (!cam_fmt)
> +		for (i = 0; i < cam_data->extra_formats_num; i++)
> +			if (cam_data->extra_formats[i].fourcc == pixfmt) {
> +				cam_fmt = cam_data->extra_formats + i;
> +				break;
> +			}
> +
>  	if (!cam_fmt)
>  		return -EINVAL;
Isn't that the second time you're looking for a format the same way, with only a
printk making a difference ? Shouldn't that be grouped in a function
(pxa_camera_find_format(icd, pixfmt) ?) ...


More globally, all camera hosts will implement the creation of this formats
table. Why did you choose to put that in pxa_camera, and not in soc_camera to
make available to all host drivers ?
I had thought you would design something like :

 - soc_camera provides a format like :

struct soc_camera_format_translate {
       u32 host_pixfmt;
       u32 sensor_pixfmt;
};

 - camera host provide a static table like this :
struct soc_camera_format_translate pxa_pixfmt_translations[] = {
       { V4L2_PIX_FMT_YUYV, V4L2_PIX_FMT_YUYV },
       { V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_UYVY },
       ...
       { V4L2_PIX_FMT_YUV422P, V4L2_PIX_FMT_UYVY},
};

 - soc_camera provides functions like :
  - soc_camera_compute_formats(struct soc_camera_format_translate trans,
                               struct soc_camera_data_format sensor_formats)
    => that creates the formats table

 - camera host either :
  - call the generic soc_camera_compute_formats()
  - or make the computation themself if it is way too specific.

Is there a reason you chose to fully export the formats computation to hosts ?

Otherwise, the other 4 patches look fine to me, I'll make some tests tomorrow.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
