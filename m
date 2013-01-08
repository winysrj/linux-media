Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3AHWfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 17:35:25 -0500
Date: Tue, 8 Jan 2013 23:35:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Simon Horman <horms@verge.net.au>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 6/6] ARM: shmobile: convert ap4evb to asynchronously
 register camera subdevices
In-Reply-To: <20130108042720.GA25895@verge.net.au>
Message-ID: <Pine.LNX.4.64.1301082326040.8852@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
 <1356544151-6313-7-git-send-email-g.liakhovetski@gmx.de>
 <20130108042720.GA25895@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon

On Tue, 8 Jan 2013, Simon Horman wrote:

> On Wed, Dec 26, 2012 at 06:49:11PM +0100, Guennadi Liakhovetski wrote:
> > Register the imx074 camera I2C and the CSI-2 platform devices directly
> > in board platform data instead of letting the sh_mobile_ceu_camera driver
> > and the soc-camera framework register them at their run-time. This uses
> > the V4L2 asynchronous subdevice probing capability.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Hi Guennadi,
> 
> could you let me know what if any dependencies this patch has.
> And the status of any dependencies.

This patch depends on the other 5 patches in this series. Since the other 
patches are still in work, this patch cannot be applied either yet. Sorry, 
I should have marked it as RFC.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
