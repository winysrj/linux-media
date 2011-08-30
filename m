Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1H3P72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:59:28 -0400
Date: Tue, 30 Aug 2011 17:59:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
In-Reply-To: <201108301742.56581.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1108301755390.19151@axis700.grange>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108301600020.19151@axis700.grange>
 <CACxGe6tCLJ6F-Rsf=1ENj98YzXHRm9p9xr4-TAiWTHpQbQVOVA@mail.gmail.com>
 <201108301742.56581.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Aug 2011, Laurent Pinchart wrote:

> A dependency system is tempting but will be very complex to implement 
> properly, especially when faced with cyclic dependencies. For instance the 
> OMAP3 ISP driver requires the camera sensor device to be present to proceed, 

Switching to a notifier instead of waiting in probe() might be a good idea 
(TM).

> and the camera sensor requires a clock provided by the OMAP3 ISP. To solve 
> this we need to probe the OMAP3 ISP first, have it register its clock devices, 
> and then wait until all sensors become available.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
