Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GOLih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 07:38:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] Binning on sensors
Date: Fri, 15 Jul 2011 13:38:35 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
References: <20110714113201.GD27451@valkosipuli.localdomain> <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107151338.35639.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 14 July 2011 19:56:10 Guennadi Liakhovetski wrote:
> On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > Hi all,
> > 
> > I was thinking about the sensor binning controls.
> 
> What wrong with just doing S_FMT on the subdev pad? Binning does in fact
> implement scaling.

That's indeed one solution. The downside, compared to controls, is that a 
sensor that implements binning, skipping and scaling would need to expose 3 
entities, to let applications configure them 3 "scalers" independently. If 
binning and skipping were implemented as controls (which might not be a good 
idea, I still haven't made up my mind on this), a single entity would 
(probably) be enough.

-- 
Regards,

Laurent Pinchart
