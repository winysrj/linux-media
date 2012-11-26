Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab2KZPUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 10:20:22 -0500
Date: Mon, 26 Nov 2012 16:20:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] OV5642: fix VIDIOC_S_GROP ioctl
In-Reply-To: <20121106141845.4641954a@wker>
Message-ID: <Pine.LNX.4.64.1211261618390.11501@axis700.grange>
References: <1352157290-13201-1-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1211061243580.6451@axis700.grange> <20121106141845.4641954a@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anatolij

Sorry for a delay

On Tue, 6 Nov 2012, Anatolij Gustschin wrote:

> On Tue, 6 Nov 2012 12:45:51 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Tue, 6 Nov 2012, Anatolij Gustschin wrote:
> > 
> > > VIDIOC_S_GROP ioctl doesn't work, soc-camera driver reports:
> > > 
> > > soc-camera-pdrv soc-camera-pdrv.0: S_CROP denied: getting current crop failed
> > > 
> > > The issue is caused by checking for V4L2_BUF_TYPE_VIDEO_CAPTURE type
> > > in driver's g_crop callback. This check should be in s_crop instead,
> > > g_crop should just set the type field to V4L2_BUF_TYPE_VIDEO_CAPTURE
> > > as other drivers do. Move the V4L2_BUF_TYPE_VIDEO_CAPTURE type check
> > > to s_crop callback.
> > 
> > I'm not sure this is correct:
> > 
> > http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-crop.html
> > 
> > Or is the .g_crop() subdev operation using a different semantics? Where is 
> > that documented?
> 
> I do not know if it is documented somewhere. But it seems natural to me
> that a sensor driver sets the type field to V4L2_BUF_TYPE_VIDEO_CAPTURE
> in its .g_crop(). A sensor is a capture device, not an output or overlay
> device. And this ioctl is a query operation.
> 
> OTOH I'm fine with this type checking in .g_crop() and it can help
> to discover bugs in user space apps. The VIDIOC_G_CROP documentation
> states that the type field needs to be set to the respective buffer type
> when querying, so the check in .g_crop() is perfectly valid. But then
> I need following patch to fix the observed issue:
> 
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -902,6 +902,8 @@ static int soc_camera_s_crop(struct file *file, void *fh,
>         dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
>                 rect->width, rect->height, rect->left, rect->top);
>  
> +       current_crop.type = a->type;
> +
>         /* If get_crop fails, we'll let host and / or client drivers decide */
>         ret = ici->ops->get_crop(icd, &current_crop);
>  
> What do you think?

Yes, this makes sense. Please, submit a patch.

> And the type field should be checked in .s_crop() anyway, I think.

It is checked in soc_camera_s_crop() just a couple of lines above the 
snippet above. Or what do you mean?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
