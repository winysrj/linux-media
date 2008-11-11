Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAB8Injd010865
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 03:18:49 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAB8Ia9Q013591
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 03:18:36 -0500
Date: Tue, 11 Nov 2008 09:18:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <874p2fkwh5.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811110834140.4565@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<874p2fkwh5.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Tue, 11 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > @@ -901,15 +1042,33 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
> >  			      __u32 pixfmt, struct v4l2_rect *rect)
> snip
> > -	/*
> > -	 * TODO: find a suitable supported by the SoC output format, check
> > -	 * whether the sensor supports one of acceptable input formats.
> > -	 */
> >  	if (pixfmt) {
> > -		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> > +		struct camera_data *cam_data = icd->host_priv;
> > +		int i;
> > +
> > +		/* First check camera native formats */
> > +		for (i = 0; i < cam_data->camera_formats_num; i++)
> > +			if (cam_data->camera_formats[i]->fourcc == pixfmt) {
> > +				cam_fmt = cam_data->camera_formats[i];
> > +				break;
> > +			}
> > +
> > +		/* Next, if failed, check synthesized formats */
> > +		if (!cam_fmt)
> > +			for (i = 0; i < cam_data->extra_formats_num; i++)
> > +				if (cam_data->extra_formats[i].fourcc ==
> > +				    pixfmt) {
> > +					cam_fmt = cam_data->extra_formats + i;
> > +					/* TODO: synthesize... */
> > +					dev_err(&icd->dev,
> > +						"Cannot provide format 0x%x\n",
> > +						pixfmt);
> > +					return -EOPNOTSUPP;
> > +				}
> > +
> >  		if (!cam_fmt)
> >  			return -EINVAL;
> >  	}
> 
> > @@ -924,18 +1083,31 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
> snip
> > -	/*
> > -	 * TODO: find a suitable supported by the SoC output format, check
> > -	 * whether the sensor supports one of acceptable input formats.
> > -	 */
> > -	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
> > +	/* First check camera native formats */
> > +	for (i = 0; i < cam_data->camera_formats_num; i++)
> > +		if (cam_data->camera_formats[i]->fourcc == pixfmt) {
> > +			cam_fmt = cam_data->camera_formats[i];
> > +			break;
> > +		}
> > +
> > +	/* Next, if failed, check synthesized formats */
> > +	if (!cam_fmt)
> > +		for (i = 0; i < cam_data->extra_formats_num; i++)
> > +			if (cam_data->extra_formats[i].fourcc == pixfmt) {
> > +				cam_fmt = cam_data->extra_formats + i;
> > +				break;
> > +			}
> > +
> >  	if (!cam_fmt)
> >  		return -EINVAL;
> Isn't that the second time you're looking for a format the same way, with only a
> printk making a difference ? Shouldn't that be grouped in a function
> (pxa_camera_find_format(icd, pixfmt) ?) ...

No, the real difference between them is the comment:

+					/* TODO: synthesize... */

that's where your code is supposed to go, and that's what makes them 
different - one only tries to see if it would work, the other one actually 
does. But depending on how complex your synthesis is going to be, maybe 
we'll be able to abstract parts of it further, yes.

> More globally, all camera hosts will implement the creation of this formats
> table.

That's what I am not sure about

> Why did you choose to put that in pxa_camera, and not in soc_camera to
> make available to all host drivers ?
> I had thought you would design something like :
> 
>  - soc_camera provides a format like :
> 
> struct soc_camera_format_translate {
>        u32 host_pixfmt;
>        u32 sensor_pixfmt;
> };
> 
>  - camera host provide a static table like this :
> struct soc_camera_format_translate pxa_pixfmt_translations[] = {
>        { V4L2_PIX_FMT_YUYV, V4L2_PIX_FMT_YUYV },
>        { V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_UYVY },
>        ...
>        { V4L2_PIX_FMT_YUV422P, V4L2_PIX_FMT_UYVY},
> };

Hm, I don't think you want to list all possible formats you can pull 
through this camera host. AFAIU, camera hosts can transfer data from 
cameras to destination (memory / framebuffer / output device...) in three 
ways:

1. generic: just pack what appears on the camera bus in output buffers. 
Only restrictions here are bus-width, frame-size...

2. 1-to-1: like pxa packed support for YUV / RGB. You get the same format 
on the output as on input, but re-packed, maybe scaled / rotated / 
otherwise transformed.

3. translated: like pxa UYUV to YUV422P - a different format on output 
than on input.

So far we only supported 1 and 2. For which we just used pixel format 
tables provided by the camera-sensor. But the easiest case is 1, this is 
what we currently use for Bayer and monochrome formats. And you do not 
want to create a table like above of all possible formats for each host 
that supports it. That's why I create two tables per device - one for 
sensor-native formats we just pass 1-to-1, and one list for synthesised 
formats.

For 1 and 2 we now export soc_camera_format_by_fourcc() (see 
sh_mobile_ceu_camera.c). For hosts only supporting these two modes, we can 
provide a default .enum_fmt(), maybe .set_fmt().

For 3 - as I wrote, camera supported pixel formats seem to be statis, and 
I just think, that SoC designers are a little bit more creative than CMOS 
camera designers, so that creating a generic approach might be too 
difficult.

In any case, in the beginning I put quite a lot of functionality in 
soc_camera.c. Now we notice, that we need more and more special-casing, 
and the functionality is migrating into respective camera or host drivers. 
Now I'd like to avoid this. Instead of guessing how to support "all" 
hosts, I would first implement functionality inside host drivers, and 
then, if there is too much copy-paste, extract it into common code. Yes, 
this approach has its disadvantages too...

Also, a probably better approach than what you suggested above (if I 
understood it right) would be not to use a static translation table, but 
to generate one dynamically during .add() and have them per-device, not 
per-host.

>  - soc_camera provides functions like :
>   - soc_camera_compute_formats(struct soc_camera_format_translate trans,
>                                struct soc_camera_data_format sensor_formats)
>     => that creates the formats table
> 
>  - camera host either :
>   - call the generic soc_camera_compute_formats()
>   - or make the computation themself if it is way too specific.
> 
> Is there a reason you chose to fully export the formats computation to hosts ?

In short: I'd prefer to first keep this in pxa-camera, and then see as new 
host drivers arrive, whether we can make portions of the code generic. 
Makes sense?

> Otherwise, the other 4 patches look fine to me, I'll make some tests tomorrow.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
