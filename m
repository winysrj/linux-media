Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43814 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2EINyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 09:54:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
Date: Wed, 09 May 2012 15:54:18 +0200
Message-ID: <4595836.oa9lg8deDZ@avalon>
In-Reply-To: <Pine.LNX.4.64.1204242359420.21239@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com> <201201262118.09750.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1204242359420.21239@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 25 April 2012 00:06:03 Guennadi Liakhovetski wrote:
> Hi Laurent
> 
> Sorry for a slightly delayed reply;-)

So slightly :-)

> On Thu, 26 Jan 2012, Laurent Pinchart wrote:
> 
> [snip]
> 
> > > > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c
> > > > b/drivers/media/video/sh_mobile_ceu_camera.c index c51decf..f4eb9e1
> > > > 100644
> > > > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > > > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> 
> [snip]
> 
> > > Looks like sh_mobile_ceu_set_rect() can also be simplified, since there
> > > bytes_per_line is calculated for data-fetch mode, for which the
> > > ->bytesperline can also be used?
> > 
> > Is sh_mobile_ceu_set_rect() guaranteed to be called after try_fmt(), with
> > the ->bytesperline value set to the correct value for the current format
> > ?
>
> I think it is, yes. soc_camera.c always configures the pipeline upon the
> first .open() call by calling soc_camera_set_fmt(), at which point
> ->bytesperline is set too. Also, just to avoid confusion - above you meant
> set_fmt(), not try_fmt(), right? *try* are not supposed to set anything.

Yes, I meant set_fmt(), sorry.

I've just checked the code paths in which sh_mobile_ceu_set_rect() is called, 
and I don't see any issue there. We can thus simplify the data-fetch mode code 
in sh_mobile_ceu_set_rect().

> So, if you agree, either you can do a patch 11/9 or I can do it myself. Or
> you could do a v3 of just one patch 3/9.

I'd rather avoid a v3 if possible :-) If you could add a 11/9 patch that would 
be great.

-- 
Regards,

Laurent Pinchart

