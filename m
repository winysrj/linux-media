Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49864 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1CGMIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 07:08:16 -0500
Date: Mon, 7 Mar 2011 14:08:12 +0200
From: Sakari Ailus <sakari.ailus@retiisi.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Message-ID: <20110307120812.GF26689@valkosipuli.localdomain>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com>
 <4D73472A.60702@retiisi.org.uk>
 <201103061117.42896.laurent.pinchart@ideasonboard.com>
 <4D74C7EF.6040004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D74C7EF.6040004@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Mar 07, 2011 at 08:56:31AM -0300, Mauro Carvalho Chehab wrote:
> Em 06-03-2011 07:17, Laurent Pinchart escreveu:
> > Hi Sakari,
> > 
> > On Sunday 06 March 2011 09:34:50 Sakari Ailus wrote:
> >> Hi Laurent,
> >>
> >> Many thanks for the pull req!
> >>
> >> On Thu, Feb 17, 2011 at 04:06:58PM +0100, Laurent Pinchart wrote:
> >> ...
> >>
> >>>  drivers/media/video/omap3-isp/ispresizer.c         | 1693 ++++++++++++++
> >>>  drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
> >>>  drivers/media/video/omap3-isp/ispstat.c            | 1092 +++++++++
> >>>  drivers/media/video/omap3-isp/ispstat.h            |  169 ++
> >>>  drivers/media/video/omap3-isp/ispvideo.c           | 1264 ++++++++++
> >>>  drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
> >>>  drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
> >>>  drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
> >>
> >> ...
> >>
> >>>  include/linux/Kbuild                               |    4 +
> >>>  include/linux/media.h                              |  132 ++
> >>>  include/linux/omap3isp.h                           |  646 +++++
> >>
> >> What about renaming the directory omap3isp for the sake of consistency?
> >> The header file is called omap3isp.h and omap3isp is the prefix used in
> >> the driver for exported symbols.
> > 
> > I'm fine with both. If Mauro prefers omap3-isp, I can update the patches.
> 
> Probably, omap3-isp would be better, but I'm fine if you prefere omap3isp.

Hi Mauro, Laurent,

I'm also fine with omap3-isp. My point was that we should be consistent in
naming. If the symbol prefix and the file / directory names are a little
different that is certainly not an issue to me. So the change to the current
state of the patchset would be that the header file was be called
omap3-isp.h, right?

Cheers,

-- 
Sakari Ailus
sakari dot ailus at retiisi dot org dot uk
