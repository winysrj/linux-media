Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33209 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab2ENXLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 19:11:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.5] Implement V4L2_CID_PIXEL_RATE in various drivers
Date: Tue, 15 May 2012 01:11:47 +0200
Message-ID: <1654469.oil1fXEATY@avalon>
In-Reply-To: <4FB12C74.8000306@redhat.com>
References: <20120514155622.GJ3373@valkosipuli.retiisi.org.uk> <4FB12C74.8000306@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 14 May 2012 13:01:56 Mauro Carvalho Chehab wrote:
> Em 14-05-2012 12:56, Sakari Ailus escreveu:
> > Hi all,
> > 
> > Here are a few patches that implement V4L2_CID_PIXEL_RATE in a couple of
> > drivers. The control is soon required by some CSI-2 receivers to configure
> > the hardware, such as the OMAP 3 ISP one.
> 
> Before spreading this everywhere, let me understand a little bit better
> about V4L2_CID_PIXEL_RATE and the other ioctl's that handle the image rate,
> as changing one affects the other.

Implementing V4L2_CID_PIXEL_RATE is required for sensor drivers used with the 
OMAP3 ISP. The ISP driver needs to know the pixel rate on the ISP sink to 
configure the hardware. This was previously done with a platform callback, the 
ISP now queries the sensor directly using the V4L2_CID_PIXEL_RATE control.

As you've pulled the ISP change for v3.5, I'd like these 3 patches to get in 
v3.5 as well to avoid regressions.

> > ---
> > 
> > The following changes since commit 
e89fca923f32de26b69bf4cd604f7b960b161551:
> >   [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)
> > 
> > are available in the git repository at:
> >   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5
> > 
> > Laurent Pinchart (3):
> >       mt9t001: Implement V4L2_CID_PIXEL_RATE control
> >       mt9p031: Implement V4L2_CID_PIXEL_RATE control
> >       mt9m032: Implement V4L2_CID_PIXEL_RATE control
> >  
> >  drivers/media/video/mt9m032.c |   13 +++++++++++--
> >  drivers/media/video/mt9p031.c |    5 ++++-
> >  drivers/media/video/mt9t001.c |   13 +++++++++++--
> >  include/media/mt9t001.h       |    1 +
> >  4 files changed, 27 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

