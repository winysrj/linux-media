Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANGW1HH031425
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 11:32:01 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mANGVnMs014562
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 11:31:49 -0500
Date: Sun, 23 Nov 2008 17:32:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87wseuihum.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811231707040.3838@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<87wseuihum.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

On Sun, 23 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > I know this code repeats, and it is not nice. But as I was writing it I 
> > didn't see another possibility. Or more precisely, I did see it, but I 
> > couldn't compare the two versions well without having at least one of them 
> > in code in front of my eyes:-) Now that I see it, I think, yes, there is a 
> > way to do this only once by using a translation struct similar to what you 
> > have proposed. Now _this_ would be a possibly important advantage, so it 
> > is useful not _only_ for debugging:-) But we would have to extend it with 
> > at least a buswidth. Like
> >
> > 	const struct soc_camera_data_format *cam_fmt;
> > 	const struct soc_camera_data_format *host_fmt;
> > 	unsigned char buswidth;
> >
> > Now this _seems_ to provide the complete information so far... In 
> > pxa_camera_get_formats() we would
> >
> > 1. compute camera- and host-formats and buswidth
> > 2. call pxa_camera_try_bus_param() to check bus-parameter compatibility
> >
> > and then in try_fmt() and set_fmt() just traverse the list of translation 
> > structs and adjust geometry?
> 
> Hi Guennadi,
> 
> I began the work. I have a pending question here. Do you want to have the
> translation structure fully contained into pxa_camera (in host_priv for
> example), or do you want to replace the user formats by translation structure
> (ie. soc_camera_init_user_formats() would generate a list of
> soc_camera_format_translate instead of a list of soc_camera_data format) ?
> 
> I'm asking because in pxa_camera, there is no easy way to "guess" the size of
> the array of translations. And as vmalloc() is done in
> soc_camera_init_user_formats(), and allocates only soc_camera_data_format
> structures, I see no easy way to generate the list of translations in
> pxa_camera.c.
> 
> I thought I would modify soc_camera.c in this way :
> static int soc_camera_init_user_formats(struct soc_camera_device *icd)
> {
> <snip>
> -       icd->user_formats = vmalloc(sizeof(struct soc_camera_data_format *) *
> -                                   fmts);
> +       icd->user_formats =
> +               vmalloc(sizeof(struct soc_camera_format_translate *) * fmts);
> <snip>
> 
> Is that what you had in mind ?

Yes, exactly. he only thing, the name soc_camera_format_translate is too 
long... But I cannot think of a better one... maybe 
soc_camera_format_xlate just to make it a bit shorter? or format_match? 
Anyway, this will not be a reason to reject your patch:-) And I would 
prefer to have

+	x = vmalloc(y *

on one line, instead of splitting it like above. E.g., 

> +       icd->user_formats = vmalloc(fmts *
> +               sizeof(struct soc_camera_format_translate *));

but that's again just a matter of taste.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
