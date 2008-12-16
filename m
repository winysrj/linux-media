Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG95dPM002232
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:05:39 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBG948Tc016773
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:04:16 -0500
Date: Tue, 16 Dec 2008 10:03:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uej08h569.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812161001000.4630@axis700.grange>
References: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812160904131.4630@axis700.grange>
	<uej08h569.wl%morimoto.kuninori@renesas.com>
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

On Tue, 16 Dec 2008, morimoto.kuninori@renesas.com wrote:

> > > +static int tw9910_try_fmt(struct soc_camera_device *icd,
> > > +			      struct v4l2_format *f)
> > > +{
> > > +	struct v4l2_pix_format *pix = &f->fmt.pix;
> > > +	__u32 wmax = (__u32)icd->width_max;
> > > +	__u32 wmin = (__u32)icd->width_min;
> > > +	__u32 hmax = (__u32)icd->height_max;
> > > +	__u32 hmin = (__u32)icd->height_min;
> > > +
> > > +	pix->width  = min(pix->width,  wmax);
> > > +	pix->width  = max(pix->width,  wmin);
> > > +	pix->height = min(pix->height, hmax);
> > > +	pix->height = max(pix->height, hmin);
> > > +
> > > +	pix->field = V4L2_FIELD_INTERLACED;
> > > +
> > > +	return 0;
> > > +}
> > 
> > You forgot to fix this one. Please, look again what O've written to you 
> > regarding this function. You may replace the field, if it is 
> > V4L2_FIELD_ANY, but if it is something different, you have to return 
> > -EINVAL.
> 
> Sorry I forget to tell you about this.
> I tried it.
> but pix->field was V4L2_FIELD_NONE when tw9910_try_fmt was 1st called.

Yes, that's fine. This depends on your application - whatever you use. And 
I would expect, if you first return -EINVAL in reply to FIELD_NONE, the 
application then will try either ANY or INTERLACED, and you will get a 
chance to select a suitable field.

> debug code is like this
> 
> ----------------------------------------------------------
> static int tw9910_try_fmt(struct soc_camera_device *icd,
> 			      struct v4l2_format *f)
> {
>         struct v4l2_pix_format *pix = &f->fmt.pix;
> ....
>         if(pix->field == V4L2_FIELD_NONE)
>                       printk("V4L2_FIELD_NONE\n")
>         if(pix->field == V4L2_FIELD_ANY)
>                       printk("V4L2_FIELD_ANY\n")
>         if(pix->field == V4L2_FIELD_NONE)
>                       printk("V4L2_FIELD_INTERLACED\n")
> ...
> }
> ----------------------------------------------------------
> 
> answer is 
> 
> ----------------------------------------------------------
> ...
> V4L2_FIELD_NONE
> V4L2_FIELD_ANY
> V4L2_FIELD_INTERLACED
> V4L2_FIELD_ANY
> ...
> ----------------------------------------------------------
> 
> I just removed field check from soc_camera.c :: soc_camera_fry_fmt_vid_cap
> It it not enough ?

It is, this looks fine. Just try returning -EINVAL on NONE and see if the 
application manages it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
