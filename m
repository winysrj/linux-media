Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42725 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1CFKR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 05:17:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@retiisi.org.uk>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sun, 6 Mar 2011 11:17:42 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D73472A.60702@retiisi.org.uk>
In-Reply-To: <4D73472A.60702@retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061117.42896.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Sunday 06 March 2011 09:34:50 Sakari Ailus wrote:
> Hi Laurent,
> 
> Many thanks for the pull req!
> 
> On Thu, Feb 17, 2011 at 04:06:58PM +0100, Laurent Pinchart wrote:
> ...
> 
> >  drivers/media/video/omap3-isp/ispresizer.c         | 1693 ++++++++++++++
> >  drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
> >  drivers/media/video/omap3-isp/ispstat.c            | 1092 +++++++++
> >  drivers/media/video/omap3-isp/ispstat.h            |  169 ++
> >  drivers/media/video/omap3-isp/ispvideo.c           | 1264 ++++++++++
> >  drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
> >  drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
> >  drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
> 
> ...
> 
> >  include/linux/Kbuild                               |    4 +
> >  include/linux/media.h                              |  132 ++
> >  include/linux/omap3isp.h                           |  646 +++++
> 
> What about renaming the directory omap3isp for the sake of consistency?
> The header file is called omap3isp.h and omap3isp is the prefix used in
> the driver for exported symbols.

I'm fine with both. If Mauro prefers omap3-isp, I can update the patches.

> My apologies for not bringing this up earlier.

-- 
Regards,

Laurent Pinchart
