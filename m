Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:48273 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab2K1US6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 15:18:58 -0500
Date: Wed, 28 Nov 2012 21:18:51 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] OV5642: fix VIDIOC_S_GROP ioctl
Message-ID: <20121128211851.7072e6f9@wker>
In-Reply-To: <Pine.LNX.4.64.1211261618390.11501@axis700.grange>
References: <1352157290-13201-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1211061243580.6451@axis700.grange>
	<20121106141845.4641954a@wker>
	<Pine.LNX.4.64.1211261618390.11501@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, 26 Nov 2012 16:20:14 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -902,6 +902,8 @@ static int soc_camera_s_crop(struct file *file, void *fh,
> >         dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
> >                 rect->width, rect->height, rect->left, rect->top);
> >  
> > +       current_crop.type = a->type;
> > +
> >         /* If get_crop fails, we'll let host and / or client drivers decide */
> >         ret = ici->ops->get_crop(icd, &current_crop);
> >  
> > What do you think?
> 
> Yes, this makes sense. Please, submit a patch.

Done.

> 
> > And the type field should be checked in .s_crop() anyway, I think.
> 
> It is checked in soc_camera_s_crop() just a couple of lines above the 
> snippet above. Or what do you mean?

Yes, you are right! Okay, then there is no need to check it again
in the subdevice driver.

Thanks,

Anatolij
