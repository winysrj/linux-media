Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9AWbG1027716
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 05:32:37 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id mA9AWTTT028995
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 05:32:29 -0500
Date: Sun, 9 Nov 2008 11:32:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87tzahwwr1.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811091105180.4485@axis700.grange>
References: <Pine.LNX.4.64.0811081917070.8956@axis700.grange>
	<87tzahwwr1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/3] soc-camera: let camera host drivers decide upon
 pixel format
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

On Sun, 9 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> > index 2a811f8..a375872 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -907,17 +907,43 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
> >  				  __u32 pixfmt, struct v4l2_rect *rect)
> >  {
> > -	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
> > +	const struct soc_camera_data_format *cam_fmt;
> > +	int ret;
> > +
> > +	/*
> > +	 * TODO: find a suitable supported by the SoC output format, check
> > +	 * whether the sensor supports one of acceptable input formats.
> > +	 */
> > +	if (pixfmt) {
> > +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> > +		if (!cam_fmt)
> > +			return -EINVAL;
> > +	}
> All right, here is something I don't understand.
> 
> Let's take an example : the pxa_camera was asked a YUV422P pixel format. It can
> deserve it by asking the sensor a UYVY format. So the logical step would be to
> do something like :
> 
> 	if (pixfmt == V4L2_PIX_FMT_YUV422P)
> 		pixfmt = V4L2_PIX_FMT_UYVY;
> 
> at the beginning of pxa_camera_set_fmt_cap().

Right.

> > +
> > +	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
> > +	if (pixfmt && !ret)
> > +		icd->current_fmt = cam_fmt;
> So here, icd->current_fmt = V4L2_PIX_FMT_UYVY, and not V4L2_PIX_FMT_YUV422P;
> 
> > @@ -345,14 +325,21 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
> >  	rect.width	= f->fmt.pix.width;
> >  	rect.height	= f->fmt.pix.height;
> >  	ret = ici->ops->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
> > -	if (ret < 0)
> > +	if (ret < 0) {
> >  		return ret;
> > +	} else if (!icd->current_fmt ||
> > +		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
> > +		dev_err(&ici->dev, "Host driver hasn't set up current "
> > +			"format correctly!\n");
> > +		return -EINVAL;
> > +	}
> And here, we fall into the error case, because icd->current_fmt is
> V4L2_PIX_FMT_UYVY, and f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P.
> 
> So there is still something to improve, or have I missed something ?

Yes, there is something to improve. With this patch I modified central 
soc_camera.c algorithms to make such format-conversions possible, but I so 
far just preserved the functionality in camera host drivers. Now we have 
to change that as needed too.

You correctly identified the first place to modify. Now this is the second 
one:

+           icd->current_fmt = cam_fmt;

You now have to substitute another struct soc_camera_data_format to 
current_fmt. Ok, I wasn't sure what's the best way to do this. Preserving 
current_fmt as a pointer is easier, because it requires no code 
modifications, and in most cases, where you don't perform any format 
substitution, you can still use a struct from sensor's list. Now if you do 
make such a substitution, I would say, you have to allocate such a struct 
and use it there. Now, how do we avoid leaking this structs. I think, the 
best would be to add a

	void	*host_priv;

to struct soc_camera_device for per-sensor host-private data. It can be 
generally useful in the future too. Then add some

struct camera_data {
	struct soc_camera_data_format data_fmt;
};

to pxa_camera.c, allocate it in pxa_camera_add_device() and assign to 
->host_priv. Then fill it in as required in pxa_camera_set_fmt_cap() iff 
such a format conversion is requested and use its data_fmt member for 
current_fmt. Of course, remembering to free it in 
pxa_camera_remove_device().

Another possibility would be to make current_fmt to hold the struct 
instead of being just a pointer, thus saving above allocations, but that 
would require all drivers do a memcpy on each format change instead of 
just a pointer assignment...

How does this sound?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
