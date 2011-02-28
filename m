Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:64847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1B1LhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:37:24 -0500
Date: Mon, 28 Feb 2011 12:37:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201102281207.34106.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102281220590.11156@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <201102281140.31643.hansverk@cisco.com> <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
 <201102281207.34106.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 28 Feb 2011, Laurent Pinchart wrote:

> > > > I don't think snapshot capture is *that* special. I don't expect most
> > > > embedded SoCs to implement snapshot capture in hardware. What usually
> > > > happens is that the hardware provides some support (like two independent
> > > > video streams for instance, or the ability to capture a given number of
> > > > frames) and the scheduling is performed in userspace. Good quality
> > > > snapshot capture requires complex algorithms and involves several
> > > > hardware pieces (ISP, flash controller, lens controller, ...), so it
> > > > can't be implemented in the kernel.
> > > 
> > > I agree.
> > 
> > Right, but sensors do need it. It is not enough to just tell the sensor -
> > a per-frame flash is used and let the driver figure out, that it has to
> > switch to snapshot mode. The snapshot mode has other effects too, e.g., on
> > some sensors it enables the external trigger pin, which some designs might
> > want to use also without a flash. Maybe there are also some other side
> > effects of such snapshot modes on some other sensors, that I'm not aware
> > of.
> 
> This makes me wonder if we need a snapshot mode at all. Why should we tie 
> flash, capture trigger (and other such options that you're not aware of yet 
> :-)) together under a single high-level control (in the general sense, not to 
> be strictly taken as a V4L2 CID) ? Wouldn't it be better to expose those 
> features individually instead ? User might want to use the flash in video 
> capture mode for a stroboscopic effect for instance.

So, you'd also need a separate control for external exposure, there are 
also sensors, that can be configured to different shutter / exposure / 
readout sequence controlling... No, we don't have to support all that 
variety, but we have to be aware of it, while making decisions;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
