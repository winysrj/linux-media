Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39944 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GOMqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 08:46:30 -0400
Date: Fri, 15 Jul 2011 15:46:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Binning on sensors
Message-ID: <20110715124626.GK27451@valkosipuli.localdomain>
References: <20110714113201.GD27451@valkosipuli.localdomain>
 <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
 <201107151338.35639.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107151338.35639.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 15, 2011 at 01:38:35PM +0200, Laurent Pinchart wrote:
> On Thursday 14 July 2011 19:56:10 Guennadi Liakhovetski wrote:
> > On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > > Hi all,
> > > 
> > > I was thinking about the sensor binning controls.
> > 
> > What wrong with just doing S_FMT on the subdev pad? Binning does in fact
> > implement scaling.
> 
> That's indeed one solution. The downside, compared to controls, is that a 
> sensor that implements binning, skipping and scaling would need to expose 3 
> entities, to let applications configure them 3 "scalers" independently. If 
> binning and skipping were implemented as controls (which might not be a good 
> idea, I still haven't made up my mind on this), a single entity would 
> (probably) be enough.

Different hardware may do these operations in a different order. Scaling
should be the last, but I'm not sure if that holds for all hardware. The
order will affect the end result, and likely also to user's decision on
configuration.

However, when one considers such decisions (s)he typically has otherwise a
very good understanding of the hardware and thus knows the order of these
operations.

-- 
Sakari Ailus
sakari.ailus@iki.fi
