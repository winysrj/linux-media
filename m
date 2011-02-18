Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab1BRONw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 09:13:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Fri, 18 Feb 2011 15:13:48 +0100
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
References: <4D5D9B57.3090809@gmail.com> <201102181421.54063.laurent.pinchart@ideasonboard.com> <op.vq3qrrv33l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vq3qrrv33l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181513.48978.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michal,

On Friday 18 February 2011 15:05:42 Michal Nazarewicz wrote:
> > On Friday 18 February 2011 14:19:44 Michal Nazarewicz wrote:
> >> Cache operations are always needed, aren't they?  Whatever you do, you
> >> will always have to handle cache coherency (in one way or another) so
> >> there's nothing we can do about it, or is there?
> 
> On Fri, 18 Feb 2011 14:21:53 +0100, Laurent Pinchart wrote:
> > To achieve low latency still image capture, you need to minimize the time
> > spent reconfiguring the device from viewfinder to still capture. Cache
> > cleaning is always needed, but you can prequeue buffers you can clean the
> > cache in advance, avoiding an extra delay when the user presses the still
> > image capture button.
> 
> If there is enough time to perform those operation while preview is shown
> (ie. several frames pare second), why would there not be enough time to
> perform those operations for still image capture?

For still image capture you want to minimize the shot-to-snapshot delay (delay 
between the time when the user presses the shot button and the time when the 
image is captured). Allocating memory for the buffers and prequeuing them 
should thus be done before the user presses the shot button.

> If I understand you correctly, what you are describing is a situation where
> one has set of buffers for preview and a buffer for still image laying
> around waiting to be used, right?

That's correct. That's what we currently do with the OMAP3 ISP.

> Such scheme will of course work, but I'm just suggesting to think of
> a scheme where the unused buffer for still image is reused for preview
> frames when preview is shown.

That will work as well, but it will increase the shot-to-snapshot delay as 
cache management will need to be performed after the user presses the shot 
button.

-- 
Regards,

Laurent Pinchart
