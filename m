Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG870V8006464
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 03:07:00 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBG86sof019090
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 03:06:54 -0500
Date: Tue, 16 Dec 2008 09:06:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812160904131.4630@axis700.grange>
References: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH v3] Add tw9910 driver
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

On Tue, 16 Dec 2008, Kuninori Morimoto wrote:

> 
> This patch adds tw9910 driver that use soc_camera framework.
> It was tested on SH Migo-r board and mplayer.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v2 -> v3
> 
> o add tw9910_set_std function
> o add tw9910_enum_input function

Ok, these two are fine now. But

> +static int tw9910_try_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	__u32 wmax = (__u32)icd->width_max;
> +	__u32 wmin = (__u32)icd->width_min;
> +	__u32 hmax = (__u32)icd->height_max;
> +	__u32 hmin = (__u32)icd->height_min;
> +
> +	pix->width  = min(pix->width,  wmax);
> +	pix->width  = max(pix->width,  wmin);
> +	pix->height = min(pix->height, hmax);
> +	pix->height = max(pix->height, hmin);
> +
> +	pix->field = V4L2_FIELD_INTERLACED;
> +
> +	return 0;
> +}

You forgot to fix this one. Please, look again what O've written to you 
regarding this function. You may replace the field, if it is 
V4L2_FIELD_ANY, but if it is something different, you have to return 
-EINVAL.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
