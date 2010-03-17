Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56539 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0CQOMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:12:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
Date: Wed, 17 Mar 2010 15:14:24 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com> <201003162330.17454.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171514.27538.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Wednesday 17 March 2010 14:52:17 Aguirre, Sergio wrote:
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Tuesday, March 16, 2010 5:30 PM
> > To: Aguirre, Sergio
> > Cc: Sakari Ailus; linux-media@vger.kernel.org
> > Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
> > 
> > Hi Sergio,
> > 
> > On Friday 05 March 2010 15:54:58 Aguirre, Sergio wrote:
> > > Hi Laurent, Sakari,
> > 
> > Oops, just noticed I forgot to answer your e-mail, sorry.
> 
> No problem.
> 
> > > I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
> > > 'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
> > > Sony IMX046 8MP sensor).
> > > 
> > > I had first one NULL pointer dereference while the driver was
> > > registering devices and creating entities, which I resolved with
> > > the attached patch. (Is this patch acceptable, or maybe I am missing
> > > something...)
> > 
> > Either that, or make OMAP34XXCAM_VIDEODEVS dynamic (the value would be
> > passed through platform data). The code will be removed (hopefully soon)
> > anyway when the legacy video nodes will disappear.
> 
> Ok, so should I keep this patch only to myself until this code is removed?

I'll let Sakari answer that, but I think they can still go in in the meantime.

-- 
Regards,

Laurent Pinchart
