Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n599DspS009247
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 05:13:54 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n599DaVT028823
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 05:13:37 -0400
Date: Tue, 9 Jun 2009 11:13:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ud49domlx.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0906091057120.4085@axis700.grange>
References: <ud49domlx.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: question about soc_camera_open
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

Hello Morimoto-san

On Tue, 9 Jun 2009, Kuninori Morimoto wrote:

> Dear Guennadi
> 
> soc_camera_open use icd->current_fmt directly.
> It doesn't check if icd->current_fmt != NULL.

Which kernel version, resp., version of the soc-camera stack are you 
using? What you describe would be a bug, but it shouldn't be present 
neither in the soc-camera stack, converted to v4l2-subdev (see my last 
series of 10 patches), nor in a partially converted stack. Ok, I see, it 
is present in the current mainline. There's a call to

	if (icd->ops->remove)
		icd->ops->remove(icd);

missing on the "goto eiufmt;" error path. You'd just have to insert the 
above call before the goto. Would you like to prepare a patch?

Thanks
Guennadi

> 
> 	if (icd->use_count == 1) {
> 		/* Restore parameters before the last close() per V4L2 API */
> 		struct v4l2_format f = {
> 			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> 			.fmt.pix = {
> 				.width		= icd->width,
> 				.height		= icd->height,
> 				.field		= icd->field,
> =>				.pixelformat	= icd->current_fmt->fourcc,
> =>				.colorspace	= icd->current_fmt->colorspace,
> 			},
> 		};
> 
> 
> if soc_camera_init_user_formats return -ENXIO,
> then, icd->current_fmt is still NULL.
> 
> 	if (!ici->ops->get_formats)
> 		/*
> 		 * Fallback mode - the host will have to serve all
> 		 * sensor-provided formats one-to-one to the user
> 		 */
> 		fmts = icd->num_formats;
> 	else
> 		/*
> 		 * First pass - only count formats this host-sensor
> 		 * configuration can provide
> 		 */
> 		for (i = 0; i < icd->num_formats; i++)
> 			fmts += ici->ops->get_formats(icd, i, NULL);
> 
> 	if (!fmts)
> =>		return -ENXIO;
> 
> in my environment, I can use "sh_mobile_ceu" and "soc_camera_platform",
> if sh_mobile_ceu_try_bus_param failed, this process will run above way.
> and it will be kernel panic.
> Is this bug ??
> 
> Best regards
> --
> Kuninori Morimoto
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
