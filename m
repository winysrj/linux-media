Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50231 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759537AbZKKWh3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 17:37:29 -0500
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 11 Nov 2009 23:37:32 +0100
From: "Philipp Wiesner" <p.wiesner@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0911111910410.4072@axis700.grange>
Message-ID: <20091111223732.228930@gmx.net>
MIME-Version: 1.0
References: <20091110144236.322090@gmx.net>
 <Pine.LNX.4.64.0911111910410.4072@axis700.grange>
Subject: Re: [PATCH] soc_camera: multiple input capable enum, g & s
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Tue, 10 Nov 2009, Philipp Wiesner wrote:
> 
> > soc_camera: multiple input capable enum, g & s
> > 
> > From: Philipp Wiesner <p.wiesner@gmx.net>
> > 
> > I did some small changes to support soc camera devices with multiple 
> > inputs, e.g. tw9910 (driver doesn't support this yet).
> > soc-camera.c:
> > soc_camera_enum_input: capable of handling multiple inputs.
> > soc_camera_g_input: calls icd's g_input if present.
> > soc_camera_s_input: calls icd's s_input if present.
> > soc-camera.h:
> > struct soc_camera_ops: Added aliases for g_input and s_input functions
> here.
> 
> Thanks for the patch, and yes, supporting multiple inputs would be good, 
> but: 1) we should not add new operations to soc_camera_ops. Any new client
> operations should be implemented using the v4l2-subdev API.

Okay, I somehow expected this. I just thought that there must be a reason that
some of the regular API functions were not carried over to the subdev API.

> 2) we should 
> first decide what we want to use multiple inputs for. There have beed 
> discussions to use inputs for switching between sensors on one interface, 
> or for switching between video and still-image modes... What is your 
> use-case for them?

The tw9910 (analog video decoder/encoder) has four physical video inputs with
one of them being active at a time, so it's real input switching in this case.
I have to admit that I'm not yet very familiar with the direction this API is
going. But I can image situations where enum_input helps to use input switching
for all of those cases.
Whether you switch physical inputs or only 'modes' or 'contexts' IMHO should be
totally up to the driver programmer, whatever is needed for the device. It
doesn't make any difference to the API and all of them can be considered inputs
in a logical way.

Thanks.
Philipp

> Thanks
> Guennadi
> 
> > 
> > Priority: normal
> > 
> > Signed-off-by: Philipp Wiesner <p.wiesner@gmx.net>
> > 
> > diff -r 43878f8dbfb0 -r a5254e7d306a
> linux/drivers/media/video/soc_camera.c
> > --- a/linux/drivers/media/video/soc_camera.c	Sun Nov 01 07:17:46 2009
> -0200
> > +++ b/linux/drivers/media/video/soc_camera.c	Tue Nov 03 17:17:49 2009
> +0100
> > @@ -119,11 +119,10 @@
> >  	struct soc_camera_device *icd = icf->icd;
> >  	int ret = 0;
> >  
> > -	if (inp->index != 0)
> > -		return -EINVAL;
> > -
> >  	if (icd->ops->enum_input)
> >  		ret = icd->ops->enum_input(icd, inp);
> > +	else if (inp->index != 0)
> > +		return -EINVAL;
> >  	else {
> >  		/* default is camera */
> >  		inp->type = V4L2_INPUT_TYPE_CAMERA;
> > @@ -136,17 +135,30 @@
> >  
> >  static int soc_camera_g_input(struct file *file, void *priv, unsigned
> int *i)
> >  {
> > -	*i = 0;
> > +	struct soc_camera_file *icf = file->private_data;
> > +	struct soc_camera_device *icd = icf->icd;
> > +	int ret = 0;
> >  
> > -	return 0;
> > +	if (icd->ops->g_input)
> > +		ret = icd->ops->g_input(icd, i);
> > +	else
> > +		*i = 0;
> > +
> > +	return ret;
> >  }
> >  
> >  static int soc_camera_s_input(struct file *file, void *priv, unsigned
> int i)
> >  {
> > -	if (i > 0)
> > +	struct soc_camera_file *icf = file->private_data;
> > +	struct soc_camera_device *icd = icf->icd;
> > +	int ret = 0;
> > +
> > +	if (icd->ops->s_input)
> > +		ret = icd->ops->s_input(icd, i);
> > +	else if (i > 0)
> >  		return -EINVAL;
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id        
> *a)
> > diff -r 43878f8dbfb0 -r a5254e7d306a linux/include/media/soc_camera.h
> > --- a/linux/include/media/soc_camera.h	Sun Nov 01 07:17:46 2009 -0200
> > +++ b/linux/include/media/soc_camera.h	Tue Nov 03 17:17:49 2009 +0100
> > @@ -197,6 +197,8 @@
> >  	unsigned long (*query_bus_param)(struct soc_camera_device *);
> >  	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
> >  	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
> > +	int (*g_input)(struct soc_camera_device *, unsigned int *);
> > +	int (*s_input)(struct soc_camera_device *, unsigned int);
> >  	const struct v4l2_queryctrl *controls;
> >  	int num_controls;
> >  };
> > 
> > -- 
> > GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
> > Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
-- 
DSL-Preisknaller: DSL Komplettpakete von GMX schon für 
16,99 Euro mtl.!* Hier klicken: http://portal.gmx.net/de/go/dsl01
