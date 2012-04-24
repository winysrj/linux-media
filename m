Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54831 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2DXWGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 18:06:06 -0400
Date: Wed, 25 Apr 2012 00:06:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] soc_camera: Use soc_camera_device::sizeimage to
 compute buffer sizes
In-Reply-To: <201201262118.09750.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1204242359420.21239@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1327504351-24413-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1201252217450.18778@axis700.grange>
 <201201262118.09750.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Sorry for a slightly delayed reply;-)

On Thu, 26 Jan 2012, Laurent Pinchart wrote:

[snip]

> > > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c
> > > b/drivers/media/video/sh_mobile_ceu_camera.c index c51decf..f4eb9e1
> > > 100644
> > > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > > +++ b/drivers/media/video/sh_mobile_ceu_camera.c

[snip]

> > Looks like sh_mobile_ceu_set_rect() can also be simplified, since there
> > bytes_per_line is calculated for data-fetch mode, for which the
> > ->bytesperline can also be used?
> 
> Is sh_mobile_ceu_set_rect() guaranteed to be called after try_fmt(), with the 
> ->bytesperline value set to the correct value for the current format ?

I think it is, yes. soc_camera.c always configures the pipeline upon the 
first .open() call by calling soc_camera_set_fmt(), at which point 
->bytesperline is set too. Also, just to avoid confusion - above you meant 
set_fmt(), not try_fmt(), right? *try* are not supposed to set anything.

So, if you agree, either you can do a patch 11/9 or I can do it myself. Or 
you could do a v3 of just one patch 3/9.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
