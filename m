Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOAi8N4032515
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 05:44:08 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBOAhrHN023808
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 05:43:54 -0500
Date: Wed, 24 Dec 2008 11:43:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uzlim9tlu.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812241106540.4017@axis700.grange>
References: <uy6ycr129.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812210201450.23780@axis700.grange>
	<uzlim9tlu.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH v6] Add tw9910 driver
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

On Wed, 24 Dec 2008, morimoto.kuninori@renesas.com wrote:

> > Ok, let's do it this way. We take this version as a basis, but I only 
> > commit it after I get an incremental improvement patch from you:
> 
> v7 patch ?

You may choose - what's easier for you. Either you make a v7, or we keep 
v6, and you make an _incremental_ (i.e., based on v6) patch to address 
issues that I point out here. If you decide to make an incremental patch, 
I think, I might merge it with v6, show it to you once more for 
confirmation and commit that in one go. But just please choose what's 
easier for you.

> > > +static int tw9910_stop_capture(struct soc_camera_device *icd)
> > > +{
> > > +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> > > +
> > > +	priv->scale = NULL;
> > > +	icd->vdev->current_norm = V4L2_STD_NTSC;
> > > +
> > > +	tw9910_reset(priv->client);
> > 
> > I think, you should leave your driver and the chip configured, so, both of 
> > these should go.
> 
> sorry. I can not understand about this.
> 
> Do you say that it is better ?
> 
> --------------------
> static int tw9910_stop_capture(struct soc_camera_device *icd)
> {
> 	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> 	tw9910_reset(priv->client);
>         return 0;
> }
> --------------------

No, not quite. Here's what I've written last time:

> > S_FMT	- set_fmt
> > STREAMON	- start_capture
> > STREAMOFF	- stop_capture
> > STREAMON	-start_capture

i.e., you should be prepared to restart capture after a stop_capture with 
the same configuration. By setting

	icd->vdev->current_norm = V4L2_STD_NTSC;

you change driver's configuration, and by calling

	tw9910_reset(priv->client);

you change chip's configuration (I assume). So, re-starting capture after 
this might be problematic. The only thing one should do in stop_capture is 
tell the sensor to stop the scan - if it supports it. Not all chips do. 
With one of my drivers I switch it to snapshot mode, in which case it 
stops scanning and waits for a trigger. See if your chip supports anything 
similar, or just do nothing.

> > > +static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
> > > +{
> > > +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> > > +	struct soc_camera_link *icl = priv->client->dev.platform_data;
> > > +	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
> > > +		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> > > +		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
> > > +
> > > +	return soc_camera_apply_sensor_flags(icl, flags);
> > > +}
> 
> In current git (2008-12-19),
> ${LINUX}/include/media/soc_camera.h :: soc_camera_bus_param_compatible
> doesn't check SOCAM_DATA_ACTIVE_XXX.
> So I think SOCAM_DATA_ACTIVE_HIGH is not needed here.
> But should I add it ? or not ?

Well, this is the query() method, it just tells your capabilities. 
Currently we don't check for SOCAM_DATA_ACTIVE_* in 
soc_camera_bus_param_compatible(), that's correct, but it is good to have 
your driver ready for the time when we do this. With a later patch we're 
going to update camera host drivers and camera device, and after that 
we'll update soc_camera_bus_param_compatible(). So, it is good that you 
already have it.

> > This is wrong too. According to the API TRY_FMT may be called at any time 
> > (also during a running streaming) and should _not_ change driver's state. 
> > And as you can see in soc_camera.c::soc_camera_s_fmt_vid_cap() we're not 
> > holding the mutex while calling soc_camera_try_fmt_vid_cap(), so, you have 
> > no guarantee in your set_fmt, that your try_fmt was last called from 
> > soc_camera_s_fmt_vid_cap() or even worse that it's not being called 
> > concurrently. Therefore, you have to call tw9910_select_norm() once more 
> > in your set_fmt, 
> 
> OK. I could understand.
> 
> > and in try_fmt you only verify if a suitable norm can be 
> > found and set pix->height and pix->width accordingly.
> 
> So I think set_fmt and try_fmt will be like this.
> It's OK ?
> 
> --------------------
> static const struct tw9910_scale_ctrl*
> tw9910_select_norm(struct soc_camera_device *icd, struct v4l2_rect *rect)
> {
> ...
> }
> 
> static int tw9910_set_fmt( xxx )
> {
>         ...
> 
> 	/*
> 	 * select suitable norm
> 	 */
> 	priv->scale = tw9910_select_norm(icd, rect);
> 	if (!priv->scale)
> 		return ret;
> 
> 	....
> }
> 
> static int tw9910_try_fmt( xxx )
> {
> 	struct v4l2_rect rect;
>         ...
> 
>         /*
>          * check pix->field is ANY or INTERLACED
>          */
>          ....
> 
> 	/*
> 	 * select suitable norm
> 	 */
> 	rect.width  = pix->width;
> 	rect.height = pix->height;
> 
> 	scale = tw9910_select_norm(icd, &rect);
> 	if (!scale) 
> 		return -EINVAL;
> 
> 	pix->width  = scale->width;
> 	pix->height = scale->height;
> 
> 	return 0;
> }
> --------------------

Yes, this looks good as far as I can see.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
