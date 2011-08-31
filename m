Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44664 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HaS3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:29:48 -0400
Date: Wed, 31 Aug 2011 21:29:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sebastian Reichel <sre@debian.org>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: status request of et8k8, ad5820 and their corresponding rx51
 board code
Message-ID: <20110831182943.GN12368@valkosipuli.localdomain>
References: <20110831151524.GA28065@earth.universe>
 <201108311733.16363.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108311733.16363.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:33:16PM +0200, Laurent Pinchart wrote:
> Hi Sebastian,

Hi,

> (CC'ing Sakari Ailus)
> 
> On Wednesday 31 August 2011 17:15:24 Sebastian Reichel wrote:
> > Hi,
> > 
> > What's the plan for the rx51 camera drivers from [0]? Is there a
> > chance, that they get included in the mainline 3.2 or 3.3 kernel?
> 
> The ad5820 driver will probably be the simplest one to upstream. It should be 
> possible to push it to v3.3. Someone needs to look at the lens-related 
> controls and how they can be standardized (if at all).

I don't know enough of different lenses to give a definitive answer but so
far what I have seen is that the way to drive a lens varies wildly from chip
to another. It might not be possible to standarside them.

I agree the ad5820 would be relatively easy to upstream.

> The et8ek8 driver is a different story. I don't think it should get mainlined 
> in its current state. We need to get rid of the "camera firmware" support from 
> the driver first, and if possible implement the V4L2 API correctly without 
> relying on register lists.

I fully agree with this. One problem is that the documentation for this
sensor is poor and not many of its registers are known. It's possible to use
it with the existing register list (which should be part of the driver
itself).

-- 
Sakari Ailus
sakari.ailus@iki.fi
