Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46122 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3AIAEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 19:04:09 -0500
Date: Wed, 9 Jan 2013 09:04:05 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 6/6] ARM: shmobile: convert ap4evb to asynchronously
 register camera subdevices
Message-ID: <20130109000405.GC29821@verge.net.au>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
 <1356544151-6313-7-git-send-email-g.liakhovetski@gmx.de>
 <20130108042720.GA25895@verge.net.au>
 <Pine.LNX.4.64.1301082326040.8852@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301082326040.8852@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 08, 2013 at 11:35:21PM +0100, Guennadi Liakhovetski wrote:
> Hi Simon
> 
> On Tue, 8 Jan 2013, Simon Horman wrote:
> 
> > On Wed, Dec 26, 2012 at 06:49:11PM +0100, Guennadi Liakhovetski wrote:
> > > Register the imx074 camera I2C and the CSI-2 platform devices directly
> > > in board platform data instead of letting the sh_mobile_ceu_camera driver
> > > and the soc-camera framework register them at their run-time. This uses
> > > the V4L2 asynchronous subdevice probing capability.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Hi Guennadi,
> > 
> > could you let me know what if any dependencies this patch has.
> > And the status of any dependencies.
> 
> This patch depends on the other 5 patches in this series. Since the other 
> patches are still in work, this patch cannot be applied either yet. Sorry, 
> I should have marked it as RFC.

Thanks, got it.
