Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48275 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1GPJwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 05:52:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
Date: Sat, 16 Jul 2011 11:52:08 +0200
Cc: linux-media@vger.kernel.org
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1107160109000.27399@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107160109000.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107161152.09214.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 16 July 2011 01:11:28 Guennadi Liakhovetski wrote:
> On Fri, 15 Jul 2011, Laurent Pinchart wrote:
> > Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/mt9v032.c |   20 ++++++++++----------
> >  1 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > If there's no comment I'll send a pull request for this patch in a couple
> > of days.
> 
> Hm, I might have a comment: why?... Isn't it natural to accept the fact,
> that different sensors put a different Bayer pixel at their sensor matrix
> origin? Isn't that why we have all possible Bayer formats? Maybe you just
> have to choose a different output format?

That's the other solution. The driver currently claims the device outputs 
SGRBG, but configures it to output SGBGR. This is clearly a bug. Is it better 
to modify the format than the crop rectangle location ?

The OMAP3 ISP supports all Bayer formats, but the driver configures itself for 
SGRBG by default. Using another pattern currently requires userspace software 
to change several hardware-dependent parameters (including matrices and 
tables). This should eventually be fixed in the OMAP3 ISP driver, but for the 
time being application developers will have an easier life if the sensor 
outputs SGRBG instead of SGBRG.

-- 
Regards,

Laurent Pinchart
