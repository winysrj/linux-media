Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:60433 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1A2TYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 14:24:11 -0500
Date: Sat, 29 Jan 2011 20:24:09 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 1/2] v4l: soc-camera: start stream after queueing the
 buffers
Message-ID: <20110129202409.36307b2d@wker>
In-Reply-To: <Pine.LNX.4.64.1101292015140.26696@axis700.grange>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
	<1296031789-1721-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1101292015140.26696@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 29 Jan 2011 20:16:42 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -646,11 +646,11 @@ static int soc_camera_streamon(struct file *file, void *priv,
> >  	if (icd->streamer != file)
> >  		return -EBUSY;
> >  
> > -	v4l2_subdev_call(sd, video, s_stream, 1);
> > -
> >  	/* This calls buf_queue from host driver's videobuf_queue_ops */
> >  	ret = videobuf_streamon(&icd->vb_vidq);
> >  
> > +	v4l2_subdev_call(sd, video, s_stream, 1);
> > +
> 
> After a bit more testing I'll make this to
> 
> +	if (!ret)
> +		v4l2_subdev_call(sd, video, s_stream, 1);
> +
> 
> Ok? Or you can submit a v2 yourself, if you like - when you fix the 
> comment in the other patch from this series.

I'll submit a v2 patch since I have to resubmit the other patch, too.


Thanks,
Anatolij
